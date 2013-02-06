From: akpm@linux-foundation.org
Subject: + misc-c2port-convert-to-idr_alloc.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:38:38 -0800
Message-ID: <20130206223839.2C0285A4277@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:55586 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758221Ab3BFWik (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:38:40 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so209806vea.2
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:38:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, arnd@arndb.de, giometti@linux.it


The patch titled
     Subject: misc/c2port: convert to idr_alloc()
has been added to the -mm tree.  Its filename is
     misc-c2port-convert-to-idr_alloc.patch

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
Subject: misc/c2port: convert to idr_alloc()

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/c2port/core.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff -puN drivers/misc/c2port/core.c~misc-c2port-convert-to-idr_alloc drivers/misc/c2port/core.c
--- a/drivers/misc/c2port/core.c~misc-c2port-convert-to-idr_alloc
+++ a/drivers/misc/c2port/core.c
@@ -885,7 +885,7 @@ struct c2port_device *c2port_device_regi
 					struct c2port_ops *ops, void *devdata)
 {
 	struct c2port_device *c2dev;
-	int id, ret;
+	int ret;
 
 	if (unlikely(!ops) || unlikely(!ops->access) || \
 		unlikely(!ops->c2d_dir) || unlikely(!ops->c2ck_set) || \
@@ -897,22 +897,18 @@ struct c2port_device *c2port_device_regi
 	if (unlikely(!c2dev))
 		return ERR_PTR(-ENOMEM);
 
-	ret = idr_pre_get(&c2port_idr, GFP_KERNEL);
-	if (!ret) {
-		ret = -ENOMEM;
-		goto error_idr_get_new;
-	}
-
+	idr_preload(GFP_KERNEL);
 	spin_lock_irq(&c2port_idr_lock);
-	ret = idr_get_new(&c2port_idr, c2dev, &id);
+	ret = idr_alloc(&c2port_idr, c2dev, 0, 0, GFP_NOWAIT);
 	spin_unlock_irq(&c2port_idr_lock);
+	idr_preload_end();
 
 	if (ret < 0)
-		goto error_idr_get_new;
-	c2dev->id = id;
+		goto error_idr_alloc;
+	c2dev->id = ret;
 
 	c2dev->dev = device_create(c2port_class, NULL, 0, c2dev,
-					"c2port%d", id);
+				   "c2port%d", c2dev->id);
 	if (unlikely(IS_ERR(c2dev->dev))) {
 		ret = PTR_ERR(c2dev->dev);
 		goto error_device_create;
@@ -946,10 +942,10 @@ error_device_create_bin_file:
 
 error_device_create:
 	spin_lock_irq(&c2port_idr_lock);
-	idr_remove(&c2port_idr, id);
+	idr_remove(&c2port_idr, c2dev->id);
 	spin_unlock_irq(&c2port_idr_lock);
 
-error_idr_get_new:
+error_idr_alloc:
 	kfree(c2dev);
 
 	return ERR_PTR(ret);
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

