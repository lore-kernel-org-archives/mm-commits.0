From: akpm@linux-foundation.org
Subject: + userfaultfd-hugetlbfs-uffd_feature_missing_shmem.patch added to -mm tree
Date: Wed, 04 Jan 2017 16:54:36 -0800
Message-ID: <586d994c.0yfYlVN5Kjekf1qD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36230 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937519AbdAEAya (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: hugetlbfs: UFFD_FEATURE_MISSING_SHMEM
has been added to the -mm tree.  Its filename is
     userfaultfd-hugetlbfs-uffd_feature_missing_shmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-hugetlbfs-uffd_feature_missing_shmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-hugetlbfs-uffd_feature_missing_shmem.patch

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
Subject: userfaultfd: hugetlbfs: UFFD_FEATURE_MISSING_SHMEM

Userland developers asked to be notified immediately by the UFFDIO_API
ioctl if shmem missing mode is supported by userfaultfd in the running
kernel. This avoids the need to run UFFDIO_REGISTER on a shmem virtual
memory range to find out.

Link: http://lkml.kernel.org/r/20161216144821.5183-38-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/userfaultfd.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN include/uapi/linux/userfaultfd.h~userfaultfd-hugetlbfs-uffd_feature_missing_shmem include/uapi/linux/userfaultfd.h
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-hugetlbfs-uffd_feature_missing_shmem
+++ a/include/uapi/linux/userfaultfd.h
@@ -21,7 +21,8 @@
 #define UFFD_API_FEATURES (UFFD_FEATURE_EVENT_FORK |		\
 			   UFFD_FEATURE_EVENT_REMAP |		\
 			   UFFD_FEATURE_EVENT_MADVDONTNEED |	\
-			   UFFD_FEATURE_MISSING_HUGETLBFS)
+			   UFFD_FEATURE_MISSING_HUGETLBFS |	\
+			   UFFD_FEATURE_MISSING_SHMEM)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -146,12 +147,17 @@ struct uffdio_api {
 	 *    it, so userland can later check if the feature flag is
 	 *    present in uffdio_api.features after UFFDIO_API
 	 *    succeeded.
+	 *
+	 * UFFD_FEATURE_MISSING_SHMEM works the same as
+	 * UFFD_FEATURE_MISSING_HUGETLBFS, but it applies to shmem
+	 * (i.e. tmpfs and other shmem based APIs).
 	 */
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
 #define UFFD_FEATURE_EVENT_REMAP		(1<<2)
 #define UFFD_FEATURE_EVENT_MADVDONTNEED		(1<<3)
 #define UFFD_FEATURE_MISSING_HUGETLBFS		(1<<4)
+#define UFFD_FEATURE_MISSING_SHMEM		(1<<5)
 	__u64 features;
 
 	__u64 ioctls;
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
userfaultfd-shmem-lock-the-page-before-adding-it-to-pagecache.patch
userfaultfd-shmem-avoid-leaking-blocks-and-used-blocks-in-uffdio_copy.patch
userfaultfd-hugetlbfs-uffd_feature_missing_shmem.patch
userfaultfd-selftest-test-uffdio_zeropage-on-all-memory-types.patch
mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock.patch

