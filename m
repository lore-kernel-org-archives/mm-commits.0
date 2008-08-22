From: akpm@linux-foundation.org
Subject: + mlock-revert-mainline-handling-of-mlock-error-return.patch added to -mm tree
Date: Fri, 22 Aug 2008 14:44:26 -0700
Message-ID: <200808222144.m7MLiQl1018096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755622AbYHVVoz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 17:44:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     mlock: revert mainline handling of mlock error return
has been added to the -mm tree.  Its filename is
     mlock-revert-mainline-handling-of-mlock-error-return.patch

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
Subject: mlock: revert mainline handling of mlock error return
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

This change is intended to make mlock() error returns correct. 
make_page_present() is a lower level function used by more than mlock(). 
Subsequent patch[es] will add this error return fixup in an mlock specific
path.

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff -puN mm/memory.c~mlock-revert-mainline-handling-of-mlock-error-return mm/memory.c
--- a/mm/memory.c~mlock-revert-mainline-handling-of-mlock-error-return
+++ a/mm/memory.c
@@ -2819,19 +2819,9 @@ int make_pages_present(unsigned long add
 	len = DIV_ROUND_UP(end, PAGE_SIZE) - addr/PAGE_SIZE;
 	ret = get_user_pages(current, current->mm, addr,
 			len, write, 0, NULL, NULL);
-	if (ret < 0) {
-		/*
-		   SUS require strange return value to mlock
-		    - invalid addr generate to ENOMEM.
-		    - out of memory should generate EAGAIN.
-		*/
-		if (ret == -EFAULT)
-			ret = -ENOMEM;
-		else if (ret == -ENOMEM)
-			ret = -EAGAIN;
+	if (ret < 0)
 		return ret;
-	}
-	return ret == len ? 0 : -ENOMEM;
+	return ret == len ? 0 : -1;
 }
 
 #if !defined(__HAVE_ARCH_GATE_AREA)
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
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-update-locked_vm-on-munmap-of-mlocked-region.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-mlocked-pages-add-event-counting-with-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-count-attempts-to-free-mlocked-page-2.patch
mlock-revert-mainline-handling-of-mlock-error-return.patch
mlock-make-mlock-error-return-posixly-correct.patch

