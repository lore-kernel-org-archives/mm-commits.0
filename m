From: akpm@linux-foundation.org
Subject: + lib-genallocc-add-support-for-specifying-the-physical-address-v2.patch added to -mm tree
Date: Wed, 20 Apr 2011 16:14:16 -0700
Message-ID: <201104202314.p3KNEGfV000708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752292Ab1DTXOY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Apr 2011 19:14:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: plagnioj@jcrosoft.com, jes@wildopensource.com, nicolas.ferre@atmel.com, patrice.vilchez@atmel.com


The patch titled
     lib-genallocc-add-support-for-specifying-the-physical-address-v2
has been added to the -mm tree.  Its filename is
     lib-genallocc-add-support-for-specifying-the-physical-address-v2.patch

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
Subject: lib-genallocc-add-support-for-specifying-the-physical-address-v2
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

	update documentation
	use phys_addr_t for physical addr

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Patrice VILCHEZ <patrice.vilchez@atmel.com>
Cc: Jes Sorensen <jes@wildopensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genalloc.h |   10 ++++++----
 lib/genalloc.c           |   12 ++++++++----
 2 files changed, 14 insertions(+), 8 deletions(-)

diff -puN include/linux/genalloc.h~lib-genallocc-add-support-for-specifying-the-physical-address-v2 include/linux/genalloc.h
--- a/include/linux/genalloc.h~lib-genallocc-add-support-for-specifying-the-physical-address-v2
+++ a/include/linux/genalloc.h
@@ -26,15 +26,15 @@ struct gen_pool {
 struct gen_pool_chunk {
 	spinlock_t lock;
 	struct list_head next_chunk;	/* next chunk in pool */
-	unsigned long phys_addr;	/* physical starting address of memory chunk */
+	phys_addr_t phys_addr;		/* physical starting address of memory chunk */
 	unsigned long start_addr;	/* starting address of memory chunk */
 	unsigned long end_addr;		/* ending address of memory chunk */
 	unsigned long bits[0];		/* bitmap for allocating memory chunk */
 };
 
 extern struct gen_pool *gen_pool_create(int, int);
-extern unsigned long gen_pool_virt_to_phys(struct gen_pool *pool, unsigned long);
-extern int gen_pool_add_virt(struct gen_pool *, unsigned long, unsigned long,
+extern phys_addr_t gen_pool_virt_to_phys(struct gen_pool *pool, unsigned long);
+extern int gen_pool_add_virt(struct gen_pool *, unsigned long, phys_addr_t,
 			     size_t, int);
 /**
  * gen_pool_add - add a new chunk of special memory to the pool
@@ -45,11 +45,13 @@ extern int gen_pool_add_virt(struct gen_
  *       allocated on, or -1
  *
  * Add a new chunk of special memory to the specified pool.
+ *
+ * Returns 0 on success or a -ve errno on failure.
  */
 static inline int gen_pool_add(struct gen_pool *pool, unsigned long addr,
 			       size_t size, int nid)
 {
-	return gen_pool_add_virt(pool, addr, 0, size, nid);
+	return gen_pool_add_virt(pool, addr, -1, size, nid);
 }
 extern void gen_pool_destroy(struct gen_pool *);
 extern unsigned long gen_pool_alloc(struct gen_pool *, size_t);
diff -puN lib/genalloc.c~lib-genallocc-add-support-for-specifying-the-physical-address-v2 lib/genalloc.c
--- a/lib/genalloc.c~lib-genallocc-add-support-for-specifying-the-physical-address-v2
+++ a/lib/genalloc.c
@@ -48,8 +48,10 @@ EXPORT_SYMBOL(gen_pool_create);
  *       allocated on, or -1
  *
  * Add a new chunk of special memory to the specified pool.
+ *
+ * Returns 0 on success or a -ve errno on failure.
  */
-int gen_pool_add_virt(struct gen_pool *pool, unsigned long virt, unsigned long phys,
+int gen_pool_add_virt(struct gen_pool *pool, unsigned long virt, phys_addr_t phys,
 		 size_t size, int nid)
 {
 	struct gen_pool_chunk *chunk;
@@ -59,7 +61,7 @@ int gen_pool_add_virt(struct gen_pool *p
 
 	chunk = kmalloc_node(nbytes, GFP_KERNEL | __GFP_ZERO, nid);
 	if (unlikely(chunk == NULL))
-		return -1;
+		return -ENOMEM;
 
 	spin_lock_init(&chunk->lock);
 	chunk->phys_addr = phys;
@@ -78,8 +80,10 @@ EXPORT_SYMBOL(gen_pool_add_virt);
  * gen_pool_virt_to_phys - return the physical address of memory
  * @pool: pool to allocate from
  * @addr: starting address of memory
+ *
+ * Returns the physical address on success, or -1 on error.
  */
-unsigned long gen_pool_virt_to_phys(struct gen_pool *pool, unsigned long addr)
+phys_addr_t gen_pool_virt_to_phys(struct gen_pool *pool, unsigned long addr)
 {
 	struct list_head *_chunk;
 	struct gen_pool_chunk *chunk;
@@ -93,7 +97,7 @@ unsigned long gen_pool_virt_to_phys(stru
 	}
 	read_unlock(&pool->lock);
 
-	return ~0UL;
+	return -1;
 }
 EXPORT_SYMBOL(gen_pool_virt_to_phys);
 
_

Patches currently in -mm which might be from plagnioj@jcrosoft.com are

bluetooth-fix-build-warnings-on-defconfigs.patch
include-linux-genalloch-add-multiple-inclusion-guards.patch
lib-genallocc-add-support-for-specifying-the-physical-address.patch
lib-genallocc-add-support-for-specifying-the-physical-address-v2.patch
lib-genpoolc-document-return-values-fix-gen_pool_add_virt-return-value.patch

