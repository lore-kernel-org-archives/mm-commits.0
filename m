From: akpm@linux-foundation.org
Subject: [merged]
 mm-zsmalloc-simplify-zs_max_alloc_size-handling.patch removed from -mm tree
Date: Tue, 11 Jul 2017 12:25:19 -0700
Message-ID: <20170711192519.7qd_Z2coh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48158 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933785AbdGKTZU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:25:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmarchan@redhat.com, minchan@kernel.org, mm-commits@vger.kernel.org, opensource.ganesh@gmail.com, sergey.senozhatsky.work@gmail.com


The patch titled
     Subject: mm/zsmalloc: simplify zs_max_alloc_size handling
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-simplify-zs_max_alloc_size-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Jerome Marchand" <jmarchan@redhat.com>
Subject: mm/zsmalloc: simplify zs_max_alloc_size handling

40f9fb8cffc6 ("mm/zsmalloc: support allocating obj with size of
ZS_MAX_ALLOC_SIZE") fixes a size calculation error that prevented zsmalloc
to allocate an object of the maximal size (ZS_MAX_ALLOC_SIZE).  I think
however the fix is unneededly complicated.

This patch replaces the dynamic calculation of zs_size_classes at init
time by a compile time calculation that uses the DIV_ROUND_UP() macro
already used in get_size_class_index().

[akpm@linux-foundation.org: use min_t]
Link: http://lkml.kernel.org/r/20170630114859.1979-1-jmarchan@redhat.com
Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Mahendran Ganesh <opensource.ganesh@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   52 +++++++++++++-----------------------------------
 1 file changed, 15 insertions(+), 37 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-simplify-zs_max_alloc_size-handling mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-simplify-zs_max_alloc_size-handling
+++ a/mm/zsmalloc.c
@@ -116,6 +116,11 @@
 #define OBJ_INDEX_BITS	(BITS_PER_LONG - _PFN_BITS - OBJ_TAG_BITS)
 #define OBJ_INDEX_MASK	((_AC(1, UL) << OBJ_INDEX_BITS) - 1)
 
+#define FULLNESS_BITS	2
+#define CLASS_BITS	8
+#define ISOLATED_BITS	3
+#define MAGIC_VAL_BITS	8
+
 #define MAX(a, b) ((a) >= (b) ? (a) : (b))
 /* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
 #define ZS_MIN_ALLOC_SIZE \
@@ -137,6 +142,8 @@
  *  (reason above)
  */
 #define ZS_SIZE_CLASS_DELTA	(PAGE_SIZE >> CLASS_BITS)
+#define ZS_SIZE_CLASSES	(DIV_ROUND_UP(ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE, \
+				      ZS_SIZE_CLASS_DELTA) + 1)
 
 enum fullness_group {
 	ZS_EMPTY,
@@ -169,11 +176,6 @@ static struct vfsmount *zsmalloc_mnt;
 #endif
 
 /*
- * number of size_classes
- */
-static int zs_size_classes;
-
-/*
  * We assign a page to ZS_ALMOST_EMPTY fullness group when:
  *	n <= N / f, where
  * n = number of allocated objects
@@ -244,7 +246,7 @@ struct link_free {
 struct zs_pool {
 	const char *name;
 
-	struct size_class **size_class;
+	struct size_class *size_class[ZS_SIZE_CLASSES];
 	struct kmem_cache *handle_cachep;
 	struct kmem_cache *zspage_cachep;
 
@@ -268,11 +270,6 @@ struct zs_pool {
 #endif
 };
 
-#define FULLNESS_BITS	2
-#define CLASS_BITS	8
-#define ISOLATED_BITS	3
-#define MAGIC_VAL_BITS	8
-
 struct zspage {
 	struct {
 		unsigned int fullness:FULLNESS_BITS;
@@ -551,7 +548,7 @@ static int get_size_class_index(int size
 		idx = DIV_ROUND_UP(size - ZS_MIN_ALLOC_SIZE,
 				ZS_SIZE_CLASS_DELTA);
 
-	return min(zs_size_classes - 1, idx);
+	return min_t(int, ZS_SIZE_CLASSES - 1, idx);
 }
 
 static inline void zs_stat_inc(struct size_class *class,
@@ -610,7 +607,7 @@ static int zs_stats_size_show(struct seq
 			"obj_allocated", "obj_used", "pages_used",
 			"pages_per_zspage", "freeable");
 
-	for (i = 0; i < zs_size_classes; i++) {
+	for (i = 0; i < ZS_SIZE_CLASSES; i++) {
 		class = pool->size_class[i];
 
 		if (class->index != i)
@@ -1294,17 +1291,6 @@ static int zs_cpu_dead(unsigned int cpu)
 	return 0;
 }
 
-static void __init init_zs_size_classes(void)
-{
-	int nr;
-
-	nr = (ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE) / ZS_SIZE_CLASS_DELTA + 1;
-	if ((ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE) % ZS_SIZE_CLASS_DELTA)
-		nr += 1;
-
-	zs_size_classes = nr;
-}
-
 static bool can_merge(struct size_class *prev, int pages_per_zspage,
 					int objs_per_zspage)
 {
@@ -2145,7 +2131,7 @@ static void async_free_zspage(struct wor
 	struct zs_pool *pool = container_of(work, struct zs_pool,
 					free_work);
 
-	for (i = 0; i < zs_size_classes; i++) {
+	for (i = 0; i < ZS_SIZE_CLASSES; i++) {
 		class = pool->size_class[i];
 		if (class->index != i)
 			continue;
@@ -2263,7 +2249,7 @@ unsigned long zs_compact(struct zs_pool
 	int i;
 	struct size_class *class;
 
-	for (i = zs_size_classes - 1; i >= 0; i--) {
+	for (i = ZS_SIZE_CLASSES - 1; i >= 0; i--) {
 		class = pool->size_class[i];
 		if (!class)
 			continue;
@@ -2309,7 +2295,7 @@ static unsigned long zs_shrinker_count(s
 	struct zs_pool *pool = container_of(shrinker, struct zs_pool,
 			shrinker);
 
-	for (i = zs_size_classes - 1; i >= 0; i--) {
+	for (i = ZS_SIZE_CLASSES - 1; i >= 0; i--) {
 		class = pool->size_class[i];
 		if (!class)
 			continue;
@@ -2361,12 +2347,6 @@ struct zs_pool *zs_create_pool(const cha
 		return NULL;
 
 	init_deferred_free(pool);
-	pool->size_class = kcalloc(zs_size_classes, sizeof(struct size_class *),
-			GFP_KERNEL);
-	if (!pool->size_class) {
-		kfree(pool);
-		return NULL;
-	}
 
 	pool->name = kstrdup(name, GFP_KERNEL);
 	if (!pool->name)
@@ -2379,7 +2359,7 @@ struct zs_pool *zs_create_pool(const cha
 	 * Iterate reversely, because, size of size_class that we want to use
 	 * for merging should be larger or equal to current size.
 	 */
-	for (i = zs_size_classes - 1; i >= 0; i--) {
+	for (i = ZS_SIZE_CLASSES - 1; i >= 0; i--) {
 		int size;
 		int pages_per_zspage;
 		int objs_per_zspage;
@@ -2453,7 +2433,7 @@ void zs_destroy_pool(struct zs_pool *poo
 	zs_unregister_migration(pool);
 	zs_pool_stat_destroy(pool);
 
-	for (i = 0; i < zs_size_classes; i++) {
+	for (i = 0; i < ZS_SIZE_CLASSES; i++) {
 		int fg;
 		struct size_class *class = pool->size_class[i];
 
@@ -2492,8 +2472,6 @@ static int __init zs_init(void)
 	if (ret)
 		goto hp_setup_fail;
 
-	init_zs_size_classes();
