From: akpm@linux-foundation.org
Subject: + userfaultfd-hugetlbfs-uffd_feature_missing_hugetlbfs.patch
 added to -mm tree
Date: Wed, 04 Jan 2017 16:54:14 -0800
Message-ID: <586d9936.uc6t0iNhy4w+Q5WN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36238 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937492AbdAEAyX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: hugetlbfs: UFFD_FEATURE_MISSING_HUGETLBFS
has been added to the -mm tree.  Its filename is
     userfaultfd-hugetlbfs-uffd_feature_missing_hugetlbfs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-hugetlbfs-uffd_feature_missing_hugetlbfs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-hugetlbfs-uffd_feature_missing_hugetlbfs.patch

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
Subject: userfaultfd: hugetlbfs: UFFD_FEATURE_MISSING_HUGETLBFS

Userland developers asked to be notified immediately by the UFFDIO_API
ioctl if hugetlbfs missing mode is supported by userfaultfd in the running
kernel.  This avoids the need to run UFFDIO_REGISTER on a hugetlbfs
virtual memory range to find out.

Link: http://lkml.kernel.org/r/20161216144821.5183-27-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/userfaultfd.h |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff -puN include/uapi/linux/userfaultfd.h~userfaultfd-hugetlbfs-uffd_feature_missing_hugetlbfs include/uapi/linux/userfaultfd.h
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-hugetlbfs-uffd_feature_missing_hugetlbfs
+++ a/include/uapi/linux/userfaultfd.h
@@ -18,9 +18,10 @@
  * means the userland is reading).
  */
 #define UFFD_API ((__u64)0xAA)
-#define UFFD_API_FEATURES (UFFD_FEATURE_EVENT_FORK |	    \
-			   UFFD_FEATURE_EVENT_REMAP |	    \
-			   UFFD_FEATURE_EVENT_MADVDONTNEED)
+#define UFFD_API_FEATURES (UFFD_FEATURE_EVENT_FORK |		\
+			   UFFD_FEATURE_EVENT_REMAP |		\
+			   UFFD_FEATURE_EVENT_MADVDONTNEED |	\
+			   UFFD_FEATURE_MISSING_HUGETLBFS)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -125,11 +126,32 @@ struct uffdio_api {
 	 * Note: UFFD_EVENT_PAGEFAULT and UFFD_PAGEFAULT_FLAG_WRITE
 	 * are to be considered implicitly always enabled in all kernels as
 	 * long as the uffdio_api.api requested matches UFFD_API.
+	 *
+	 * UFFD_FEATURE_MISSING_HUGETLBFS means an UFFDIO_REGISTER
+	 * with UFFDIO_REGISTER_MODE_MISSING mode will succeed on
+	 * hugetlbfs virtual memory ranges. Adding or not adding
+	 * UFFD_FEATURE_MISSING_HUGETLBFS to uffdio_api.features has
+	 * no real functional effect after UFFDIO_API returns, but
+	 * it's only useful for an initial feature set probe at
+	 * UFFDIO_API time. There are two ways to use it:
+	 *
+	 * 1) by adding UFFD_FEATURE_MISSING_HUGETLBFS to the
+	 *    uffdio_api.features before calling UFFDIO_API, an error
+	 *    will be returned by UFFDIO_API on a kernel without
+	 *    hugetlbfs missing support
+	 *
+	 * 2) the UFFD_FEATURE_MISSING_HUGETLBFS can not be added in
+	 *    uffdio_api.features and instead it will be set by the
+	 *    kernel in the uffdio_api.features if the kernel supports
+	 *    it, so userland can later check if the feature flag is
+	 *    present in uffdio_api.features after UFFDIO_API
+	 *    succeeded.
 	 */
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
 #define UFFD_FEATURE_EVENT_REMAP		(1<<2)
 #define UFFD_FEATURE_EVENT_MADVDONTNEED		(1<<3)
+#define UFFD_FEATURE_MISSING_HUGETLBFS		(1<<4)
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

