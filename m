From: akpm@linux-foundation.org
Subject: + block-fix-synchronization-and-limit-check-in-blk_alloc_devt.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:37:19 -0800
Message-ID: <20130206223720.2EC435A42B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:46926 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab3BFWhV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:37:21 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so209842vea.0
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:37:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, axboe@kernel.dk, stable@vger.kernel.org


The patch titled
     Subject: block: fix synchronization and limit check in blk_alloc_devt()
has been added to the -mm tree.  Its filename is
     block-fix-synchronization-and-limit-check-in-blk_alloc_devt.patch

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
Subject: block: fix synchronization and limit check in blk_alloc_devt()

idr allocation in blk_alloc_devt() wasn't synchronized against lookup
and removal, and its limit check was off by one - 1 << MINORBITS is
the number of minors allowed, not the maximum allowed minor.

Add locking and rename MAX_EXT_DEVT to NR_EXT_DEVT and fix limit
checking.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN block/genhd.c~block-fix-synchronization-and-limit-check-in-blk_alloc_devt block/genhd.c
--- a/block/genhd.c~block-fix-synchronization-and-limit-check-in-blk_alloc_devt
+++ a/block/genhd.c
@@ -26,7 +26,7 @@ static DEFINE_MUTEX(block_class_lock);
 struct kobject *block_depr;
 
 /* for extended dynamic devt allocation, currently only one major is used */
-#define MAX_EXT_DEVT		(1 << MINORBITS)
+#define NR_EXT_DEVT		(1 << MINORBITS)
 
 /* For extended devt allocation.  ext_devt_mutex prevents look up
  * results from going away underneath its user.
@@ -425,19 +425,16 @@ int blk_alloc_devt(struct hd_struct *par
 			return -ENOMEM;
 		mutex_lock(&ext_devt_mutex);
 		rc = idr_get_new(&ext_devt_idr, part, &idx);
+		if (!rc && idx >= NR_EXT_DEVT) {
+			idr_remove(&ext_devt_idr, idx);
+			rc = -EBUSY;
+		}
 		mutex_unlock(&ext_devt_mutex);
 	} while (rc == -EAGAIN);
 
 	if (rc)
 		return rc;
 
-	if (idx > MAX_EXT_DEVT) {
-		mutex_lock(&ext_devt_mutex);
-		idr_remove(&ext_devt_idr, idx);
-		mutex_unlock(&ext_devt_mutex);
-		return -EBUSY;
-	}
-
 	*devt = MKDEV(BLOCK_EXT_MAJOR, blk_mangle_minor(idx));
 	return 0;
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

