From: akpm@linux-foundation.org
Subject: [merged] vfio-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:15:27 -0800
Message-ID: <20130228201527.A4C305A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:60249 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236Ab3B1UP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:15:28 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so246812yhr.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:15:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, alex.williamson@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vfio: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     vfio-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: vfio: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vfio/vfio.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff -puN drivers/vfio/vfio.c~vfio-convert-to-idr_alloc drivers/vfio/vfio.c
--- a/drivers/vfio/vfio.c~vfio-convert-to-idr_alloc
+++ a/drivers/vfio/vfio.c
@@ -139,23 +139,8 @@ EXPORT_SYMBOL_GPL(vfio_unregister_iommu_
  */
 static int vfio_alloc_group_minor(struct vfio_group *group)
 {
-	int ret, minor;
-
-again:
-	if (unlikely(idr_pre_get(&vfio.group_idr, GFP_KERNEL) == 0))
-		return -ENOMEM;
-
 	/* index 0 is used by /dev/vfio/vfio */
-	ret = idr_get_new_above(&vfio.group_idr, group, 1, &minor);
-	if (ret == -EAGAIN)
-		goto again;
-	if (ret || minor > MINORMASK) {
-		if (minor > MINORMASK)
-			idr_remove(&vfio.group_idr, minor);
-		return -ENOSPC;
-	}
