From: akpm@linux-foundation.org
Subject: + idr-implement-lookup-hint.patch added to -mm tree
Date: Mon, 11 Feb 2013 15:42:32 -0800
Message-ID: <20130211234233.4110B5A41D2@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f201.google.com ([209.85.210.201]:45328 "EHLO
	mail-ia0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760215Ab3BKXme (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Feb 2013 18:42:34 -0500
Received: by mail-ia0-f201.google.com with SMTP id t4so1260008iag.2
        for <mm-commits@vger.kernel.org>; Mon, 11 Feb 2013 15:42:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org


The patch titled
     Subject: idr: implement lookup hint
has been added to the -mm tree.  Its filename is
     idr-implement-lookup-hint.patch

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
Subject: idr: implement lookup hint

While idr lookup isn't a particularly heavy operation, it still is too
substantial to use in hot paths without worrying about the performance
implications.  With recent changes, each idr_layer covers 256 slots
which should be enough to cover most use cases with single idr_layer
making lookup hint very attractive.

This patch adds idr->hint which points to the idr_layer which
allocated an ID most recently and the fast path lookup becomes

	if (look up target's prefix matches that of the hinted layer)
		return hint->ary[ID's offset in the leaf layer];

which can be inlined.

idr->hint is set to the leaf node on idr_fill_slot() and cleared from
free_layer().

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |   25 ++++++++++++++++++++++++-
 lib/idr.c           |   38 ++++++++++++++++----------------------
 2 files changed, 40 insertions(+), 23 deletions(-)

diff -puN include/linux/idr.h~idr-implement-lookup-hint include/linux/idr.h
--- a/include/linux/idr.h~idr-implement-lookup-hint
+++ a/include/linux/idr.h
@@ -37,6 +37,7 @@ struct idr_layer {
 };
 
 struct idr {
+	struct idr_layer __rcu	*hint;	/* the last layer allocated from */
 	struct idr_layer __rcu	*top;
 	struct idr_layer	*id_free;
 	int			layers;	/* only valid w/o concurrent changes */
@@ -71,7 +72,7 @@ struct idr {
  * This is what we export.
  */
 
-void *idr_find(struct idr *idp, int id);
+void *idr_find_slowpath(struct idr *idp, int id);
 int idr_pre_get(struct idr *idp, gfp_t gfp_mask);
 int idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id);
 void idr_preload(gfp_t gfp_mask);
@@ -97,6 +98,28 @@ static inline void idr_preload_end(void)
 }
 
 /**
+ * idr_find - return pointer for given id
+ * @idp: idr handle
+ * @id: lookup key
+ *
+ * Return the pointer given the id it has been registered with.  A %NULL
+ * return indicates that @id is not valid or you passed %NULL in
+ * idr_get_new().
+ *
+ * This function can be called under rcu_read_lock(), given that the leaf
+ * pointers lifetimes are correctly managed.
+ */
+static inline void *idr_find(struct idr *idr, int id)
+{
+	struct idr_layer *hint = rcu_dereference_raw(idr->hint);
+
+	if ((id & ~IDR_MASK) == hint->prefix)
+		return rcu_dereference_raw(hint->ary[id & IDR_MASK]);
+
+	return idr_find_slowpath(idr, id);
+}
+
+/**
  * idr_get_new - allocate new idr entry
  * @idp: idr handle
  * @ptr: pointer you want associated with the id
diff -puN lib/idr.c~idr-implement-lookup-hint lib/idr.c
--- a/lib/idr.c~idr-implement-lookup-hint
+++ a/lib/idr.c
@@ -137,8 +137,10 @@ static void idr_layer_rcu_free(struct rc
 	kmem_cache_free(idr_layer_cache, layer);
 }
 
-static inline void free_layer(struct idr_layer *p)
+static inline void free_layer(struct idr *idr, struct idr_layer *p)
 {
+	if (idr->hint == p)
+		RCU_INIT_POINTER(idr->hint, NULL);
 	call_rcu(&p->rcu_head, idr_layer_rcu_free);
 }
 
@@ -363,8 +365,12 @@ build_up:
  * @id and @pa are from a successful allocation from idr_get_empty_slot().
  * Install the user pointer @ptr and mark the slot full.
  */
-static void idr_fill_slot(void *ptr, int id, struct idr_layer **pa)
+static void idr_fill_slot(struct idr *idr, void *ptr, int id,
+			  struct idr_layer **pa)
 {
+	/* update hint used for lookup, cleared from free_layer() */
+	rcu_assign_pointer(idr->hint, pa[0]);
+
 	rcu_assign_pointer(pa[0]->ary[id & IDR_MASK], (struct idr_layer *)ptr);
 	pa[0]->count++;
 	idr_mark_full(pa, id);
@@ -397,7 +403,7 @@ int idr_get_new_above(struct idr *idp, v
 	if (rv < 0)
 		return rv == -ENOMEM ? -EAGAIN : rv;
 
-	idr_fill_slot(ptr, rv, pa);
+	idr_fill_slot(idp, ptr, rv, pa);
 	*id = rv;
 	return 0;
 }
@@ -504,7 +510,7 @@ int idr_alloc(struct idr *idr, void *ptr
 	if (unlikely(id > max))
 		return -ENOSPC;
 
-	idr_fill_slot(ptr, id, pa);
+	idr_fill_slot(idr, ptr, id, pa);
 	return id;
 }
 EXPORT_SYMBOL_GPL(idr_alloc);
@@ -541,14 +547,14 @@ static void sub_remove(struct idr *idp, 
 		to_free = NULL;
 		while(*paa && ! --((**paa)->count)){
 			if (to_free)
-				free_layer(to_free);
+				free_layer(idp, to_free);
 			to_free = **paa;
 			**paa-- = NULL;
 		}
 		if (!*paa)
 			idp->layers = 0;
 		if (to_free)
-			free_layer(to_free);
+			free_layer(idp, to_free);
 	} else
 		idr_remove_warning(id);
 }
@@ -581,7 +587,7 @@ void idr_remove(struct idr *idp, int id)
 		--idp->layers;
 		to_free->count = 0;
 		bitmap_clear(to_free->bitmap, 0, IDR_SIZE);
-		free_layer(to_free);
+		free_layer(idp, to_free);
 	}
 	while (idp->id_free_cnt >= MAX_IDR_FREE) {
 		p = get_from_free_list(idp);
@@ -622,7 +628,7 @@ void __idr_remove_all(struct idr *idp)
 		/* Get the highest bit that the above add changed from 0->1. */
 		while (n < fls(id ^ bt_mask)) {
 			if (p)
-				free_layer(p);
+				free_layer(idp, p);
 			n += IDR_BITS;
 			p = *--paa;
 		}
@@ -655,19 +661,7 @@ void idr_destroy(struct idr *idp)
 }
 EXPORT_SYMBOL(idr_destroy);
 
-/**
- * idr_find - return pointer for given id
- * @idp: idr handle
- * @id: lookup key
- *
- * Return the pointer given the id it has been registered with.  A %NULL
- * return indicates that @id is not valid or you passed %NULL in
- * idr_get_new().
- *
- * This function can be called under rcu_read_lock(), given that the leaf
- * pointers lifetimes are correctly managed.
- */
-void *idr_find(struct idr *idp, int id)
+void *idr_find_slowpath(struct idr *idp, int id)
 {
 	int n;
 	struct idr_layer *p;
@@ -691,7 +685,7 @@ void *idr_find(struct idr *idp, int id)
 	}
 	return((void *)p);
 }
-EXPORT_SYMBOL(idr_find);
+EXPORT_SYMBOL(idr_find_slowpath);
 
 /**
  * idr_for_each - iterate through all stored pointers
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

