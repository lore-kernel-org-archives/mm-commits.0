From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-hugetlbfs-uffd_feature_missing_hugetlbfs.patch removed from -mm tree
Date: Thu, 23 Feb 2017 13:14:22 -0800
Message-ID: <58af50ae.FCS2J4+ym9QecnqL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40010 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751284AbdBWVOt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:14:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: hugetlbfs: UFFD_FEATURE_MISSING_HUGETLBFS
has been removed from the -mm tree.  Its filename was
     userfaultfd-hugetlbfs-uffd_feature_missing_hugetlbfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2-fix-fix.patch

