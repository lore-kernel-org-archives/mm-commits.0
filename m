From: akpm@linux-foundation.org
Subject: [merged]
 slab-change-int-to-size_t-for-representing-allocation-size.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:03:21 -0700
Message-ID: <53e3db89.CdsmUEvkqKPUTD2a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:59999 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaHGUDW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:03:22 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so1175442pab.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:03:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, akpm@linux-foundation.org, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: change int to size_t for representing allocation size
has been removed from the -mm tree.  Its filename was
     slab-change-int-to-size_t-for-representing-allocation-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: slab: change int to size_t for representing allocation size

It is better to represent allocation size in size_t rather than int.
So change it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/slab.c~slab-change-int-to-size_t-for-representing-allocation-size mm/slab.c
--- a/mm/slab.c~slab-change-int-to-size_t-for-representing-allocation-size
+++ a/mm/slab.c
@@ -681,7 +681,7 @@ static void init_arraycache(struct array
 static struct array_cache *alloc_arraycache(int node, int entries,
 					    int batchcount, gfp_t gfp)
 {
-	int memsize = sizeof(void *) * entries + sizeof(struct array_cache);
+	size_t memsize = sizeof(void *) * entries + sizeof(struct array_cache);
 	struct array_cache *ac = NULL;
 
 	ac = kmalloc_node(memsize, gfp, node);
@@ -868,7 +868,7 @@ static void *alternate_node_alloc(struct
 static struct alien_cache *__alloc_alien_cache(int node, int entries,
 						int batch, gfp_t gfp)
 {
-	int memsize = sizeof(void *) * entries + sizeof(struct alien_cache);
+	size_t memsize = sizeof(void *) * entries + sizeof(struct alien_cache);
 	struct alien_cache *alc = NULL;
 
 	alc = kmalloc_node(memsize, gfp, node);
@@ -880,7 +880,7 @@ static struct alien_cache *__alloc_alien
 static struct alien_cache **alloc_alien_cache(int node, int limit, gfp_t gfp)
 {
 	struct alien_cache **alc_ptr;
-	int memsize = sizeof(void *) * nr_node_ids;
+	size_t memsize = sizeof(void *) * nr_node_ids;
 	int i;
 
 	if (limit > 1)
@@ -1037,7 +1037,7 @@ static int init_cache_node_node(int node
 {
 	struct kmem_cache *cachep;
 	struct kmem_cache_node *n;
-	const int memsize = sizeof(struct kmem_cache_node);
+	const size_t memsize = sizeof(struct kmem_cache_node);
 
 	list_for_each_entry(cachep, &slab_caches, list) {
 		/*
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
page-owners-correct-page-order-when-to-free-page.patch

