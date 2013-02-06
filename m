From: akpm@linux-foundation.org
Subject: + idr-implement-idr_preload-and-idr_alloc.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:37:16 -0800
Message-ID: <20130206223717.4FC3D31C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:64249 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab3BFWhS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:37:18 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so221762qaj.5
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:37:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, rusty@rustcorp.com.au


The patch titled
     Subject: idr: implement idr_preload[_end]() and idr_alloc()
has been added to the -mm tree.  Its filename is
     idr-implement-idr_preload-and-idr_alloc.patch

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
Subject: idr: implement idr_preload[_end]() and idr_alloc()

The current idr interface is very cumbersome.

* For all allocations, two function calls - idr_pre_get() and
  idr_get_new*() - should be made.

* idr_pre_get() doesn't guarantee that the following idr_get_new*()
  will not fail from memory shortage.  If idr_get_new*() returns
  -EAGAIN, the caller is expected to retry pre_get and allocation.

* idr_get_new*() can't enforce upper limit.  Upper limit can only be
  enforced by allocating and then freeing if above limit.

* idr_layer buffer is unnecessarily per-idr.  Each idr ends up keeping
  around MAX_IDR_FREE idr_layers.  The memory consumed per idr is
  under two pages but it makes it difficult to make idr_layer larger.

This patch implements the following new set of allocation functions.

* idr_preload[_end]() - Similar to radix preload but doesn't fail.
  The first idr_alloc() inside preload section can be treated as if it
  were called with @gfp_mask used for idr_preload().

* idr_alloc() - Allocate an ID w/ lower and upper limits.  Takes
  @gfp_flags and can be used w/o preloading.  When used inside
  preloaded section, the allocation mask of preloading can be assumed.

If idr_alloc() can be called from a context which allows sufficiently
relaxed @gfp_mask, it can be used by itself.  If, for example,
idr_alloc() is called inside spinlock protected region, preloading can
be used like the following.

	idr_preload(GFP_KERNEL);
	spin_lock(lock);

	id = idr_alloc(idr, ptr, start, end, GFP_NOWAIT);

	spin_unlock(lock);
	idr_preload_end();
	if (id < 0)
		error;

which is much simpler and less error-prone than idr_pre_get and
idr_get_new*() loop.

The new interface uses per-pcu idr_layer buffer and thus the number of
idr's in the system doesn't affect the amount of memory used for
preloading.

idr_layer_alloc() is introduced to handle idr_layer allocations for
both old and new ID allocation paths.  This is a bit hairy now but the
new interface is expected to replace the old and the internal
implementation eventually will become simpler.

v2: Improve idr_preload() comment a bit so that it's clear that
    preemption is disabled while preloaded.  Make idr_layer_alloc()
    try kmem_cache first and then fall back to per-cpu buffer;
    otherwise, non-preloading idr_alloc()s empty per-cpu buffers
    makeing preloaders fill them, which, while not incorrect, still is
    a bit unfair.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |   14 +++
 lib/idr.c           |  171 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 177 insertions(+), 8 deletions(-)

diff -puN include/linux/idr.h~idr-implement-idr_preload-and-idr_alloc include/linux/idr.h
--- a/include/linux/idr.h~idr-implement-idr_preload-and-idr_alloc
+++ a/include/linux/idr.h
@@ -94,15 +94,29 @@ struct idr {
 void *idr_find(struct idr *idp, int id);
 int idr_pre_get(struct idr *idp, gfp_t gfp_mask);
 int idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id);
+void idr_preload(gfp_t gfp_mask);
+int idr_alloc(struct idr *idp, void *ptr, int start, int end, gfp_t gfp_mask);
 int idr_for_each(struct idr *idp,
 		 int (*fn)(int id, void *p, void *data), void *data);
 void *idr_get_next(struct idr *idp, int *nextid);
 void *idr_replace(struct idr *idp, void *ptr, int id);
 void idr_remove(struct idr *idp, int id);
+void idr_free(struct idr *idp, int id);
 void idr_destroy(struct idr *idp);
 void idr_init(struct idr *idp);
 
 /**
+ * idr_preload_end - end preload section started with idr_preload()
+ *
+ * Each idr_preload() should be matched with an invocation of this
+ * function.  See idr_preload() for details.
+ */
+static inline void idr_preload_end(void)
+{
+	preempt_enable();
+}
+
+/**
  * idr_get_new - allocate new idr entry
  * @idp: idr handle
  * @ptr: pointer you want associated with the id
diff -puN lib/idr.c~idr-implement-idr_preload-and-idr_alloc lib/idr.c
--- a/lib/idr.c~idr-implement-idr_preload-and-idr_alloc
+++ a/lib/idr.c
@@ -35,8 +35,12 @@
 #include <linux/string.h>
 #include <linux/idr.h>
 #include <linux/spinlock.h>
+#include <linux/percpu.h>
+#include <linux/hardirq.h>
 
 static struct kmem_cache *idr_layer_cache;
+static DEFINE_PER_CPU(struct idr_layer *, idr_preload_head);
+static DEFINE_PER_CPU(int, idr_preload_cnt);
 static DEFINE_SPINLOCK(simple_ida_lock);
 
 static struct idr_layer *get_from_free_list(struct idr *idp)
@@ -54,6 +58,50 @@ static struct idr_layer *get_from_free_l
 	return(p);
 }
 
+/**
+ * idr_layer_alloc - allocate a new idr_layer
+ * @gfp_mask: allocation mask
+ * @layer_idr: optional idr to allocate from
+ *
+ * If @layer_idr is %NULL, directly allocate one using @gfp_mask or fetch
+ * one from the per-cpu preload buffer.  If @layer_idr is not %NULL, fetch
+ * an idr_layer from @idr->id_free.
+ *
+ * @layer_idr is to maintain backward compatibility with the old alloc
+ * interface - idr_pre_get() and idr_get_new*() - and will be removed
+ * together with per-pool preload buffer.
+ */
+static struct idr_layer *idr_layer_alloc(gfp_t gfp_mask, struct idr *layer_idr)
+{
+	struct idr_layer *new;
+
+	/* this is the old path, bypass to get_from_free_list() */
+	if (layer_idr)
+		return get_from_free_list(layer_idr);
+
+	/* try to allocate directly from kmem_cache */
+	new = kmem_cache_zalloc(idr_layer_cache, gfp_mask);
+	if (new)
+		return new;
+
+	/*
+	 * Try to fetch one from the per-cpu preload buffer if in process
+	 * context.  See idr_preload() for details.
+	 */
+	if (in_interrupt())
+		return NULL;
+
+	preempt_disable();
+	new = __this_cpu_read(idr_preload_head);
+	if (new) {
+		__this_cpu_write(idr_preload_head, new->ary[0]);
+		__this_cpu_dec(idr_preload_cnt);
+		new->ary[0] = NULL;
+	}
+	preempt_enable();
+	return new;
+}
+
 static void idr_layer_rcu_free(struct rcu_head *head)
 {
 	struct idr_layer *layer;
@@ -139,6 +187,8 @@ EXPORT_SYMBOL(idr_pre_get);
  * @starting_id: id to start search at
  * @id: pointer to the allocated handle
  * @pa: idr_layer[MAX_IDR_LEVEL] used as backtrack buffer
+ * @gfp_mask: allocation mask for idr_layer_alloc()
+ * @layer_idr: optional idr passed to idr_layer_alloc()
  *
  * Allocate an id in range [@starting_id, INT_MAX] from @idp without
  * growing its depth.  Returns
@@ -148,7 +198,8 @@ EXPORT_SYMBOL(idr_pre_get);
  *  -ENOSPC if the id space is exhausted,
  *  -ENOMEM if more idr_layers need to be allocated.
  */
-static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
+static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa,
+		     gfp_t gfp_mask, struct idr *layer_idr)
 {
 	int n, m, sh;
 	struct idr_layer *p, *new;
@@ -202,7 +253,7 @@ static int sub_alloc(struct idr *idp, in
 		 * Create the layer below if it is missing.
 		 */
 		if (!p->ary[m]) {
-			new = get_from_free_list(idp);
+			new = idr_layer_alloc(gfp_mask, layer_idr);
 			if (!new)
 				return -ENOMEM;
 			new->layer = l-1;
@@ -218,7 +269,8 @@ static int sub_alloc(struct idr *idp, in
 }
 
 static int idr_get_empty_slot(struct idr *idp, int starting_id,
-			      struct idr_layer **pa)
+			      struct idr_layer **pa, gfp_t gfp_mask,
+			      struct idr *layer_idr)
 {
 	struct idr_layer *p, *new;
 	int layers, v, id;
@@ -229,7 +281,7 @@ build_up:
 	p = idp->top;
 	layers = idp->layers;
 	if (unlikely(!p)) {
-		if (!(p = get_from_free_list(idp)))
+		if (!(p = idr_layer_alloc(gfp_mask, layer_idr)))
 			return -ENOMEM;
 		p->layer = 0;
 		layers = 1;
@@ -248,7 +300,7 @@ build_up:
 			p->layer++;
 			continue;
 		}
-		if (!(new = get_from_free_list(idp))) {
+		if (!(new = idr_layer_alloc(gfp_mask, layer_idr))) {
 			/*
 			 * The allocation failed.  If we built part of
 			 * the structure tear it down.
@@ -272,7 +324,7 @@ build_up:
 	}
 	rcu_assign_pointer(idp->top, p);
 	idp->layers = layers;
-	v = sub_alloc(idp, &id, pa);
+	v = sub_alloc(idp, &id, pa, gfp_mask, layer_idr);
 	if (v == -EAGAIN)
 		goto build_up;
 	return(v);
@@ -312,7 +364,7 @@ int idr_get_new_above(struct idr *idp, v
 	struct idr_layer *pa[MAX_IDR_LEVEL];
 	int rv;
 
-	rv = idr_get_empty_slot(idp, starting_id, pa);
+	rv = idr_get_empty_slot(idp, starting_id, pa, 0, idp);
 	if (rv < 0)
 		return rv == -ENOMEM ? -EAGAIN : rv;
 
@@ -322,6 +374,109 @@ int idr_get_new_above(struct idr *idp, v
 }
 EXPORT_SYMBOL(idr_get_new_above);
 
+/**
+ * idr_preload - preload for idr_alloc()
+ * @gfp_mask: allocation mask to use for preloading
+ *
+ * Preload per-cpu layer buffer for idr_alloc().  Can only be used from
+ * process context and each idr_preload() invocation should be matched with
+ * idr_preload_end().  Note that preemption is disabled while preloaded.
+ *
+ * The first idr_alloc() in the preloaded section can be treated as if it
+ * were invoked with @gfp_mask used for preloading.  This allows using more
+ * permissive allocation masks for idrs protected by spinlocks.
+ *
+ * For example, if idr_alloc() below fails, the failure can be treated as
+ * if idr_alloc() were called with GFP_KERNEL rather than GFP_NOWAIT.
+ *
+ *	idr_preload(GFP_KERNEL);
+ *	spin_lock(lock);
+ *
+ *	id = idr_alloc(idr, ptr, start, end, GFP_NOWAIT);
+ *
+ *	spin_unlock(lock);
+ *	idr_preload_end();
+ *	if (id < 0)
+ *		error;
+ */
+void idr_preload(gfp_t gfp_mask)
+{
+	/*
+	 * Consuming preload buffer from non-process context breaks preload
+	 * allocation guarantee.  Disallow usage from those contexts.
+	 */
+	WARN_ON_ONCE(in_interrupt());
+	might_sleep_if(gfp_mask & __GFP_WAIT);
+
+	preempt_disable();
+
+	/*
+	 * idr_alloc() is likely to succeed w/o full idr_layer buffer and
+	 * return value from idr_alloc() needs to be checked for failure
+	 * anyway.  Silently give up if allocation fails.  The caller can
+	 * treat failures from idr_alloc() as if idr_alloc() were called
+	 * with @gfp_mask which should be enough.
+	 */
+	while (__this_cpu_read(idr_preload_cnt) < MAX_IDR_FREE) {
+		struct idr_layer *new;
+
+		preempt_enable();
+		new = kmem_cache_zalloc(idr_layer_cache, gfp_mask);
+		preempt_disable();
+		if (!new)
+			break;
+
+		/* link the new one to per-cpu preload list */
+		new->ary[0] = __this_cpu_read(idr_preload_head);
+		__this_cpu_write(idr_preload_head, new);
+		__this_cpu_inc(idr_preload_cnt);
+	}
+}
+EXPORT_SYMBOL(idr_preload);
+
+/**
+ * idr_alloc - allocate new idr entry
+ * @idr: the (initialized) idr
+ * @ptr: pointer to be associated with the new id
+ * @start: the minimum id (inclusive)
+ * @end: the maximum id (exclusive, 0 for max)
+ * @gfp_mask: memory allocation flags
+ *
+ * Allocate an id in [start, end) and associate it with @ptr.  If no ID is
+ * available in the specified range, returns -ENOSPC.  On memory allocation
+ * failure, returns -ENOMEM.
+ *
+ * The user is responsible for exclusively synchronizing all operations
+ * which may modify @idr.  However, read-only accesses such as idr_find()
+ * or iteration can be performed under RCU read lock provided the user
+ * destroys @ptr in RCU-safe way after removal from idr.
+ */
+int idr_alloc(struct idr *idr, void *ptr, int start, int end, gfp_t gfp_mask)
+{
+	int max = end ? end - 1 : INT_MAX;	/* inclusive upper limit */
+	struct idr_layer *pa[MAX_IDR_LEVEL];
+	int id;
+
+	might_sleep_if(gfp_mask & __GFP_WAIT);
+
+	/* sanity checks */
+	if (WARN_ON_ONCE(start < 0 || end < 0))
+		return -EINVAL;
+	if (unlikely(max < start))
+		return -ENOSPC;
+
+	/* allocate id */
+	id = idr_get_empty_slot(idr, start, pa, gfp_mask, NULL);
+	if (unlikely(id < 0))
+		return id;
+	if (unlikely(id > max))
+		return -ENOSPC;
+
+	idr_fill_slot(ptr, id, pa);
+	return id;
+}
+EXPORT_SYMBOL_GPL(idr_alloc);
+
 static void idr_remove_warning(int id)
 {
 	printk(KERN_WARNING
@@ -769,7 +924,7 @@ int ida_get_new_above(struct ida *ida, i
 
  restart:
 	/* get vacant slot */
-	t = idr_get_empty_slot(&ida->idr, idr_id, pa);
+	t = idr_get_empty_slot(&ida->idr, idr_id, pa, 0, &ida->idr);
 	if (t < 0)
 		return t == -ENOMEM ? -EAGAIN : t;
 
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

