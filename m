Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBA81B960
	for <mm-commits@vger.kernel.org>; Wed, 11 Jun 2025 01:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749607069; cv=none; b=Xg6GNR8n/zyt6wVRwbzk23fy6qSFWZyg+Qn6BWhOcdchCALxfuWaBCvybwR8LG2aevYN9WoFXdTfCM/c0N+TrFWoiNa13usd2j+7WkpnCcRjqTMz6oO0/8QyBl0Q7doXHVoW5EAspZT9kjPHIlW6ANX7pmZ/AIC6sf4jKsFYcsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749607069; c=relaxed/simple;
	bh=uaWtfnmE0mRUXjKHD38uCtVsWFNAvzwgeJOhExYcH60=;
	h=Date:To:From:Subject:Message-Id; b=NgOzTVgRuSRyREMR+H5WmbZMO4R1GlJSjrSaMTdOItlS6C5RCVX+KuWj99R3TjObvFc0ZugZtuIvf4hWyntrr/L+PNnwY7S/LCLYpjl1UbHLr8Q32YTvY+QGNZTjxZWGccN4a64yHOs2PKw645Htx0vKTxAf1vLDkf/bibxVR0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yL0jK5lQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yL0jK5lQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F572C4CEED;
	Wed, 11 Jun 2025 01:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749607069;
	bh=uaWtfnmE0mRUXjKHD38uCtVsWFNAvzwgeJOhExYcH60=;
	h=Date:To:From:Subject:From;
	b=yL0jK5lQ6d7VVrzDijcID+JS2vr/ZuKchg9gs1ByIT7mFsmrCt3dL2jYICf6G8suk
	 5wziLPRYRuSQ3dTfbJUg+O67q9GAT4Yww7vkbhw+JwddwdTuWOEOQrj7QKLNpy/b/e
	 PTp26gEMmwyUGXIfAWbpHM1PCIbsKTfjcFiaMJQc=
Date: Tue, 10 Jun 2025 18:57:48 -0700
To: mm-commits@vger.kernel.org,vitaly.wool@konsulko.se,shakeel.butt@linux.dev,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,igor.b@beldev.am,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zblock-use-vmalloc-for-page-allocations.patch removed from -mm tree
Message-Id: <20250611015749.1F572C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zblock: use vmalloc for page allocations
has been removed from the -mm tree.  Its filename was
     mm-zblock-use-vmalloc-for-page-allocations.patch

This patch was dropped because it was folded into mm-add-zblock-allocator.patch

------------------------------------------------------
From: Igor Belousov <igor.b@beldev.am>
Subject: mm/zblock: use vmalloc for page allocations
Date: Wed, 7 May 2025 00:03:29 +0200

Use vmalloc for page allocations for zblock blocks to avoid extra pressure
on the memmory subsystem with multiple higher order allocations.

Since vmalloc works fine with non-power of 2 numbers of pages, rewrite the
block size tables to use that opportunity.

Link: https://lkml.kernel.org/r/20250506220329.2355482-1-vitaly.wool@konsulko.se
Signed-off-by: Igor Belousov <igor.b@beldev.am>
Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zblock.c |  119 ++++++++++++++++++-------------------
 mm/zblock.h |  158 +++++++++++++++++++++++++++++---------------------
 2 files changed, 152 insertions(+), 125 deletions(-)

--- a/mm/zblock.c~mm-zblock-use-vmalloc-for-page-allocations
+++ a/mm/zblock.c
@@ -24,6 +24,7 @@
 #include <linux/preempt.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/vmalloc.h>
 #include <linux/zpool.h>
 #include "zblock.h"
 
@@ -31,19 +32,16 @@ static struct rb_root block_desc_tree =
 static struct dentry *zblock_debugfs_root;
 
 /* Encode handle of a particular slot in the pool using metadata */
-static inline unsigned long metadata_to_handle(struct zblock_block *block,
-				unsigned int block_type, unsigned int slot)
+static inline unsigned long metadata_to_handle(struct zblock_block *block, unsigned int slot)
 {
-	return (unsigned long)(block) | (block_type << SLOT_BITS) | slot;
+	return (unsigned long)(block) | slot;
 }
 
 /* Return block, block type and slot in the pool corresponding to handle */
-static inline struct zblock_block *handle_to_metadata(unsigned long handle,
-				unsigned int *block_type, unsigned int *slot)
+static inline struct zblock_block *handle_to_metadata(unsigned long handle, unsigned int *slot)
 {
-	*block_type = (handle & (PAGE_SIZE - 1)) >> SLOT_BITS;
 	*slot = handle & SLOT_MASK;
-	return (struct zblock_block *)(handle & PAGE_MASK);
+	return (struct zblock_block *)(handle & ~SLOT_MASK);
 }
 
 /*
@@ -56,13 +54,14 @@ static inline struct zblock_block *find_
 	struct list_head *l = &b->active_list;
 	unsigned int slot;
 
-	if (!list_empty(l)) {
+	spin_lock(&b->lock);
+	if (likely(!list_empty(l))) {
 		struct zblock_block *z = list_first_entry(l, typeof(*z), link);
 
 		if (--z->free_slots == 0)
-			list_move(&z->link, &b->full_list);
+			__list_del_clearprev(&z->link);
 		/*
-		 * There is a slot in the block and we just made sure it would
+		 * There is a slot in the block and we just made sure it will
 		 * remain.
 		 * Find that slot and set the busy bit.
 		 */
@@ -74,13 +73,13 @@ static inline struct zblock_block *find_
 					slot)) {
 			if (!test_and_set_bit(slot, z->slot_info))
 				break;
-			barrier();
 		}
+		spin_unlock(&b->lock);
 
-		WARN_ON(slot >= block_desc[block_type].slots_per_block);
-		*handle = metadata_to_handle(z, block_type, slot);
+		*handle = metadata_to_handle(z, slot);
 		return z;
 	}
+	spin_unlock(&b->lock);
 	return NULL;
 }
 
@@ -89,22 +88,23 @@ static inline struct zblock_block *find_
  */
 static struct zblock_block *alloc_block(struct zblock_pool *pool,
 					int block_type, gfp_t gfp,
-					unsigned long *handle)
+					unsigned long *handle,
+					unsigned int nid)
 {
+	struct block_list *block_list = &pool->block_lists[block_type];
+	unsigned int num_pages = block_desc[block_type].num_pages;
 	struct zblock_block *block;
-	struct block_list *block_list;
 
-	block = (void *)__get_free_pages(gfp, block_desc[block_type].order);
+	block = __vmalloc_node(PAGE_SIZE * num_pages, PAGE_SIZE, gfp, nid, NULL);
 	if (!block)
 		return NULL;
 
-	block_list = &pool->block_lists[block_type];
-
-	/* init block data  */
+	/* init block data */
+	block->block_type = block_type;
 	block->free_slots = block_desc[block_type].slots_per_block - 1;
 	memset(&block->slot_info, 0, sizeof(block->slot_info));
 	set_bit(0, block->slot_info);
-	*handle = metadata_to_handle(block, block_type, 0);
+	*handle = metadata_to_handle(block, 0);
 
 	spin_lock(&block_list->lock);
 	list_add(&block->link, &block_list->active_list);
@@ -122,8 +122,8 @@ static int zblock_blocks_show(struct seq
 		struct block_list *block_list = &pool->block_lists[i];
 
 		seq_printf(s, "%d: %ld blocks of %d pages (total %ld pages)\n",
-			i, block_list->block_count, 1 << block_desc[i].order,
-			block_list->block_count << block_desc[i].order);
+			i, block_list->block_count, block_desc[i].num_pages,
+			block_list->block_count * block_desc[i].num_pages);
 	}
 	return 0;
 }
@@ -141,26 +141,34 @@ DEFINE_SHOW_ATTRIBUTE(zblock_blocks);
  */
 static struct zblock_pool *zblock_create_pool(gfp_t gfp)
 {
-	struct zblock_pool *pool;
-	struct block_list *block_list;
+	struct zblock_pool *pool = kmalloc(sizeof(struct zblock_pool), gfp);
 	int i;
 
-	pool = kmalloc(sizeof(struct zblock_pool), gfp);
 	if (!pool)
 		return NULL;
 
 	/* init each block list */
 	for (i = 0; i < ARRAY_SIZE(block_desc); i++) {
-		block_list = &pool->block_lists[i];
+		struct block_list *block_list = &pool->block_lists[i];
+
 		spin_lock_init(&block_list->lock);
-		INIT_LIST_HEAD(&block_list->full_list);
 		INIT_LIST_HEAD(&block_list->active_list);
 		block_list->block_count = 0;
 	}
 
+	pool->block_header_cache = kmem_cache_create("zblock",
+						     sizeof(struct zblock_block),
+						     (1 << SLOT_BITS), 0, NULL);
+	if (!pool->block_header_cache)
+		goto out;
+
 	debugfs_create_file("blocks", S_IFREG | 0444, zblock_debugfs_root,
 			    pool, &zblock_blocks_fops);
 	return pool;
+
+out:
+	kfree(pool);
+	return NULL;
 }
 
 /**
@@ -170,6 +178,7 @@ static struct zblock_pool *zblock_create
  */
 static void zblock_destroy_pool(struct zblock_pool *pool)
 {
+	kmem_cache_destroy(pool->block_header_cache);
 	kfree(pool);
 }
 
@@ -186,7 +195,7 @@ static void zblock_destroy_pool(struct z
  * a new slot.
  */
 static int zblock_alloc(struct zblock_pool *pool, size_t size, gfp_t gfp,
-			unsigned long *handle)
+			unsigned long *handle, unsigned int nid)
 {
 	int block_type = -1;
 	struct zblock_block *block;
@@ -195,7 +204,7 @@ static int zblock_alloc(struct zblock_po
 	if (!size)
 		return -EINVAL;
 
-	if (size > PAGE_SIZE)
+	if (size > block_desc[ARRAY_SIZE(block_desc) - 1].slot_size)
 		return -ENOSPC;
 
 	/* find basic block type with suitable slot size */
@@ -219,19 +228,15 @@ static int zblock_alloc(struct zblock_po
 	}
 	if (WARN_ON(block_type < 0))
 		return -EINVAL;
-	if (block_type >= ARRAY_SIZE(block_desc))
-		return -ENOSPC;
 
 	block_list = &pool->block_lists[block_type];
 
-	spin_lock(&block_list->lock);
 	block = find_and_claim_block(block_list, block_type, handle);
-	spin_unlock(&block_list->lock);
 	if (block)
 		return 0;
 
 	/* not found block with free slots try to allocate new empty block */
-	block = alloc_block(pool, block_type, gfp & ~(__GFP_MOVABLE | __GFP_HIGHMEM), handle);
+	block = alloc_block(pool, block_type, gfp, handle, nid);
 	return block ? 0 : -ENOMEM;
 }
 
@@ -247,20 +252,23 @@ static void zblock_free(struct zblock_po
 	struct zblock_block *block;
 	struct block_list *block_list;
 
-	block = handle_to_metadata(handle, &block_type, &slot);
+	block = handle_to_metadata(handle, &slot);
+	block_type = block->block_type;
 	block_list = &pool->block_lists[block_type];
 
+	/* clear bit early, this will shorten the search */
+	clear_bit(slot, block->slot_info);
+
 	spin_lock(&block_list->lock);
-	/* if all slots in block are empty delete whole block */
+	/* if all slots in block are empty delete the whole block */
 	if (++block->free_slots == block_desc[block_type].slots_per_block) {
 		block_list->block_count--;
-		list_del(&block->link);
+		__list_del_clearprev(&block->link);
 		spin_unlock(&block_list->lock);
-		free_pages((unsigned long)block, block_desc[block_type].order);
+		vfree(block);
 		return;
 	} else if (block->free_slots == 1)
-		list_move_tail(&block->link, &block_list->active_list);
-	clear_bit(slot, block->slot_info);
+		list_add(&block->link, &block_list->active_list);
 	spin_unlock(&block_list->lock);
 }
 
@@ -274,15 +282,11 @@ static void zblock_free(struct zblock_po
  */
 static void *zblock_map(struct zblock_pool *pool, unsigned long handle)
 {
-	unsigned int block_type, slot;
-	struct zblock_block *block;
-	unsigned long offs;
-	void *p;
+	unsigned int slot;
+	struct zblock_block *block = handle_to_metadata(handle, &slot);
+	unsigned long offs = ZBLOCK_HEADER_SIZE + slot * block_desc[block->block_type].slot_size;
 
-	block = handle_to_metadata(handle, &block_type, &slot);
-	offs = ZBLOCK_HEADER_SIZE + slot * block_desc[block_type].slot_size;
-	p = (void *)block + offs;
-	return p;
+	return (void *)block + offs;
 }
 
 /**
@@ -304,15 +308,11 @@ static void zblock_unmap(struct zblock_p
 static void zblock_write(struct zblock_pool *pool, unsigned long handle,
 			 void *handle_mem, size_t mem_len)
 {
-	unsigned int block_type, slot;
-	struct zblock_block *block;
-	unsigned long offs;
-	void *p;
+	unsigned int slot;
+	struct zblock_block *block = handle_to_metadata(handle, &slot);
+	unsigned long offs = ZBLOCK_HEADER_SIZE + slot * block_desc[block->block_type].slot_size;
 
-	block = handle_to_metadata(handle, &block_type, &slot);
-	offs = ZBLOCK_HEADER_SIZE + slot * block_desc[block_type].slot_size;
-	p = (void *)block + offs;
-	memcpy(p, handle_mem, mem_len);
+	memcpy((void *)block + offs, handle_mem, mem_len);
 }
 
 /**
@@ -328,7 +328,7 @@ static u64 zblock_get_total_pages(struct
 
 	total_size = 0;
 	for (i = 0; i < ARRAY_SIZE(block_desc); i++)
-		total_size += pool->block_lists[i].block_count << block_desc[i].order;
+		total_size += pool->block_lists[i].block_count * block_desc[i].num_pages;
 
 	return total_size;
 }
@@ -350,7 +350,7 @@ static void zblock_zpool_destroy(void *p
 static int zblock_zpool_malloc(void *pool, size_t size, gfp_t gfp,
 			unsigned long *handle, const int nid)
 {
-	return zblock_alloc(pool, size, gfp, handle);
+	return zblock_alloc(pool, size, gfp, handle, nid);
 }
 
 static void zblock_zpool_free(void *pool, unsigned long handle)
@@ -406,6 +406,7 @@ static int __init create_rbtree(void)
 {
 	int i;
 
+	BUILD_BUG_ON(ARRAY_SIZE(block_desc) > MAX_TABLE_SIZE);
 	for (i = 0; i < ARRAY_SIZE(block_desc); i++) {
 		struct block_desc_node *block_node = kmalloc(sizeof(*block_node),
 							GFP_KERNEL);
@@ -424,7 +425,7 @@ static int __init create_rbtree(void)
 		block_node->this_slot_size = block_desc[i].slot_size;
 		block_node->block_idx = i;
 		if (i == ARRAY_SIZE(block_desc) - 1)
-			block_node->next_slot_size = PAGE_SIZE;
+			block_node->next_slot_size = PAGE_SIZE * 2;
 		else
 			block_node->next_slot_size = block_desc[i+1].slot_size;
 		while (*new) {
--- a/mm/zblock.h~mm-zblock-use-vmalloc-for-page-allocations
+++ a/mm/zblock.h
@@ -10,13 +10,9 @@
 #include <linux/rbtree.h>
 #include <linux/types.h>
 
-#define SLOT_FREE 0
-#define BIT_SLOT_OCCUPIED 0
-#define BIT_SLOT_MAPPED 1
-
 #if PAGE_SIZE == 0x1000
-/* max 128 slots per block, max table size 32 */
-#define SLOT_BITS 7
+/* max 64 slots per block, max table size 64 */
+#define SLOT_BITS 6
 #elif PAGE_SIZE == 0x4000
 /* max 256 slots per block, max table size 64 */
 #define SLOT_BITS 8
@@ -25,25 +21,29 @@
 #define SLOT_BITS 8
 #endif
 
+#define MAX_TABLE_SIZE (1 << (PAGE_SHIFT - SLOT_BITS))
+
 #define MAX_SLOTS (1 << SLOT_BITS)
 #define SLOT_MASK ((0x1UL << SLOT_BITS) - 1)
 
 #define ZBLOCK_HEADER_SIZE	round_up(sizeof(struct zblock_block), sizeof(long))
-#define BLOCK_DATA_SIZE(order) ((PAGE_SIZE << order) - ZBLOCK_HEADER_SIZE)
-#define SLOT_SIZE(nslots, order) (round_down((BLOCK_DATA_SIZE(order) / nslots), sizeof(long)))
+#define BLOCK_DATA_SIZE(num) ((PAGE_SIZE * (num)) - ZBLOCK_HEADER_SIZE)
+#define SLOT_SIZE(nslots, num) (round_down((BLOCK_DATA_SIZE(num) / nslots), sizeof(long)))
+#define ZBLOCK_MAX_PAGES_PER_BLOCK	8
 
 /**
  * struct zblock_block - block metadata
- * Block consists of several (1/2/4/8) pages and contains fixed
+ * Block consists of several pages and contains fixed
  * integer number of slots for allocating compressed pages.
  *
  * free_slots:	number of free slots in the block
  * slot_info:	contains data about free/occupied slots
  */
 struct zblock_block {
-	struct list_head link;
 	DECLARE_BITMAP(slot_info, 1 << SLOT_BITS);
-	u32 free_slots;
+	struct list_head link;
+	unsigned short block_type;
+	unsigned short free_slots;
 };
 
 /**
@@ -54,12 +54,12 @@ struct zblock_block {
  *
  * slot_size:		size of slot for this list
  * slots_per_block:	number of slots per block for this list
- * order:		order for __get_free_pages
+ * num_pages:		number of pages per block
  */
 struct block_desc {
 	unsigned int slot_size;
 	unsigned short slots_per_block;
-	unsigned short order;
+	unsigned short num_pages;
 };
 
 struct block_desc_node {
@@ -71,78 +71,105 @@ struct block_desc_node {
 
 static const struct block_desc block_desc[] = {
 #if PAGE_SIZE == 0x1000
-	{ SLOT_SIZE(63, 0), 63, 0 },
-	{ SLOT_SIZE(32, 0), 32, 0 },
-	{ SLOT_SIZE(21, 0), 21, 0 },
-	{ SLOT_SIZE(15, 0), 15, 0 },
-	{ SLOT_SIZE(12, 0), 12, 0 },
-	{ SLOT_SIZE(10, 0), 10, 0 },
-	{ SLOT_SIZE(9, 0), 9, 0 },
-	{ SLOT_SIZE(8, 0), 8, 0 },
-	{ SLOT_SIZE(29, 2), 29, 2 },
-	{ SLOT_SIZE(13, 1), 13, 1 },
-	{ SLOT_SIZE(6, 0), 6, 0 },
-	{ SLOT_SIZE(11, 1), 11, 1 },
-	{ SLOT_SIZE(5, 0), 5, 0 },
-	{ SLOT_SIZE(9, 1), 9, 1 },
-	{ SLOT_SIZE(8, 1), 8, 1 },
-	{ SLOT_SIZE(29, 3), 29, 3 },
+	{ SLOT_SIZE(28, 1), 28, 1 },
+	{ SLOT_SIZE(18, 1), 18, 1 },
+	{ SLOT_SIZE(12, 1), 12, 1 },
+	{ SLOT_SIZE(10, 1), 10, 1 },
+	{ SLOT_SIZE(17, 2), 17, 2 },
+	{ SLOT_SIZE(15, 2), 15, 2 },
 	{ SLOT_SIZE(13, 2), 13, 2 },
-	{ SLOT_SIZE(12, 2), 12, 2 },
+	{ SLOT_SIZE(6, 1), 6, 1 },
 	{ SLOT_SIZE(11, 2), 11, 2 },
-	{ SLOT_SIZE(10, 2), 10, 2 },
+	{ SLOT_SIZE(5, 1), 5, 1 },
+	{ SLOT_SIZE(19, 4), 19, 4 },
 	{ SLOT_SIZE(9, 2), 9, 2 },
-	{ SLOT_SIZE(17, 3), 17, 3 },
-	{ SLOT_SIZE(8, 2), 8, 2 },
-	{ SLOT_SIZE(15, 3), 15, 3 },
-	{ SLOT_SIZE(14, 3), 14, 3 },
-	{ SLOT_SIZE(13, 3), 13, 3 },
-	{ SLOT_SIZE(6, 2), 6, 2 },
+	{ SLOT_SIZE(17, 4), 17, 4 },
+	{ SLOT_SIZE(4, 1), 4, 1 },
+	{ SLOT_SIZE(23, 6), 23, 6 },
 	{ SLOT_SIZE(11, 3), 11, 3 },
+	{ SLOT_SIZE(7, 2), 7, 2 },
 	{ SLOT_SIZE(10, 3), 10, 3 },
-	{ SLOT_SIZE(9, 3), 9, 3 },
-	{ SLOT_SIZE(4, 2), 4, 2 },
+	{ SLOT_SIZE(19, 6), 19, 6 },
+	{ SLOT_SIZE(6, 2), 6, 2 },
+	{ SLOT_SIZE(14, 5), 14, 5 },
+	{ SLOT_SIZE(8, 3), 8, 3 },
+	{ SLOT_SIZE(5, 2), 5, 2 },
+	{ SLOT_SIZE(12, 5), 12, 5 },
+	{ SLOT_SIZE(9, 4), 9, 4 },
+	{ SLOT_SIZE(15, 7), 15, 7 },
+	{ SLOT_SIZE(2, 1), 2, 1 },
+	{ SLOT_SIZE(15, 8), 15, 8 },
+	{ SLOT_SIZE(9, 5), 9, 5 },
+	{ SLOT_SIZE(12, 7), 12, 7 },
+	{ SLOT_SIZE(13, 8), 13, 8 },
+	{ SLOT_SIZE(6, 4), 6, 4 },
+	{ SLOT_SIZE(11, 8), 11, 8 },
+	{ SLOT_SIZE(9, 7), 9, 7 },
+	{ SLOT_SIZE(6, 5), 6, 5 },
+	{ SLOT_SIZE(9, 8), 9, 8 },
+	{ SLOT_SIZE(4, 4), 4, 4 },
 #else
-	{ SLOT_SIZE(255, 0), 255, 0 },
-	{ SLOT_SIZE(185, 0), 185, 0 },
-	{ SLOT_SIZE(145, 0), 145, 0 },
-	{ SLOT_SIZE(113, 0), 113, 0 },
-	{ SLOT_SIZE(92, 0), 92, 0 },
-	{ SLOT_SIZE(75, 0), 75, 0 },
-	{ SLOT_SIZE(60, 0), 60, 0 },
-	{ SLOT_SIZE(51, 0), 51, 0 },
-	{ SLOT_SIZE(43, 0), 43, 0 },
-	{ SLOT_SIZE(37, 0), 37, 0 },
-	{ SLOT_SIZE(32, 0), 32, 0 },
-	{ SLOT_SIZE(27, 0), 27, 0 },
-	{ SLOT_SIZE(23, 0), 23, 0 },
-	{ SLOT_SIZE(19, 0), 19, 0 },
-	{ SLOT_SIZE(17, 0), 17, 0 },
-	{ SLOT_SIZE(15, 0), 15, 0 },
-	{ SLOT_SIZE(13, 0), 13, 0 },
-	{ SLOT_SIZE(11, 0), 11, 0 },
-	{ SLOT_SIZE(10, 0), 10, 0 },
-	{ SLOT_SIZE(9, 0), 9, 0 },
-	{ SLOT_SIZE(8, 0), 8, 0 },
-	{ SLOT_SIZE(15, 1), 15, 1 },
-	{ SLOT_SIZE(14, 1), 14, 1 },
-	{ SLOT_SIZE(13, 1), 13, 1 },
+	{ SLOT_SIZE(185, 1), 185, 1 },
+	{ SLOT_SIZE(113, 1), 113, 1 },
+	{ SLOT_SIZE(86, 1), 86, 1 },
+	{ SLOT_SIZE(72, 1), 72, 1 },
+	{ SLOT_SIZE(58, 1), 58, 1 },
+	{ SLOT_SIZE(49, 1), 49, 1 },
+	{ SLOT_SIZE(42, 1), 42, 1 },
+	{ SLOT_SIZE(37, 1), 37, 1 },
+	{ SLOT_SIZE(33, 1), 33, 1 },
+	{ SLOT_SIZE(59, 2), 59, 2 },
+	{ SLOT_SIZE(27, 1), 27, 1 },
+	{ SLOT_SIZE(25, 1), 25, 1 },
+	{ SLOT_SIZE(23, 1), 23, 1 },
+	{ SLOT_SIZE(21, 1), 21, 1 },
+	{ SLOT_SIZE(39, 2), 39, 2 },
+	{ SLOT_SIZE(37, 2), 37, 2 },
+	{ SLOT_SIZE(35, 2), 35, 2 },
+	{ SLOT_SIZE(33, 2), 33, 2 },
+	{ SLOT_SIZE(31, 2), 31, 2 },
+	{ SLOT_SIZE(29, 2), 29, 2 },
+	{ SLOT_SIZE(27, 2), 27, 2 },
+	{ SLOT_SIZE(25, 2), 25, 2 },
 	{ SLOT_SIZE(12, 1), 12, 1 },
 	{ SLOT_SIZE(11, 1), 11, 1 },
+	{ SLOT_SIZE(21, 2), 21, 2 },
 	{ SLOT_SIZE(10, 1), 10, 1 },
+	{ SLOT_SIZE(19, 2), 19, 2 },
 	{ SLOT_SIZE(9, 1), 9, 1 },
+	{ SLOT_SIZE(17, 2), 17, 2 },
 	{ SLOT_SIZE(8, 1), 8, 1 },
 	{ SLOT_SIZE(15, 2), 15, 2 },
 	{ SLOT_SIZE(14, 2), 14, 2 },
+	{ SLOT_SIZE(27, 4), 27, 4 },
 	{ SLOT_SIZE(13, 2), 13, 2 },
+	{ SLOT_SIZE(25, 4), 25, 4 },
 	{ SLOT_SIZE(12, 2), 12, 2 },
+	{ SLOT_SIZE(23, 4), 23, 4 },
 	{ SLOT_SIZE(11, 2), 11, 2 },
+	{ SLOT_SIZE(21, 4), 21, 4 },
 	{ SLOT_SIZE(10, 2), 10, 2 },
+	{ SLOT_SIZE(19, 4), 19, 4 },
 	{ SLOT_SIZE(9, 2), 9, 2 },
-	{ SLOT_SIZE(8, 2), 8, 2 },
+	{ SLOT_SIZE(17, 4), 17, 4 },
+	{ SLOT_SIZE(4, 1), 4, 1 },
+	{ SLOT_SIZE(23, 6), 23, 6 },
+	{ SLOT_SIZE(11, 3), 11, 3 },
 	{ SLOT_SIZE(7, 2), 7, 2 },
+	{ SLOT_SIZE(10, 3), 10, 3 },
+	{ SLOT_SIZE(16, 5), 16, 5 },
 	{ SLOT_SIZE(6, 2), 6, 2 },
+	{ SLOT_SIZE(11, 4), 11, 4 },
+	{ SLOT_SIZE(8, 3), 8, 3 },
 	{ SLOT_SIZE(5, 2), 5, 2 },
+	{ SLOT_SIZE(7, 3), 7, 3 },
+	{ SLOT_SIZE(11, 5), 11, 5 },
+	{ SLOT_SIZE(4, 2), 4, 2 },
+	{ SLOT_SIZE(9, 5), 9, 5 },
+	{ SLOT_SIZE(8, 5), 8, 5 },
+	{ SLOT_SIZE(3, 2), 3, 2 },
+	{ SLOT_SIZE(7, 6), 7, 6 },
+	{ SLOT_SIZE(4, 4), 4, 4 },
 #endif /* PAGE_SIZE */
 };
 
@@ -150,13 +177,11 @@ static const struct block_desc block_des
  * struct block_list - stores metadata of particular list
  * lock:		protects the list of blocks
  * active_list:		linked list of active (non-full) blocks
- * full_list:		linked list of full blocks
  * block_count:		total number of blocks in the list
  */
 struct block_list {
 	spinlock_t lock;
 	struct list_head active_list;
-	struct list_head full_list;
 	unsigned long block_count;
 };
 
@@ -170,6 +195,7 @@ struct block_list {
  */
 struct zblock_pool {
 	struct block_list block_lists[ARRAY_SIZE(block_desc)];
+	struct kmem_cache *block_header_cache;
 	struct zpool *zpool;
 };
 
_

Patches currently in -mm which might be from igor.b@beldev.am are

mm-add-zblock-allocator.patch

