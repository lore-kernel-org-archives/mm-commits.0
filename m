From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-add-fullness-into-stat.patch removed from -mm
 tree
Date: Thu, 16 Apr 2015 09:53:36 -0700
Message-ID: <552fe910.8qIFoPwqZ+mnYG/C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbbDPQsI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:48:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, ddstreet@ieee.org, gunho.lee@lge.com, iamjoonsoo.kim@lge.com, jmarchan@redhat.com, juno.choi@lge.com, mel@csn.ul.ie, ngupta@vflare.org, semenzato@google.com, sergey.senozhatsky@gmail.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: add fullness into stat
has been removed from the -mm tree.  Its filename was
     zsmalloc-add-fullness-into-stat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: add fullness into stat

During investigating compaction, fullness information of each class is
helpful for investigating how the compaction works well.  With that, we
could know how compaction works well more clear on each size class.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Juneho Choi <juno.choi@lge.com>
Cc: Gunho Lee <gunho.lee@lge.com>
Cc: Luigi Semenzato <semenzato@google.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |  349 +++++++++++++++++++++++++-----------------------
 1 file changed, 184 insertions(+), 165 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-add-fullness-into-stat mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-add-fullness-into-stat
+++ a/mm/zsmalloc.c
@@ -197,6 +197,8 @@ enum fullness_group {
 enum zs_stat_type {
 	OBJ_ALLOCATED,
 	OBJ_USED,
+	CLASS_ALMOST_FULL,
+	CLASS_ALMOST_EMPTY,
 	NR_ZS_STAT_TYPE,
 };
 
@@ -412,6 +414,11 @@ static struct zpool_driver zs_zpool_driv
 MODULE_ALIAS("zpool-zsmalloc");
 #endif /* CONFIG_ZPOOL */
 
+static unsigned int get_maxobj_per_zspage(int size, int pages_per_zspage)
+{
+	return pages_per_zspage * PAGE_SIZE / size;
+}
+
 /* per-cpu VM mapping areas for zspage accesses that cross page boundaries */
 static DEFINE_PER_CPU(struct mapping_area, zs_map_area);
 
@@ -465,6 +472,179 @@ static int get_size_class_index(int size
 	return min(zs_size_classes - 1, idx);
 }
 
+#ifdef CONFIG_ZSMALLOC_STAT
+
+static inline void zs_stat_inc(struct size_class *class,
+				enum zs_stat_type type, unsigned long cnt)
+{
+	class->stats.objs[type] += cnt;
+}
+
+static inline void zs_stat_dec(struct size_class *class,
+				enum zs_stat_type type, unsigned long cnt)
+{
+	class->stats.objs[type] -= cnt;
+}
+
+static inline unsigned long zs_stat_get(struct size_class *class,
+				enum zs_stat_type type)
+{
+	return class->stats.objs[type];
+}
+
+static int __init zs_stat_init(void)
+{
+	if (!debugfs_initialized())
+		return -ENODEV;
+
+	zs_stat_root = debugfs_create_dir("zsmalloc", NULL);
+	if (!zs_stat_root)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void __exit zs_stat_exit(void)
+{
+	debugfs_remove_recursive(zs_stat_root);
+}
+
+static int zs_stats_size_show(struct seq_file *s, void *v)
+{
+	int i;
+	struct zs_pool *pool = s->private;
+	struct size_class *class;
+	int objs_per_zspage;
+	unsigned long class_almost_full, class_almost_empty;
+	unsigned long obj_allocated, obj_used, pages_used;
+	unsigned long total_class_almost_full = 0, total_class_almost_empty = 0;
+	unsigned long total_objs = 0, total_used_objs = 0, total_pages = 0;
+
+	seq_printf(s, " %5s %5s %11s %12s %13s %10s %10s %16s\n",
+			"class", "size", "almost_full", "almost_empty",
+			"obj_allocated", "obj_used", "pages_used",
+			"pages_per_zspage");
+
+	for (i = 0; i < zs_size_classes; i++) {
+		class = pool->size_class[i];
+
+		if (class->index != i)
+			continue;
+
+		spin_lock(&class->lock);
+		class_almost_full = zs_stat_get(class, CLASS_ALMOST_FULL);
+		class_almost_empty = zs_stat_get(class, CLASS_ALMOST_EMPTY);
+		obj_allocated = zs_stat_get(class, OBJ_ALLOCATED);
+		obj_used = zs_stat_get(class, OBJ_USED);
+		spin_unlock(&class->lock);
+
+		objs_per_zspage = get_maxobj_per_zspage(class->size,
+				class->pages_per_zspage);
+		pages_used = obj_allocated / objs_per_zspage *
+				class->pages_per_zspage;
+
+		seq_printf(s, " %5u %5u %11lu %12lu %13lu %10lu %10lu %16d\n",
+			i, class->size, class_almost_full, class_almost_empty,
+			obj_allocated, obj_used, pages_used,
+			class->pages_per_zspage);
+
+		total_class_almost_full += class_almost_full;
+		total_class_almost_empty += class_almost_empty;
+		total_objs += obj_allocated;
+		total_used_objs += obj_used;
+		total_pages += pages_used;
+	}
+
+	seq_puts(s, "\n");
+	seq_printf(s, " %5s %5s %11lu %12lu %13lu %10lu %10lu\n",
+			"Total", "", total_class_almost_full,
+			total_class_almost_empty, total_objs,
+			total_used_objs, total_pages);
+
+	return 0;
+}
+
+static int zs_stats_size_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, zs_stats_size_show, inode->i_private);
+}
+
+static const struct file_operations zs_stat_size_ops = {
+	.open           = zs_stats_size_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = single_release,
+};
+
+static int zs_pool_stat_create(char *name, struct zs_pool *pool)
+{
+	struct dentry *entry;
+
+	if (!zs_stat_root)
+		return -ENODEV;
+
+	entry = debugfs_create_dir(name, zs_stat_root);
+	if (!entry) {
+		pr_warn("debugfs dir <%s> creation failed\n", name);
+		return -ENOMEM;
+	}
+	pool->stat_dentry = entry;
+
+	entry = debugfs_create_file("classes", S_IFREG | S_IRUGO,
+			pool->stat_dentry, pool, &zs_stat_size_ops);
+	if (!entry) {
+		pr_warn("%s: debugfs file entry <%s> creation failed\n",
+				name, "classes");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void zs_pool_stat_destroy(struct zs_pool *pool)
+{
+	debugfs_remove_recursive(pool->stat_dentry);
+}
+
+#else /* CONFIG_ZSMALLOC_STAT */
+
+static inline void zs_stat_inc(struct size_class *class,
+				enum zs_stat_type type, unsigned long cnt)
+{
+}
+
+static inline void zs_stat_dec(struct size_class *class,
+				enum zs_stat_type type, unsigned long cnt)
+{
+}
+
+static inline unsigned long zs_stat_get(struct size_class *class,
+				enum zs_stat_type type)
+{
+	return 0;
+}
+
+static int __init zs_stat_init(void)
+{
+	return 0;
+}
+
+static void __exit zs_stat_exit(void)
+{
+}
+
+static inline int zs_pool_stat_create(char *name, struct zs_pool *pool)
+{
+	return 0;
+}
+
+static inline void zs_pool_stat_destroy(struct zs_pool *pool)
+{
+}
+
+#endif
+
+
 /*
  * For each size class, zspages are divided into different groups
  * depending on how "full" they are. This was done so that we could
@@ -514,6 +694,8 @@ static void insert_zspage(struct page *p
 		list_add_tail(&page->lru, &(*head)->lru);
 
 	*head = page;
+	zs_stat_inc(class, fullness == ZS_ALMOST_EMPTY ?
+			CLASS_ALMOST_EMPTY : CLASS_ALMOST_FULL, 1);
 }
 
 /*
@@ -539,6 +721,8 @@ static void remove_zspage(struct page *p
 					struct page, lru);
 
 	list_del_init(&page->lru);
+	zs_stat_dec(class, fullness == ZS_ALMOST_EMPTY ?
+			CLASS_ALMOST_EMPTY : CLASS_ALMOST_FULL, 1);
 }
 
 /*
@@ -1057,11 +1241,6 @@ static void init_zs_size_classes(void)
 	zs_size_classes = nr;
 }
 
-static unsigned int get_maxobj_per_zspage(int size, int pages_per_zspage)
-{
-	return pages_per_zspage * PAGE_SIZE / size;
-}
-
 static bool can_merge(struct size_class *prev, int size, int pages_per_zspage)
 {
 	if (prev->pages_per_zspage != pages_per_zspage)
@@ -1081,166 +1260,6 @@ static bool zspage_full(struct page *pag
 	return page->inuse == page->objects;
 }
 
-#ifdef CONFIG_ZSMALLOC_STAT
-
-static inline void zs_stat_inc(struct size_class *class,
-				enum zs_stat_type type, unsigned long cnt)
-{
-	class->stats.objs[type] += cnt;
-}
-
-static inline void zs_stat_dec(struct size_class *class,
-				enum zs_stat_type type, unsigned long cnt)
-{
-	class->stats.objs[type] -= cnt;
-}
-
-static inline unsigned long zs_stat_get(struct size_class *class,
-				enum zs_stat_type type)
-{
-	return class->stats.objs[type];
-}
-
-static int __init zs_stat_init(void)
-{
-	if (!debugfs_initialized())
-		return -ENODEV;
-
-	zs_stat_root = debugfs_create_dir("zsmalloc", NULL);
-	if (!zs_stat_root)
-		return -ENOMEM;
-
-	return 0;
-}
-
-static void __exit zs_stat_exit(void)
-{
-	debugfs_remove_recursive(zs_stat_root);
-}
-
-static int zs_stats_size_show(struct seq_file *s, void *v)
-{
-	int i;
-	struct zs_pool *pool = s->private;
-	struct size_class *class;
-	int objs_per_zspage;
-	unsigned long obj_allocated, obj_used, pages_used;
-	unsigned long total_objs = 0, total_used_objs = 0, total_pages = 0;
-
-	seq_printf(s, " %5s %5s %13s %10s %10s\n", "class", "size",
-				"obj_allocated", "obj_used", "pages_used");
-
-	for (i = 0; i < zs_size_classes; i++) {
-		class = pool->size_class[i];
-
-		if (class->index != i)
-			continue;
-
-		spin_lock(&class->lock);
-		obj_allocated = zs_stat_get(class, OBJ_ALLOCATED);
-		obj_used = zs_stat_get(class, OBJ_USED);
-		spin_unlock(&class->lock);
-
-		objs_per_zspage = get_maxobj_per_zspage(class->size,
-				class->pages_per_zspage);
-		pages_used = obj_allocated / objs_per_zspage *
-				class->pages_per_zspage;
-
-		seq_printf(s, " %5u %5u    %10lu %10lu %10lu\n", i,
-			class->size, obj_allocated, obj_used, pages_used);
-
-		total_objs += obj_allocated;
-		total_used_objs += obj_used;
-		total_pages += pages_used;
-	}
-
-	seq_puts(s, "\n");
-	seq_printf(s, " %5s %5s    %10lu %10lu %10lu\n", "Total", "",
-			total_objs, total_used_objs, total_pages);
-
-	return 0;
-}
-
-static int zs_stats_size_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, zs_stats_size_show, inode->i_private);
-}
-
-static const struct file_operations zs_stat_size_ops = {
-	.open           = zs_stats_size_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.release        = single_release,
-};
-
-static int zs_pool_stat_create(char *name, struct zs_pool *pool)
-{
-	struct dentry *entry;
-
-	if (!zs_stat_root)
-		return -ENODEV;
-
-	entry = debugfs_create_dir(name, zs_stat_root);
-	if (!entry) {
-		pr_warn("debugfs dir <%s> creation failed\n", name);
-		return -ENOMEM;
-	}
-	pool->stat_dentry = entry;
-
-	entry = debugfs_create_file("obj_in_classes", S_IFREG | S_IRUGO,
-			pool->stat_dentry, pool, &zs_stat_size_ops);
-	if (!entry) {
-		pr_warn("%s: debugfs file entry <%s> creation failed\n",
-				name, "obj_in_classes");
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static void zs_pool_stat_destroy(struct zs_pool *pool)
-{
-	debugfs_remove_recursive(pool->stat_dentry);
-}
-
-#else /* CONFIG_ZSMALLOC_STAT */
-
-static inline void zs_stat_inc(struct size_class *class,
-				enum zs_stat_type type, unsigned long cnt)
-{
-}
-
-static inline void zs_stat_dec(struct size_class *class,
-				enum zs_stat_type type, unsigned long cnt)
-{
-}
-
-static inline unsigned long zs_stat_get(struct size_class *class,
-				enum zs_stat_type type)
-{
-	return 0;
-}
-
-static int __init zs_stat_init(void)
-{
-	return 0;
-}
-
-static void __exit zs_stat_exit(void)
-{
-}
-
-static inline int zs_pool_stat_create(char *name, struct zs_pool *pool)
-{
-	return 0;
-}
-
-static inline void zs_pool_stat_destroy(struct zs_pool *pool)
-{
-}
-
-#endif
-
 unsigned long zs_get_total_pages(struct zs_pool *pool)
 {
 	return atomic_long_read(&pool->pages_allocated);
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
x86-add-pmd_-for-thp.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp-fix.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch
zram-use-idr-instead-of-zram_devices-array.patch
zram-factor-out-device-reset-from-reset_store.patch
zram-reorganize-code-layout.patch
zram-add-dynamic-device-add-remove-functionality.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-value-from-zram_add.patch
zram-introduce-automatic-device_id-generation.patch
zram-introduce-automatic-device_id-generation-fix.patch
zram-do-not-let-user-enforce-new-device-dev_id.patch

