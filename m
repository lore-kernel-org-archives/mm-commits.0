From: akpm@linux-foundation.org
Subject: + ksm-add-ksm-kernel-shared-memory-driver-change-the-prot-handling-to-use-the-generic-helper-functions.patch added to -mm tree
Date: Tue, 05 May 2009 13:15:16 -0700
Message-ID: <200905052015.n45KFHSJ004940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753254AbZEEUUP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 16:20:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ieidus@redhat.com, aarcange@redhat.com, avi@redhat.com, chrisw@redhat.com, hugh@veritas.com, nickpiggin@yahoo.com.au


The patch titled
     ksm: change the prot handling to use the generic helper functions
has been added to the -mm tree.  Its filename is
     ksm-add-ksm-kernel-shared-memory-driver-change-the-prot-handling-to-use-the-generic-helper-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: change the prot handling to use the generic helper functions
From: Izik Eidus <ieidus@redhat.com>

This is needed to avoid breaking some architectures.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/ksm.c~ksm-add-ksm-kernel-shared-memory-driver-change-the-prot-handling-to-use-the-generic-helper-functions mm/ksm.c
--- a/mm/ksm.c~ksm-add-ksm-kernel-shared-memory-driver-change-the-prot-handling-to-use-the-generic-helper-functions
+++ a/mm/ksm.c
@@ -761,8 +761,8 @@ static int try_to_merge_two_pages_alloc(
 		up_read(&mm1->mmap_sem);
 		return ret;
 	}
-	prot = vma->vm_page_prot;
-	pgprot_val(prot) &= ~_PAGE_RW;
+
+	prot = vm_get_page_prot(vma->vm_flags & ~VM_WRITE);
 
 	copy_user_highpage(kpage, page1, addr1, vma);
 	ret = try_to_merge_one_page(mm1, vma, page1, kpage, prot);
@@ -779,8 +779,7 @@ static int try_to_merge_two_pages_alloc(
 			return ret;
 		}
 
-		prot = vma->vm_page_prot;
-		pgprot_val(prot) &= ~_PAGE_RW;
+		prot = vm_get_page_prot(vma->vm_flags & ~VM_WRITE);
 
 		ret = try_to_merge_one_page(mm2, vma, page2, kpage,
 					    prot);
@@ -825,8 +824,9 @@ static int try_to_merge_two_pages_noallo
 		up_read(&mm1->mmap_sem);
 		return ret;
 	}
-	prot = vma->vm_page_prot;
-	pgprot_val(prot) &= ~_PAGE_RW;
+
+	prot = vm_get_page_prot(vma->vm_flags & ~VM_WRITE);
+
 	ret = try_to_merge_one_page(mm1, vma, page1, page2, prot);
 	up_read(&mm1->mmap_sem);
 	if (!ret)
_

Patches currently in -mm which might be from ieidus@redhat.com are

linux-next.patch
ksm-mmu_notifiers-add-set_pte_at_notify.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-page_wrprotect-write-protecting-page.patch
ksm-add-replace_page-change-the-page-pte-is-pointing-to.patch
ksm-add-ksm-kernel-shared-memory-driver.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
ksm-add-ksm-kernel-shared-memory-driver-fix-unsafe-pte-fetching.patch
ksm-add-ksm-kernel-shared-memory-driver-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-limiting-the-num-of-mem-regions-user-can-register-per-fd.patch
ksm-add-ksm-kernel-shared-memory-driver-dont-allow-overlap-memory-addresses-registrations.patch
ksm-add-ksm-kernel-shared-memory-driver-change-the-ksm_remove_memory_region-ioctl.patch
ksm-add-ksm-kernel-shared-memory-driver-change-the-prot-handling-to-use-the-generic-helper-functions.patch
ksm-add-ksm-kernel-shared-memory-driver-use-another-miscdevice-minor-number.patch

