From: akpm@linux-foundation.org
Subject: + block-convert-to-idr_alloc.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:37:22 -0800
Message-ID: <20130206223723.2ADC031C1FF@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:42354 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab3BFWhY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:37:24 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so209900yen.0
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:37:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, axboe@kernel.dk


The patch titled
     Subject: block: convert to idr_alloc()
has been added to the -mm tree.  Its filename is
     block-convert-to-idr_alloc.patch

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
Subject: block: convert to idr_alloc()

Convert to the much saner new idr interface.  Both bsg and genhd
protect idr w/ mutex making preloading unnecessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/bsg.c   |   26 +++++++++-----------------
 block/genhd.c |   21 ++++++---------------
 2 files changed, 15 insertions(+), 32 deletions(-)

diff -puN block/bsg.c~block-convert-to-idr_alloc block/bsg.c
--- a/block/bsg.c~block-convert-to-idr_alloc
+++ a/block/bsg.c
@@ -997,7 +997,7 @@ int bsg_register_queue(struct request_qu
 {
 	struct bsg_class_device *bcd;
 	dev_t dev;
-	int ret, minor;
+	int ret;
 	struct device *class_dev = NULL;
 	const char *devname;
 
@@ -1017,23 +1017,16 @@ int bsg_register_queue(struct request_qu
 
 	mutex_lock(&bsg_mutex);
 
-	ret = idr_pre_get(&bsg_minor_idr, GFP_KERNEL);
-	if (!ret) {
-		ret = -ENOMEM;
+	ret = idr_alloc(&bsg_minor_idr, bcd, 0, BSG_MAX_DEVS, GFP_KERNEL);
+	if (ret < 0) {
+		if (ret == -ENOSPC) {
+			printk(KERN_ERR "bsg: too many bsg devices\n");
+			ret = -EINVAL;
+		}
 		goto unlock;
 	}
 
-	ret = idr_get_new(&bsg_minor_idr, bcd, &minor);
-	if (ret < 0)
-		goto unlock;
-
-	if (minor >= BSG_MAX_DEVS) {
-		printk(KERN_ERR "bsg: too many bsg devices\n");
-		ret = -EINVAL;
-		goto remove_idr;
-	}
-
-	bcd->minor = minor;
+	bcd->minor = ret;
 	bcd->queue = q;
 	bcd->parent = get_device(parent);
 	bcd->release = release;
@@ -1059,8 +1052,7 @@ unregister_class_dev:
 	device_unregister(class_dev);
 put_dev:
 	put_device(parent);
-remove_idr:
-	idr_remove(&bsg_minor_idr, minor);
+	idr_remove(&bsg_minor_idr, bcd->minor);
 unlock:
 	mutex_unlock(&bsg_mutex);
 	return ret;
diff -puN block/genhd.c~block-convert-to-idr_alloc block/genhd.c
--- a/block/genhd.c~block-convert-to-idr_alloc
+++ a/block/genhd.c
@@ -411,7 +411,7 @@ static int blk_mangle_minor(int minor)
 int blk_alloc_devt(struct hd_struct *part, dev_t *devt)
 {
 	struct gendisk *disk = part_to_disk(part);
-	int idx, rc;
+	int idx;
 
 	/* in consecutive minor range? */
 	if (part->partno < disk->minors) {
@@ -420,20 +420,11 @@ int blk_alloc_devt(struct hd_struct *par
 	}
 
 	/* allocate ext devt */
-	do {
-		if (!idr_pre_get(&ext_devt_idr, GFP_KERNEL))
-			return -ENOMEM;
-		mutex_lock(&ext_devt_mutex);
-		rc = idr_get_new(&ext_devt_idr, part, &idx);
-		if (!rc && idx >= NR_EXT_DEVT) {
-			idr_remove(&ext_devt_idr, idx);
-			rc = -EBUSY;
-		}
-		mutex_unlock(&ext_devt_mutex);
-	} while (rc == -EAGAIN);
-
-	if (rc)
-		return rc;
+	mutex_lock(&ext_devt_mutex);
+	idx = idr_alloc(&ext_devt_idr, part, 0, NR_EXT_DEVT, GFP_KERNEL);
+	mutex_unlock(&ext_devt_mutex);
+	if (idx < 0)
+		return idx == -ENOSPC ? -EBUSY : idx;
 
 	*devt = MKDEV(BLOCK_EXT_MAJOR, blk_mangle_minor(idx));
 	return 0;
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

