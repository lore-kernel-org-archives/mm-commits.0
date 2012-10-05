From: akpm@linux-foundation.org
Subject: [merged] idr-rename-max_level-to-max_idr_level.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:15:33 -0700
Message-ID: <20121005201533.BF523100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:64934 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab2JEUPf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:15:35 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so93875qae.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:15:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, bernd@petrovitsch.priv.at, glommer@parallels.com, roland@purestorage.com, sfr@canb.auug.org.au, wharms@bfs.de, mm-commits@vger.kernel.org


The patch titled
     Subject: idr: rename MAX_LEVEL to MAX_IDR_LEVEL
has been removed from the -mm tree.  Its filename was
     idr-rename-max_level-to-max_idr_level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: idr: rename MAX_LEVEL to MAX_IDR_LEVEL

To avoid name conflicts:

drivers/video/riva/fbdev.c:281:9: sparse: preprocessor token MAX_LEVEL redefined

While at it, also make the other names more consistent and add
parentheses.

[akpm@linux-foundation.org: repair fallout]
[sfr@canb.auug.org.au: IB/mlx4: fix for MAX_ID_MASK to MAX_IDR_MASK name change]
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: walter harms <wharms@bfs.de>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/i2c-core.c          |    2 -
 drivers/infiniband/core/cm.c    |    2 -
 drivers/infiniband/hw/mlx4/cm.c |    2 -
 drivers/pps/pps.c               |    2 -
 drivers/thermal/thermal_sys.c   |    2 -
 fs/super.c                      |    2 -
 include/linux/idr.h             |   10 ++++-----
 lib/idr.c                       |   32 +++++++++++++++---------------
 8 files changed, 27 insertions(+), 27 deletions(-)

diff -puN drivers/i2c/i2c-core.c~idr-rename-max_level-to-max_idr_level drivers/i2c/i2c-core.c
--- a/drivers/i2c/i2c-core.c~idr-rename-max_level-to-max_idr_level
+++ a/drivers/i2c/i2c-core.c
@@ -982,7 +982,7 @@ int i2c_add_numbered_adapter(struct i2c_
 
 	if (adap->nr == -1) /* -1 means dynamically assign bus id */
 		return i2c_add_adapter(adap);
-	if (adap->nr & ~MAX_ID_MASK)
+	if (adap->nr & ~MAX_IDR_MASK)
 		return -EINVAL;
 
 retry:
diff -puN drivers/infiniband/core/cm.c~idr-rename-max_level-to-max_idr_level drivers/infiniband/core/cm.c
--- a/drivers/infiniband/core/cm.c~idr-rename-max_level-to-max_idr_level
+++ a/drivers/infiniband/core/cm.c
@@ -390,7 +390,7 @@ static int cm_alloc_id(struct cm_id_priv
 		ret = idr_get_new_above(&cm.local_id_table, cm_id_priv,
 					next_id, &id);
 		if (!ret)
-			next_id = ((unsigned) id + 1) & MAX_ID_MASK;
+			next_id = ((unsigned) id + 1) & MAX_IDR_MASK;
 		spin_unlock_irqrestore(&cm.lock, flags);
 	} while( (ret == -EAGAIN) && idr_pre_get(&cm.local_id_table, GFP_KERNEL) );
 
diff -puN drivers/infiniband/hw/mlx4/cm.c~idr-rename-max_level-to-max_idr_level drivers/infiniband/hw/mlx4/cm.c
--- a/drivers/infiniband/hw/mlx4/cm.c~idr-rename-max_level-to-max_idr_level
+++ a/drivers/infiniband/hw/mlx4/cm.c
@@ -225,7 +225,7 @@ id_map_alloc(struct ib_device *ibdev, in
 		ret = idr_get_new_above(&sriov->pv_id_table, ent,
 					next_id, &id);
 		if (!ret) {
-			next_id = ((unsigned) id + 1) & MAX_ID_MASK;
+			next_id = ((unsigned) id + 1) & MAX_IDR_MASK;
 			ent->pv_cm_id = (u32)id;
 			sl_id_map_add(ibdev, ent);
 		}
diff -puN drivers/pps/pps.c~idr-rename-max_level-to-max_idr_level drivers/pps/pps.c
--- a/drivers/pps/pps.c~idr-rename-max_level-to-max_idr_level
+++ a/drivers/pps/pps.c
@@ -306,7 +306,7 @@ int pps_register_cdev(struct pps_device 
 	if (err < 0)
 		return err;
 
-	pps->id &= MAX_ID_MASK;
+	pps->id &= MAX_IDR_MASK;
 	if (pps->id >= PPS_MAX_SOURCES) {
 		pr_err("%s: too many PPS sources in the system\n",
 					pps->info.name);
diff -puN drivers/thermal/thermal_sys.c~idr-rename-max_level-to-max_idr_level drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~idr-rename-max_level-to-max_idr_level
+++ a/drivers/thermal/thermal_sys.c
@@ -78,7 +78,7 @@ again:
 	else if (unlikely(err))
 		return err;
 
-	*id = *id & MAX_ID_MASK;
+	*id = *id & MAX_IDR_MASK;
 	return 0;
 }
 
diff -puN fs/super.c~idr-rename-max_level-to-max_idr_level fs/super.c
--- a/fs/super.c~idr-rename-max_level-to-max_idr_level
+++ a/fs/super.c
@@ -865,7 +865,7 @@ int get_anon_bdev(dev_t *p)
 	else if (error)
 		return -EAGAIN;
 
-	if ((dev & MAX_ID_MASK) == (1 << MINORBITS)) {
+	if ((dev & MAX_IDR_MASK) == (1 << MINORBITS)) {
 		spin_lock(&unnamed_dev_lock);
 		ida_remove(&unnamed_dev_ida, dev);
 		if (unnamed_dev_start > dev)
diff -puN include/linux/idr.h~idr-rename-max_level-to-max_idr_level include/linux/idr.h
--- a/include/linux/idr.h~idr-rename-max_level-to-max_idr_level
+++ a/include/linux/idr.h
@@ -38,15 +38,15 @@
 #define IDR_SIZE (1 << IDR_BITS)
 #define IDR_MASK ((1 << IDR_BITS)-1)
 
-#define MAX_ID_SHIFT (sizeof(int)*8 - 1)
-#define MAX_ID_BIT (1U << MAX_ID_SHIFT)
-#define MAX_ID_MASK (MAX_ID_BIT - 1)
+#define MAX_IDR_SHIFT (sizeof(int)*8 - 1)
+#define MAX_IDR_BIT (1U << MAX_IDR_SHIFT)
+#define MAX_IDR_MASK (MAX_IDR_BIT - 1)
 
 /* Leave the possibility of an incomplete final layer */
-#define MAX_LEVEL (MAX_ID_SHIFT + IDR_BITS - 1) / IDR_BITS
+#define MAX_IDR_LEVEL ((MAX_IDR_SHIFT + IDR_BITS - 1) / IDR_BITS)
 
 /* Number of id_layer structs to leave in free list */
-#define IDR_FREE_MAX MAX_LEVEL + MAX_LEVEL
+#define MAX_IDR_FREE (MAX_IDR_LEVEL * 2)
 
 struct idr_layer {
 	unsigned long		 bitmap; /* A zero bit means "space here" */
diff -puN lib/idr.c~idr-rename-max_level-to-max_idr_level lib/idr.c
--- a/lib/idr.c~idr-rename-max_level-to-max_idr_level
+++ a/lib/idr.c
@@ -20,7 +20,7 @@
  * that id to this code and it returns your pointer.
 
  * You can release ids at any time. When all ids are released, most of
- * the memory is returned (we keep IDR_FREE_MAX) in a local pool so we
+ * the memory is returned (we keep MAX_IDR_FREE) in a local pool so we
  * don't need to go to the memory "store" during an id allocate, just
  * so you don't need to be too concerned about locking and conflicts
  * with the slab allocator.
@@ -122,7 +122,7 @@ static void idr_mark_full(struct idr_lay
  */
 int idr_pre_get(struct idr *idp, gfp_t gfp_mask)
 {
-	while (idp->id_free_cnt < IDR_FREE_MAX) {
+	while (idp->id_free_cnt < MAX_IDR_FREE) {
 		struct idr_layer *new;
 		new = kmem_cache_zalloc(idr_layer_cache, gfp_mask);
 		if (new == NULL)
@@ -179,7 +179,7 @@ static int sub_alloc(struct idr *idp, in
 			sh = IDR_BITS*l;
 			id = ((id >> sh) ^ n ^ m) << sh;
 		}
-		if ((id >= MAX_ID_BIT) || (id < 0))
+		if ((id >= MAX_IDR_BIT) || (id < 0))
 			return IDR_NOMORE_SPACE;
 		if (l == 0)
 			break;
@@ -223,7 +223,7 @@ build_up:
 	 * Add a new layer to the top of the tree if the requested
 	 * id is larger than the currently allocated space.
 	 */
-	while ((layers < (MAX_LEVEL - 1)) && (id >= (1 << (layers*IDR_BITS)))) {
+	while ((layers < (MAX_IDR_LEVEL - 1)) && (id >= (1 << (layers*IDR_BITS)))) {
 		layers++;
 		if (!p->count) {
 			/* special case: if the tree is currently empty,
@@ -265,7 +265,7 @@ build_up:
 
 static int idr_get_new_above_int(struct idr *idp, void *ptr, int starting_id)
 {
-	struct idr_layer *pa[MAX_LEVEL];
+	struct idr_layer *pa[MAX_IDR_LEVEL];
 	int id;
 
 	id = idr_get_empty_slot(idp, starting_id, pa);
@@ -357,7 +357,7 @@ static void idr_remove_warning(int id)
 static void sub_remove(struct idr *idp, int shift, int id)
 {
 	struct idr_layer *p = idp->top;
-	struct idr_layer **pa[MAX_LEVEL];
+	struct idr_layer **pa[MAX_IDR_LEVEL];
 	struct idr_layer ***paa = &pa[0];
 	struct idr_layer *to_free;
 	int n;
@@ -402,7 +402,7 @@ void idr_remove(struct idr *idp, int id)
 	struct idr_layer *to_free;
 
 	/* Mask off upper bits we don't use for the search. */
-	id &= MAX_ID_MASK;
+	id &= MAX_IDR_MASK;
 
 	sub_remove(idp, (idp->layers - 1) * IDR_BITS, id);
 	if (idp->top && idp->top->count == 1 && (idp->layers > 1) &&
@@ -420,7 +420,7 @@ void idr_remove(struct idr *idp, int id)
 		to_free->bitmap = to_free->count = 0;
 		free_layer(to_free);
 	}
-	while (idp->id_free_cnt >= IDR_FREE_MAX) {
+	while (idp->id_free_cnt >= MAX_IDR_FREE) {
 		p = get_from_free_list(idp);
 		/*
 		 * Note: we don't call the rcu callback here, since the only
@@ -451,7 +451,7 @@ void idr_remove_all(struct idr *idp)
 	int n, id, max;
 	int bt_mask;
 	struct idr_layer *p;
-	struct idr_layer *pa[MAX_LEVEL];
+	struct idr_layer *pa[MAX_IDR_LEVEL];
 	struct idr_layer **paa = &pa[0];
 
 	n = idp->layers * IDR_BITS;
@@ -517,7 +517,7 @@ void *idr_find(struct idr *idp, int id)
 	n = (p->layer+1) * IDR_BITS;
 
 	/* Mask off upper bits we don't use for the search. */
-	id &= MAX_ID_MASK;
+	id &= MAX_IDR_MASK;
 
 	if (id >= (1 << n))
 		return NULL;
@@ -555,7 +555,7 @@ int idr_for_each(struct idr *idp,
 {
 	int n, id, max, error = 0;
 	struct idr_layer *p;
-	struct idr_layer *pa[MAX_LEVEL];
+	struct idr_layer *pa[MAX_IDR_LEVEL];
 	struct idr_layer **paa = &pa[0];
 
 	n = idp->layers * IDR_BITS;
@@ -601,7 +601,7 @@ EXPORT_SYMBOL(idr_for_each);
  */
 void *idr_get_next(struct idr *idp, int *nextidp)
 {
-	struct idr_layer *p, *pa[MAX_LEVEL];
+	struct idr_layer *p, *pa[MAX_IDR_LEVEL];
 	struct idr_layer **paa = &pa[0];
 	int id = *nextidp;
 	int n, max;
@@ -659,7 +659,7 @@ void *idr_replace(struct idr *idp, void 
 
 	n = (p->layer+1) * IDR_BITS;
 
-	id &= MAX_ID_MASK;
+	id &= MAX_IDR_MASK;
 
 	if (id >= (1 << n))
 		return ERR_PTR(-EINVAL);
@@ -780,7 +780,7 @@ EXPORT_SYMBOL(ida_pre_get);
  */
 int ida_get_new_above(struct ida *ida, int starting_id, int *p_id)
 {
-	struct idr_layer *pa[MAX_LEVEL];
+	struct idr_layer *pa[MAX_IDR_LEVEL];
 	struct ida_bitmap *bitmap;
 	unsigned long flags;
 	int idr_id = starting_id / IDA_BITMAP_BITS;
@@ -793,7 +793,7 @@ int ida_get_new_above(struct ida *ida, i
 	if (t < 0)
 		return _idr_rc_to_errno(t);
 
-	if (t * IDA_BITMAP_BITS >= MAX_ID_BIT)
+	if (t * IDA_BITMAP_BITS >= MAX_IDR_BIT)
 		return -ENOSPC;
 
 	if (t != idr_id)
@@ -827,7 +827,7 @@ int ida_get_new_above(struct ida *ida, i
 	}
 
 	id = idr_id * IDA_BITMAP_BITS + t;
-	if (id >= MAX_ID_BIT)
+	if (id >= MAX_IDR_BIT)
 		return -ENOSPC;
 
 	__set_bit(t, bitmap->bitmap);
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
h8300-select-generic-atomic64_t-support.patch
readahead-fault-retry-breaks-mmap-file-read-random-detection.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
rbtree-performance-and-correctness-test-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix.patch
mm-compaction-restart-compaction-from-near-where-it-left-off-fix.patch
fs-fs-writebackc-remove-unneccesary-parameter-of-__writeback_single_inode.patch
kpageflags-fix-wrong-kpf_thp-on-non-huge-compound-pages.patch
idr-rename-max_level-to-max_idr_level-fix-3.patch

