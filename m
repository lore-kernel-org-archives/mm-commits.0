From: akpm@linux-foundation.org
Subject: + firewire-convert-to-idr_alloc.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:37:42 -0800
Message-ID: <20130206223743.01D095A42B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:45874 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab3BFWho (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:37:44 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so210416ghb.0
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:37:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, stefanr@s5r6.in-berlin.de


The patch titled
     Subject: firewire: convert to idr_alloc()
has been added to the -mm tree.  Its filename is
     firewire-convert-to-idr_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: firewire: convert to idr_alloc()

Convert to the much saner new idr interface.

Only compile tested.

v2: Stefan pointed out that add_client_resource() may be called from
    non-process context.  Preload iff @gfp_mask contains __GFP_WAIT.
    Also updated to include minor upper limit check.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firewire/core-cdev.c   |   19 ++++++++++---------
 drivers/firewire/core-device.c |    8 +-------
 2 files changed, 11 insertions(+), 16 deletions(-)

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
@@ -1017,13 +1017,7 @@ static void fw_device_init(struct work_s
 
 	fw_device_get(device);
 	down_write(&fw_device_rwsem);
-	ret = idr_pre_get(&fw_device_idr, GFP_KERNEL) ?
-	      idr_get_new(&fw_device_idr, device, &minor) :
-	      -ENOMEM;
-	if (minor >= 1 << MINORBITS) {
-		idr_remove(&fw_device_idr, minor);
-		minor = -ENOSPC;
-	}
+	ret = idr_alloc(&fw_device_idr, device, 0, 1 << MINORBITS, GFP_KERNEL);
 	up_write(&fw_device_rwsem);
 
 	if (ret < 0)
_

Patches currently in -mm which might be from tj@kernel.org are

linux-next.patch
cfq-fix-lock-imbalance-with-failed-allocations.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled.patch
memcg-clean-up-swap-accounting-initialization-code.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
idr-fix-a-subtle-bug-in-idr_get_next.patch
idr-make-idr_destroy-imply-idr_remove_all.patch
atm-nicstar-dont-use-idr_remove_all.patch
block-loop-dont-use-idr_remove_all.patch
firewire-dont-use-idr_remove_all.patch
drm-dont-use-idr_remove_all.patch
dm-dont-use-idr_remove_all.patch
remoteproc-dont-use-idr_remove_all.patch
rpmsg-dont-use-idr_remove_all.patch
dlm-use-idr_for_each_entry-in-recover_idr_clear-error-path.patch
dlm-dont-use-idr_remove_all.patch
nfs-idr_destroy-no-longer-needs-idr_remove_all.patch
inotify-dont-use-idr_remove_all.patch
cgroup-dont-use-idr_remove_all.patch
idr-deprecate-idr_remove_all.patch
idr-cosmetic-updates-to-struct-initializer-definitions.patch
idr-relocate-idr_for_each_entry-and-reorganize-id_get_new.patch
idr-remove-_idr_rc_to_errno-hack.patch
idr-refactor-idr_get_new_above.patch
idr-implement-idr_preload-and-idr_alloc.patch
block-fix-synchronization-and-limit-check-in-blk_alloc_devt.patch
block-convert-to-idr_alloc.patch
block-loop-convert-to-idr_alloc.patch
atm-nicstar-convert-to-idr_alloc.patch
drbd-convert-to-idr_alloc.patch
dca-convert-to-idr_alloc.patch
dmaengine-convert-to-idr_alloc.patch
firewire-add-minor-number-range-check-to-fw_device_init.patch
firewire-convert-to-idr_alloc.patch
gpio-convert-to-idr_alloc.patch
drm-convert-to-idr_alloc.patch
drm-exynos-convert-to-idr_alloc.patch
drm-i915-convert-to-idr_alloc.patch
drm-sis-convert-to-idr_alloc.patch
drm-via-convert-to-idr_alloc.patch
drm-vmwgfx-convert-to-idr_alloc.patch
i2c-convert-to-idr_alloc.patch
ib-core-convert-to-idr_alloc.patch
ib-amso1100-convert-to-idr_alloc.patch
ib-cxgb3-convert-to-idr_alloc.patch
ib-cxgb4-convert-to-idr_alloc.patch
ib-ehca-convert-to-idr_alloc.patch
ib-ipath-convert-to-idr_alloc.patch
ib-mlx4-convert-to-idr_alloc.patch
ib-ocrdma-convert-to-idr_alloc.patch
ib-qib-convert-to-idr_alloc.patch
dm-convert-to-idr_alloc.patch
memstick-convert-to-idr_alloc.patch
mfd-convert-to-idr_alloc.patch
misc-c2port-convert-to-idr_alloc.patch
misc-tifm_core-convert-to-idr_alloc.patch
mmc-convert-to-idr_alloc.patch
mtd-convert-to-idr_alloc.patch
macvtap-convert-to-idr_alloc.patch
ppp-convert-to-idr_alloc.patch
power-convert-to-idr_alloc.patch
pps-convert-to-idr_alloc.patch
remoteproc-convert-to-idr_alloc.patch
rpmsg-convert-to-idr_alloc.patch
scsi-bfa-convert-to-idr_alloc.patch
scsi-convert-to-idr_alloc.patch
target-iscsi-convert-to-idr_alloc.patch
scsi-lpfc-convert-to-idr_alloc.patch
thermal-convert-to-idr_alloc.patch
uio-convert-to-idr_alloc.patch
vfio-convert-to-idr_alloc.patch
dlm-convert-to-idr_alloc.patch
inotify-convert-to-idr_alloc.patch
ocfs2-convert-to-idr_alloc.patch
ipc-convert-to-idr_alloc.patch
cgroup-convert-to-idr_alloc.patch
events-convert-to-idr_alloc.patch
posix-timers-convert-to-idr_alloc.patch
net-9p-convert-to-idr_alloc.patch
mac80211-convert-to-idr_alloc.patch
sctp-convert-to-idr_alloc.patch
nfs4client-convert-to-idr_alloc.patch

