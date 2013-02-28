From: akpm@linux-foundation.org
Subject: [merged] idr-implement-lookup-hint.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:16:20 -0800
Message-ID: <20130228201620.B0D2131C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:34981 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813Ab3B1UQV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:16:21 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so261471qah.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:16:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, kirill.shutemov@linux.intel.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: idr: implement lookup hint
has been removed from the -mm tree.  Its filename was
     idr-implement-lookup-hint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[andriy.shevchenko@linux.intel.com: always do slow path when hint is uninitialized]
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
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
+	if (hint && (id & ~IDR_MASK) == hint->prefix)
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
+	if (idr->hint && idr->hint == p)
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

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

