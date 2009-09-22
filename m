From: akpm@linux-foundation.org
Subject: [merged] mm-remove-broken-kzalloc-mempool.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:41:36 -0700
Message-ID: <200909222041.n8MKfaKF007909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752637AbZIVUls (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:41:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sage@newdream.net, mm-commits@vger.kernel.org


The patch titled
     mm: remove broken 'kzalloc' mempool
has been removed from the -mm tree.  Its filename was
     mm-remove-broken-kzalloc-mempool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove broken 'kzalloc' mempool
From: Sage Weil <sage@newdream.net>

The kzalloc mempool zeros items when they are initially allocated, but
does not rezero used items that are returned to the pool.  Consequently
mempool_alloc()s may return non-zeroed memory.

Since there are/were only two in-tree users for
mempool_create_kzalloc_pool(), and 'fixing' this in a way that will
re-zero used (but not new) items before first use is non-trivial, just
remove it.

Signed-off-by: Sage Weil <sage@newdream.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempool.h |   10 ++--------
 mm/mempool.c            |    7 -------
 2 files changed, 2 insertions(+), 15 deletions(-)

diff -puN include/linux/mempool.h~mm-remove-broken-kzalloc-mempool include/linux/mempool.h
--- a/include/linux/mempool.h~mm-remove-broken-kzalloc-mempool
+++ a/include/linux/mempool.h
@@ -47,22 +47,16 @@ mempool_create_slab_pool(int min_nr, str
 }
 
 /*
- * 2 mempool_alloc_t's and a mempool_free_t to kmalloc/kzalloc and kfree
- * the amount of memory specified by pool_data
+ * a mempool_alloc_t and a mempool_free_t to kmalloc and kfree the
+ * amount of memory specified by pool_data
  */
 void *mempool_kmalloc(gfp_t gfp_mask, void *pool_data);
-void *mempool_kzalloc(gfp_t gfp_mask, void *pool_data);
 void mempool_kfree(void *element, void *pool_data);
 static inline mempool_t *mempool_create_kmalloc_pool(int min_nr, size_t size)
 {
 	return mempool_create(min_nr, mempool_kmalloc, mempool_kfree,
 			      (void *) size);
 }
-static inline mempool_t *mempool_create_kzalloc_pool(int min_nr, size_t size)
-{
-	return mempool_create(min_nr, mempool_kzalloc, mempool_kfree,
-			      (void *) size);
-}
 
 /*
  * A mempool_alloc_t and mempool_free_t for a simple page allocator that
diff -puN mm/mempool.c~mm-remove-broken-kzalloc-mempool mm/mempool.c
--- a/mm/mempool.c~mm-remove-broken-kzalloc-mempool
+++ a/mm/mempool.c
@@ -308,13 +308,6 @@ void *mempool_kmalloc(gfp_t gfp_mask, vo
 }
 EXPORT_SYMBOL(mempool_kmalloc);
 
-void *mempool_kzalloc(gfp_t gfp_mask, void *pool_data)
-{
-	size_t size = (size_t)pool_data;
-	return kzalloc(size, gfp_mask);
-}
-EXPORT_SYMBOL(mempool_kzalloc);
