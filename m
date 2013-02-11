From: akpm@linux-foundation.org
Subject: + idr-remove-max_idr_mask-and-move-left-max_idr_-into-idrc.patch added to -mm tree
Date: Mon, 11 Feb 2013 15:42:21 -0800
Message-ID: <20130211234221.9EF305A403C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:33491 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760128Ab3BKXmY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Feb 2013 18:42:24 -0500
Received: by mail-oa0-f74.google.com with SMTP id k14so1259457oag.3
        for <mm-commits@vger.kernel.org>; Mon, 11 Feb 2013 15:42:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, hal.rosenstock@gmail.com, jackm@dev.mellanox.co.il, khali@linux-fr.org, mike.marciniszyn@intel.com, ogerlitz@mellanox.com, roland@kernel.org, sean.hefty@intel.com, viro@zeniv.linux.org.uk, wolfram@the-dreams.de


The patch titled
     Subject: idr: remove MAX_IDR_MASK and move left MAX_IDR_* into idr.c
has been added to the -mm tree.  Its filename is
     idr-remove-max_idr_mask-and-move-left-max_idr_-into-idrc.patch

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
Subject: idr: remove MAX_IDR_MASK and move left MAX_IDR_* into idr.c

MAX_IDR_MASK is another weirdness in the idr interface.  As idr covers
whole positive integer range, it's defined as 0x7fffffff or INT_MAX.

Its usage in idr_find(), idr_replace() and idr_remove() is bizarre.
They basically mask off the sign bit and operate on the rest, so if
the caller, by accident, passes in a negative number, the sign bit
will be masked off and the remaining part will be used as if that was
the input, which is worse than crashing.

The constant is visible in idr.h and there are several users in the
kernel.

* drivers/i2c/i2c-core.c:i2c_add_numbered_adapter()

  Basically used to test if adap->nr is a negative number which isn't
  -1 and returns -EINVAL if so.  idr_alloc() already has negative
  @start checking (w/ WARN_ON_ONCE), so this can go away.

* drivers/infiniband/core/cm.c:cm_alloc_id()
  drivers/infiniband/hw/mlx4/cm.c:id_map_alloc()

  Used to wrap cyclic @start.  Can be replaced with max(next, 0).
  Note that this type of cyclic allocation using idr is buggy.  These
  are prone to spurious -ENOSPC failure after the first wraparound.

* fs/super.c:get_anon_bdev()

  The ID allocated from ida is masked off before being tested whether
  it's inside valid range.  ida allocated ID can never be a negative
  number and the masking is unnecessary.

Update idr_*() functions to fail with -EINVAL when negative @id is
specified and update other MAX_IDR_MASK users as described above.

This leaves MAX_IDR_MASK without any user, remove it and relocate
other MAX_IDR_* constants to lib/idr.c.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc: Jack Morgenstein <jackm@dev.mellanox.co.il>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Wolfram Sang <wolfram@the-dreams.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/i2c-core.c          |    2 --
 drivers/infiniband/core/cm.c    |    2 +-
 drivers/infiniband/hw/mlx4/cm.c |    2 +-
 fs/super.c                      |    2 +-
 include/linux/idr.h             |   10 ----------
 lib/idr.c                       |   24 +++++++++++++++++-------
 6 files changed, 20 insertions(+), 22 deletions(-)

diff -puN drivers/i2c/i2c-core.c~idr-remove-max_idr_mask-and-move-left-max_idr_-into-idrc drivers/i2c/i2c-core.c
--- a/drivers/i2c/i2c-core.c~idr-remove-max_idr_mask-and-move-left-max_idr_-into-idrc
+++ a/drivers/i2c/i2c-core.c
@@ -978,8 +978,6 @@ int i2c_add_numbered_adapter(struct i2c_
 
 	if (adap->nr == -1) /* -1 means dynamically assign bus id */
 		return i2c_add_adapter(adap);
-	if (adap->nr & ~MAX_IDR_MASK)
-		return -EINVAL;
 
 	mutex_lock(&core_lock);
 	id = idr_alloc(&i2c_adapter_idr, adap, adap->nr, adap->nr + 1,
diff -puN drivers/infiniband/core/cm.c~idr-remove-max_idr_mask-and-move-left-max_idr_-into-idrc drivers/infiniband/core/cm.c
--- a/drivers/infiniband/core/cm.c~idr-remove-max_idr_mask-and-move-left-max_idr_-into-idrc
+++ a/drivers/infiniband/core/cm.c
@@ -390,7 +390,7 @@ static int cm_alloc_id(struct cm_id_priv
 
 	id = idr_alloc(&cm.local_id_table, cm_id_priv, next_id, 0, GFP_NOWAIT);
 	if (id >= 0)
-		next_id = ((unsigned) id + 1) & MAX_IDR_MASK;
+		next_id = max(id + 1, 0);
 
 	spin_unlock_irqrestore(&cm.lock, flags);
 	idr_preload_end();
diff -puN drivers/infiniband/hw/mlx4/cm.c~idr-remove-max_idr_mask-and-move-left-max_idr_-into-idrc drivers/infiniband/hw/mlx4/cm.c
--- a/drivers/infiniband/hw/mlx4/cm.c~idr-remove-max_idr_mask-and-move-left-max_idr_-into-idrc
+++ a/drivers/infiniband/hw/mlx4/cm.c
@@ -225,7 +225,7 @@ id_map_alloc(struct ib_device *ibdev, in
 
 	ret = idr_alloc(&sriov->pv_id_table, ent, next_id, 0, GFP_NOWAIT);
 	if (ret >= 0) {
-		next_id = ((unsigned)ret + 1) & MAX_IDR_MASK;
+		next_id = max(ret + 1, 0);
 		ent->pv_cm_id = (u32)ret;
 		sl_id_map_add(ibdev, ent);
 		list_add_tail(&ent->list, &sriov->cm_list);
diff -puN fs/super.c~idr-remove-max_idr_mask-and-move-left-max_idr_-into-idrc fs/super.c
--- a/fs/super.c~idr-remove-max_idr_mask-and-move-left-max_idr_-into-idrc
+++ a/fs/super.c
@@ -842,7 +842,7 @@ int get_anon_bdev(dev_t *p)
 	else if (error)
 		return -EAGAIN;
 
-	if ((dev & MAX_IDR_MASK) == (1 << MINORBITS)) {
+	if (dev == (1 << MINORBITS)) {
 		spin_lock(&unnamed_dev_lock);
 		ida_remove(&unnamed_dev_ida, dev);
 		if (unnamed_dev_start > dev)
diff -puN include/linux/idr.h~idr-remove-max_idr_mask-and-move-left-max_idr_-into-idrc include/linux/idr.h
--- a/include/linux/idr.h~idr-remove-max_idr_mask-and-move-left-max_idr_-into-idrc
+++ a/include/linux/idr.h
@@ -38,16 +38,6 @@
 #define IDR_SIZE (1 << IDR_BITS)
 #define IDR_MASK ((1 << IDR_BITS)-1)
 
-#define MAX_IDR_SHIFT (sizeof(int)*8 - 1)
-#define MAX_IDR_BIT (1U << MAX_IDR_SHIFT)
-#define MAX_IDR_MASK (MAX_IDR_BIT - 1)
-
-/* Leave the possibility of an incomplete final layer */
-#define MAX_IDR_LEVEL ((MAX_IDR_SHIFT + IDR_BITS - 1) / IDR_BITS)
-
-/* Number of id_layer structs to leave in free list */
-#define MAX_IDR_FREE (MAX_IDR_LEVEL * 2)
-
 struct idr_layer {
 	unsigned long		bitmap;	/* A zero bit means "space here" */
 	struct idr_layer __rcu	*ary[1<<IDR_BITS];
diff -puN lib/idr.c~idr-remove-max_idr_mask-and-move-left-max_idr_-into-idrc lib/idr.c
--- a/lib/idr.c~idr-remove-max_idr_mask-and-move-left-max_idr_-into-idrc
+++ a/lib/idr.c
@@ -38,6 +38,15 @@
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
 
+#define MAX_IDR_SHIFT		(sizeof(int) * 8 - 1)
+#define MAX_IDR_BIT		(1U << MAX_IDR_SHIFT)
+
+/* Leave the possibility of an incomplete final layer */
+#define MAX_IDR_LEVEL ((MAX_IDR_SHIFT + IDR_BITS - 1) / IDR_BITS)
+
+/* Number of id_layer structs to leave in free list */
+#define MAX_IDR_FREE (MAX_IDR_LEVEL * 2)
+
 static struct kmem_cache *idr_layer_cache;
 static DEFINE_PER_CPU(struct idr_layer *, idr_preload_head);
 static DEFINE_PER_CPU(int, idr_preload_cnt);
@@ -542,8 +551,8 @@ void idr_remove(struct idr *idp, int id)
 	struct idr_layer *p;
 	struct idr_layer *to_free;
 
-	/* Mask off upper bits we don't use for the search. */
-	id &= MAX_IDR_MASK;
+	if (WARN_ON_ONCE(id < 0))
+		return;
 
 	sub_remove(idp, (idp->layers - 1) * IDR_BITS, id);
 	if (idp->top && idp->top->count == 1 && (idp->layers > 1) &&
@@ -650,14 +659,14 @@ void *idr_find(struct idr *idp, int id)
 	int n;
 	struct idr_layer *p;
 
+	if (WARN_ON_ONCE(id < 0))
+		return NULL;
+
 	p = rcu_dereference_raw(idp->top);
 	if (!p)
 		return NULL;
 	n = (p->layer+1) * IDR_BITS;
 
-	/* Mask off upper bits we don't use for the search. */
-	id &= MAX_IDR_MASK;
-
 	if (id > idr_max(p->layer + 1))
 		return NULL;
 	BUG_ON(n == 0);
@@ -799,14 +808,15 @@ void *idr_replace(struct idr *idp, void 
 	int n;
 	struct idr_layer *p, *old_p;
 
+	if (WARN_ON_ONCE(id < 0))
+		return ERR_PTR(-EINVAL);
+
 	p = idp->top;
 	if (!p)
 		return ERR_PTR(-EINVAL);
 
 	n = (p->layer+1) * IDR_BITS;
 
-	id &= MAX_IDR_MASK;
-
 	if (id >= (1 << n))
 		return ERR_PTR(-EINVAL);
 
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
memcg-fast-hierarchy-aware-child-test-fix-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock-fix.patch
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
gpio-convert-to-idr_alloc.patch
drm-convert-to-idr_alloc.patch
drm-exynos-convert-to-idr_alloc.patch
drm-i915-convert-to-idr_alloc.patch
drm-sis-convert-to-idr_alloc.patch
drm-via-convert-to-idr_alloc.patch
drm-vmwgfx-convert-to-idr_alloc.patch
i2c-convert-to-idr_alloc.patch
i2c-convert-to-idr_alloc-fix.patch
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
idr-make-idr_layer-larger.patch
idr-add-idr_layer-prefix.patch
idr-implement-lookup-hint.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch

