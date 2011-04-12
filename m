From: akpm@linux-foundation.org
Subject: + lib-genallocc-add-support-for-specifying-the-physical-address.patch added to -mm tree
Date: Tue, 12 Apr 2011 15:38:08 -0700
Message-ID: <201104122238.p3CMc8J5006974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753503Ab1DLWim (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Apr 2011 18:38:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: plagnioj@jcrosoft.com, jes@wildopensource.com, nicolas.ferre@atmel.com, patrice.vilchez@atmel.com


The patch titled
     lib/genalloc.c: add support for specifying the physical address
has been added to the -mm tree.  Its filename is
     lib-genallocc-add-support-for-specifying-the-physical-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/genalloc.c: add support for specifying the physical address
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

So we can specify the virtual address as the base of the pool chunk and
then get physical addresses for hardware IP.

For example on at91 we will use this on spi, uart or macb

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Patrice VILCHEZ <patrice.vilchez@atmel.com>
Cc: Jes Sorensen <jes@wildopensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genalloc.h |   20 ++++++++++++++++++
 lib/genalloc.c           |   39 ++++++++++++++++++++++++++++++-------
 2 files changed, 51 insertions(+), 8 deletions(-)

diff -puN include/linux/genalloc.h~lib-genallocc-add-support-for-specifying-the-physical-address include/linux/genalloc.h
--- a/include/linux/genalloc.h~lib-genallocc-add-support-for-specifying-the-physical-address
+++ a/include/linux/genalloc.h
@@ -26,13 +26,31 @@ struct gen_pool {
 struct gen_pool_chunk {
 	spinlock_t lock;
 	struct list_head next_chunk;	/* next chunk in pool */
+	unsigned long phys_addr;	/* physical starting address of memory chunk */
 	unsigned long start_addr;	/* starting address of memory chunk */
 	unsigned long end_addr;		/* ending address of memory chunk */
 	unsigned long bits[0];		/* bitmap for allocating memory chunk */
 };
 
 extern struct gen_pool *gen_pool_create(int, int);
-extern int gen_pool_add(struct gen_pool *, unsigned long, size_t, int);
+extern unsigned long gen_pool_virt_to_phys(struct gen_pool *pool, unsigned long);
+extern int gen_pool_add_virt(struct gen_pool *, unsigned long, unsigned long,
+			     size_t, int);
+/**
+ * gen_pool_add - add a new chunk of special memory to the pool
+ * @pool: pool to add new memory chunk to
+ * @addr: starting address of memory chunk to add to pool
+ * @size: size in bytes of the memory chunk to add to pool
+ * @nid: node id of the node the chunk structure and bitmap should be
+ *       allocated on, or -1
+ *
+ * Add a new chunk of special memory to the specified pool.
+ */
+static inline int gen_pool_add(struct gen_pool *pool, unsigned long addr,
+			       size_t size, int nid)
+{
+	return gen_pool_add_virt(pool, addr, 0, size, nid);
+}
 extern void gen_pool_destroy(struct gen_pool *);
 extern unsigned long gen_pool_alloc(struct gen_pool *, size_t);
 extern void gen_pool_free(struct gen_pool *, unsigned long, size_t);
diff -puN lib/genalloc.c~lib-genallocc-add-support-for-specifying-the-physical-address lib/genalloc.c
--- a/lib/genalloc.c~lib-genallocc-add-support-for-specifying-the-physical-address
+++ a/lib/genalloc.c
@@ -39,17 +39,18 @@ struct gen_pool *gen_pool_create(int min
 EXPORT_SYMBOL(gen_pool_create);
 
 /**
- * gen_pool_add - add a new chunk of special memory to the pool
+ * gen_pool_add_virt - add a new chunk of special memory to the pool
  * @pool: pool to add new memory chunk to
- * @addr: starting address of memory chunk to add to pool
+ * @virt: virtual starting address of memory chunk to add to pool
+ * @phys: physical starting address of memory chunk to add to pool
  * @size: size in bytes of the memory chunk to add to pool
  * @nid: node id of the node the chunk structure and bitmap should be
  *       allocated on, or -1
  *
  * Add a new chunk of special memory to the specified pool.
  */
-int gen_pool_add(struct gen_pool *pool, unsigned long addr, size_t size,
-		 int nid)
+int gen_pool_add_virt(struct gen_pool *pool, unsigned long virt, unsigned long phys,
+		 size_t size, int nid)
 {
 	struct gen_pool_chunk *chunk;
 	int nbits = size >> pool->min_alloc_order;
@@ -61,8 +62,9 @@ int gen_pool_add(struct gen_pool *pool, 
 		return -1;
 
 	spin_lock_init(&chunk->lock);
-	chunk->start_addr = addr;
-	chunk->end_addr = addr + size;
+	chunk->phys_addr = phys;
+	chunk->start_addr = virt;
+	chunk->end_addr = virt + size;
 
 	write_lock(&pool->lock);
 	list_add(&chunk->next_chunk, &pool->chunks);
@@ -70,7 +72,30 @@ int gen_pool_add(struct gen_pool *pool, 
 
 	return 0;
 }
-EXPORT_SYMBOL(gen_pool_add);
+EXPORT_SYMBOL(gen_pool_add_virt);
+
+/**
+ * gen_pool_virt_to_phys - return the physical address of memory
+ * @pool: pool to allocate from
+ * @addr: starting address of memory
+ */
+unsigned long gen_pool_virt_to_phys(struct gen_pool *pool, unsigned long addr)
+{
+	struct list_head *_chunk;
+	struct gen_pool_chunk *chunk;
+
+	read_lock(&pool->lock);
+	list_for_each(_chunk, &pool->chunks) {
+		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
+
+		if (addr >= chunk->start_addr && addr < chunk->end_addr)
+			return chunk->phys_addr + addr - chunk->start_addr;
+	}
+	read_unlock(&pool->lock);
+
+	return ~0UL;
+}
+EXPORT_SYMBOL(gen_pool_virt_to_phys);
 
 /**
  * gen_pool_destroy - destroy a special memory pool
_

Patches currently in -mm which might be from plagnioj@jcrosoft.com are

linux-next.patch
bluetooth-fix-build-warnings-on-defconfigs.patch
include-linux-genalloch-add-multiple-inclusion-guards.patch
lib-genallocc-add-support-for-specifying-the-physical-address.patch
lib-genpoolc-document-return-values-fix-gen_pool_add_virt-return-value.patch

