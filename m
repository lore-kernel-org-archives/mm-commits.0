From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-non-cooperative-report-all-available-features-to-userland.patch removed from -mm tree
Date: Thu, 23 Feb 2017 13:13:31 -0800
Message-ID: <58af507b.pfvtilpD8IKQ3nff%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39864 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdBWVOr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:14:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: report all available features to userland
has been removed from the -mm tree.  Its filename was
     userfaultfd-non-cooperative-report-all-available-features-to-userland.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1285,6 +1285,7 @@ static int userfaultfd_api(struct userfa
 	struct uffdio_api uffdio_api;
 	void __user *buf = (void __user *)arg;
 	int ret;
+	__u64 features;
 
 	ret = -EINVAL;
 	if (ctx->state != UFFD_STATE_WAIT_API)
@@ -1292,21 +1293,23 @@ static int userfaultfd_api(struct userfa
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

userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2-fix-fix.patch

