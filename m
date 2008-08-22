From: akpm@linux-foundation.org
Subject: + mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-return-value-for-munmap-mlock-vma-race.patch added to -mm tree
Date: Fri, 22 Aug 2008 14:43:21 -0700
Message-ID: <200808222143.m7MLhLtv018077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754568AbYHVVn4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 17:43:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     mlock: fix return value for munmap/mlock vma race
has been added to the -mm tree.  Its filename is
     mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-return-value-for-munmap-mlock-vma-race.patch

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
Subject: mlock: fix return value for munmap/mlock vma race
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Now, We call downgrade_write(&mm->mmap_sem) at begin of mlock.
It increase mlock scalability.

But if mlock and munmap conflict happend, We can find vma gone.  At that
time, kernel should return ENOMEM because mlock after munmap return
ENOMEM.  (in addition, EAGAIN indicate "please try again", but mlock()
called again cause error again)

This problem is theoretical issue.
I can't reproduce that vma gone on my box, but fixes is better.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/mlock.c~mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-return-value-for-munmap-mlock-vma-race mm/mlock.c
--- a/mm/mlock.c~mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-return-value-for-munmap-mlock-vma-race
+++ a/mm/mlock.c
@@ -283,7 +283,7 @@ long mlock_vma_pages_range(struct vm_are
 		vma = find_vma(mm, start);
 		/* non-NULL vma must contain @start, but need to check @end */
 		if (!vma ||  end > vma->vm_end)
-			return -EAGAIN;
+			return -ENOMEM;
 
 		return 0;	/* hide other errors from mmap(), et al */
 	}
@@ -405,7 +405,7 @@ success:
 		*prev = find_vma(mm, start);
 		/* non-NULL *prev must contain @start, but need to check @end */
 		if (!(*prev) || end > (*prev)->vm_end)
-			ret = -EAGAIN;
+			ret = -ENOMEM;
 	} else {
 		/*
 		 * TODO:  for unlocking, pages will already be resident, so
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
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-backout-locked_vm-adjustment-during-mmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-return-value-for-munmap-mlock-vma-race.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-mlocked-pages-add-event-counting-with-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-count-attempts-to-free-mlocked-page-2.patch
mlock-update-locked_vm-on-munmap-of-mlocked-region.patch
mlock-revert-mainline-handling-of-mlock-error-return.patch
mlock-make-mlock-error-return-posixly-correct.patch

