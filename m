From: akpm@linux-foundation.org
Subject: + scsi-convert-to-idr_alloc.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:39:08 -0800
Message-ID: <20130206223909.2EC1931C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:38739 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758221Ab3BFWjK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:39:10 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so209724vbi.5
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:39:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, James.Bottomley@HansenPartnership.com


The patch titled
     Subject: scsi: convert to idr_alloc()
has been added to the -mm tree.  Its filename is
     scsi-convert-to-idr_alloc.patch

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
Subject: scsi: convert to idr_alloc()

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ch.c |   21 +++++++++------------
 drivers/scsi/sg.c |   43 +++++++++++++++++--------------------------
 drivers/scsi/st.c |   27 ++++++++-------------------
 3 files changed, 34 insertions(+), 57 deletions(-)

diff -puN drivers/scsi/ch.c~scsi-convert-to-idr_alloc drivers/scsi/ch.c
--- a/drivers/scsi/ch.c~scsi-convert-to-idr_alloc
+++ a/drivers/scsi/ch.c
@@ -895,7 +895,7 @@ static int ch_probe(struct device *dev)
 {
 	struct scsi_device *sd = to_scsi_device(dev);
 	struct device *class_dev;
-	int minor, ret = -ENOMEM;
+	int ret;
 	scsi_changer *ch;
 
 	if (sd->type != TYPE_MEDIUM_CHANGER)
@@ -905,22 +905,19 @@ static int ch_probe(struct device *dev)
 	if (NULL == ch)
 		return -ENOMEM;
 
-	if (!idr_pre_get(&ch_index_idr, GFP_KERNEL))
-		goto free_ch;
-
+	idr_preload(GFP_KERNEL);
 	spin_lock(&ch_index_lock);
-	ret = idr_get_new(&ch_index_idr, ch, &minor);
+	ret = idr_alloc(&ch_index_idr, ch, 0, CH_MAX_DEVS + 1, GFP_NOWAIT);
 	spin_unlock(&ch_index_lock);
+	idr_preload_end();
 
-	if (ret)
+	if (ret < 0) {
+		if (ret == -ENOSPC)
+			ret = -ENODEV;
 		goto free_ch;
-
-	if (minor > CH_MAX_DEVS) {
-		ret = -ENODEV;
-		goto remove_idr;
 	}
 
-	ch->minor = minor;
+	ch->minor = ret;
 	sprintf(ch->name,"ch%d",ch->minor);
 
 	class_dev = device_create(ch_sysfs_class, dev,
@@ -944,7 +941,7 @@ static int ch_probe(struct device *dev)
 
 	return 0;
 remove_idr:
-	idr_remove(&ch_index_idr, minor);
+	idr_remove(&ch_index_idr, ch->minor);
 free_ch:
 	kfree(ch);
 	return ret;
diff -puN drivers/scsi/sg.c~scsi-convert-to-idr_alloc drivers/scsi/sg.c
--- a/drivers/scsi/sg.c~scsi-convert-to-idr_alloc
+++ a/drivers/scsi/sg.c
@@ -1391,24 +1391,23 @@ static Sg_device *sg_alloc(struct gendis
 		return ERR_PTR(-ENOMEM);
 	}
 
-	if (!idr_pre_get(&sg_index_idr, GFP_KERNEL)) {
-		printk(KERN_WARNING "idr expansion Sg_device failure\n");
-		error = -ENOMEM;
-		goto out;
-	}
-
+	idr_preload(GFP_KERNEL);
 	write_lock_irqsave(&sg_index_lock, iflags);
 
-	error = idr_get_new(&sg_index_idr, sdp, &k);
-	if (error) {
-		write_unlock_irqrestore(&sg_index_lock, iflags);
-		printk(KERN_WARNING "idr allocation Sg_device failure: %d\n",
-		       error);
-		goto out;
+	error = idr_alloc(&sg_index_idr, sdp, 0, SG_MAX_DEVS, GFP_NOWAIT);
+	if (error < 0) {
+		if (error == -ENOSPC) {
+			sdev_printk(KERN_WARNING, scsidp,
+				    "Unable to attach sg device type=%d, minor number exceeds %d\n",
+				    scsidp->type, SG_MAX_DEVS - 1);
+			error = -ENODEV;
+		} else {
+			printk(KERN_WARNING
+			       "idr allocation Sg_device failure: %d\n", error);
+		}
+		goto out_unlock;
 	}
-
-	if (unlikely(k >= SG_MAX_DEVS))
-		goto overflow;
+	k = error;
 
 	SCSI_LOG_TIMEOUT(3, printk("sg_alloc: dev=%d \n", k));
 	sprintf(disk->disk_name, "sg%d", k);
@@ -1420,25 +1419,17 @@ static Sg_device *sg_alloc(struct gendis
 	sdp->sg_tablesize = queue_max_segments(q);
 	sdp->index = k;
 	kref_init(&sdp->d_ref);
+	error = 0;
 
+out_unlock:
 	write_unlock_irqrestore(&sg_index_lock, iflags);
+	idr_preload_end();
 
-	error = 0;
- out:
 	if (error) {
 		kfree(sdp);
 		return ERR_PTR(error);
 	}
 	return sdp;
-
- overflow:
-	idr_remove(&sg_index_idr, k);
-	write_unlock_irqrestore(&sg_index_lock, iflags);
-	sdev_printk(KERN_WARNING, scsidp,
-		    "Unable to attach sg device type=%d, minor "
-		    "number exceeds %d\n", scsidp->type, SG_MAX_DEVS - 1);
-	error = -ENODEV;
-	goto out;
 }
 
 static int
diff -puN drivers/scsi/st.c~scsi-convert-to-idr_alloc drivers/scsi/st.c
--- a/drivers/scsi/st.c~scsi-convert-to-idr_alloc
+++ a/drivers/scsi/st.c
@@ -4076,7 +4076,7 @@ static int st_probe(struct device *dev)
 	struct st_modedef *STm;
 	struct st_partstat *STps;
 	struct st_buffer *buffer;
-	int i, dev_num, error;
+	int i, error;
 	char *stp;
 
 	if (SDp->type != TYPE_TAPE)
@@ -4178,27 +4178,17 @@ static int st_probe(struct device *dev)
 	    tpnt->blksize_changed = 0;
 	mutex_init(&tpnt->lock);
 
-	if (!idr_pre_get(&st_index_idr, GFP_KERNEL)) {
-		pr_warn("st: idr expansion failed\n");
-		error = -ENOMEM;
-		goto out_put_disk;
-	}
-
+	idr_preload(GFP_KERNEL);
 	spin_lock(&st_index_lock);
-	error = idr_get_new(&st_index_idr, tpnt, &dev_num);
+	error = idr_alloc(&st_index_idr, tpnt, 0, ST_MAX_TAPES + 1, GFP_NOWAIT);
 	spin_unlock(&st_index_lock);
-	if (error) {
+	idr_preload_end();
+	if (error < 0) {
 		pr_warn("st: idr allocation failed: %d\n", error);
 		goto out_put_disk;
 	}
-
-	if (dev_num > ST_MAX_TAPES) {
-		pr_err("st: Too many tape devices (max. %d).\n", ST_MAX_TAPES);
-		goto out_put_index;
-	}
-
-	tpnt->index = dev_num;
-	sprintf(disk->disk_name, "st%d", dev_num);
+	tpnt->index = error;
+	sprintf(disk->disk_name, "st%d", tpnt->index);
 
 	dev_set_drvdata(dev, tpnt);
 
@@ -4218,9 +4208,8 @@ static int st_probe(struct device *dev)
 
 out_remove_devs:
 	remove_cdevs(tpnt);
-out_put_index:
 	spin_lock(&st_index_lock);
-	idr_remove(&st_index_idr, dev_num);
+	idr_remove(&st_index_idr, tpnt->index);
 	spin_unlock(&st_index_lock);
 out_put_disk:
 	put_disk(disk);
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

