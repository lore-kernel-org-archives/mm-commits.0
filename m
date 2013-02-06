From: akpm@linux-foundation.org
Subject: + power-convert-to-idr_alloc.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:38:54 -0800
Message-ID: <20130206223855.3644A5A4277@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:41564 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758313Ab3BFWi4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:38:56 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so209798vch.2
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:38:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, cbou@mail.ru, dwmw2@infradead.org


The patch titled
     Subject: power: convert to idr_alloc()
has been added to the -mm tree.  Its filename is
     power-convert-to-idr_alloc.patch

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
Subject: power: convert to idr_alloc()

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/bq2415x_charger.c |   11 +++--------
 drivers/power/bq27x00_battery.c |    9 +++------
 drivers/power/ds2782_battery.c  |    9 ++-------
 3 files changed, 8 insertions(+), 21 deletions(-)

diff -puN drivers/power/bq2415x_charger.c~power-convert-to-idr_alloc drivers/power/bq2415x_charger.c
--- a/drivers/power/bq2415x_charger.c~power-convert-to-idr_alloc
+++ a/drivers/power/bq2415x_charger.c
@@ -1504,16 +1504,11 @@ static int bq2415x_probe(struct i2c_clie
 	}
 
 	/* Get new ID for the new device */
-	ret = idr_pre_get(&bq2415x_id, GFP_KERNEL);
-	if (ret == 0)
-		return -ENOMEM;
-
 	mutex_lock(&bq2415x_id_mutex);
-	ret = idr_get_new(&bq2415x_id, client, &num);
+	num = idr_alloc(&bq2415x_id, client, 0, 0, GFP_KERNEL);
 	mutex_unlock(&bq2415x_id_mutex);
-
-	if (ret < 0)
-		return ret;
+	if (num < 0)
+		return num;
 
 	name = kasprintf(GFP_KERNEL, "%s-%d", id->name, num);
 	if (!name) {
diff -puN drivers/power/bq27x00_battery.c~power-convert-to-idr_alloc drivers/power/bq27x00_battery.c
--- a/drivers/power/bq27x00_battery.c~power-convert-to-idr_alloc
+++ a/drivers/power/bq27x00_battery.c
@@ -791,14 +791,11 @@ static int bq27x00_battery_probe(struct 
 	int retval = 0;
 
 	/* Get new ID for the new battery device */
-	retval = idr_pre_get(&battery_id, GFP_KERNEL);
-	if (retval == 0)
-		return -ENOMEM;
 	mutex_lock(&battery_mutex);
-	retval = idr_get_new(&battery_id, client, &num);
+	num = idr_alloc(&battery_id, client, 0, 0, GFP_KERNEL);
 	mutex_unlock(&battery_mutex);
-	if (retval < 0)
-		return retval;
+	if (num < 0)
+		return num;
 
 	name = kasprintf(GFP_KERNEL, "%s-%d", id->name, num);
 	if (!name) {
diff -puN drivers/power/ds2782_battery.c~power-convert-to-idr_alloc drivers/power/ds2782_battery.c
--- a/drivers/power/ds2782_battery.c~power-convert-to-idr_alloc
+++ a/drivers/power/ds2782_battery.c
@@ -395,17 +395,12 @@ static int ds278x_battery_probe(struct i
 	}
 
 	/* Get an ID for this battery */
-	ret = idr_pre_get(&battery_id, GFP_KERNEL);
-	if (ret == 0) {
-		ret = -ENOMEM;
-		goto fail_id;
-	}
-
 	mutex_lock(&battery_lock);
-	ret = idr_get_new(&battery_id, client, &num);
+	ret = idr_alloc(&battery_id, client, 0, 0, GFP_KERNEL);
 	mutex_unlock(&battery_lock);
 	if (ret < 0)
 		goto fail_id;
+	num = ret;
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info) {
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

