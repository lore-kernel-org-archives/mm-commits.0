From: akpm@linux-foundation.org
Subject: +
 userfaultfd-shmem-allow-registration-of-shared-memory-ranges-fix.patch
 added to -mm tree
Date: Wed, 15 Feb 2017 11:57:40 -0800
Message-ID: <58a4b2b4.chSuBZk7WXK8bwHF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37836 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750791AbdBOT5l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2017 14:57:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: hugetlbfs: report the working ioctls for shared hugetlbfs mappings
has been added to the -mm tree.  Its filename is
     userfaultfd-shmem-allow-registration-of-shared-memory-ranges-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-shmem-allow-registration-of-shared-memory-ranges-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-shmem-allow-registration-of-shared-memory-ranges-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: hugetlbfs: report the working ioctls for shared hugetlbfs mappings

The hugetlbfs support is complete for private mappings, shared mappings
will be working soon.  Until that restriction is lifted, it's more correct
not to report UFFDIO_COPY as working for uffd registered shared hugetlbfs
mappings.

This change will prevent userland from getting confused about the ioctls
value returned by UFFDIO_REGISTER.

Link: http://lkml.kernel.org/r/20170215195202.GO25530@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-shmem-allow-registration-of-shared-memory-ranges-fix fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-shmem-allow-registration-of-shared-memory-ranges-fix
+++ a/fs/userfaultfd.c
@@ -1113,6 +1113,7 @@ static int userfaultfd_register(struct u
 	unsigned long vm_flags, new_flags;
 	bool found;
 	bool non_anon_pages;
+	bool hugetlbfs_shared_pages;
 	unsigned long start, end, vma_end;
 
 	user_uffdio_register = (struct uffdio_register __user *) arg;
@@ -1179,6 +1180,7 @@ static int userfaultfd_register(struct u
 	 */
 	found = false;
 	non_anon_pages = false;
+	hugetlbfs_shared_pages = false;
 	for (cur = vma; cur && cur->vm_start < end; cur = cur->vm_next) {
 		cond_resched();
 
@@ -1217,7 +1219,12 @@ static int userfaultfd_register(struct u
 		/*
 		 * Note vmas containing huge pages
 		 */
-		if (is_vm_hugetlb_page(cur) || vma_is_shmem(cur))
+		if (is_vm_hugetlb_page(cur)) {
+			non_anon_pages = true;
+			if (cur->vm_flags & VM_SHARED)
+				hugetlbfs_shared_pages = true;
+		}
+		if (vma_is_shmem(cur))
 			non_anon_pages = true;
 
 		found = true;
@@ -1284,13 +1291,25 @@ out_unlock:
 	up_write(&mm->mmap_sem);
 	mmput(mm);
 	if (!ret) {
+		__u64 ioctls = UFFD_API_RANGE_IOCTLS;
+		if (non_anon_pages)
+			ioctls = UFFD_API_RANGE_IOCTLS_BASIC;
+		/*
+		 * This hugetlbfs_shared_pages check should be dropped
+		 * in the future, so that the
+		 * UFFD_API_RANGE_IOCTLS_BASIC will be reported for
+		 * VM_SHARED hugetlbfs vmas too. For now don't mislead
+		 * userland in thinking UFFDIO_COPY works on hugetlbfs
+		 * shared mappings too.
+		 */
+		if (hugetlbfs_shared_pages)
+			ioctls = 0;
 		/*
 		 * Now that we scanned all vmas we can already tell
 		 * userland which ioctls methods are guaranteed to
 		 * succeed on this range.
 		 */
-		if (put_user(non_anon_pages ? UFFD_API_RANGE_IOCTLS_BASIC :
-			     UFFD_API_RANGE_IOCTLS,
+		if (put_user(ioctls,
 			     &user_uffdio_register->ioctls))
 			ret = -EFAULT;
 	}
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-document-_ior-_iow.patch
userfaultfd-correct-comment-about-uffd_feature_pagefault_flag_wp.patch
userfaultfd-convert-bug-to-warn_on_once.patch
userfaultfd-use-vma_is_anonymous.patch
userfaultfd-non-cooperative-report-all-available-features-to-userland.patch
userfaultfd-non-cooperative-add-fork-event-build-warning-fix.patch
userfaultfd-non-cooperative-optimize-mremap_userfaultfd_complete.patch
userfaultfd-non-cooperative-avoid-madv_dontneed-race-condition.patch
userfaultfd-non-cooperative-wake-userfaults-after-uffdio_unregister.patch
userfaultfd-hugetlbfs-gup-support-vm_fault_retry.patch
userfaultfd-hugetlbfs-uffd_feature_missing_hugetlbfs.patch
userfaultfd-shmem-add-tlbflushh-header-for-microblaze.patch
userfaultfd-shmem-allow-registration-of-shared-memory-ranges-fix.patch
userfaultfd-shmem-lock-the-page-before-adding-it-to-pagecache.patch
userfaultfd-shmem-avoid-a-lockup-resulting-from-corrupted-page-flags.patch
userfaultfd-shmem-avoid-leaking-blocks-and-used-blocks-in-uffdio_copy.patch
userfaultfd-hugetlbfs-uffd_feature_missing_shmem.patch
userfaultfd-selftest-test-uffdio_zeropage-on-all-memory-types.patch
mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock.patch

