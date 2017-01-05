From: akpm@linux-foundation.org
Subject: +
 userfaultfd-non-cooperative-report-all-available-features-to-userland.patch added to -mm tree
Date: Wed, 04 Jan 2017 16:53:31 -0800
Message-ID: <586d990b.OmMEIm6/e96+L7SZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36188 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935646AbdAEAyU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: report all available features to userland
has been added to the -mm tree.  Its filename is
     userfaultfd-non-cooperative-report-all-available-features-to-userland.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-non-cooperative-report-all-available-features-to-userland.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-non-cooperative-report-all-available-features-to-userland.patch

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
Subject: userfaultfd: non-cooperative: report all available features to userland

This will allow userland to probe all features available in the kernel. 
It will however only enable the requested features in the open userfaultfd
context.

Link: http://lkml.kernel.org/r/20161216144821.5183-8-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-non-cooperative-report-all-available-features-to-userland fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-non-cooperative-report-all-available-features-to-userland
+++ a/fs/userfaultfd.c
@@ -1252,6 +1252,7 @@ static int userfaultfd_api(struct userfa
 	struct uffdio_api uffdio_api;
 	void __user *buf = (void __user *)arg;
 	int ret;
+	__u64 features;
 
 	ret = -EINVAL;
 	if (ctx->state != UFFD_STATE_WAIT_API)
@@ -1259,21 +1260,23 @@ static int userfaultfd_api(struct userfa
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_api, buf, sizeof(uffdio_api)))
 		goto out;
-	if (uffdio_api.api != UFFD_API ||
-	    (uffdio_api.features & ~UFFD_API_FEATURES)) {
+	features = uffdio_api.features;
+	if (uffdio_api.api != UFFD_API || (features & ~UFFD_API_FEATURES)) {
 		memset(&uffdio_api, 0, sizeof(uffdio_api));
 		if (copy_to_user(buf, &uffdio_api, sizeof(uffdio_api)))
 			goto out;
 		ret = -EINVAL;
 		goto out;
 	}
-	uffdio_api.features &= UFFD_API_FEATURES;
+	/* report all available features and ioctls to userland */
+	uffdio_api.features = UFFD_API_FEATURES;
 	uffdio_api.ioctls = UFFD_API_IOCTLS;
 	ret = -EFAULT;
 	if (copy_to_user(buf, &uffdio_api, sizeof(uffdio_api)))
 		goto out;
 	ctx->state = UFFD_STATE_RUNNING;
-	ctx->features = uffd_ctx_features(uffdio_api.features);
+	/* only enable the requested features for this uffd context */
+	ctx->features = uffd_ctx_features(features);
 	ret = 0;
 out:
 	return ret;
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

