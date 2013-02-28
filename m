From: akpm@linux-foundation.org
Subject: [folded-dropped] idr-implement-idr_preload-and-idr_alloc-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:42:36 -0800
Message-ID: <20130228004236.745E631C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:46118 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3B1Amh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:42:37 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so138793ghb.0
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:42:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: idr: implement idr_preload[_end]() and idr_alloc()
has been removed from the -mm tree.  Its filename was
     idr-implement-idr_preload-and-idr_alloc-fix.patch

This patch was dropped because it was folded into idr-implement-idr_preload-and-idr_alloc.patch

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: idr: implement idr_preload[_end]() and idr_alloc()

v3: In idr_alloc() treat @end <= 0 as indicating max.  This is
    necessary to always allow using @start + N as @end for a positive
    integer N.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN lib/idr.c~idr-implement-idr_preload-and-idr_alloc-fix lib/idr.c
--- a/lib/idr.c~idr-implement-idr_preload-and-idr_alloc-fix
+++ a/lib/idr.c
@@ -439,13 +439,16 @@ EXPORT_SYMBOL(idr_preload);
  * @idr: the (initialized) idr
  * @ptr: pointer to be associated with the new id
  * @start: the minimum id (inclusive)
- * @end: the maximum id (exclusive, 0 for max)
+ * @end: the maximum id (exclusive, <= 0 for max)
  * @gfp_mask: memory allocation flags
  *
  * Allocate an id in [start, end) and associate it with @ptr.  If no ID is
  * available in the specified range, returns -ENOSPC.  On memory allocation
  * failure, returns -ENOMEM.
  *
+ * Note that @end is treated as max when <= 0.  This is to always allow
+ * using @start + N as @end as long as N is inside integer range.
+ *
  * The user is responsible for exclusively synchronizing all operations
  * which may modify @idr.  However, read-only accesses such as idr_find()
  * or iteration can be performed under RCU read lock provided the user
@@ -453,14 +456,14 @@ EXPORT_SYMBOL(idr_preload);
  */
 int idr_alloc(struct idr *idr, void *ptr, int start, int end, gfp_t gfp_mask)
 {
-	int max = end ? end - 1 : INT_MAX;	/* inclusive upper limit */
+	int max = end > 0 ? end - 1 : INT_MAX;	/* inclusive upper limit */
 	struct idr_layer *pa[MAX_IDR_LEVEL];
 	int id;
 
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
 	/* sanity checks */
-	if (WARN_ON_ONCE(start < 0 || end < 0))
+	if (WARN_ON_ONCE(start < 0))
 		return -EINVAL;
 	if (unlikely(max < start))
 		return -ENOSPC;
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

