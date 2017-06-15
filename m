From: akpm@linux-foundation.org
Subject: [withdrawn] zram-make-deduplication-feature-optional.patch
 removed from -mm tree
Date: Thu, 15 Jun 2017 16:29:54 -0700
Message-ID: <59431872.TaJ3sd7Padi+0siX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49206 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751590AbdFOX3z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 19:29:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: make deduplication feature optional
has been removed from the -mm tree.  Its filename was
     zram-make-deduplication-feature-optional.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: zram: make deduplication feature optional

Benefit of deduplication is dependent on the workload so it's not
preferable to always enable.  Therefore, make it optional in Kconfig and
device param.  Default is 'off'.  This option will be beneficial for users
who use the zram as blockdev and stores build output to it.

Link: http://lkml.kernel.org/r/1494556204-25796-4-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram |   10 ++
 Documentation/blockdev/zram.txt            |    1 
 drivers/block/zram/Kconfig                 |   14 +++
 drivers/block/zram/Makefile                |    3 
 drivers/block/zram/zram_dedup.c            |   15 +++
 drivers/block/zram/zram_dedup.h            |   23 +++++
 drivers/block/zram/zram_drv.c              |   81 ++++++++++++++++---
 drivers/block/zram/zram_drv.h              |    9 ++
 8 files changed, 144 insertions(+), 12 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-block-zram~zram-make-deduplication-feature-optional Documentation/ABI/testing/sysfs-block-zram
--- a/Documentation/ABI/testing/sysfs-block-zram~zram-make-deduplication-feature-optional
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -90,3 +90,13 @@ Description:
 		device's debugging info useful for kernel developers. Its
 		format is not documented intentionally and may change
 		anytime without any notice.
+
+What:		/sys/block/zram<id>/use_dedup
+Date:		March 2017
+Contact:	Joonsoo Kim <iamjoonsoo.kim@lge.com>
+Description:
+		The use_dedup file is read-write and specifies deduplication
+		feature is used or not. If enabled, duplicated data is
+		managed by reference count and will not be stored in memory
+		twice. Benefit of this feature largely depends on the workload
+		so keep attention when use.
diff -puN Documentation/blockdev/zram.txt~zram-make-deduplication-feature-optional Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-make-deduplication-feature-optional
+++ a/Documentation/blockdev/zram.txt
@@ -168,6 +168,7 @@ max_comp_streams  RW    the number of po
 comp_algorithm    RW    show and change the compression algorithm
 compact           WO    trigger memory compaction
 debug_stat        RO    this file is used for zram debugging purposes
+use_dedup	  RW	show and set deduplication feature
 
 
 User space is advised to use the following files to read the device statistics.
diff -puN drivers/block/zram/Kconfig~zram-make-deduplication-feature-optional drivers/block/zram/Kconfig
--- a/drivers/block/zram/Kconfig~zram-make-deduplication-feature-optional
+++ a/drivers/block/zram/Kconfig
@@ -13,3 +13,17 @@ config ZRAM
 	  disks and maybe many more.
 
 	  See zram.txt for more information.
+
+config ZRAM_DEDUP
+	bool "Deduplication support for ZRAM data"
+	depends on ZRAM
+	default n
+	help
+	  Deduplicate ZRAM data to reduce amount of memory consumption.
+	  Advantage largely depends on the workload. In some cases, this
+	  option reduces memory usage to the half. However, if there is no
+	  duplicated data, the amount of memory consumption would be
+	  increased due to additional metadata usage. And, there is
+	  computation time trade-off. Please check the benefit before
+	  enabling this option. Experiment shows the positive effect when
+	  the zram is used as blockdev and is used to store build output.
diff -puN drivers/block/zram/Makefile~zram-make-deduplication-feature-optional drivers/block/zram/Makefile
--- a/drivers/block/zram/Makefile~zram-make-deduplication-feature-optional
+++ a/drivers/block/zram/Makefile
@@ -1,3 +1,4 @@
-zram-y	:=	zcomp.o zram_drv.o zram_dedup.o
+zram-y				:=	zcomp.o zram_drv.o
+zram-$(CONFIG_ZRAM_DEDUP)	+=	zram_dedup.o
 
 obj-$(CONFIG_ZRAM)	+=	zram.o
diff -puN drivers/block/zram/zram_dedup.c~zram-make-deduplication-feature-optional drivers/block/zram/zram_dedup.c
--- a/drivers/block/zram/zram_dedup.c~zram-make-deduplication-feature-optional
+++ a/drivers/block/zram/zram_dedup.c
@@ -41,6 +41,9 @@ void zram_dedup_insert(struct zram *zram
 	struct rb_node **rb_node, *parent = NULL;
 	struct zram_entry *entry;
 
+	if (!zram_dedup_enabled(zram))
+		return;
+
 	new->checksum = checksum;
 	hash = &zram->hash[checksum % zram->hash_size];
 	rb_root = &hash->rb_root;
@@ -148,6 +151,9 @@ struct zram_entry *zram_dedup_find(struc
 	void *mem;
 	struct zram_entry *entry;
 
+	if (!zram_dedup_enabled(zram))
+		return NULL;
+
 	mem = kmap_atomic(page);
 	*checksum = zram_dedup_checksum(mem);
 
@@ -160,6 +166,9 @@ struct zram_entry *zram_dedup_find(struc
 void zram_dedup_init_entry(struct zram *zram, struct zram_entry *entry,
 				unsigned long handle, unsigned int len)
 {
+	if (!zram_dedup_enabled(zram))
+		return;
+
 	entry->handle = handle;
 	entry->refcount = 1;
 	entry->len = len;
@@ -167,6 +176,9 @@ void zram_dedup_init_entry(struct zram *
 
 bool zram_dedup_put_entry(struct zram *zram, struct zram_entry *entry)
 {
+	if (!zram_dedup_enabled(zram))
+		return true;
+
 	if (zram_dedup_put(zram, entry))
 		return false;
 
@@ -178,6 +190,9 @@ int zram_dedup_init(struct zram *zram, s
 	int i;
 	struct zram_hash *hash;
 
+	if (!zram_dedup_enabled(zram))
+		return 0;
+
 	zram->hash_size = num_pages >> ZRAM_HASH_SHIFT;
 	zram->hash_size = min_t(size_t, ZRAM_HASH_SIZE_MAX, zram->hash_size);
 	zram->hash_size = max_t(size_t, ZRAM_HASH_SIZE_MIN, zram->hash_size);
diff -puN drivers/block/zram/zram_dedup.h~zram-make-deduplication-feature-optional drivers/block/zram/zram_dedup.h
--- a/drivers/block/zram/zram_dedup.h~zram-make-deduplication-feature-optional
+++ a/drivers/block/zram/zram_dedup.h
@@ -4,6 +4,8 @@
 struct zram;
 struct zram_entry;
 
+#ifdef CONFIG_ZRAM_DEDUP
+
 u64 zram_dedup_dup_size(struct zram *zram);
 u64 zram_dedup_meta_size(struct zram *zram);
 
@@ -18,5 +20,26 @@ bool zram_dedup_put_entry(struct zram *z
 
 int zram_dedup_init(struct zram *zram, size_t num_pages);
 void zram_dedup_fini(struct zram *zram);
+#else
+
+static inline u64 zram_dedup_dup_size(struct zram *zram) { return 0; }
+static inline u64 zram_dedup_meta_size(struct zram *zram) { return 0; }
+
+static inline void zram_dedup_insert(struct zram *zram, struct zram_entry *new,
+			u32 checksum) { }
+static inline struct zram_entry *zram_dedup_find(struct zram *zram,
+			struct page *page, u32 *checksum) { return NULL; }
+
+static inline void zram_dedup_init_entry(struct zram *zram,
+			struct zram_entry *entry, unsigned long handle,
+			unsigned int len) { }
+static inline bool zram_dedup_put_entry(struct zram *zram,
+			struct zram_entry *entry) { return true; }
+
+static inline int zram_dedup_init(struct zram *zram,
+			size_t num_pages) { return 0; }
+static inline void zram_dedup_fini(struct zram *zram) { }
+
+#endif
 
 #endif /* _ZRAM_DEDUP_H_ */
diff -puN drivers/block/zram/zram_drv.c~zram-make-deduplication-feature-optional drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-make-deduplication-feature-optional
+++ a/drivers/block/zram/zram_drv.c
@@ -333,6 +333,41 @@ static ssize_t comp_algorithm_store(stru
 	return len;
 }
 
+static ssize_t use_dedup_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	bool val;
+	struct zram *zram = dev_to_zram(dev);
+
+	down_read(&zram->init_lock);
+	val = zram->use_dedup;
+	up_read(&zram->init_lock);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (int)val);
+}
+
+#ifdef CONFIG_ZRAM_DEDUP
+static ssize_t use_dedup_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	int val;
+	struct zram *zram = dev_to_zram(dev);
+
+	if (kstrtoint(buf, 10, &val) || (val != 0 && val != 1))
+		return -EINVAL;
+
+	down_write(&zram->init_lock);
+	if (init_done(zram)) {
+		up_write(&zram->init_lock);
+		pr_info("Can't change dedup usage for initialized device\n");
+		return -EBUSY;
+	}
+	zram->use_dedup = val;
+	up_write(&zram->init_lock);
+	return len;
+}
+#endif
+
 static ssize_t compact_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
@@ -425,6 +460,15 @@ static DEVICE_ATTR_RO(io_stat);
 static DEVICE_ATTR_RO(mm_stat);
 static DEVICE_ATTR_RO(debug_stat);
 
+static unsigned long zram_entry_handle(struct zram *zram,
+		struct zram_entry *entry)
+{
+	if (zram_dedup_enabled(zram))
+		return entry->handle;
+	else
+		return (unsigned long)entry;
+}
+
 static void zram_slot_lock(struct zram *zram, u32 index)
 {
 	bit_spin_lock(ZRAM_ACCESS, &zram->table[index].value);
@@ -485,14 +529,17 @@ static struct zram_entry *zram_entry_all
 	struct zram_entry *entry;
 	unsigned long handle;
 
-	entry = kzalloc(sizeof(*entry),
-			flags & ~(__GFP_HIGHMEM|__GFP_MOVABLE));
-	if (!entry)
+	handle = zs_malloc(zram->mem_pool, len, flags);
+	if (!handle)
 		return NULL;
 
-	handle = zs_malloc(zram->mem_pool, len, flags);
-	if (!handle) {
-		kfree(entry);
+	if (!zram_dedup_enabled(zram))
+		return (struct zram_entry *)handle;
+
+	entry = kzalloc(sizeof(*entry),
+			flags & ~(__GFP_HIGHMEM|__GFP_MOVABLE));
+	if (!entry) {
+		zs_free(zram->mem_pool, handle);
 		return NULL;
 	}
 
@@ -507,7 +554,11 @@ void zram_entry_free(struct zram *zram,
 	if (!zram_dedup_put_entry(zram, entry))
 		return;
 
-	zs_free(zram->mem_pool, entry->handle);
+	zs_free(zram->mem_pool, zram_entry_handle(zram, entry));
+
+	if (!zram_dedup_enabled(zram))
+		return;
+
 	kfree(entry);
 
 	atomic64_sub(sizeof(*entry), &zram->stats.meta_data_size);
@@ -598,7 +649,8 @@ static int zram_decompress_page(struct z
 	entry = zram_get_entry(zram, index);
 	size = zram_get_obj_size(zram, index);
 
-	src = zs_map_object(zram->mem_pool, entry->handle, ZS_MM_RO);
+	src = zs_map_object(zram->mem_pool,
+		zram_entry_handle(zram, entry), ZS_MM_RO);
 	if (size == PAGE_SIZE) {
 		dst = kmap_atomic(page);
 		memcpy(dst, src, PAGE_SIZE);
@@ -612,7 +664,7 @@ static int zram_decompress_page(struct z
 		kunmap_atomic(dst);
 		zcomp_stream_put(zram->comp);
 	}
-	zs_unmap_object(zram->mem_pool, entry->handle);
+	zs_unmap_object(zram->mem_pool, zram_entry_handle(zram, entry));
 	zram_slot_unlock(zram, index);
 
 	/* Should NEVER happen. Return bio error if it does. */
@@ -750,7 +802,8 @@ static int __zram_bvec_write(struct zram
 		return ret;
 	}
 
-	dst = zs_map_object(zram->mem_pool, entry->handle, ZS_MM_WO);
+	dst = zs_map_object(zram->mem_pool,
+		zram_entry_handle(zram, entry), ZS_MM_WO);
 
 	src = zstrm->buffer;
 	if (comp_len == PAGE_SIZE)
@@ -760,7 +813,7 @@ static int __zram_bvec_write(struct zram
 		kunmap_atomic(src);
 
 	zcomp_stream_put(zram->comp);
-	zs_unmap_object(zram->mem_pool, entry->handle);
+	zs_unmap_object(zram->mem_pool, zram_entry_handle(zram, entry));
 	zram_dedup_insert(zram, entry, checksum);
 
 found_dup:
@@ -1159,6 +1212,11 @@ static DEVICE_ATTR_WO(mem_limit);
 static DEVICE_ATTR_WO(mem_used_max);
 static DEVICE_ATTR_RW(max_comp_streams);
 static DEVICE_ATTR_RW(comp_algorithm);
+#ifdef CONFIG_ZRAM_DEDUP
+static DEVICE_ATTR_RW(use_dedup);
+#else
+static DEVICE_ATTR_RO(use_dedup);
+#endif
 
 static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_disksize.attr,
@@ -1169,6 +1227,7 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_mem_used_max.attr,
 	&dev_attr_max_comp_streams.attr,
 	&dev_attr_comp_algorithm.attr,
+	&dev_attr_use_dedup.attr,
 	&dev_attr_io_stat.attr,
 	&dev_attr_mm_stat.attr,
 	&dev_attr_debug_stat.attr,
diff -puN drivers/block/zram/zram_drv.h~zram-make-deduplication-feature-optional drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-make-deduplication-feature-optional
+++ a/drivers/block/zram/zram_drv.h
@@ -134,7 +134,16 @@ struct zram {
 	 * zram is claimed so open request will be failed
 	 */
 	bool claim; /* Protected by bdev->bd_mutex */
+	bool use_dedup;
 };
 
+static inline bool zram_dedup_enabled(struct zram *zram)
+{
+#ifdef CONFIG_ZRAM_DEDUP
+	return zram->use_dedup;
+#else
+	return false;
+#endif
+}
 void zram_entry_free(struct zram *zram, struct zram_entry *entry);
 #endif
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

zram-compare-all-the-entries-with-same-checksum-for-deduplication.patch
mm-kasan-use-kasan_zero_pud-for-p4d-table.patch
mm-kasan-rename-xxx_is_zero-to-xxx_is_nonzero.patch

