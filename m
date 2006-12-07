From: akpm@osdl.org
Subject: - remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:57:47 -0800
Message-ID: <200612072257.kB7Mvl2r029322@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50661 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163623AbWLGW5t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:57:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Remove uses of kmem_cache_t from mm/* and include/linux/slab.h
has been removed from the -mm tree.  Its filename was
     remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove uses of kmem_cache_t from mm/* and include/linux/slab.h
From: Christoph Lameter <clameter@sgi.com>

Remove all uses of kmem_cache_t (the most were left in slab.h).  The
typedef for kmem_cache_t is then only necessary for other kernel
subsystems.  Add a comment to that effect.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/slab.h |   33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff -puN include/linux/slab.h~remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh include/linux/slab.h
--- a/include/linux/slab.h~remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh
+++ a/include/linux/slab.h
@@ -9,6 +9,7 @@
 
 #if	defined(__KERNEL__)
 
+/* kmem_cache_t exists for legacy reasons and is not used by code in mm */
 typedef struct kmem_cache kmem_cache_t;
 
 #include	<linux/gfp.h>
@@ -57,22 +58,23 @@ typedef struct kmem_cache kmem_cache_t;
 /* prototypes */
 extern void __init kmem_cache_init(void);
 
-extern kmem_cache_t *kmem_cache_create(const char *, size_t, size_t, unsigned long,
-				       void (*)(void *, kmem_cache_t *, unsigned long),
-				       void (*)(void *, kmem_cache_t *, unsigned long));
-extern void kmem_cache_destroy(kmem_cache_t *);
-extern int kmem_cache_shrink(kmem_cache_t *);
-extern void *kmem_cache_alloc(kmem_cache_t *, gfp_t);
+extern struct kmem_cache *kmem_cache_create(const char *, size_t, size_t,
+			unsigned long,
+			void (*)(void *, struct kmem_cache *, unsigned long),
+			void (*)(void *, struct kmem_cache *, unsigned long));
+extern void kmem_cache_destroy(struct kmem_cache *);
+extern int kmem_cache_shrink(struct kmem_cache *);
+extern void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
 extern void *kmem_cache_zalloc(struct kmem_cache *, gfp_t);
-extern void kmem_cache_free(kmem_cache_t *, void *);
-extern unsigned int kmem_cache_size(kmem_cache_t *);
-extern const char *kmem_cache_name(kmem_cache_t *);
+extern void kmem_cache_free(struct kmem_cache *, void *);
+extern unsigned int kmem_cache_size(struct kmem_cache *);
+extern const char *kmem_cache_name(struct kmem_cache *);
 
 /* Size description struct for general caches. */
 struct cache_sizes {
-	size_t		 cs_size;
-	kmem_cache_t	*cs_cachep;
-	kmem_cache_t	*cs_dmacachep;
+	size_t		 	cs_size;
+	struct kmem_cache	*cs_cachep;
+	struct kmem_cache	*cs_dmacachep;
 };
 extern struct cache_sizes malloc_sizes[];
 
@@ -211,7 +213,7 @@ extern unsigned int ksize(const void *);
 extern int slab_is_available(void);
 
 #ifdef CONFIG_NUMA
-extern void *kmem_cache_alloc_node(kmem_cache_t *, gfp_t flags, int node);
+extern void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
 extern void *__kmalloc_node(size_t size, gfp_t flags, int node);
 
 static inline void *kmalloc_node(size_t size, gfp_t flags, int node)
@@ -255,7 +257,8 @@ extern void *__kmalloc_node_track_caller
 			__builtin_return_address(0))
 #endif
 #else /* CONFIG_NUMA */
-static inline void *kmem_cache_alloc_node(kmem_cache_t *cachep, gfp_t flags, int node)
+static inline void *kmem_cache_alloc_node(struct kmem_cache *cachep,
+					gfp_t flags, int node)
 {
 	return kmem_cache_alloc(cachep, flags);
 }
@@ -269,7 +272,7 @@ static inline void *kmalloc_node(size_t 
 #endif
 
 extern int FASTCALL(kmem_cache_reap(int));
-extern int FASTCALL(kmem_ptr_validate(kmem_cache_t *cachep, void *ptr));
+extern int FASTCALL(kmem_ptr_validate(struct kmem_cache *cachep, void *ptr));
 
 #else /* CONFIG_SLOB */
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
workstruct-implement-generic-up-cmpxchg-where-an-arch-doesnt-support-it.patch
ia64-resolve-name-clash-by-renaming-is_available_memory.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
introduce-config_zone_dma.patch
optional-zone_dma-in-the-vm.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs.patch
optional-zone_dma-for-ia64.patch
remove-zone_dma-remains-from-parisc.patch
remove-zone_dma-remains-from-sh-sh64.patch
set-config_zone_dma-for-arches-with-generic_isa_dma.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
sched-domain-move-sched-group-allocations-to-percpu-area.patch
sched-avoid-taking-rq-lock-in-wake_priority_sleeper.patch
sched-remove-staggering-of-load-balancing.patch
sched-disable-interrupts-for-locking-in-load_balance.patch
sched-extract-load-calculation-from-rebalance_tick.patch
sched-move-idle-status-calculation-into-rebalance_tick.patch
sched-use-softirq-for-load-balancing.patch
sched-call-tasklet-less-frequently.patch
sched-add-option-to-serialize-load-balancing.patch
sched-add-option-to-serialize-load-balancing-fix.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch

