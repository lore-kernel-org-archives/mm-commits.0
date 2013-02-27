From: akpm@linux-foundation.org
Subject: [merged] posix-timer-dont-call-idr_find-w-out-of-range-id.patch removed from -mm tree
Date: Wed, 27 Feb 2013 12:51:17 -0800
Message-ID: <20130227205118.17DAE5A41BD@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:43349 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758399Ab3B0UvT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 15:51:19 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so110998ghb.4
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 12:51:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, sasha.levin@oracle.com, stable@vger.kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: posix-timer: don't call idr_find() w/ out-of-range ID
has been removed from the -mm tree.  Its filename was
     posix-timer-dont-call-idr_find-w-out-of-range-id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: posix-timer: don't call idr_find() w/ out-of-range ID

When idr_find() is fed a negative ID, it used to look up the ID ignoring
the sign bit before recent ("idr: remove MAX_IDR_MASK and move left
MAX_IDR_* into idr.c") patch, and triggers WARN_ON_ONCE() after it.

__lock_timer() feeds timer_id from userland directly to idr_find() without
sanitizing it which can trigger the above malfunctions.  Add a range check
on @timer_id before invoking idr_find() in __lock_timer().

While timer_t is defined as int by all archs at the moment, Andrew worries
that it may be defined as a larger type later on.  Make the test cover
larger integers too so that it at least is guaranteed to not return the
wrong timer.

Note that WARN_ON_ONCE() in idr_find() on id < 0 is transitional
precaution while moving away from ignoring MSB.  Once it's gone we can
remove the guard as long as timer_t isn't larger than int.


Given that larger timer_t is possible, at least theoretically, it probably
is better to keep the guard even if idr_find() is later updated, so not
marking the guard as to be removed.

Will send a separate patch to add comment on top of WARN_ON_ONCE() in
idr_find().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN kernel/posix-timers.c~posix-timer-dont-call-idr_find-w-out-of-range-id kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timer-dont-call-idr_find-w-out-of-range-id
+++ a/kernel/posix-timers.c
@@ -639,6 +639,13 @@ static struct k_itimer *__lock_timer(tim
 {
 	struct k_itimer *timr;
 
+	/*
+	 * timer_t could be any type >= int and we want to make sure any
+	 * @timer_id outside positive int range fails lookup.
+	 */
+	if ((unsigned long long)timer_id > INT_MAX)
+		return NULL;
+
 	rcu_read_lock();
 	timr = idr_find(&posix_timers_id, (int)timer_id);
 	if (timr) {
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
lib-devresc-fix-misplaced-endif.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
lib-scatterlist-add-simple-page-iterator.patch
lib-scatterlist-use-page-iterator-in-the-mapping-iterator.patch
lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix.patch
lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix-fix.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
lockdep-check-that-no-locks-held-at-freeze-time.patch
lockdep-check-that-no-locks-held-at-freeze-time-v2.patch
lockdep-check-that-no-locks-held-at-freeze-time-fix.patch
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
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch
idr-deprecate-idr_remove_all.patch
idr-cosmetic-updates-to-struct-initializer-definitions.patch
idr-relocate-idr_for_each_entry-and-reorganize-id_get_new.patch
idr-remove-_idr_rc_to_errno-hack.patch
idr-refactor-idr_get_new_above.patch
idr-implement-idr_preload-and-idr_alloc.patch
idr-implement-idr_preload-and-idr_alloc-fix.patch
block-fix-synchronization-and-limit-check-in-blk_alloc_devt.patch
block-convert-to-idr_alloc.patch
block-loop-convert-to-idr_alloc.patch
atm-nicstar-convert-to-idr_alloc.patch
drbd-convert-to-idr_alloc.patch
dca-convert-to-idr_alloc.patch
dmaengine-convert-to-idr_alloc.patch
firewire-add-minor-number-range-check-to-fw_device_init.patch
firewire-convert-to-idr_alloc.patch
firewire-convert-to-idr_alloc-fix.patch
gpio-convert-to-idr_alloc.patch
drm-convert-to-idr_alloc.patch
drm-convert-to-idr_alloc-fix.patch
drm-convert-to-idr_alloc-fix-fix.patch
drm-exynos-convert-to-idr_alloc.patch
drm-i915-convert-to-idr_alloc.patch
drm-sis-convert-to-idr_alloc.patch
drm-via-convert-to-idr_alloc.patch
drm-vmwgfx-convert-to-idr_alloc.patch
i2c-convert-to-idr_alloc.patch
i2c-convert-to-idr_alloc-fix.patch
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

