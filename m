From: akpm@linux-foundation.org
Subject: + i2c-convert-to-idr_alloc.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:38:03 -0800
Message-ID: <20130206223804.255F05A42B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:53933 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab3BFWiF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:38:05 -0500
Received: by mail-qe0-f73.google.com with SMTP id 7so209882qeb.0
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:38:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, khali@linux-fr.org


The patch titled
     Subject: i2c: convert to idr_alloc()
has been added to the -mm tree.  Its filename is
     i2c-convert-to-idr_alloc.patch

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
Subject: i2c: convert to idr_alloc()

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/i2c-core.c |   45 ++++++++-------------------------------
 1 file changed, 10 insertions(+), 35 deletions(-)

diff -puN drivers/i2c/i2c-core.c~i2c-convert-to-idr_alloc drivers/i2c/i2c-core.c
--- a/drivers/i2c/i2c-core.c~i2c-convert-to-idr_alloc
+++ a/drivers/i2c/i2c-core.c
@@ -935,25 +935,16 @@ out_list:
  */
 int i2c_add_adapter(struct i2c_adapter *adapter)
 {
-	int	id, res = 0;
-
-retry:
-	if (idr_pre_get(&i2c_adapter_idr, GFP_KERNEL) == 0)
-		return -ENOMEM;
+	int res;
 
 	mutex_lock(&core_lock);
-	/* "above" here means "above or equal to", sigh */
-	res = idr_get_new_above(&i2c_adapter_idr, adapter,
-				__i2c_first_dynamic_bus_num, &id);
+	res = idr_alloc(&i2c_adapter_idr, adapter,
+			__i2c_first_dynamic_bus_num, 0, GFP_KERNEL);
 	mutex_unlock(&core_lock);
-
-	if (res < 0) {
-		if (res == -EAGAIN)
-			goto retry;
+	if (res < 0)
 		return res;
-	}
 
-	adapter->nr = id;
+	adapter->nr = res;
 	return i2c_register_adapter(adapter);
 }
 EXPORT_SYMBOL(i2c_add_adapter);
@@ -984,33 +975,17 @@ EXPORT_SYMBOL(i2c_add_adapter);
 int i2c_add_numbered_adapter(struct i2c_adapter *adap)
 {
 	int	id;
-	int	status;
 
 	if (adap->nr == -1) /* -1 means dynamically assign bus id */
 		return i2c_add_adapter(adap);
-	if (adap->nr & ~MAX_IDR_MASK)
-		return -EINVAL;
-
-retry:
-	if (idr_pre_get(&i2c_adapter_idr, GFP_KERNEL) == 0)
-		return -ENOMEM;
 
 	mutex_lock(&core_lock);
-	/* "above" here means "above or equal to", sigh;
-	 * we need the "equal to" result to force the result
-	 */
-	status = idr_get_new_above(&i2c_adapter_idr, adap, adap->nr, &id);
-	if (status == 0 && id != adap->nr) {
-		status = -EBUSY;
-		idr_remove(&i2c_adapter_idr, id);
-	}
+	id = idr_alloc(&i2c_adapter_idr, adap, adap->nr, adap->nr + 1,
+		       GFP_KERNEL);
 	mutex_unlock(&core_lock);
-	if (status == -EAGAIN)
-		goto retry;
-
-	if (status == 0)
-		status = i2c_register_adapter(adap);
-	return status;
+	if (id < 0)
+		return id == -ENOSPC ? -EBUSY : id;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(i2c_add_numbered_adapter);
 
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

