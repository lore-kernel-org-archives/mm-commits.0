From: akpm@linux-foundation.org
Subject: + mm-xip-fix-fault-vs-sparse-page-invalidate-race.patch added to -mm tree
Date: Mon, 18 Aug 2008 16:13:32 -0700
Message-ID: <200808182313.m7INDWWI018029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753489AbYHRXNv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 19:13:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, cotte@freenet.de, hugh@veritas.com, jaredeh@gmail.com


The patch titled
     mm: xip fix fault vs sparse page invalidate race
has been added to the -mm tree.  Its filename is
     mm-xip-fix-fault-vs-sparse-page-invalidate-race.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: xip fix fault vs sparse page invalidate race
From: Nick Piggin <npiggin@suse.de>

XIP has a race between sparse pages being inserted into page tables, and
sparse pages being zapped when its time to put a non-sparse page in.

What can happen is that a process can be left with a dangling sparse page
in a MAP_SHARED mapping, while the rest of the world sees the non-sparse
version.  Ie.  data corruption.

Guard these operations with a seqlock, making fault-in-sparse-pages the
slowpath, and try-to-unmap-sparse-pages the fastpath.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Jared Hulbert <jaredeh@gmail.com>
Acked-by: Carsten Otte <cotte@freenet.de>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap_xip.c |   60 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 46 insertions(+), 14 deletions(-)

diff -puN mm/filemap_xip.c~mm-xip-fix-fault-vs-sparse-page-invalidate-race mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-xip-fix-fault-vs-sparse-page-invalidate-race
+++ a/mm/filemap_xip.c
@@ -15,6 +15,8 @@
 #include <linux/rmap.h>
 #include <linux/mmu_notifier.h>
 #include <linux/sched.h>
+#include <linux/seqlock.h>
+#include <linux/mutex.h>
 #include <asm/tlbflush.h>
 #include <asm/io.h>
 
@@ -22,22 +24,18 @@
  * We do use our own empty page to avoid interference with other users
  * of ZERO_PAGE(), such as /dev/zero
  */
+static DEFINE_MUTEX(xip_sparse_mutex);
+static seqcount_t xip_sparse_seq = SEQCNT_ZERO;
 static struct page *__xip_sparse_page;
 
+/* called under xip_sparse_mutex */
 static struct page *xip_sparse_page(void)
 {
 	if (!__xip_sparse_page) {
 		struct page *page = alloc_page(GFP_HIGHUSER | __GFP_ZERO);
 
-		if (page) {
-			static DEFINE_SPINLOCK(xip_alloc_lock);
-			spin_lock(&xip_alloc_lock);
-			if (!__xip_sparse_page)
-				__xip_sparse_page = page;
-			else
-				__free_page(page);
-			spin_unlock(&xip_alloc_lock);
-		}
+		if (page)
+			__xip_sparse_page = page;
 	}
 	return __xip_sparse_page;
 }
@@ -174,11 +172,16 @@ __xip_unmap (struct address_space * mapp
 	pte_t pteval;
 	spinlock_t *ptl;
 	struct page *page;
+	unsigned count;
+	int locked = 0;
+
+	count = read_seqcount_begin(&xip_sparse_seq);
 
 	page = __xip_sparse_page;
 	if (!page)
 		return;
 
+retry:
 	spin_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		mm = vma->vm_mm;
@@ -198,6 +201,14 @@ __xip_unmap (struct address_space * mapp
 		}
 	}
 	spin_unlock(&mapping->i_mmap_lock);
+
+	if (locked) {
+		mutex_unlock(&xip_sparse_mutex);
+	} else if (read_seqcount_retry(&xip_sparse_seq, count)) {
+		mutex_lock(&xip_sparse_mutex);
+		locked = 1;
+		goto retry;
+	}
 }
 
 /*
@@ -218,7 +229,7 @@ static int xip_file_fault(struct vm_area
 	int error;
 
 	/* XXX: are VM_FAULT_ codes OK? */
-
+again:
 	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	if (vmf->pgoff >= size)
 		return VM_FAULT_SIGBUS;
@@ -245,6 +256,7 @@ static int xip_file_fault(struct vm_area
 		__xip_unmap(mapping, vmf->pgoff);
 
 found:
+		printk("%s insert %lx@%lx\n", current->comm, (unsigned long)vmf->virtual_address, xip_pfn);
 		err = vm_insert_mixed(vma, (unsigned long)vmf->virtual_address,
 							xip_pfn);
 		if (err == -ENOMEM)
@@ -252,14 +264,34 @@ found:
 		BUG_ON(err);
 		return VM_FAULT_NOPAGE;
 	} else {
+		int err, ret = VM_FAULT_OOM;
+
+		mutex_lock(&xip_sparse_mutex);
+		write_seqcount_begin(&xip_sparse_seq);
+		error = mapping->a_ops->get_xip_mem(mapping, vmf->pgoff, 0,
+							&xip_mem, &xip_pfn);
+		if (unlikely(!error)) {
+			write_seqcount_end(&xip_sparse_seq);
+			mutex_unlock(&xip_sparse_mutex);
+			goto again;
+		}
+		if (error != -ENODATA)
+			goto out;
 		/* not shared and writable, use xip_sparse_page() */
 		page = xip_sparse_page();
 		if (!page)
-			return VM_FAULT_OOM;
+			goto out;
+		err = vm_insert_page(vma, (unsigned long)vmf->virtual_address,
+							page);
+		if (err == -ENOMEM)
+			goto out;
 
-		page_cache_get(page);
-		vmf->page = page;
-		return 0;
+		ret = VM_FAULT_NOPAGE;
+out:
+		write_seqcount_end(&xip_sparse_seq);
+		mutex_unlock(&xip_sparse_mutex);
+
+		return ret;
 	}
 }
 
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
mm-dirty-page-tracking-race-fix.patch
mm-dirty-page-tracking-race-fix-fix.patch
mm-xip-fix-fault-vs-sparse-page-invalidate-race.patch
mm-xip-ext2-fix-block-allocation-race.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

