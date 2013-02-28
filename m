From: akpm@linux-foundation.org
Subject: [merged] rpmsg-dont-use-idr_remove_all.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:12:43 -0800
Message-ID: <20130228201243.F27D331C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:54000 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103Ab3B1UMo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:12:44 -0500
Received: by mail-ye0-f201.google.com with SMTP id m12so245138yen.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:12:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, ohad@wizery.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rpmsg: don't use idr_remove_all()
has been removed from the -mm tree.  Its filename was
     rpmsg-dont-use-idr_remove_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: rpmsg: don't use idr_remove_all()

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rpmsg/virtio_rpmsg_bus.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rpmsg/virtio_rpmsg_bus.c~rpmsg-dont-use-idr_remove_all drivers/rpmsg/virtio_rpmsg_bus.c
--- a/drivers/rpmsg/virtio_rpmsg_bus.c~rpmsg-dont-use-idr_remove_all
+++ a/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -1036,7 +1036,6 @@ static void rpmsg_remove(struct virtio_d
 	if (vrp->ns_ept)
 		__rpmsg_destroy_ept(vrp, vrp->ns_ept);
 
-	idr_remove_all(&vrp->endpoints);
 	idr_destroy(&vrp->endpoints);
 
 	vdev->config->del_vqs(vrp->vdev);
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

