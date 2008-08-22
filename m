From: akpm@linux-foundation.org
Subject: + mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-__mlock_vma_pages_range-comment-block.patch added to -mm tree
Date: Fri, 22 Aug 2008 14:39:45 -0700
Message-ID: <200808222139.m7MLdj6T017883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756005AbYHVVkV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 17:40:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     mlock: fix __mlock_vma_pages_range comment block
has been added to the -mm tree.  Its filename is
     mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-__mlock_vma_pages_range-comment-block.patch

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
Subject: mlock: fix __mlock_vma_pages_range comment block
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

__mlock_vma_pages_range comment block needs updating:
 - it fails to mention the mlock parameter
 - no longer requires that mmap_sem be held for write.

following patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN mm/mlock.c~mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-__mlock_vma_pages_range-comment-block mm/mlock.c
--- a/mm/mlock.c~mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-__mlock_vma_pages_range-comment-block
+++ a/mm/mlock.c
@@ -112,12 +112,20 @@ static void munlock_vma_page(struct page
 	}
 }
 
-/*
- * mlock a range of pages in the vma.
+/**
+ * __mlock_vma_pages_range() -  mlock/munlock a range of pages in the vma.
+ * @vma:   target vma
+ * @start: start address
+ * @end:   end address
+ * @mlock: 0 indicate munlock, otherwise mlock.
+ *
+ * If @mlock == 0, unlock an mlocked range;
+ * else mlock the range of pages.  This takes care of making the pages present ,
+ * too.
  *
- * This takes care of making the pages present too.
+ * return 0 on success, negative error code on error.
  *
- * vma->vm_mm->mmap_sem must be held for write.
+ * vma->vm_mm->mmap_sem must be held for at least read.
  */
 static int __mlock_vma_pages_range(struct vm_area_struct *vma,
 				   unsigned long start, unsigned long end,
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

vmscan-use-an-indexed-array-for-lru-variables.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
pageflag-helpers-for-configed-out-flags.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-nommu-fix.patch
unevictable-lru-infrastructure-remember-pages-active-state.patch
unevictable-lru-infrastructure-defer-vm-event-counting.patch
unevictable-infrastructure-lru-add-event-counting-with-statistics.patch
unevictable-lru-page-statistics.patch
ramfs-and-ram-disk-pages-are-unevictable.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-add-event-counts-to-list-scan.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
doc-unevictable-lru-and-mlocked-pages-documentation.patch
doc-unevictable-lru-and-mlocked-pages-documentation-update.patch
doc-unevictable-lru-and-mlocked-pages-documentation-update-2.patch
mlock-downgrade-mmap-sem-while-populating-mlocked-regions.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-__mlock_vma_pages_range-comment-block.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-mlocked-pages-add-event-counting-with-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-count-attempts-to-free-mlocked-page-2.patch
mlock-backout-locked_vm-adjustment-during-mmap.patch
mlock-resubmit-locked_vm-adjustment-as-separate-patch.patch
mlock-fix-return-value-for-munmap-mlock-vma-race.patch
mlock-update-locked_vm-on-munmap-of-mlocked-region.patch
mlock-revert-mainline-handling-of-mlock-error-return.patch
mlock-make-mlock-error-return-posixly-correct.patch

