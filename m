From: akpm@linux-foundation.org
Subject: +
 userfaultfd-report-uffdio_zeropage-as-available-for-shmem-vmas.patch added
 to -mm tree
Date: Thu, 27 Jul 2017 16:42:06 -0700
Message-ID: <597a7a4e.dB51EEX2wD2xIsko%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37952 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751600AbdG0XmH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2017 19:42:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, hillf.zj@alibaba-inc.com, hughd@google.com, kirill.shutemov@linux.intel.com, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: report UFFDIO_ZEROPAGE as available for shmem VMAs
has been added to the -mm tree.  Its filename is
     userfaultfd-report-uffdio_zeropage-as-available-for-shmem-vmas.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-report-uffdio_zeropage-as-available-for-shmem-vmas.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-report-uffdio_zeropage-as-available-for-shmem-vmas.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: report UFFDIO_ZEROPAGE as available for shmem VMAs

Now when shmem VMAs can be filled with zero page via userfaultfd we can
report that UFFDIO_ZEROPAGE is available for those VMAs

Link: http://lkml.kernel.org/r/1497939652-16528-7-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-report-uffdio_zeropage-as-available-for-shmem-vmas fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-report-uffdio_zeropage-as-available-for-shmem-vmas
+++ a/fs/userfaultfd.c
@@ -1194,7 +1194,7 @@ static int userfaultfd_register(struct u
 	struct uffdio_register __user *user_uffdio_register;
 	unsigned long vm_flags, new_flags;
 	bool found;
-	bool non_anon_pages;
+	bool basic_ioctls;
 	unsigned long start, end, vma_end;
 
 	user_uffdio_register = (struct uffdio_register __user *) arg;
@@ -1260,7 +1260,7 @@ static int userfaultfd_register(struct u
 	 * Search for not compatible vmas.
 	 */
 	found = false;
-	non_anon_pages = false;
+	basic_ioctls = false;
 	for (cur = vma; cur && cur->vm_start < end; cur = cur->vm_next) {
 		cond_resched();
 
@@ -1299,8 +1299,8 @@ static int userfaultfd_register(struct u
 		/*
 		 * Note vmas containing huge pages
 		 */
-		if (is_vm_hugetlb_page(cur) || vma_is_shmem(cur))
-			non_anon_pages = true;
+		if (is_vm_hugetlb_page(cur))
+			basic_ioctls = true;
 
 		found = true;
 	}
@@ -1371,7 +1371,7 @@ out_unlock:
 		 * userland which ioctls methods are guaranteed to
 		 * succeed on this range.
 		 */
-		if (put_user(non_anon_pages ? UFFD_API_RANGE_IOCTLS_BASIC :
+		if (put_user(basic_ioctls ? UFFD_API_RANGE_IOCTLS_BASIC :
 			     UFFD_API_RANGE_IOCTLS,
 			     &user_uffdio_register->ioctls))
 			ret = -EFAULT;
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

userfaultfd-non-cooperative-notify-about-unmap-of-destination-during-mremap.patch
userfaultfd_zeropage-return-enospc-in-case-mm-has-gone.patch
shmem-shmem_charge-verify-max_block-is-not-exceeded-before-inode-update.patch
shmem-introduce-shmem_inode_acct_block.patch
userfaultfd-shmem-add-shmem_mfill_zeropage_pte-for-userfaultfd-support.patch
userfaultfd-mcopy_atomic-introduce-mfill_atomic_pte-helper.patch
userfaultfd-shmem-wire-up-shmem_mfill_zeropage_pte.patch
userfaultfd-report-uffdio_zeropage-as-available-for-shmem-vmas.patch
userfaultfd-selftest-enable-testing-of-uffdio_zeropage-for-shmem.patch

