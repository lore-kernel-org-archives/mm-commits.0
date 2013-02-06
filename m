From: akpm@linux-foundation.org
Subject: + memstick-convert-to-idr_alloc.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:38:33 -0800
Message-ID: <20130206223834.222DA31C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:43039 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab3BFWif (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:38:35 -0500
Received: by mail-qe0-f73.google.com with SMTP id 7so209909qeb.2
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:38:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, oakad@yahoo.com


The patch titled
     Subject: memstick: convert to idr_alloc()
has been added to the -mm tree.  Its filename is
     memstick-convert-to-idr_alloc.patch

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
Subject: memstick: convert to idr_alloc()

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/memstick.c    |   21 ++++++++++-----------
 drivers/memstick/core/mspro_block.c |   17 +++--------------
 2 files changed, 13 insertions(+), 25 deletions(-)

diff -puN drivers/memstick/core/memstick.c~memstick-convert-to-idr_alloc drivers/memstick/core/memstick.c
--- a/drivers/memstick/core/memstick.c~memstick-convert-to-idr_alloc
+++ a/drivers/memstick/core/memstick.c
@@ -512,18 +512,17 @@ int memstick_add_host(struct memstick_ho
 {
 	int rc;
 
-	while (1) {
-		if (!idr_pre_get(&memstick_host_idr, GFP_KERNEL))
-			return -ENOMEM;
+	idr_preload(GFP_KERNEL);
+	spin_lock(&memstick_host_lock);
 
-		spin_lock(&memstick_host_lock);
-		rc = idr_get_new(&memstick_host_idr, host, &host->id);
-		spin_unlock(&memstick_host_lock);
-		if (!rc)
-			break;
-		else if (rc != -EAGAIN)
-			return rc;
-	}
+	rc = idr_alloc(&memstick_host_idr, host, 0, 0, GFP_NOWAIT);
+	if (rc >= 0)
+		host->id = rc;
+
+	spin_unlock(&memstick_host_lock);
+	idr_preload_end();
+	if (rc < 0)
+		return rc;
 
 	dev_set_name(&host->dev, "memstick%u", host->id);
 
diff -puN drivers/memstick/core/mspro_block.c~memstick-convert-to-idr_alloc drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-convert-to-idr_alloc
+++ a/drivers/memstick/core/mspro_block.c
@@ -1213,21 +1213,10 @@ static int mspro_block_init_disk(struct 
 	msb->page_size = be16_to_cpu(sys_info->unit_size);
 
 	mutex_lock(&mspro_block_disk_lock);
-	if (!idr_pre_get(&mspro_block_disk_idr, GFP_KERNEL)) {
-		mutex_unlock(&mspro_block_disk_lock);
-		return -ENOMEM;
-	}
-
-	rc = idr_get_new(&mspro_block_disk_idr, card, &disk_id);
+	disk_id = idr_alloc(&mspro_block_disk_idr, card, 0, 256, GFP_KERNEL);
 	mutex_unlock(&mspro_block_disk_lock);
-
-	if (rc)
-		return rc;
-
-	if ((disk_id << MSPRO_BLOCK_PART_SHIFT) > 255) {
-		rc = -ENOSPC;
-		goto out_release_id;
-	}
+	if (disk_id < 0)
+		return disk_id;
 
 	msb->disk = alloc_disk(1 << MSPRO_BLOCK_PART_SHIFT);
 	if (!msb->disk) {
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

