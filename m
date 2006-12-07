From: akpm@osdl.org
Subject: - add-noaliencache-boot-option-to-disable-numa-alien-caches.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:56:43 -0800
Message-ID: <200612072256.kB7Muh3p029222@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50536 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163567AbWLGW5A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:57:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, clameter@engr.sgi.com, manfred@colorfullife.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     mm: add noaliencache boot option to disable numa alien caches
has been removed from the -mm tree.  Its filename was
     add-noaliencache-boot-option-to-disable-numa-alien-caches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: add noaliencache boot option to disable numa alien caches
From: Paul Menage <menage@google.com>

When using numa=fake on non-NUMA hardware there is no benefit to haveing the
alien caches, and they consume much memory.

Add a kernel boot option to disable them.

Christoph sayeth "This is good to have even on large NUMA.  The problem is
that the alien caches grow by the square of the size of the system in terms of
nodes."

Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/kernel-parameters.txt |    4 ++
 mm/slab.c                           |   38 +++++++++++++++++++-------
 2 files changed, 33 insertions(+), 9 deletions(-)

diff -puN Documentation/kernel-parameters.txt~add-noaliencache-boot-option-to-disable-numa-alien-caches Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~add-noaliencache-boot-option-to-disable-numa-alien-caches
+++ a/Documentation/kernel-parameters.txt
@@ -1012,6 +1012,10 @@ and is between 256 and 4096 characters. 
 			emulation library even if a 387 maths coprocessor
 			is present.
 
+	noaliencache	[MM, NUMA] Disables the allcoation of alien caches in
+			the slab allocator.  Saves per-node memory, but will
+			impact performance on real NUMA hardware.
+
 	noalign		[KNL,ARM]
 
 	noapic		[SMP,APIC] Tells the kernel to not make use of any
diff -puN mm/slab.c~add-noaliencache-boot-option-to-disable-numa-alien-caches mm/slab.c
--- a/mm/slab.c~add-noaliencache-boot-option-to-disable-numa-alien-caches
+++ a/mm/slab.c
@@ -869,6 +869,22 @@ static void __slab_error(const char *fun
 	dump_stack();
 }
 
+/*
+ * By default on NUMA we use alien caches to stage the freeing of
+ * objects allocated from other nodes. This causes massive memory
+ * inefficiencies when using fake NUMA setup to split memory into a
+ * large number of small nodes, so it can be disabled on the command
+ * line
+  */
+
+static int use_alien_caches __read_mostly = 1;
+static int __init noaliencache_setup(char *s)
+{
+	use_alien_caches = 0;
+	return 1;
+}
+__setup("noaliencache", noaliencache_setup);
+
 #ifdef CONFIG_NUMA
 /*
  * Special reaping functions for NUMA systems called from cache_reap().
@@ -1117,7 +1133,7 @@ static inline int cache_free_alien(struc
 	 * Make sure we are not freeing a object from another node to the array
 	 * cache on this cpu.
 	 */
-	if (likely(slabp->nodeid == node))
+	if (likely(slabp->nodeid == node) || unlikely(!use_alien_caches))
 		return 0;
 
 	l3 = cachep->nodelists[node];
@@ -1195,7 +1211,7 @@ static int __cpuinit cpuup_callback(stru
 		list_for_each_entry(cachep, &cache_chain, next) {
 			struct array_cache *nc;
 			struct array_cache *shared;
-			struct array_cache **alien;
+			struct array_cache **alien = NULL;
 
 			nc = alloc_arraycache(node, cachep->limit,
 						cachep->batchcount);
@@ -1207,9 +1223,11 @@ static int __cpuinit cpuup_callback(stru
 			if (!shared)
 				goto bad;
 
-			alien = alloc_alien_cache(node, cachep->limit);
-			if (!alien)
-				goto bad;
+			if (use_alien_caches) {
+                                alien = alloc_alien_cache(node, cachep->limit);
+                                if (!alien)
+                                        goto bad;
+                        }
 			cachep->array[cpu] = nc;
 			l3 = cachep->nodelists[node];
 			BUG_ON(!l3);
@@ -3590,13 +3608,15 @@ static int alloc_kmemlist(struct kmem_ca
 	int node;
 	struct kmem_list3 *l3;
 	struct array_cache *new_shared;
-	struct array_cache **new_alien;
+	struct array_cache **new_alien = NULL;
 
 	for_each_online_node(node) {
 
-		new_alien = alloc_alien_cache(node, cachep->limit);
-		if (!new_alien)
-			goto fail;
+                if (use_alien_caches) {
+                        new_alien = alloc_alien_cache(node, cachep->limit);
+                        if (!new_alien)
+                                goto fail;
+                }
 
 		new_shared = alloc_arraycache(node,
 				cachep->shared*cachep->batchcount,
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
mm-fallback_alloc-cpuset_zone_allowed-irq-fix.patch

