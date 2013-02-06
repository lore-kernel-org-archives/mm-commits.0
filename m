From: akpm@linux-foundation.org
Subject: + pps-convert-to-idr_alloc.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:38:57 -0800
Message-ID: <20130206223858.22EDD5A42B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:33160 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758313Ab3BFWi7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:38:59 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so209634vcd.5
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:38:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, giometti@enneenne.com


The patch titled
     Subject: pps: convert to idr_alloc()
has been added to the -mm tree.  Its filename is
     pps-convert-to-idr_alloc.patch

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
Subject: pps: convert to idr_alloc()

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/kapi.c |    2 +-
 drivers/pps/pps.c  |   36 ++++++++++++++----------------------
 2 files changed, 15 insertions(+), 23 deletions(-)

diff -puN drivers/pps/kapi.c~pps-convert-to-idr_alloc drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~pps-convert-to-idr_alloc
+++ a/drivers/pps/kapi.c
@@ -102,7 +102,7 @@ struct pps_device *pps_register_source(s
 		goto pps_register_source_exit;
 	}
 
-	/* These initializations must be done before calling idr_get_new()
+	/* These initializations must be done before calling idr_alloc()
 	 * in order to avoid reces into pps_event().
 	 */
 	pps->params.api_version = PPS_API_VERS;
diff -puN drivers/pps/pps.c~pps-convert-to-idr_alloc drivers/pps/pps.c
--- a/drivers/pps/pps.c~pps-convert-to-idr_alloc
+++ a/drivers/pps/pps.c
@@ -290,29 +290,21 @@ int pps_register_cdev(struct pps_device 
 	dev_t devt;
 
 	mutex_lock(&pps_idr_lock);
-	/* Get new ID for the new PPS source */
-	if (idr_pre_get(&pps_idr, GFP_KERNEL) == 0) {
-		mutex_unlock(&pps_idr_lock);
-		return -ENOMEM;
-	}
-
-	/* Now really allocate the PPS source.
-	 * After idr_get_new() calling the new source will be freely available
-	 * into the kernel.
+	/*
+	 * Get new ID for the new PPS source.  After idr_alloc() calling
+	 * the new source will be freely available into the kernel.
 	 */
-	err = idr_get_new(&pps_idr, pps, &pps->id);
-	mutex_unlock(&pps_idr_lock);
-
-	if (err < 0)
-		return err;
-
-	pps->id &= MAX_IDR_MASK;
-	if (pps->id >= PPS_MAX_SOURCES) {
-		pr_err("%s: too many PPS sources in the system\n",
-					pps->info.name);
-		err = -EBUSY;
-		goto free_idr;
+	err = idr_alloc(&pps_idr, pps, 0, PPS_MAX_SOURCES, GFP_KERNEL);
+	if (err < 0) {
+		if (err == -ENOSPC) {
+			pr_err("%s: too many PPS sources in the system\n",
+			       pps->info.name);
+			err = -EBUSY;
+		}
+		goto out_unlock;
 	}
+	pps->id = err;
+	mutex_unlock(&pps_idr_lock);
 
 	devt = MKDEV(MAJOR(pps_devt), pps->id);
 
@@ -345,8 +337,8 @@ del_cdev:
 free_idr:
 	mutex_lock(&pps_idr_lock);
 	idr_remove(&pps_idr, pps->id);
+out_unlock:
 	mutex_unlock(&pps_idr_lock);
-
 	return err;
 }
 
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

