From: akpm@linux-foundation.org
Subject: [merged] firewire-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:13:36 -0800
Message-ID: <20130228201336.BD4C75A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:36889 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab3B1UNi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:13:38 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so244779vch.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:13:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, stefanr@s5r6.in-berlin.de, tim.gardner@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: firewire: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     firewire-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: firewire: convert to idr_alloc()

Convert to the much saner new idr interface.

v2: Stefan pointed out that add_client_resource() may be called from
    non-process context.  Preload iff @gfp_mask contains __GFP_WAIT.
    Also updated to include minor upper limit check.

[tim.gardner@canonical.com: fix accidentally orphaned 'minor'[
Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firewire/core-cdev.c   |   19 ++++++++++---------
 drivers/firewire/core-device.c |   11 +++--------
 2 files changed, 13 insertions(+), 17 deletions(-)

diff -puN drivers/firewire/core-cdev.c~firewire-convert-to-idr_alloc drivers/firewire/core-cdev.c
--- a/drivers/firewire/core-cdev.c~firewire-convert-to-idr_alloc
+++ a/drivers/firewire/core-cdev.c
@@ -487,27 +487,28 @@ static int ioctl_get_info(struct client 
 static int add_client_resource(struct client *client,
 			       struct client_resource *resource, gfp_t gfp_mask)
 {
+	bool preload = gfp_mask & __GFP_WAIT;
 	unsigned long flags;
 	int ret;
 
- retry:
-	if (idr_pre_get(&client->resource_idr, gfp_mask) == 0)
-		return -ENOMEM;
-
+	if (preload)
+		idr_preload(gfp_mask);
 	spin_lock_irqsave(&client->lock, flags);
+
 	if (client->in_shutdown)
 		ret = -ECANCELED;
 	else
-		ret = idr_get_new(&client->resource_idr, resource,
-				  &resource->handle);
+		ret = idr_alloc(&client->resource_idr, resource, 0, 0,
+				GFP_NOWAIT);
 	if (ret >= 0) {
+		resource->handle = ret;
 		client_get(client);
 		schedule_if_iso_resource(resource);
 	}
-	spin_unlock_irqrestore(&client->lock, flags);
 
-	if (ret == -EAGAIN)
-		goto retry;
+	spin_unlock_irqrestore(&client->lock, flags);
+	if (preload)
+		idr_preload_end();
 
 	return ret < 0 ? ret : 0;
 }
diff -puN drivers/firewire/core-device.c~firewire-convert-to-idr_alloc drivers/firewire/core-device.c
--- a/drivers/firewire/core-device.c~firewire-convert-to-idr_alloc
+++ a/drivers/firewire/core-device.c
@@ -1017,16 +1017,11 @@ static void fw_device_init(struct work_s
 
 	fw_device_get(device);
 	down_write(&fw_device_rwsem);
-	ret = idr_pre_get(&fw_device_idr, GFP_KERNEL) ?
-	      idr_get_new(&fw_device_idr, device, &minor) :
-	      -ENOMEM;
-	if (minor >= 1 << MINORBITS) {
-		idr_remove(&fw_device_idr, minor);
-		minor = -ENOSPC;
-	}
+	minor = idr_alloc(&fw_device_idr, device, 0, 1 << MINORBITS,
+			GFP_KERNEL);
 	up_write(&fw_device_rwsem);
 
-	if (ret < 0)
+	if (minor < 0)
 		goto error;
 
 	device->device.bus = &fw_bus_type;
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

