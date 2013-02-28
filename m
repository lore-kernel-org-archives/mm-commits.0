From: akpm@linux-foundation.org
Subject: [folded-merged] i2c-convert-to-idr_alloc-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:44:32 -0800
Message-ID: <20130228004433.1C05131C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:42768 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3B1Aoe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:44:34 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so138959ves.3
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:44:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, broonie@opensource.wolfsonmicro.com, khali@linux-fr.org, wolfram@the-dreams.de, mm-commits@vger.kernel.org


The patch titled
     Subject: i2c-convert-to-idr_alloc-fix
has been removed from the -mm tree.  Its filename was
     i2c-convert-to-idr_alloc-fix.patch

This patch was dropped because it was folded into i2c-convert-to-idr_alloc.patch

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: i2c-convert-to-idr_alloc-fix

v2: The original conversion accidentally dropped a call to
    i2c_register_adapter() in i2c_add_numbered_adapter() leaving @adap
    uninitialized and unregistered.  Reported by Mark Brown.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Wolfram Sang <wolfram@the-dreams.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/i2c-core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/i2c/i2c-core.c~i2c-convert-to-idr_alloc-fix drivers/i2c/i2c-core.c
--- a/drivers/i2c/i2c-core.c~i2c-convert-to-idr_alloc-fix
+++ a/drivers/i2c/i2c-core.c
@@ -978,6 +978,8 @@ int i2c_add_numbered_adapter(struct i2c_
 
 	if (adap->nr == -1) /* -1 means dynamically assign bus id */
 		return i2c_add_adapter(adap);
+	if (adap->nr & ~MAX_IDR_MASK)
+		return -EINVAL;
 
 	mutex_lock(&core_lock);
 	id = idr_alloc(&i2c_adapter_idr, adap, adap->nr, adap->nr + 1,
@@ -985,7 +987,7 @@ int i2c_add_numbered_adapter(struct i2c_
 	mutex_unlock(&core_lock);
 	if (id < 0)
 		return id == -ENOSPC ? -EBUSY : id;
-	return 0;
+	return i2c_register_adapter(adap);
 }
 EXPORT_SYMBOL_GPL(i2c_add_numbered_adapter);
 
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
lib-devresc-fix-misplaced-endif.patch
lib-scatterlist-add-simple-page-iterator.patch
lib-scatterlist-use-page-iterator-in-the-mapping-iterator.patch
lockdep-check-that-no-locks-held-at-freeze-time.patch
coredump-use-a-freezable_schedule-for-the-coredump_finish-wait.patch
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
i2c-convert-to-idr_alloc-fix-fix.patch
ib-core-convert-to-idr_alloc.patch
ib-amso1100-convert-to-idr_alloc.patch
ib-cxgb3-convert-to-idr_alloc.patch
ib-cxgb4-convert-to-idr_alloc.patch
ib-ehca-convert-to-idr_alloc.patch
ib-ipath-convert-to-idr_alloc.patch
ib-ipath-convert-to-idr_alloc-fix.patch
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
ipc-convert-to-idr_alloc-fix.patch
cgroup-convert-to-idr_alloc.patch
events-convert-to-idr_alloc.patch
posix-timers-convert-to-idr_alloc.patch
net-9p-convert-to-idr_alloc.patch
mac80211-convert-to-idr_alloc.patch
sctp-convert-to-idr_alloc.patch
nfs4client-convert-to-idr_alloc.patch
idr-fix-top-layer-handling.patch
idr-remove-max_idr_mask-and-move-left-max_idr_-into-idrc.patch
idr-remove-length-restriction-from-idr_layer-bitmap.patch
idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes.patch
idr-make-idr_layer-larger.patch
idr-add-idr_layer-prefix.patch
idr-implement-lookup-hint.patch
idr-implement-lookup-hint-always-do-slow-path-when-hint-is-uninitialized.patch
idr-explain-warn_on_once-on-negative-ids-out-of-range-id.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch

