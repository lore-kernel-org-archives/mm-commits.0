From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-fix-a-data-race-in-filemap_fault.patch added
 to -mm tree
Date: Mon, 10 Feb 2020 21:39:07 -0800
Message-ID: <20200211053907.yLfIipi8t%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727842AbgBKFjJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Feb 2020 00:39:09 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, elver@google.com, kirill@shutemov.name, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: mm/filemap.c: fix a data race in filemap_fault()
has been added to the -mm tree.  Its filename is
     mm-filemap-fix-a-data-race-in-filemap_fault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-fix-a-data-race-in-filemap_fault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-fix-a-data-race-in-filemap_fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kirill A. Shutemov <kirill@shutemov.name>
Subject: mm/filemap.c: fix a data race in filemap_fault()

struct file_ra_state ra.mmap_miss could be accessed concurrently during
page faults as noticed by KCSAN,

 BUG: KCSAN: data-race in filemap_fault / filemap_map_pages

 write to 0xffff9b1700a2c1b4 of 4 bytes by task 3292 on cpu 30:
  filemap_fault+0x920/0xfc0
  do_sync_mmap_readahead at mm/filemap.c:2384
  (inlined by) filemap_fault at mm/filemap.c:2486
  __xfs_filemap_fault+0x112/0x3e0 [xfs]
  xfs_filemap_fault+0x74/0x90 [xfs]
  __do_fault+0x9e/0x220
  do_fault+0x4a0/0x920
  __handle_mm_fault+0xc69/0xd00
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 read to 0xffff9b1700a2c1b4 of 4 bytes by task 3313 on cpu 32:
  filemap_map_pages+0xc2e/0xd80
  filemap_map_pages at mm/filemap.c:2625
  do_fault+0x3da/0x920
  __handle_mm_fault+0xc69/0xd00
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 Reported by Kernel Concurrency Sanitizer on:
 CPU: 32 PID: 3313 Comm: systemd-udevd Tainted: G        W    L 5.5.0-next-20200210+ #1
 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019

ra.mmap_miss is used to contribute the readahead decisions, a data race
could be undesirable.  Both the read and write is only under non-exclusive
mmap_sem, two concurrent writers could even underflow the counter.  Fix
the underflow by writing to a local variable before committing a final
store to ra.mmap_miss given a small inaccuracy of the counter should be
acceptable.

Link: http://lkml.kernel.org/r/20200211030134.1847-1-cai@lca.pw
Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Qian Cai <cai@lca.pw>
Tested-by: Qian Cai <cai@lca.pw>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/mm/filemap.c~mm-filemap-fix-a-data-race-in-filemap_fault
+++ a/mm/filemap.c
@@ -2365,6 +2365,7 @@ static struct file *do_sync_mmap_readahe
 	struct address_space *mapping = file->f_mapping;
 	struct file *fpin = NULL;
 	pgoff_t offset = vmf->pgoff;
+	unsigned int mmap_miss;
 
 	/* If we don't want any read-ahead, don't bother */
 	if (vmf->vma->vm_flags & VM_RAND_READ)
@@ -2380,14 +2381,15 @@ static struct file *do_sync_mmap_readahe
 	}
 
 	/* Avoid banging the cache line if not needed */
-	if (ra->mmap_miss < MMAP_LOTSAMISS * 10)
-		ra->mmap_miss++;
+	mmap_miss = READ_ONCE(ra->mmap_miss);
+	if (mmap_miss < MMAP_LOTSAMISS * 10)
+		WRITE_ONCE(ra->mmap_miss, ++mmap_miss);
 
 	/*
 	 * Do we miss much more than hit in this file? If so,
 	 * stop bothering with read-ahead. It will only hurt.
 	 */
-	if (ra->mmap_miss > MMAP_LOTSAMISS)
+	if (mmap_miss > MMAP_LOTSAMISS)
 		return fpin;
 
 	/*
@@ -2413,13 +2415,15 @@ static struct file *do_async_mmap_readah
 	struct file_ra_state *ra = &file->f_ra;
 	struct address_space *mapping = file->f_mapping;
 	struct file *fpin = NULL;
+	unsigned int mmap_miss;
 	pgoff_t offset = vmf->pgoff;
 
 	/* If we don't want any read-ahead, don't bother */
 	if (vmf->vma->vm_flags & VM_RAND_READ)
 		return fpin;
-	if (ra->mmap_miss > 0)
-		ra->mmap_miss--;
+	mmap_miss = READ_ONCE(ra->mmap_miss);
+	if (mmap_miss)
+		WRITE_ONCE(ra->mmap_miss, --mmap_miss);
 	if (PageReadahead(page)) {
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 		page_cache_async_readahead(mapping, ra, file,
@@ -2586,6 +2590,7 @@ void filemap_map_pages(struct vm_fault *
 	unsigned long max_idx;
 	XA_STATE(xas, &mapping->i_pages, start_pgoff);
 	struct page *page;
+	unsigned int mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
 
 	rcu_read_lock();
 	xas_for_each(&xas, page, end_pgoff) {
@@ -2622,8 +2627,8 @@ void filemap_map_pages(struct vm_fault *
 		if (page->index >= max_idx)
 			goto unlock;
 
-		if (file->f_ra.mmap_miss > 0)
-			file->f_ra.mmap_miss--;
+		if (mmap_miss > 0)
+			mmap_miss--;
 
 		vmf->address += (xas.xa_index - last_pgoff) << PAGE_SHIFT;
 		if (vmf->pte)
@@ -2643,6 +2648,7 @@ next:
 			break;
 	}
 	rcu_read_unlock();
+	WRITE_ONCE(file->f_ra.mmap_miss, mmap_miss);
 }
 EXPORT_SYMBOL(filemap_map_pages);
 
_

Patches currently in -mm which might be from kirill@shutemov.name are

mm-filemap-fix-a-data-race-in-filemap_fault.patch
