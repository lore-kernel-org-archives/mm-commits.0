From: akpm@linux-foundation.org
Subject: [merged]
 genalloc-fix-overflow-of-ending-address-of-memory-chunk.patch removed from
 -mm tree
Date: Thu, 12 Sep 2013 12:43:43 -0700
Message-ID: <5232196f.AsMxhzvCd+hFirKi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab3ILTnn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:43:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jy0922.shim@samsung.com

Subject: [merged] genalloc-fix-overflow-of-ending-address-of-memory-chunk.patch removed from -mm tree
To: jy0922.shim@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:43:43 -0700


The patch titled
     Subject: lib/genalloc.c: fix overflow of ending address of memory chunk
has been removed from the -mm tree.  Its filename was
     genalloc-fix-overflow-of-ending-address-of-memory-chunk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: lib/genalloc.c: fix overflow of ending address of memory chunk

In struct gen_pool_chunk, end_addr means the end address of memory chunk
(inclusive), but in the implementation it is treated as address + size of
memory chunk (exclusive), so it points to the address plus one instead of
correct ending address.

The ending address of memory chunk plus one will cause overflow on the
memory chunk including the last address of memory map, e.g.  when starting
address is 0xFFF00000 and size is 0x100000 on 32bit machine, ending
address will be 0x100000000.

Use correct ending address like starting address + size - 1.

[akpm@linux-foundation.org: add comment to struct gen_pool_chunk:end_addr]
Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genalloc.h |    4 ++--
 lib/genalloc.c           |   19 ++++++++++++-------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff -puN include/linux/genalloc.h~genalloc-fix-overflow-of-ending-address-of-memory-chunk include/linux/genalloc.h
--- a/include/linux/genalloc.h~genalloc-fix-overflow-of-ending-address-of-memory-chunk
+++ a/include/linux/genalloc.h
@@ -66,8 +66,8 @@ struct gen_pool_chunk {
 	struct list_head next_chunk;	/* next chunk in pool */
 	atomic_t avail;
 	phys_addr_t phys_addr;		/* physical starting address of memory chunk */
-	unsigned long start_addr;	/* starting address of memory chunk */
-	unsigned long end_addr;		/* ending address of memory chunk */
+	unsigned long start_addr;	/* start address of memory chunk */
+	unsigned long end_addr;		/* end address of memory chunk (inclusive) */
 	unsigned long bits[0];		/* bitmap for allocating memory chunk */
 };
 
diff -puN lib/genalloc.c~genalloc-fix-overflow-of-ending-address-of-memory-chunk lib/genalloc.c
--- a/lib/genalloc.c~genalloc-fix-overflow-of-ending-address-of-memory-chunk
+++ a/lib/genalloc.c
@@ -37,6 +37,11 @@
 #include <linux/of_address.h>
 #include <linux/of_device.h>
 
+static inline size_t chunk_size(const struct gen_pool_chunk *chunk)
+{
+	return chunk->end_addr - chunk->start_addr + 1;
+}
+
 static int set_bits_ll(unsigned long *addr, unsigned long mask_to_set)
 {
 	unsigned long val, nval;
@@ -188,7 +193,7 @@ int gen_pool_add_virt(struct gen_pool *p
 
 	chunk->phys_addr = phys;
 	chunk->start_addr = virt;
-	chunk->end_addr = virt + size;
+	chunk->end_addr = virt + size - 1;
 	atomic_set(&chunk->avail, size);
 
 	spin_lock(&pool->lock);
@@ -213,7 +218,7 @@ phys_addr_t gen_pool_virt_to_phys(struct
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(chunk, &pool->chunks, next_chunk) {
-		if (addr >= chunk->start_addr && addr < chunk->end_addr) {
+		if (addr >= chunk->start_addr && addr <= chunk->end_addr) {
 			paddr = chunk->phys_addr + (addr - chunk->start_addr);
 			break;
 		}
@@ -242,7 +247,7 @@ void gen_pool_destroy(struct gen_pool *p
 		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
 		list_del(&chunk->next_chunk);
 
-		end_bit = (chunk->end_addr - chunk->start_addr) >> order;
+		end_bit = chunk_size(chunk) >> order;
 		bit = find_next_bit(chunk->bits, end_bit, 0);
 		BUG_ON(bit < end_bit);
 
@@ -283,7 +288,7 @@ unsigned long gen_pool_alloc(struct gen_
 		if (size > atomic_read(&chunk->avail))
 			continue;
 
-		end_bit = (chunk->end_addr - chunk->start_addr) >> order;
+		end_bit = chunk_size(chunk) >> order;
 retry:
 		start_bit = pool->algo(chunk->bits, end_bit, start_bit, nbits,
 				pool->data);
@@ -330,8 +335,8 @@ void gen_pool_free(struct gen_pool *pool
 	nbits = (size + (1UL << order) - 1) >> order;
 	rcu_read_lock();
 	list_for_each_entry_rcu(chunk, &pool->chunks, next_chunk) {
-		if (addr >= chunk->start_addr && addr < chunk->end_addr) {
-			BUG_ON(addr + size > chunk->end_addr);
+		if (addr >= chunk->start_addr && addr <= chunk->end_addr) {
+			BUG_ON(addr + size - 1 > chunk->end_addr);
 			start_bit = (addr - chunk->start_addr) >> order;
 			remain = bitmap_clear_ll(chunk->bits, start_bit, nbits);
 			BUG_ON(remain);
@@ -400,7 +405,7 @@ size_t gen_pool_size(struct gen_pool *po
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(chunk, &pool->chunks, next_chunk)
-		size += chunk->end_addr - chunk->start_addr;
+		size += chunk_size(chunk);
 	rcu_read_unlock();
 	return size;
 }
_

Patches currently in -mm which might be from jy0922.shim@samsung.com are

origin.patch

