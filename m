From: akpm@linux-foundation.org
Subject: [merged] mm-slab-remove-useless-structure-define.patch removed
 from -mm tree
Date: Wed, 16 Mar 2016 12:54:08 -0700
Message-ID: <56e9b9e0.53P8U5aa9hP0QOys%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbcCPTyJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:54:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: remove useless structure define
has been removed from the -mm tree.  Its filename was
     mm-slab-remove-useless-structure-define.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: remove useless structure define

It is obsolete so remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff -puN mm/slab.c~mm-slab-remove-useless-structure-define mm/slab.c
--- a/mm/slab.c~mm-slab-remove-useless-structure-define
+++ a/mm/slab.c
@@ -225,16 +225,6 @@ static inline void clear_obj_pfmemalloc(
 }
 
 /*
- * bootstrap: The caches do not work without cpuarrays anymore, but the
- * cpuarrays are allocated from the generic caches...
- */
-#define BOOT_CPUCACHE_ENTRIES	1
-struct arraycache_init {
-	struct array_cache cache;
-	void *entries[BOOT_CPUCACHE_ENTRIES];
-};
-
-/*
  * Need this for bootstrapping a per node allocator.
  */
 #define NUM_INIT_LISTS (2 * MAX_NUMNODES)
@@ -457,6 +447,7 @@ static inline unsigned int obj_to_index(
 	return reciprocal_divide(offset, cache->reciprocal_buffer_size);
 }
 
+#define BOOT_CPUCACHE_ENTRIES	1
 /* internal cache of cache description objs */
 static struct kmem_cache kmem_cache_boot = {
 	.batchcount = 1,
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-vmalloc-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting-v2.patch
sound-query-dynamic-debug_pagealloc-setting.patch
powerpc-query-dynamic-debug_pagealloc-setting.patch
tile-query-dynamic-debug_pagealloc-setting.patch
mm-introduce-page-reference-manipulation-functions.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3.patch

