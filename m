Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E74C7EE2D
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 23:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjBZXtF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 18:49:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjBZXtA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 18:49:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A553CA23
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 15:48:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27688B80CA3
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 23:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D558AC433EF;
        Sun, 26 Feb 2023 23:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677455331;
        bh=nCy14ruUm3rflp/5AStZbKVCu6AsG63Dwdh/6uBrZZk=;
        h=Date:To:From:Subject:From;
        b=TpiRS2wXbCyh8kDYqTSJd05tnUbYUov9K/Snkkc5wv+slJvW6ESiVvl0vuK55faIJ
         ubTlqAQ34HCnuzCNsAJNmUPT5SzWhWYeB/oDldmPYY8xskI5sgdAhau8qAn/iNfRrQ
         yVh/WQ9ttNcJyxxlH0CH5/P2A5reBumaxN4jkVZo=
Date:   Sun, 26 Feb 2023 15:48:51 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tonyb@cybernetics.com, hch@lst.de, bryan.odonoghue@linaro.org,
        kbusch@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dmapool-link-blocks-across-pages.patch removed from -mm tree
Message-Id: <20230226234851.D558AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: dmapool: link blocks across pages
has been removed from the -mm tree.  Its filename was
     dmapool-link-blocks-across-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Keith Busch <kbusch@kernel.org>
Subject: dmapool: link blocks across pages
Date: Thu, 26 Jan 2023 13:51:24 -0800

The allocated dmapool pages are never freed for the lifetime of the pool. 
There is no need for the two level list+stack lookup for finding a free
block since nothing is ever removed from the list.  Just use a simple
stack, reducing time complexity to constant.

The implementation inserts the stack linking elements and the dma handle
of the block within itself when freed.  This means the smallest possible
dmapool block is increased to at most 16 bytes to accommodate these
fields, but there are no exisiting users requesting a dma pool smaller
than that anyway.

Removing the list has a significant change in performance. Using the
kernel's micro-benchmarking self test:

Before:

  # modprobe dmapool_test
  dmapool test: size:16   blocks:8192   time:57282
  dmapool test: size:64   blocks:8192   time:172562
  dmapool test: size:256  blocks:8192   time:789247
  dmapool test: size:1024 blocks:2048   time:371823
  dmapool test: size:4096 blocks:1024   time:362237

After:

  # modprobe dmapool_test
  dmapool test: size:16   blocks:8192   time:24997
  dmapool test: size:64   blocks:8192   time:26584
  dmapool test: size:256  blocks:8192   time:33542
  dmapool test: size:1024 blocks:2048   time:9022
  dmapool test: size:4096 blocks:1024   time:6045

The module test allocates quite a few blocks that may not accurately
represent how these pools are used in real life.  For a more marco level
benchmark, running fio high-depth + high-batched on nvme, this patch shows
submission and completion latency reduced by ~100usec each, 1% IOPs
improvement, and perf record's time spent in dma_pool_alloc/free were
reduced by half.

Link: https://lkml.kernel.org/r/20230126215125.4069751-12-kbusch@meta.com
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Tony Battersby <tonyb@cybernetics.com>
[kbusch@kernel.org: push new blocks in ascending order]
  Link: https://lkml.kernel.org/r/20230221165400.1595247-1-kbusch@meta.com
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/dmapool.c~dmapool-link-blocks-across-pages
+++ a/mm/dmapool.c
@@ -15,7 +15,7 @@
  * represented by the 'struct dma_pool' which keeps a doubly-linked list of
  * allocated pages.  Each page in the page_list is split into blocks of at
  * least 'size' bytes.  Free blocks are tracked in an unsorted singly-linked
- * list of free blocks within the page.  Used blocks aren't tracked, but we
+ * list of free blocks across all pages.  Used blocks aren't tracked, but we
  * keep a count of how many are currently allocated from each page.
  */
 
@@ -40,9 +40,18 @@
 #define DMAPOOL_DEBUG 1
 #endif
 
+struct dma_block {
+	struct dma_block *next_block;
+	dma_addr_t dma;
+};
+
 struct dma_pool {		/* the pool */
 	struct list_head page_list;
 	spinlock_t lock;
+	struct dma_block *next_block;
+	size_t nr_blocks;
+	size_t nr_active;
+	size_t nr_pages;
 	struct device *dev;
 	unsigned int size;
 	unsigned int allocation;
@@ -55,8 +64,6 @@ struct dma_page {		/* cacheable header f
 	struct list_head page_list;
 	void *vaddr;
 	dma_addr_t dma;
-	unsigned int in_use;
-	unsigned int offset;
 };
 
 static DEFINE_MUTEX(pools_lock);
@@ -64,30 +71,18 @@ static DEFINE_MUTEX(pools_reg_lock);
 
 static ssize_t pools_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	int size;
-	struct dma_page *page;
 	struct dma_pool *pool;
+	unsigned size;
 
 	size = sysfs_emit(buf, "poolinfo - 0.1\n");
 
 	mutex_lock(&pools_lock);
 	list_for_each_entry(pool, &dev->dma_pools, pools) {
-		unsigned pages = 0;
-		size_t blocks = 0;
-
-		spin_lock_irq(&pool->lock);
-		list_for_each_entry(page, &pool->page_list, page_list) {
-			pages++;
-			blocks += page->in_use;
-		}
-		spin_unlock_irq(&pool->lock);
-
 		/* per-pool info, no real statistics yet */
-		size += sysfs_emit_at(buf, size, "%-16s %4zu %4zu %4u %2u\n",
-				      pool->name, blocks,
-				      (size_t) pages *
-				      (pool->allocation / pool->size),
-				      pool->size, pages);
+		size += sysfs_emit_at(buf, size, "%-16s %4zu %4zu %4u %2zu\n",
+				      pool->name, pool->nr_active,
+				      pool->nr_blocks, pool->size,
+				      pool->nr_pages);
 	}
 	mutex_unlock(&pools_lock);
 
@@ -97,17 +92,17 @@ static ssize_t pools_show(struct device
 static DEVICE_ATTR_RO(pools);
 
 #ifdef DMAPOOL_DEBUG
-static void pool_check_block(struct dma_pool *pool, void *retval,
-			     unsigned int offset, gfp_t mem_flags)
+static void pool_check_block(struct dma_pool *pool, struct dma_block *block,
+			     gfp_t mem_flags)
 {
+	u8 *data = (void *)block;
 	int i;
-	u8 *data = retval;
-	/* page->offset is stored in first 4 bytes */
-	for (i = sizeof(offset); i < pool->size; i++) {
+
+	for (i = sizeof(struct dma_block); i < pool->size; i++) {
 		if (data[i] == POOL_POISON_FREED)
 			continue;
-		dev_err(pool->dev, "%s %s, %p (corrupted)\n",
-			__func__, pool->name, retval);
+		dev_err(pool->dev, "%s %s, %p (corrupted)\n", __func__,
+			pool->name, block);
 
 		/*
 		 * Dump the first 4 bytes even if they are not
@@ -117,31 +112,46 @@ static void pool_check_block(struct dma_
 				data, pool->size, 1);
 		break;
 	}
+
 	if (!want_init_on_alloc(mem_flags))
-		memset(retval, POOL_POISON_ALLOCATED, pool->size);
+		memset(block, POOL_POISON_ALLOCATED, pool->size);
 }
 
-static bool pool_page_err(struct dma_pool *pool, struct dma_page *page,
-			  void *vaddr, dma_addr_t dma)
+static struct dma_page *pool_find_page(struct dma_pool *pool, dma_addr_t dma)
 {
-	unsigned int offset = vaddr - page->vaddr;
-	unsigned int chain = page->offset;
+	struct dma_page *page;
 
-	if ((dma - page->dma) != offset) {
-		dev_err(pool->dev, "%s %s, %p (bad vaddr)/%pad\n",
+	list_for_each_entry(page, &pool->page_list, page_list) {
+		if (dma < page->dma)
+			continue;
+		if ((dma - page->dma) < pool->allocation)
+			return page;
+	}
+	return NULL;
+}
+
+static bool pool_block_err(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
+{
+	struct dma_block *block = pool->next_block;
+	struct dma_page *page;
+
+	page = pool_find_page(pool, dma);
+	if (!page) {
+		dev_err(pool->dev, "%s %s, %p/%pad (bad dma)\n",
 			__func__, pool->name, vaddr, &dma);
 		return true;
 	}
 
-	while (chain < pool->allocation) {
-		if (chain != offset) {
-			chain = *(int *)(page->vaddr + chain);
+	while (block) {
+		if (block != vaddr) {
+			block = block->next_block;
 			continue;
 		}
 		dev_err(pool->dev, "%s %s, dma %pad already free\n",
 			__func__, pool->name, &dma);
 		return true;
 	}
+
 	memset(vaddr, POOL_POISON_FREED, pool->size);
 	return false;
 }
@@ -151,14 +161,12 @@ static void pool_init_page(struct dma_po
 	memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
 }
 #else
-static void pool_check_block(struct dma_pool *pool, void *retval,
-			     unsigned int offset, gfp_t mem_flags)
-
+static void pool_check_block(struct dma_pool *pool, struct dma_block *block,
+			     gfp_t mem_flags)
 {
 }
 
-static bool pool_page_err(struct dma_pool *pool, struct dma_page *page,
-			  void *vaddr, dma_addr_t dma)
+static bool pool_block_err(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
 {
 	if (want_init_on_free())
 		memset(vaddr, 0, pool->size);
@@ -170,6 +178,26 @@ static void pool_init_page(struct dma_po
 }
 #endif
 
+static struct dma_block *pool_block_pop(struct dma_pool *pool)
+{
+	struct dma_block *block = pool->next_block;
+
+	if (block) {
+		pool->next_block = block->next_block;
+		pool->nr_active++;
+	}
+	return block;
+}
+
+static void pool_block_push(struct dma_pool *pool, struct dma_block *block,
+			    dma_addr_t dma)
+{
+	block->dma = dma;
+	block->next_block = pool->next_block;
+	pool->next_block = block;
+}
+
+
 /**
  * dma_pool_create - Creates a pool of consistent memory blocks, for dma.
  * @name: name of pool, for diagnostics
@@ -210,8 +238,8 @@ struct dma_pool *dma_pool_create(const c
 
 	if (size == 0 || size > INT_MAX)
 		return NULL;
-	else if (size < 4)
-		size = 4;
+	if (size < sizeof(struct dma_block))
+		size = sizeof(struct dma_block);
 
 	size = ALIGN(size, align);
 	allocation = max_t(size_t, size, PAGE_SIZE);
@@ -223,7 +251,7 @@ struct dma_pool *dma_pool_create(const c
 
 	boundary = min(boundary, allocation);
 
-	retval = kmalloc(sizeof(*retval), GFP_KERNEL);
+	retval = kzalloc(sizeof(*retval), GFP_KERNEL);
 	if (!retval)
 		return retval;
 
@@ -236,7 +264,6 @@ struct dma_pool *dma_pool_create(const c
 	retval->size = size;
 	retval->boundary = boundary;
 	retval->allocation = allocation;
-
 	INIT_LIST_HEAD(&retval->pools);
 
 	/*
@@ -273,21 +300,36 @@ EXPORT_SYMBOL(dma_pool_create);
 
 static void pool_initialise_page(struct dma_pool *pool, struct dma_page *page)
 {
-	unsigned int offset = 0;
-	unsigned int next_boundary = pool->boundary;
+	unsigned int next_boundary = pool->boundary, offset = 0;
+	struct dma_block *block, *first = NULL, *last = NULL;
 
 	pool_init_page(pool, page);
-	page->in_use = 0;
-	page->offset = 0;
-	do {
-		unsigned int next = offset + pool->size;
-		if (unlikely((next + pool->size) >= next_boundary)) {
-			next = next_boundary;
+	while (offset + pool->size <= pool->allocation) {
+		if (offset + pool->size > next_boundary) {
+			offset = next_boundary;
 			next_boundary += pool->boundary;
+			continue;
 		}
-		*(int *)(page->vaddr + offset) = next;
-		offset = next;
-	} while (offset < pool->allocation);
+
+		block = page->vaddr + offset;
+		block->dma = page->dma + offset;
+		block->next_block = NULL;
+
+		if (last)
+			last->next_block = block;
+		else
+			first = block;
+		last = block;
+
+		offset += pool->size;
+		pool->nr_blocks++;
+	}
+
+	last->next_block = pool->next_block;
+	pool->next_block = first;
+
+	list_add(&page->page_list, &pool->page_list);
+	pool->nr_pages++;
 }
 
 static struct dma_page *pool_alloc_page(struct dma_pool *pool, gfp_t mem_flags)
@@ -305,15 +347,9 @@ static struct dma_page *pool_alloc_page(
 		return NULL;
 	}
 
-	pool_initialise_page(pool, page);
 	return page;
 }
 
-static inline bool is_page_busy(struct dma_page *page)
-{
-	return page->in_use != 0;
-}
-
 /**
  * dma_pool_destroy - destroys a pool of dma memory blocks.
  * @pool: dma pool that will be destroyed
@@ -325,7 +361,7 @@ static inline bool is_page_busy(struct d
 void dma_pool_destroy(struct dma_pool *pool)
 {
 	struct dma_page *page, *tmp;
-	bool empty = false;
+	bool empty = false, busy = false;
 
 	if (unlikely(!pool))
 		return;
@@ -340,13 +376,15 @@ void dma_pool_destroy(struct dma_pool *p
 		device_remove_file(pool->dev, &dev_attr_pools);
 	mutex_unlock(&pools_reg_lock);
 
+	if (pool->nr_active) {
+		dev_err(pool->dev, "%s %s busy\n", __func__, pool->name);
+		busy = true;
+	}
+
 	list_for_each_entry_safe(page, tmp, &pool->page_list, page_list) {
-		if (!is_page_busy(page))
+		if (!busy)
 			dma_free_coherent(pool->dev, pool->allocation,
 					  page->vaddr, page->dma);
-		else
-			dev_err(pool->dev, "%s %s, %p busy\n", __func__,
-				pool->name, page->vaddr);
 		list_del(&page->page_list);
 		kfree(page);
 	}
@@ -368,58 +406,40 @@ EXPORT_SYMBOL(dma_pool_destroy);
 void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
 		     dma_addr_t *handle)
 {
-	unsigned long flags;
+	struct dma_block *block;
 	struct dma_page *page;
-	unsigned int offset;
-	void *retval;
+	unsigned long flags;
 
 	might_alloc(mem_flags);
 
 	spin_lock_irqsave(&pool->lock, flags);
-	list_for_each_entry(page, &pool->page_list, page_list) {
-		if (page->offset < pool->allocation)
-			goto ready;
-	}
-
-	/* pool_alloc_page() might sleep, so temporarily drop &pool->lock */
-	spin_unlock_irqrestore(&pool->lock, flags);
-
-	page = pool_alloc_page(pool, mem_flags & (~__GFP_ZERO));
-	if (!page)
-		return NULL;
+	block = pool_block_pop(pool);
+	if (!block) {
+		/*
+		 * pool_alloc_page() might sleep, so temporarily drop
+		 * &pool->lock
+		 */
+		spin_unlock_irqrestore(&pool->lock, flags);
 
-	spin_lock_irqsave(&pool->lock, flags);
+		page = pool_alloc_page(pool, mem_flags & (~__GFP_ZERO));
+		if (!page)
+			return NULL;
 
-	list_add(&page->page_list, &pool->page_list);
- ready:
-	page->in_use++;
-	offset = page->offset;
-	page->offset = *(int *)(page->vaddr + offset);
-	retval = offset + page->vaddr;
-	*handle = offset + page->dma;
-	pool_check_block(pool, retval, offset, mem_flags);
+		spin_lock_irqsave(&pool->lock, flags);
+		pool_initialise_page(pool, page);
+		block = pool_block_pop(pool);
+	}
 	spin_unlock_irqrestore(&pool->lock, flags);
 
+	*handle = block->dma;
+	pool_check_block(pool, block, mem_flags);
 	if (want_init_on_alloc(mem_flags))
-		memset(retval, 0, pool->size);
+		memset(block, 0, pool->size);
 
-	return retval;
+	return block;
 }
 EXPORT_SYMBOL(dma_pool_alloc);
 
-static struct dma_page *pool_find_page(struct dma_pool *pool, dma_addr_t dma)
-{
-	struct dma_page *page;
-
-	list_for_each_entry(page, &pool->page_list, page_list) {
-		if (dma < page->dma)
-			continue;
-		if ((dma - page->dma) < pool->allocation)
-			return page;
-	}
-	return NULL;
-}
-
 /**
  * dma_pool_free - put block back into dma pool
  * @pool: the dma pool holding the block
@@ -431,31 +451,14 @@ static struct dma_page *pool_find_page(s
  */
 void dma_pool_free(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
 {
-	struct dma_page *page;
+	struct dma_block *block = vaddr;
 	unsigned long flags;
 
 	spin_lock_irqsave(&pool->lock, flags);
-	page = pool_find_page(pool, dma);
-	if (!page) {
-		spin_unlock_irqrestore(&pool->lock, flags);
-		dev_err(pool->dev, "%s %s, %p/%pad (bad dma)\n",
-			__func__, pool->name, vaddr, &dma);
-		return;
-	}
-
-	if (pool_page_err(pool, page, vaddr, dma)) {
-		spin_unlock_irqrestore(&pool->lock, flags);
-		return;
+	if (!pool_block_err(pool, vaddr, dma)) {
+		pool_block_push(pool, block, dma);
+		pool->nr_active--;
 	}
-
-	page->in_use--;
-	*(int *)vaddr = page->offset;
-	page->offset = vaddr - page->vaddr;
-	/*
-	 * Resist a temptation to do
-	 *    if (!is_page_busy(page)) pool_free_page(pool, page);
-	 * Better have a few empty pages hang around.
-	 */
 	spin_unlock_irqrestore(&pool->lock, flags);
 }
 EXPORT_SYMBOL(dma_pool_free);
_

Patches currently in -mm which might be from kbusch@kernel.org are


