From: akpm@linux-foundation.org
Subject: + mm-xip-share-the-i_mmap_rwsem.patch added to -mm tree
Date: Tue, 04 Nov 2014 15:04:52 -0800
Message-ID: <54595b94.r1ZbUOdJ4AJDdMrl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaKDXEv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 18:04:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, hughd@google.com, kirill.shutemov@intel.linux.com, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/xip: share the i_mmap_rwsem
has been added to the -mm tree.  Its filename is
     mm-xip-share-the-i_mmap_rwsem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-xip-share-the-i_mmap_rwsem.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-xip-share-the-i_mmap_rwsem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm/xip: share the i_mmap_rwsem

__xip_unmap() will remove the xip sparse page from the cache and take down
pte mapping, without altering the interval tree, thus share the
i_mmap_rwsem when searching for the ptes to unmap.

Additionally, tidy up the function a bit and make variables only local to
the interval tree walk loop.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Kirill A. Shutemov <kirill.shutemov@intel.linux.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap_xip.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff -puN mm/filemap_xip.c~mm-xip-share-the-i_mmap_rwsem mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-xip-share-the-i_mmap_rwsem
+++ a/mm/filemap_xip.c
@@ -155,22 +155,14 @@ xip_file_read(struct file *filp, char __
 EXPORT_SYMBOL_GPL(xip_file_read);
 
 /*
- * __xip_unmap is invoked from xip_unmap and
- * xip_write
+ * __xip_unmap is invoked from xip_unmap and xip_write
  *
  * This function walks all vmas of the address_space and unmaps the
  * __xip_sparse_page when found at pgoff.
  */
-static void
-__xip_unmap (struct address_space * mapping,
-		     unsigned long pgoff)
+static void __xip_unmap(struct address_space * mapping, unsigned long pgoff)
 {
 	struct vm_area_struct *vma;
-	struct mm_struct *mm;
-	unsigned long address;
-	pte_t *pte;
-	pte_t pteval;
-	spinlock_t *ptl;
 	struct page *page;
 	unsigned count;
 	int locked = 0;
@@ -182,11 +174,14 @@ __xip_unmap (struct address_space * mapp
 		return;
 
 retry:
-	i_mmap_lock_write(mapping);
+	i_mmap_lock_read(mapping);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
-		mm = vma->vm_mm;
-		address = vma->vm_start +
+		pte_t *pte, pteval;
+		spinlock_t *ptl;
+		struct mm_struct *mm = vma->vm_mm;
+		unsigned long address = vma->vm_start +
 			((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+
 		BUG_ON(address < vma->vm_start || address >= vma->vm_end);
 		pte = page_check_address(page, mm, address, &ptl, 1);
 		if (pte) {
@@ -202,7 +197,7 @@ retry:
 			page_cache_release(page);
 		}
 	}
-	i_mmap_unlock_write(mapping);
+	i_mmap_unlock_read(mapping);
 
 	if (locked) {
 		mutex_unlock(&xip_sparse_mutex);
_

Patches currently in -mm which might be from dave@stgolabs.net are

mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-semc-increase-semmsl-semmni-semopm.patch
ipc-msg-increase-msgmni-remove-scaling.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch

