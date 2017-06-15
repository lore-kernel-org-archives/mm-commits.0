From: akpm@linux-foundation.org
Subject: [withdrawn] zram-implement-deduplication-in-zram.patch removed
 from -mm tree
Date: Thu, 15 Jun 2017 16:29:52 -0700
Message-ID: <59431870.sXY5wLb4tDSQurIA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49202 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbdFOX3x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 19:29:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: implement deduplication in zram
has been removed from the -mm tree.  Its filename was
     zram-implement-deduplication-in-zram.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: zram: implement deduplication in zram

Implement deduplication feature in zram.  The purpose of this work is
naturally to save amount of memory usage by zram.

Android is one of the biggest users to use zram as swap and it's really
important to save amount of memory usage.  There is a paper that reports
that duplication ratio of Android's memory content is rather high [1]. 
And, there is a similar work on zswap that also reports that experiments
has shown that around 10-15% of pages stored in zswp are duplicates and
deduplicate them provides some benefits [2].

Also, there is a different kind of workload that uses zram as blockdev and
store build outputs into it to reduce wear-out problem of real blockdev. 
In this workload, deduplication hit is very high due to temporary files
and intermediate object files.  Detailed analysis is on the bottom of this
description.

Anyway, if we can detect duplicated content and avoid to store duplicated
content at different memory space, we can save memory.  This patch tries
to do that.

Implementation is almost simple and intuitive but I should note one thing
about implementation detail.

To check duplication, this patch uses checksum of the page and collision
of this checksum could be possible.  There would be many choices to handle
this situation but this patch chooses to allow entry with duplicated
checksum to be added to the hash, but, not to compare all entries with
duplicated checksum when checking duplication.  I guess that checksum
collision is quite rare event and we don't need to pay any attention to
such a case.  Therefore, I decided the most simplest way to implement the
feature.  If there is a different opinion, I can accept and go that way.

Following is the result of this patch.

Test result #1 (Swap):
Android Marshmallow, emulator, x86_64, Backporting to kernel v3.18

orig_data_size: 145297408
compr_data_size: 32408125
mem_used_total: 32276480
dup_data_size: 3188134
meta_data_size: 1444272

Last two metrics added to mm_stat are related to this work.  First one,
dup_data_size, is amount of saved memory by avoiding to store duplicated
page.  Later one, meta_data_size, is the amount of data structure to
support deduplication.  If dup > meta, we can judge that the patch
improves memory usage.

In Adnroid, we can save 5% of memory usage by this work.

Test result #2 (Blockdev):
build the kernel and store output to ext4 FS on zram

<no-dedup>
Elapsed time: 249 s
mm_stat: 430845952 191014886 196898816 0 196898816 28320 0 0 0

<dedup>
Elapsed time: 250 s
mm_stat: 430505984 190971334 148365312 0 148365312 28404 0 47287038  3945792

There is no performance degradation and save 23% memory.

Test result #3 (Blockdev):
copy android build output dir(out/host) to ext4 FS on zram

<no-dedup>
Elapsed time: out/host: 88 s
mm_stat: 8834420736 3658184579 3834208256 0 3834208256 32889 0 0 0

<dedup>
Elapsed time: out/host: 100 s
mm_stat: 8832929792 3657329322 2832015360 0 2832015360 32609 0 952568877 80880336

It shows performance degradation roughly 13% and save 24% memory. Maybe,
it is due to overhead of calculating checksum and comparison.

Test result #4 (Blockdev):
copy android build output dir(out/target/common) to ext4 FS on zram

<no-dedup>
Elapsed time: out/host: 203 s
mm_stat: 4041678848 2310355010 2346577920 0 2346582016 500 4 0 0

<dedup>
Elapsed time: out/host: 201 s
mm_stat: 4041666560 2310488276 1338150912 0 1338150912 476 0 989088794 24564336

Memory is saved by 42% and performance is the same. Even if there is overhead
of calculating checksum and comparison, large hit ratio compensate it since
hit leads to less compression attempt.

I checked the detailed reason of savings on kernel build workload and
there are some cases that deduplication happens.

1) *.cmd
Build command is usually similar in one directory so content of these file
are very similar. In my system, more than 789 lines in fs/ext4/.namei.o.cmd
and fs/ext4/.inode.o.cmd are the same in 944 and 938 lines of the file,
respectively.

2) intermediate object files
built-in.o and temporary object file have the similar contents. More than
50% of fs/ext4/ext4.o is the same with fs/ext4/built-in.o.

3) vmlinux
.tmp_vmlinux1 and .tmp_vmlinux2 and arch/x86/boo/compressed/vmlinux.bin
have the similar contents.

Android test has similar case that some of object files(.class
and .so) are similar with another ones.
(./host/linux-x86/lib/libartd.so and
./host/linux-x86-lib/libartd-comiler.so)

Anyway, benefit seems to be largely dependent on the workload so
following patch will make this feature optional. However, this feature
can help some usecases so is deserved to be merged.

[1]: MemScope: Analyzing Memory Duplication on Android Systems,
dl.acm.org/citation.cfm?id=2797023
[2]: zswap: Optimize compressed pool memory utilization,
lkml.kernel.org/r/1341407574.7551.1471584870761.JavaMail.weblogic@epwas3p2

Link: http://lkml.kernel.org/r/1494556204-25796-3-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/blockdev/zram.txt |    2 
 drivers/block/zram/Makefile     |    2 
 drivers/block/zram/zram_dedup.c |  204 ++++++++++++++++++++++++++++++
 drivers/block/zram/zram_dedup.h |   22 +++
 drivers/block/zram/zram_drv.c   |   38 ++++-
 drivers/block/zram/zram_drv.h   |   17 ++
 6 files changed, 278 insertions(+), 7 deletions(-)

diff -puN Documentation/blockdev/zram.txt~zram-implement-deduplication-in-zram Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-implement-deduplication-in-zram
+++ a/Documentation/blockdev/zram.txt
@@ -217,6 +217,8 @@ line of text and contains the following
  same_pages       the number of same element filled pages written to this disk.
                   No memory is allocated for such pages.
  pages_compacted  the number of pages freed during compaction
+ dup_data_size	  deduplicated data size
+ meta_data_size	  the amount of metadata allocated for deduplication feature
 
 9) Deactivate:
 	swapoff /dev/zram0
diff -puN drivers/block/zram/Makefile~zram-implement-deduplication-in-zram drivers/block/zram/Makefile
--- a/drivers/block/zram/Makefile~zram-implement-deduplication-in-zram
+++ a/drivers/block/zram/Makefile
@@ -1,3 +1,3 @@
-zram-y	:=	zcomp.o zram_drv.o
+zram-y	:=	zcomp.o zram_drv.o zram_dedup.o
 
 obj-$(CONFIG_ZRAM)	+=	zram.o
diff -puN /dev/null drivers/block/zram/zram_dedup.c
--- /dev/null
+++ a/drivers/block/zram/zram_dedup.c
@@ -0,0 +1,204 @@
+/*
+ * Copyright (C) 2017 Joonsoo Kim.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/vmalloc.h>
+#include <linux/jhash.h>
+#include <linux/highmem.h>
+
+#include "zram_drv.h"
+
+/* One slot will contain 128 pages theoretically */
+#define ZRAM_HASH_SHIFT		7
+#define ZRAM_HASH_SIZE_MIN	(1 << 10)
+#define ZRAM_HASH_SIZE_MAX	(1 << 31)
+
+u64 zram_dedup_dup_size(struct zram *zram)
+{
+	return (u64)atomic64_read(&zram->stats.dup_data_size);
+}
+
+u64 zram_dedup_meta_size(struct zram *zram)
+{
+	return (u64)atomic64_read(&zram->stats.meta_data_size);
+}
+
+static u32 zram_dedup_checksum(unsigned char *mem)
+{
+	return jhash(mem, PAGE_SIZE, 0);
+}
+
+void zram_dedup_insert(struct zram *zram, struct zram_entry *new,
+				u32 checksum)
+{
+	struct zram_hash *hash;
+	struct rb_root *rb_root;
+	struct rb_node **rb_node, *parent = NULL;
+	struct zram_entry *entry;
+
+	new->checksum = checksum;
+	hash = &zram->hash[checksum % zram->hash_size];
+	rb_root = &hash->rb_root;
+
+	spin_lock(&hash->lock);
+	rb_node = &rb_root->rb_node;
+	while (*rb_node) {
+		parent = *rb_node;
+		entry = rb_entry(parent, struct zram_entry, rb_node);
+		if (checksum < entry->checksum)
+			rb_node = &parent->rb_left;
+		else if (checksum > entry->checksum)
+			rb_node = &parent->rb_right;
+		else
+			rb_node = &parent->rb_left;
+	}
+
+	rb_link_node(&new->rb_node, parent, rb_node);
+	rb_insert_color(&new->rb_node, rb_root);
+	spin_unlock(&hash->lock);
+}
+
+static bool zram_dedup_match(struct zram *zram, struct zram_entry *entry,
+				unsigned char *mem)
+{
+	bool match = false;
+	unsigned char *cmem;
+	struct zcomp_strm *zstrm;
+
+	cmem = zs_map_object(zram->mem_pool, entry->handle, ZS_MM_RO);
+	if (entry->len == PAGE_SIZE) {
+		match = !memcmp(mem, cmem, PAGE_SIZE);
+	} else {
+		zstrm = zcomp_stream_get(zram->comp);
+		if (!zcomp_decompress(zstrm, cmem, entry->len, zstrm->buffer))
+			match = !memcmp(mem, zstrm->buffer, PAGE_SIZE);
+		zcomp_stream_put(zram->comp);
+	}
+	zs_unmap_object(zram->mem_pool, entry->handle);
+
+	return match;
+}
+
+static unsigned long zram_dedup_put(struct zram *zram,
+				struct zram_entry *entry)
+{
+	struct zram_hash *hash;
+	u32 checksum;
+
+	checksum = entry->checksum;
+	hash = &zram->hash[checksum % zram->hash_size];
+
+	spin_lock(&hash->lock);
+
+	entry->refcount--;
+	if (!entry->refcount)
+		rb_erase(&entry->rb_node, &hash->rb_root);
+	else
+		atomic64_sub(entry->len, &zram->stats.dup_data_size);
+
+	spin_unlock(&hash->lock);
+
+	return entry->refcount;
+}
+
+static struct zram_entry *zram_dedup_get(struct zram *zram,
+				unsigned char *mem, u32 checksum)
+{
+	struct zram_hash *hash;
+	struct zram_entry *entry;
+	struct rb_node *rb_node;
+
+	hash = &zram->hash[checksum % zram->hash_size];
+
+	spin_lock(&hash->lock);
+	rb_node = hash->rb_root.rb_node;
+	while (rb_node) {
+		entry = rb_entry(rb_node, struct zram_entry, rb_node);
+		if (checksum == entry->checksum) {
+			entry->refcount++;
+			atomic64_add(entry->len, &zram->stats.dup_data_size);
+			spin_unlock(&hash->lock);
+
+			if (zram_dedup_match(zram, entry, mem))
+				return entry;
+
+			zram_entry_free(zram, entry);
+
+			return NULL;
+		}
+
+		if (checksum < entry->checksum)
+			rb_node = rb_node->rb_left;
+		else
+			rb_node = rb_node->rb_right;
+	}
+	spin_unlock(&hash->lock);
+
+	return NULL;
+}
+
+struct zram_entry *zram_dedup_find(struct zram *zram, struct page *page,
+				u32 *checksum)
+{
+	void *mem;
+	struct zram_entry *entry;
+
+	mem = kmap_atomic(page);
+	*checksum = zram_dedup_checksum(mem);
+
+	entry = zram_dedup_get(zram, mem, *checksum);
+	kunmap_atomic(mem);
+
+	return entry;
+}
+
+void zram_dedup_init_entry(struct zram *zram, struct zram_entry *entry,
+				unsigned long handle, unsigned int len)
+{
+	entry->handle = handle;
+	entry->refcount = 1;
+	entry->len = len;
+}
+
+bool zram_dedup_put_entry(struct zram *zram, struct zram_entry *entry)
+{
+	if (zram_dedup_put(zram, entry))
+		return false;
+
+	return true;
+}
+
+int zram_dedup_init(struct zram *zram, size_t num_pages)
+{
+	int i;
+	struct zram_hash *hash;
+
+	zram->hash_size = num_pages >> ZRAM_HASH_SHIFT;
+	zram->hash_size = min_t(size_t, ZRAM_HASH_SIZE_MAX, zram->hash_size);
+	zram->hash_size = max_t(size_t, ZRAM_HASH_SIZE_MIN, zram->hash_size);
+	zram->hash = vzalloc(zram->hash_size * sizeof(struct zram_hash));
+	if (!zram->hash) {
+		pr_err("Error allocating zram entry hash\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < zram->hash_size; i++) {
+		hash = &zram->hash[i];
+		spin_lock_init(&hash->lock);
+		hash->rb_root = RB_ROOT;
+	}
+
+	return 0;
+}
+
+void zram_dedup_fini(struct zram *zram)
+{
+	vfree(zram->hash);
+	zram->hash = NULL;
+	zram->hash_size = 0;
+}
diff -puN /dev/null drivers/block/zram/zram_dedup.h
--- /dev/null
+++ a/drivers/block/zram/zram_dedup.h
@@ -0,0 +1,22 @@
+#ifndef _ZRAM_DEDUP_H_
+#define _ZRAM_DEDUP_H_
+
+struct zram;
+struct zram_entry;
+
+u64 zram_dedup_dup_size(struct zram *zram);
+u64 zram_dedup_meta_size(struct zram *zram);
+
+void zram_dedup_insert(struct zram *zram, struct zram_entry *new,
+				u32 checksum);
+struct zram_entry *zram_dedup_find(struct zram *zram, struct page *page,
+				u32 *checksum);
+
+void zram_dedup_init_entry(struct zram *zram, struct zram_entry *entry,
+				unsigned long handle, unsigned int len);
+bool zram_dedup_put_entry(struct zram *zram, struct zram_entry *entry);
+
+int zram_dedup_init(struct zram *zram, size_t num_pages);
+void zram_dedup_fini(struct zram *zram);
+
+#endif /* _ZRAM_DEDUP_H_ */
diff -puN drivers/block/zram/zram_drv.c~zram-implement-deduplication-in-zram drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-implement-deduplication-in-zram
+++ a/drivers/block/zram/zram_drv.c
@@ -389,14 +389,16 @@ static ssize_t mm_stat_show(struct devic
 	max_used = atomic_long_read(&zram->stats.max_used_pages);
 
 	ret = scnprintf(buf, PAGE_SIZE,
-			"%8llu %8llu %8llu %8lu %8ld %8llu %8lu\n",
+			"%8llu %8llu %8llu %8lu %8ld %8llu %8lu %8llu %8llu\n",
 			orig_size << PAGE_SHIFT,
 			(u64)atomic64_read(&zram->stats.compr_data_size),
 			mem_used << PAGE_SHIFT,
 			zram->limit_pages << PAGE_SHIFT,
 			max_used << PAGE_SHIFT,
 			(u64)atomic64_read(&zram->stats.same_pages),
-			pool_stats.pages_compacted);
+			pool_stats.pages_compacted,
+			zram_dedup_dup_size(zram),
+			zram_dedup_meta_size(zram));
 	up_read(&zram->init_lock);
 
 	return ret;
@@ -481,26 +483,34 @@ static struct zram_entry *zram_entry_all
 					unsigned int len, gfp_t flags)
 {
 	struct zram_entry *entry;
+	unsigned long handle;
 
 	entry = kzalloc(sizeof(*entry),
 			flags & ~(__GFP_HIGHMEM|__GFP_MOVABLE));
 	if (!entry)
 		return NULL;
 
-	entry->handle = zs_malloc(zram->mem_pool, len, flags);
-	if (!entry->handle) {
+	handle = zs_malloc(zram->mem_pool, len, flags);
+	if (!handle) {
 		kfree(entry);
 		return NULL;
 	}
 
+	zram_dedup_init_entry(zram, entry, handle, len);
+	atomic64_add(sizeof(*entry), &zram->stats.meta_data_size);
+
 	return entry;
 }
 
-static inline void zram_entry_free(struct zram *zram,
-			struct zram_entry *entry)
+void zram_entry_free(struct zram *zram, struct zram_entry *entry)
 {
+	if (!zram_dedup_put_entry(zram, entry))
+		return;
+
 	zs_free(zram->mem_pool, entry->handle);
 	kfree(entry);
+
+	atomic64_sub(sizeof(*entry), &zram->stats.meta_data_size);
 }
 
 static void zram_meta_free(struct zram *zram, u64 disksize)
@@ -513,6 +523,7 @@ static void zram_meta_free(struct zram *
 		zram_free_page(zram, index);
 
 	zs_destroy_pool(zram->mem_pool);
+	zram_dedup_fini(zram);
 	vfree(zram->table);
 }
 
@@ -531,6 +542,12 @@ static bool zram_meta_alloc(struct zram
 		return false;
 	}
 
+	if (zram_dedup_init(zram, num_pages)) {
+		vfree(zram->table);
+		zs_destroy_pool(zram->mem_pool);
+		return false;
+	}
+
 	return true;
 }
 
@@ -715,10 +732,17 @@ static int __zram_bvec_write(struct zram
 	void *src, *dst;
 	struct zcomp_strm *zstrm;
 	struct page *page = bvec->bv_page;
+	u32 checksum;
 
 	if (zram_same_page_write(zram, index, page))
 		return 0;
 
+	entry = zram_dedup_find(zram, page, &checksum);
+	if (entry) {
+		comp_len = entry->len;
+		goto found_dup;
+	}
+
 	zstrm = zcomp_stream_get(zram->comp);
 	ret = zram_compress(zram, &zstrm, page, &entry, &comp_len);
 	if (ret) {
@@ -737,7 +761,9 @@ static int __zram_bvec_write(struct zram
 
 	zcomp_stream_put(zram->comp);
 	zs_unmap_object(zram->mem_pool, entry->handle);
+	zram_dedup_insert(zram, entry, checksum);
 
+found_dup:
 	/*
 	 * Free memory associated with this sector
 	 * before overwriting unused sectors.
diff -puN drivers/block/zram/zram_drv.h~zram-implement-deduplication-in-zram drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-implement-deduplication-in-zram
+++ a/drivers/block/zram/zram_drv.h
@@ -18,8 +18,10 @@
 #include <linux/rwsem.h>
 #include <linux/zsmalloc.h>
 #include <linux/crypto.h>
+#include <linux/spinlock.h>
 
 #include "zcomp.h"
+#include "zram_dedup.h"
 
 /*-- Configurable parameters */
 
@@ -70,6 +72,10 @@ enum zram_pageflags {
 /*-- Data structures */
 
 struct zram_entry {
+	struct rb_node rb_node;
+	u32 len;
+	u32 checksum;
+	unsigned long refcount;
 	unsigned long handle;
 };
 
@@ -94,6 +100,13 @@ struct zram_stats {
 	atomic64_t pages_stored;	/* no. of pages currently stored */
 	atomic_long_t max_used_pages;	/* no. of maximum pages stored */
 	atomic64_t writestall;		/* no. of write slow paths */
+	atomic64_t dup_data_size;	/* compressed size of pages duplicated */
+	atomic64_t meta_data_size;	/* size of zram_entries */
+};
+
+struct zram_hash {
+	spinlock_t lock;
+	struct rb_root rb_root;
 };
 
 struct zram {
@@ -101,6 +114,8 @@ struct zram {
 	struct zs_pool *mem_pool;
 	struct zcomp *comp;
 	struct gendisk *disk;
+	struct zram_hash *hash;
+	size_t hash_size;
 	/* Prevent concurrent execution of device init */
 	struct rw_semaphore init_lock;
 	/*
@@ -120,4 +135,6 @@ struct zram {
 	 */
 	bool claim; /* Protected by bdev->bd_mutex */
 };
+
+void zram_entry_free(struct zram *zram, struct zram_entry *entry);
 #endif
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

zram-make-deduplication-feature-optional.patch
zram-compare-all-the-entries-with-same-checksum-for-deduplication.patch
mm-kasan-use-kasan_zero_pud-for-p4d-table.patch
mm-kasan-rename-xxx_is_zero-to-xxx_is_nonzero.patch

