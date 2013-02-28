From: akpm@linux-foundation.org
Subject: [merged] uio-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:15:24 -0800
Message-ID: <20130228201524.A5BA131C211@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:39971 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236Ab3B1UPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:15:25 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so244893ghb.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:15:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, gregkh@linuxfoundation.org, hjk@hansjkoch.de, mm-commits@vger.kernel.org


The patch titled
     Subject: uio: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     uio-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: uio: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/uio/uio.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff -puN drivers/uio/uio.c~uio-convert-to-idr_alloc drivers/uio/uio.c
--- a/drivers/uio/uio.c~uio-convert-to-idr_alloc
+++ a/drivers/uio/uio.c
@@ -369,26 +369,15 @@ static void uio_dev_del_attributes(struc
 static int uio_get_minor(struct uio_device *idev)
 {
 	int retval = -ENOMEM;
-	int id;
 
 	mutex_lock(&minor_lock);
-	if (idr_pre_get(&uio_idr, GFP_KERNEL) == 0)
-		goto exit;
-
-	retval = idr_get_new(&uio_idr, idev, &id);
-	if (retval < 0) {
-		if (retval == -EAGAIN)
-			retval = -ENOMEM;
-		goto exit;
-	}
-	if (id < UIO_MAX_DEVICES) {
-		idev->minor = id;
-	} else {
+	retval = idr_alloc(&uio_idr, idev, 0, UIO_MAX_DEVICES, GFP_KERNEL);
+	if (retval >= 0) {
+		idev->minor = retval;
+	} else if (retval == -ENOSPC) {
 		dev_err(idev->dev, "too many uio devices\n");
 		retval = -EINVAL;
-		idr_remove(&uio_idr, id);
 	}
-exit:
 	mutex_unlock(&minor_lock);
 	return retval;
 }
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

