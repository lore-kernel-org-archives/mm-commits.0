From: akpm@linux-foundation.org
Subject: [merged] slub-use-new-node-functions.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:02:53 -0700
Message-ID: <53e3db6d.OEB7JnA6AF6qeOa+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:42345 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138AbaHGUCy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:02:54 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so842690oac.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:02:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: use new node functions
has been removed from the -mm tree.  Its filename was
     slub-use-new-node-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: slub: use new node functions

Make use of the new node functions in mm/slab.h to reduce code size and
simplify.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   78 +++++++++++++++++++---------------------------------
 1 file changed, 29 insertions(+), 49 deletions(-)

diff -puN mm/slub.c~slub-use-new-node-functions mm/slub.c
--- a/mm/slub.c~slub-use-new-node-functions
+++ a/mm/slub.c
@@ -2157,6 +2157,7 @@ slab_out_of_memory(struct kmem_cache *s,
 	static DEFINE_RATELIMIT_STATE(slub_oom_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
 	int node;
+	struct kmem_cache_node *n;
 
 	if ((gfpflags & __GFP_NOWARN) || !__ratelimit(&slub_oom_rs))
 		return;
@@ -2171,15 +2172,11 @@ slab_out_of_memory(struct kmem_cache *s,
 		pr_warn("  %s debugging increased min order, use slub_debug=O to disable.\n",
 			s->name);
 
-	for_each_online_node(node) {
-		struct kmem_cache_node *n = get_node(s, node);
+	for_each_kmem_cache_node(s, node, n) {
 		unsigned long nr_slabs;
 		unsigned long nr_objs;
 		unsigned long nr_free;
 
-		if (!n)
-			continue;
-
 		nr_free  = count_partial(n, count_free);
 		nr_slabs = node_nr_slabs(n);
 		nr_objs  = node_nr_objs(n);
@@ -2923,13 +2920,10 @@ static void early_kmem_cache_node_alloc(
 static void free_kmem_cache_nodes(struct kmem_cache *s)
 {
 	int node;
+	struct kmem_cache_node *n;
 
-	for_each_node_state(node, N_NORMAL_MEMORY) {
-		struct kmem_cache_node *n = s->node[node];
-
-		if (n)
-			kmem_cache_free(kmem_cache_node, n);
-
+	for_each_kmem_cache_node(s, node, n) {
+		kmem_cache_free(kmem_cache_node, n);
 		s->node[node] = NULL;
 	}
 }
@@ -3217,12 +3211,11 @@ static void free_partial(struct kmem_cac
 static inline int kmem_cache_close(struct kmem_cache *s)
 {
 	int node;
+	struct kmem_cache_node *n;
 
 	flush_all(s);
 	/* Attempt to free all objects */
-	for_each_node_state(node, N_NORMAL_MEMORY) {
-		struct kmem_cache_node *n = get_node(s, node);
-
+	for_each_kmem_cache_node(s, node, n) {
 		free_partial(s, n);
 		if (n->nr_partial || slabs_node(s, node))
 			return 1;
@@ -3407,9 +3400,7 @@ int __kmem_cache_shrink(struct kmem_cach
 		return -ENOMEM;
 
 	flush_all(s);
-	for_each_node_state(node, N_NORMAL_MEMORY) {
-		n = get_node(s, node);
-
+	for_each_kmem_cache_node(s, node, n) {
 		if (!n->nr_partial)
 			continue;
 
@@ -3581,6 +3572,7 @@ static struct kmem_cache * __init bootst
 {
 	int node;
 	struct kmem_cache *s = kmem_cache_zalloc(kmem_cache, GFP_NOWAIT);
+	struct kmem_cache_node *n;
 
 	memcpy(s, static_cache, kmem_cache->object_size);
 
@@ -3590,19 +3582,16 @@ static struct kmem_cache * __init bootst
 	 * IPIs around.
 	 */
 	__flush_cpu_slab(s, smp_processor_id());
-	for_each_node_state(node, N_NORMAL_MEMORY) {
-		struct kmem_cache_node *n = get_node(s, node);
+	for_each_kmem_cache_node(s, node, n) {
 		struct page *p;
 
-		if (n) {
-			list_for_each_entry(p, &n->partial, lru)
-				p->slab_cache = s;
+		list_for_each_entry(p, &n->partial, lru)
+			p->slab_cache = s;
 
 #ifdef CONFIG_SLUB_DEBUG
-			list_for_each_entry(p, &n->full, lru)
-				p->slab_cache = s;
+		list_for_each_entry(p, &n->full, lru)
+			p->slab_cache = s;
 #endif
-		}
 	}
 	list_add(&s->list, &slab_caches);
 	return s;
@@ -3955,16 +3944,14 @@ static long validate_slab_cache(struct k
 	unsigned long count = 0;
 	unsigned long *map = kmalloc(BITS_TO_LONGS(oo_objects(s->max)) *
 				sizeof(unsigned long), GFP_KERNEL);
+	struct kmem_cache_node *n;
 
 	if (!map)
 		return -ENOMEM;
 
 	flush_all(s);
-	for_each_node_state(node, N_NORMAL_MEMORY) {
-		struct kmem_cache_node *n = get_node(s, node);
-
+	for_each_kmem_cache_node(s, node, n)
 		count += validate_slab_node(s, n, map);
-	}
 	kfree(map);
 	return count;
 }
@@ -4118,6 +4105,7 @@ static int list_locations(struct kmem_ca
 	int node;
 	unsigned long *map = kmalloc(BITS_TO_LONGS(oo_objects(s->max)) *
 				     sizeof(unsigned long), GFP_KERNEL);
+	struct kmem_cache_node *n;
 
 	if (!map || !alloc_loc_track(&t, PAGE_SIZE / sizeof(struct location),
 				     GFP_TEMPORARY)) {
@@ -4127,8 +4115,7 @@ static int list_locations(struct kmem_ca
 	/* Push back cpu slabs */
 	flush_all(s);
 
-	for_each_node_state(node, N_NORMAL_MEMORY) {
-		struct kmem_cache_node *n = get_node(s, node);
+	for_each_kmem_cache_node(s, node, n) {
 		unsigned long flags;
 		struct page *page;
 
@@ -4327,8 +4314,9 @@ static ssize_t show_slab_objects(struct
 	get_online_mems();
 #ifdef CONFIG_SLUB_DEBUG
 	if (flags & SO_ALL) {
-		for_each_node_state(node, N_NORMAL_MEMORY) {
-			struct kmem_cache_node *n = get_node(s, node);
+		struct kmem_cache_node *n;
+
+		for_each_kmem_cache_node(s, node, n) {
 
 			if (flags & SO_TOTAL)
 				x = atomic_long_read(&n->total_objects);
@@ -4344,9 +4332,9 @@ static ssize_t show_slab_objects(struct
 	} else
 #endif
 	if (flags & SO_PARTIAL) {
-		for_each_node_state(node, N_NORMAL_MEMORY) {
-			struct kmem_cache_node *n = get_node(s, node);
+		struct kmem_cache_node *n;
 
+		for_each_kmem_cache_node(s, node, n) {
 			if (flags & SO_TOTAL)
 				x = count_partial(n, count_total);
 			else if (flags & SO_OBJECTS)
@@ -4359,7 +4347,7 @@ static ssize_t show_slab_objects(struct
 	}
 	x = sprintf(buf, "%lu", total);
 #ifdef CONFIG_NUMA
-	for_each_node_state(node, N_NORMAL_MEMORY)
+	for (node = 0; node < nr_node_ids; node++)
 		if (nodes[node])
 			x += sprintf(buf + x, " N%d=%lu",
 					node, nodes[node]);
@@ -4373,16 +4361,12 @@ static ssize_t show_slab_objects(struct
 static int any_slab_objects(struct kmem_cache *s)
 {
 	int node;
+	struct kmem_cache_node *n;
 
-	for_each_online_node(node) {
-		struct kmem_cache_node *n = get_node(s, node);
-
-		if (!n)
-			continue;
-
+	for_each_kmem_cache_node(s, node, n)
 		if (atomic_long_read(&n->total_objects))
 			return 1;
-	}
+
 	return 0;
 }
 #endif
@@ -5337,13 +5321,9 @@ void get_slabinfo(struct kmem_cache *s,
 	unsigned long nr_objs = 0;
 	unsigned long nr_free = 0;
 	int node;
+	struct kmem_cache_node *n;
 
-	for_each_online_node(node) {
-		struct kmem_cache_node *n = get_node(s, node);
-
-		if (!n)
-			continue;
