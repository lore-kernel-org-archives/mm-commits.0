From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-report-uffdio_zeropage-as-available-for-shmem-vmas.patch
 removed from -mm tree
Date: Thu, 07 Sep 2017 11:40:31 -0700
Message-ID: <20170907184031.oQxNtneow%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57448 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755707AbdIGSkc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:40:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hillf.zj@alibaba-inc.com, hughd@google.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com, xemul@virtuozzo.com


The patch titled
     Subject: userfaultfd: report UFFDIO_ZEROPAGE as available for shmem VMAs
has been removed from the -mm tree.  Its filename was
     userfaultfd-report-uffdio_zeropage-as-available-for-shmem-vmas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


