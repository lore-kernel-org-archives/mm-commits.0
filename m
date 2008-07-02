From: akpm@linux-foundation.org
Subject: - revert-git-pekka.patch removed from -mm tree
Date: Tue, 01 Jul 2008 23:09:42 -0700
Message-ID: <200807020609.m6269gUQ002028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752941AbYGBGJ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 02:09:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, clameter@sgi.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     revert-git-pekka
has been removed from the -mm tree.  Its filename was
     revert-git-pekka.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert-git-pekka
From: Andrew Morton <akpm@linux-foundation.org>

This was premature and ignored all the pending 2.6.27 MM work.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   12 
 Documentation/vm/slabinfo.c |   86 -------
 fs/drop_caches.c            |    2 
 include/linux/mm.h          |    3 
 include/linux/mmzone.h      |    1 
 include/linux/slab.h        |   53 ----
 include/linux/slub_def.h    |   16 -
 include/linux/swap.h        |    3 
 kernel/sysctl.c             |   20 -
 mm/slub.c                   |  412 +++++-----------------------------
 mm/vmscan.c                 |   65 -----
 mm/vmstat.c                 |    2 
 12 files changed, 83 insertions(+), 592 deletions(-)

diff -puN Documentation/sysctl/vm.txt~revert-git-pekka Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~revert-git-pekka
+++ a/Documentation/sysctl/vm.txt
@@ -38,7 +38,6 @@ Currently, these files are in /proc/sys/
 - numa_zonelist_order
 - nr_hugepages
 - nr_overcommit_hugepages
-- slab_defrag_limit
 
 ==============================================================
 
@@ -348,14 +347,3 @@ Change the maximum size of the hugepage 
 nr_hugepages + nr_overcommit_hugepages.
 
 See Documentation/vm/hugetlbpage.txt
-
-==============================================================
-
-slab_defrag_limit
-
-Determines the frequency of calls from reclaim into slab defragmentation.
-Slab defrag reclaims objects from sparsely populates slab pages.
-The default is 1000. Increase if slab defragmentation occurs
-too frequently. Decrease if more slab defragmentation passes
-are needed. The slabinfo tool can report on the frequency of the callbacks.
-
diff -puN Documentation/vm/slabinfo.c~revert-git-pekka Documentation/vm/slabinfo.c
--- a/Documentation/vm/slabinfo.c~revert-git-pekka
+++ a/Documentation/vm/slabinfo.c
@@ -31,8 +31,6 @@ struct slabinfo {
 	int hwcache_align, object_size, objs_per_slab;
 	int sanity_checks, slab_size, store_user, trace;
 	int order, poison, reclaim_account, red_zone;
-	int defrag, ctor;
-	int defrag_ratio, remote_node_defrag_ratio;
 	unsigned long partial, objects, slabs, objects_partial, objects_total;
 	unsigned long alloc_fastpath, alloc_slowpath;
 	unsigned long free_fastpath, free_slowpath;
@@ -41,9 +39,6 @@ struct slabinfo {
 	unsigned long cpuslab_flush, deactivate_full, deactivate_empty;
 	unsigned long deactivate_to_head, deactivate_to_tail;
 	unsigned long deactivate_remote_frees, order_fallback;
-	unsigned long shrink_calls, shrink_attempt_defrag, shrink_empty_slab;
-	unsigned long shrink_slab_skipped, shrink_slab_reclaimed;
-	unsigned long shrink_object_reclaim_failed;
 	int numa[MAX_NODES];
 	int numa_partial[MAX_NODES];
 } slabinfo[MAX_SLABS];
@@ -69,8 +64,6 @@ int show_slab = 0;
 int skip_zero = 1;
 int show_numa = 0;
 int show_track = 0;
-int show_defrag = 0;
-int show_ctor = 0;
 int show_first_alias = 0;
 int validate = 0;
 int shrink = 0;
@@ -82,7 +75,6 @@ int sort_active = 0;
 int set_debug = 0;
 int show_ops = 0;
 int show_activity = 0;
-int show_defragcount = 0;
 
 /* Debug options */
 int sanity = 0;
@@ -302,11 +294,9 @@ void first_line(void)
 {
 	if (show_activity)
 		printf("Name                   Objects      Alloc       Free   %%Fast Fallb O\n");
-	else if (show_defragcount)
-		printf("Name                   Objects DefragRQ  Slabs Success   Empty Skipped  Failed\n");
 	else
 		printf("Name                   Objects Objsize    Space "
-			"Slabs/Part/Cpu  O/S O %%Ra %%Ef Flg\n");
+			"Slabs/Part/Cpu  O/S O %%Fr %%Ef Flg\n");
 }
 
 /*
@@ -355,7 +345,7 @@ void slab_numa(struct slabinfo *s, int m
 		return;
 
 	if (!line) {
-		printf("\n%-21s: Rto ", mode ? "NUMA nodes" : "Slab");
+		printf("\n%-21s:", mode ? "NUMA nodes" : "Slab");
 		for(node = 0; node <= highest_node; node++)
 			printf(" %4d", node);
 		printf("\n----------------------");
@@ -364,7 +354,6 @@ void slab_numa(struct slabinfo *s, int m
 		printf("\n");
 	}
 	printf("%-21s ", mode ? "All slabs" : s->name);
-	printf("%3d ", s->remote_node_defrag_ratio);
 	for(node = 0; node <= highest_node; node++) {
 		char b[20];
 
@@ -470,28 +459,22 @@ void slab_stats(struct slabinfo *s)
 
 	printf("Total                %8lu %8lu\n\n", total_alloc, total_free);
 
-	if (s->cpuslab_flush || s->alloc_refill)
-		printf("CPU Slab  : Flushes=%lu Refills=%lu\n",
-			s->cpuslab_flush, s->alloc_refill);
+	if (s->cpuslab_flush)
+		printf("Flushes %8lu\n", s->cpuslab_flush);
+
+	if (s->alloc_refill)
+		printf("Refill %8lu\n", s->alloc_refill);
 
 	total = s->deactivate_full + s->deactivate_empty +
 			s->deactivate_to_head + s->deactivate_to_tail;
 
 	if (total)
-		printf("Deactivate: Full=%lu(%lu%%) Empty=%lu(%lu%%) "
+		printf("Deactivate Full=%lu(%lu%%) Empty=%lu(%lu%%) "
 			"ToHead=%lu(%lu%%) ToTail=%lu(%lu%%)\n",
 			s->deactivate_full, (s->deactivate_full * 100) / total,
 			s->deactivate_empty, (s->deactivate_empty * 100) / total,
 			s->deactivate_to_head, (s->deactivate_to_head * 100) / total,
 			s->deactivate_to_tail, (s->deactivate_to_tail * 100) / total);
-
-	if (s->shrink_calls)
-		printf("Shrink    : Calls=%lu Attempts=%lu Empty=%lu Successful=%lu\n",
-			s->shrink_calls, s->shrink_attempt_defrag,
-			s->shrink_empty_slab, s->shrink_slab_reclaimed);
-	if (s->shrink_slab_skipped || s->shrink_object_reclaim_failed)
-		printf("Defrag    : Slabs skipped=%lu Object reclaim failed=%lu\n",
-		s->shrink_slab_skipped, s->shrink_object_reclaim_failed);
 }
 
 void report(struct slabinfo *s)
@@ -509,8 +492,6 @@ void report(struct slabinfo *s)
 		printf("** Slabs are destroyed via RCU\n");
 	if (s->reclaim_account)
 		printf("** Reclaim accounting active\n");
-	if (s->defrag)
-		printf("** Defragmentation at %d%%\n", s->defrag_ratio);
 
 	printf("\nSizes (bytes)     Slabs              Debug                Memory\n");
 	printf("------------------------------------------------------------------------\n");
@@ -558,12 +539,6 @@ void slabcache(struct slabinfo *s)
 	if (show_empty && s->slabs)
 		return;
 
-	if (show_defrag && !s->defrag)
-		return;
-
-	if (show_ctor && !s->ctor)
-		return;
-
 	store_size(size_str, slab_size(s));
 	snprintf(dist_str, 40, "%lu/%lu/%d", s->slabs - s->cpu_slabs,
 						s->partial, s->cpu_slabs);
@@ -575,10 +550,6 @@ void slabcache(struct slabinfo *s)
 		*p++ = '*';
 	if (s->cache_dma)
 		*p++ = 'd';
-	if (s->defrag)
-		*p++ = 'F';
-	if (s->ctor)
-		*p++ = 'C';
 	if (s->hwcache_align)
 		*p++ = 'A';
 	if (s->poison)
@@ -608,18 +579,12 @@ void slabcache(struct slabinfo *s)
 			total_alloc ? (s->alloc_fastpath * 100 / total_alloc) : 0,
 			total_free ? (s->free_fastpath * 100 / total_free) : 0,
 			s->order_fallback, s->order);
-	} else
-	if (show_defragcount)
-		printf("%-21s %8ld %7d %7d %7d %7d %7d %7d\n",
-			s->name, s->objects, s->shrink_calls, s->shrink_attempt_defrag,
-			s->shrink_slab_reclaimed, s->shrink_empty_slab,
-			s->shrink_slab_skipped, s->shrink_object_reclaim_failed);
+	}
 	else
 		printf("%-21s %8ld %7d %8s %14s %4d %1d %3ld %3ld %s\n",
 			s->name, s->objects, s->object_size, size_str, dist_str,
 			s->objs_per_slab, s->order,
-			s->slabs ? (s->partial * 100) /
-					(s->slabs * s->objs_per_slab) : 100,
+			s->slabs ? (s->partial * 100) / s->slabs : 100,
 			s->slabs ? (s->objects * s->object_size * 100) /
 				(s->slabs * (page_size << s->order)) : 100,
 			flags);
@@ -1225,24 +1190,7 @@ void read_slab_dir(void)
 			slab->deactivate_to_tail = get_obj("deactivate_to_tail");
 			slab->deactivate_remote_frees = get_obj("deactivate_remote_frees");
 			slab->order_fallback = get_obj("order_fallback");
-			slab->shrink_calls = get_obj("shrink_calls");
-			slab->shrink_attempt_defrag = get_obj("shrink_attempt_defrag");
-			slab->shrink_empty_slab = get_obj("shrink_empty_slab");
-			slab->shrink_slab_skipped = get_obj("shrink_slab_skipped");
-			slab->shrink_slab_reclaimed = get_obj("shrink_slab_reclaimed");
-			slab->shrink_object_reclaim_failed =
-					get_obj("shrink_object_reclaim_failed");
-			slab->defrag_ratio = get_obj("defrag_ratio");
-			slab->remote_node_defrag_ratio =
-					get_obj("remote_node_defrag_ratio");
 			chdir("..");
-			if (read_slab_obj(slab, "ops")) {
-				if (strstr(buffer, "ctor :"))
-					slab->ctor = 1;
-				if (strstr(buffer, "kick :"))
-					slab->defrag = 1;
-			}
-
 			if (slab->name[0] == ':')
 				alias_targets++;
 			slab++;
@@ -1293,13 +1241,10 @@ void output_slabs(void)
 struct option opts[] = {
 	{ "aliases", 0, NULL, 'a' },
 	{ "activity", 0, NULL, 'A' },
-	{ "ctor", 0, NULL, 'C' },
 	{ "debug", 2, NULL, 'd' },
 	{ "display-activity", 0, NULL, 'D' },
-	{ "display-defrag", 0, NULL, 'G' },
 	{ "empty", 0, NULL, 'e' },
 	{ "first-alias", 0, NULL, 'f' },
-	{ "defrag", 0, NULL, 'F' },
 	{ "help", 0, NULL, 'h' },
 	{ "inverted", 0, NULL, 'i'},
 	{ "numa", 0, NULL, 'n' },
@@ -1322,7 +1267,7 @@ int main(int argc, char *argv[])
 
 	page_size = getpagesize();
 
-	while ((c = getopt_long(argc, argv, "aACd::DefFGhil1noprstvzTS",
+	while ((c = getopt_long(argc, argv, "aAd::Defhil1noprstvzTS",
 						opts, NULL)) != -1)
 		switch (c) {
 		case '1':
@@ -1348,9 +1293,6 @@ int main(int argc, char *argv[])
 		case 'f':
 			show_first_alias = 1;
 			break;
-		case 'G':
-			show_defragcount = 1;
-			break;
 		case 'h':
 			usage();
 			return 0;
@@ -1381,12 +1323,6 @@ int main(int argc, char *argv[])
 		case 'z':
 			skip_zero = 0;
 			break;
-		case 'C':
-			show_ctor = 1;
-			break;
-		case 'F':
-			show_defrag = 1;
-			break;
 		case 'T':
 			show_totals = 1;
 			break;
diff -puN fs/drop_caches.c~revert-git-pekka fs/drop_caches.c
--- a/fs/drop_caches.c~revert-git-pekka
+++ a/fs/drop_caches.c
@@ -58,7 +58,7 @@ static void drop_slab(void)
 	int nr_objects;
 
 	do {
-		nr_objects = shrink_slab(1000, GFP_KERNEL, 1000, NULL);
+		nr_objects = shrink_slab(1000, GFP_KERNEL, 1000);
 	} while (nr_objects > 10);
 }
 
diff -puN include/linux/mm.h~revert-git-pekka include/linux/mm.h
--- a/include/linux/mm.h~revert-git-pekka
+++ a/include/linux/mm.h
@@ -1246,7 +1246,8 @@ int in_gate_area_no_task(unsigned long a
 int drop_caches_sysctl_handler(struct ctl_table *, int, struct file *,
 					void __user *, size_t *, loff_t *);
 unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
-				unsigned long lru_pages, struct zone *z);
+			unsigned long lru_pages);
+
 #ifndef CONFIG_MMU
 #define randomize_va_space 0
 #else
diff -puN include/linux/mmzone.h~revert-git-pekka include/linux/mmzone.h
--- a/include/linux/mmzone.h~revert-git-pekka
+++ a/include/linux/mmzone.h
@@ -256,7 +256,6 @@ struct zone {
 	unsigned long		nr_scan_active;
 	unsigned long		nr_scan_inactive;
 	unsigned long		pages_scanned;	   /* since last reclaim */
-	unsigned long		slab_defrag_counter; /* since last defrag */
 	unsigned long		flags;		   /* zone flags, see below */
 
 	/* Zone statistics */
diff -puN include/linux/slab.h~revert-git-pekka include/linux/slab.h
--- a/include/linux/slab.h~revert-git-pekka
+++ a/include/linux/slab.h
@@ -101,59 +101,6 @@ void kfree(const void *);
 size_t ksize(const void *);
 
 /*
- * Function prototypes passed to kmem_cache_defrag() to enable defragmentation
- * and targeted reclaim in slab caches.
- */
-
-/*
- * kmem_cache_defrag_get_func() is called with locks held so that the slab
- * objects cannot be freed. We are in an atomic context and no slab
- * operations may be performed. The purpose of kmem_cache_defrag_get_func()
- * is to obtain a stable refcount on the objects, so that they cannot be
- * removed until kmem_cache_kick_func() has handled them.
- *
- * Parameters passed are the number of objects to process and an array of
- * pointers to objects for which we need references.
- *
- * Returns a pointer that is passed to the kick function. If any objects
- * cannot be moved then the pointer may indicate a failure and
- * then kick can simply remove the references that were already obtained.
- *
- * The object pointer array passed is also passed to kmem_cache_defrag_kick().
- * The function may remove objects from the array by setting pointers to
- * NULL. This is useful if we can determine that an object is already about
- * to be removed. In that case it is often impossible to obtain the necessary
- * refcount.
- */
-typedef void *kmem_defrag_get_func(struct kmem_cache *, int, void **);
-
-/*
- * kmem_cache_defrag_kick_func is called with no locks held and interrupts
- * enabled. Sleeping is possible. Any operation may be performed in kick().
- * kmem_cache_defrag should free all the objects in the pointer array.
- *
- * Parameters passed are the number of objects in the array, the array of
- * pointers to the objects and the pointer returned by kmem_cache_defrag_get().
- *
- * Success is checked by examining the number of remaining objects in the slab.
- */
-typedef void kmem_defrag_kick_func(struct kmem_cache *, int, void **, void *);
-
-/*
- * kmem_cache_setup_defrag() is used to setup callbacks for a slab cache.
- * kmem_cache_defrag() performs the actual defragmentation.
- */
-#ifdef CONFIG_SLUB
-void kmem_cache_setup_defrag(struct kmem_cache *, kmem_defrag_get_func,
-						kmem_defrag_kick_func);
-int kmem_cache_defrag(int node);
-#else
-static inline void kmem_cache_setup_defrag(struct kmem_cache *s,
-	kmem_defrag_get_func get, kmem_defrag_kick_func kiok) {}
-static inline int kmem_cache_defrag(int node) { return 0; }
-#endif
-
-/*
  * Allocator specific definitions. These are mainly used to establish optimized
  * ways to convert kmalloc() calls to kmem_cache_alloc() invocations by
  * selecting the appropriate general cache at compile time.
diff -puN include/linux/slub_def.h~revert-git-pekka include/linux/slub_def.h
--- a/include/linux/slub_def.h~revert-git-pekka
+++ a/include/linux/slub_def.h
@@ -30,12 +30,6 @@ enum stat_item {
 	DEACTIVATE_TO_TAIL,	/* Cpu slab was moved to the tail of partials */
 	DEACTIVATE_REMOTE_FREES,/* Slab contained remotely freed objects */
 	ORDER_FALLBACK,		/* Number of times fallback was necessary */
-	SHRINK_CALLS,		/* Number of invocations of kmem_cache_shrink */
-	SHRINK_ATTEMPT_DEFRAG,	/* Slabs that were attempted to be reclaimed */
-	SHRINK_EMPTY_SLAB,	/* Shrink encountered and freed empty slab */
-	SHRINK_SLAB_SKIPPED,	/* Slab reclaim skipped an slab (busy etc) */
-	SHRINK_SLAB_RECLAIMED,	/* Successfully reclaimed slabs */
-	SHRINK_OBJECT_RECLAIM_FAILED, /* Callbacks signaled busy objects */
 	NR_SLUB_STAT_ITEMS };
 
 struct kmem_cache_cpu {
@@ -92,18 +86,8 @@ struct kmem_cache {
 	gfp_t allocflags;	/* gfp flags to use on each alloc */
 	int refcount;		/* Refcount for slab cache destroy */
 	void (*ctor)(struct kmem_cache *, void *);
-	kmem_defrag_get_func *get;
-	kmem_defrag_kick_func *kick;
-
 	int inuse;		/* Offset to metadata */
 	int align;		/* Alignment */
-	int defrag_ratio;	/*
-				 * Ratio used to check the percentage of
-				 * objects allocate in a slab page.
-				 * If less than this ratio is allocated
-				 * then reclaim attempts are made.
-				 */
-
 	const char *name;	/* Name (only for display!) */
 	struct list_head list;	/* List of slab caches */
 #ifdef CONFIG_SLUB_DEBUG
diff -puN include/linux/swap.h~revert-git-pekka include/linux/swap.h
--- a/include/linux/swap.h~revert-git-pekka
+++ a/include/linux/swap.h
@@ -188,9 +188,6 @@ extern unsigned long try_to_free_mem_cgr
 extern int __isolate_lru_page(struct page *page, int mode);
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
-extern int slab_defrag_limit;
-extern int slab_defrag_counter;
-
 extern int remove_mapping(struct address_space *mapping, struct page *page);
 extern long vm_total_pages;
 
diff -puN kernel/sysctl.c~revert-git-pekka kernel/sysctl.c
--- a/kernel/sysctl.c~revert-git-pekka
+++ a/kernel/sysctl.c
@@ -1047,26 +1047,6 @@ static struct ctl_table vm_table[] = {
 		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "slab_defrag_limit",
-		.data		= &slab_defrag_limit,
-		.maxlen		= sizeof(slab_defrag_limit),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-		.strategy	= &sysctl_intvec,
-		.extra1		= &one_hundred,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "slab_defrag_count",
-		.data		= &slab_defrag_counter,
-		.maxlen		= sizeof(slab_defrag_counter),
-		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
-		.strategy	= &sysctl_intvec,
-		.extra1		= &zero,
-	},
 #ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
 	{
 		.ctl_name	= VM_LEGACY_VA_LAYOUT,
diff -puN mm/slub.c~revert-git-pekka mm/slub.c
--- a/mm/slub.c~revert-git-pekka
+++ a/mm/slub.c
@@ -103,7 +103,6 @@
  */
 
 #define FROZEN (1 << PG_active)
-#define KICKABLE (1 << PG_dirty)
 
 #ifdef CONFIG_SLUB_DEBUG
 #define SLABDEBUG (1 << PG_error)
@@ -141,21 +140,6 @@ static inline void ClearSlabDebug(struct
 	page->flags &= ~SLABDEBUG;
 }
 
-static inline int SlabKickable(struct page *page)
-{
-	return page->flags & KICKABLE;
-}
-
-static inline void SetSlabKickable(struct page *page)
-{
-	page->flags |= KICKABLE;
-}
-
-static inline void ClearSlabKickable(struct page *page)
-{
-	page->flags &= ~KICKABLE;
-}
-
 /*
  * Issues still to be resolved:
  *
@@ -175,10 +159,10 @@ static inline void ClearSlabKickable(str
 
 /*
  * Maximum number of desirable partial slabs.
- * More slabs cause kmem_cache_shrink to sort the slabs by objects
- * and triggers slab defragmentation.
+ * The existence of more partial slabs makes kmem_cache_shrink
+ * sort the partial list by the number of objects in the.
  */
-#define MAX_PARTIAL 20
+#define MAX_PARTIAL 10
 
 #define DEBUG_DEFAULT_FLAGS (SLAB_DEBUG_FREE | SLAB_RED_ZONE | \
 				SLAB_POISON | SLAB_STORE_USER)
@@ -221,9 +205,6 @@ static enum {
 static DECLARE_RWSEM(slub_lock);
 static LIST_HEAD(slab_caches);
 
-/* Maximum objects in defragmentable slabs */
-static unsigned int max_defrag_slab_objects;
-
 /*
  * Tracking user of a slab.
  */
@@ -1179,9 +1160,6 @@ static struct page *new_slab(struct kmem
 			SLAB_STORE_USER | SLAB_TRACE))
 		SetSlabDebug(page);
 
-	if (s->kick)
-		SetSlabKickable(page);
-
 	start = page_address(page);
 
 	if (unlikely(s->flags & SLAB_POISON))
@@ -1222,7 +1200,6 @@ static void __free_slab(struct kmem_cach
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
 		-pages);
 
-	ClearSlabKickable(page);
 	__ClearPageSlab(page);
 	reset_page_mapcount(page);
 	__free_pages(page, order);
@@ -1432,8 +1409,6 @@ static void unfreeze_slab(struct kmem_ca
 			stat(c, DEACTIVATE_FULL);
 			if (SlabDebug(page) && (s->flags & SLAB_STORE_USER))
 				add_full(n, page);
-			if (s->kick)
-				SetSlabKickable(page);
 		}
 		slab_unlock(page);
 	} else {
@@ -2362,7 +2337,6 @@ static int kmem_cache_open(struct kmem_c
 		goto error;
 
 	s->refcount = 1;
-	s->defrag_ratio = 30;
 #ifdef CONFIG_NUMA
 	s->remote_node_defrag_ratio = 100;
 #endif
@@ -2569,7 +2543,7 @@ static struct kmem_cache *create_kmalloc
 								flags, NULL))
 		goto panic;
 
-	list_add_tail(&s->list, &slab_caches);
+	list_add(&s->list, &slab_caches);
 	up_write(&slub_lock);
 	if (sysfs_slab_add(s))
 		goto panic;
@@ -2791,7 +2765,6 @@ void kfree(const void *x)
 
 	page = virt_to_head_page(x);
 	if (unlikely(!PageSlab(page))) {
-		BUG_ON(!PageCompound(page));
 		put_page(page);
 		return;
 	}
@@ -2800,287 +2773,76 @@ void kfree(const void *x)
 EXPORT_SYMBOL(kfree);
 
 /*
- * Allocate a slab scratch space that is sufficient to keep at least
- * max_defrag_slab_objects pointers to individual objects and also a bitmap
- * for max_defrag_slab_objects.
- */
-static inline void *alloc_scratch(void)
-{
-	return kmalloc(max_defrag_slab_objects * sizeof(void *) +
-		BITS_TO_LONGS(max_defrag_slab_objects) * sizeof(unsigned long),
-		GFP_KERNEL);
-}
-
-void kmem_cache_setup_defrag(struct kmem_cache *s,
-	kmem_defrag_get_func get, kmem_defrag_kick_func kick)
-{
-	int max_objects = oo_objects(s->max);
-
-	/*
-	 * Defragmentable slabs must have a ctor otherwise objects may be
-	 * in an undetermined state after they are allocated.
-	 */
-	BUG_ON(!s->ctor);
-	s->get = get;
-	s->kick = kick;
-	down_write(&slub_lock);
-	list_move(&s->list, &slab_caches);
-	if (max_objects > max_defrag_slab_objects)
-		max_defrag_slab_objects = max_objects;
-	up_write(&slub_lock);
-}
-EXPORT_SYMBOL(kmem_cache_setup_defrag);
-
-/*
- * Vacate all objects in the given slab.
+ * kmem_cache_shrink removes empty slabs from the partial lists and sorts
+ * the remaining slabs by the number of items in use. The slabs with the
+ * most items in use come first. New allocations will then fill those up
+ * and thus they can be removed from the partial lists.
  *
- * The scratch aread passed to list function is sufficient to hold
- * struct listhead times objects per slab. We use it to hold void ** times
- * objects per slab plus a bitmap for each object.
+ * The slabs with the least items are placed last. This results in them
+ * being allocated from last increasing the chance that the last objects
+ * are freed in them.
  */
-static int kmem_cache_vacate(struct page *page, void *scratch)
-{
-	void **vector = scratch;
-	void *p;
-	void *addr = page_address(page);
-	struct kmem_cache *s;
-	unsigned long *map;
-	int leftover;
-	int count;
-	void *private;
-	unsigned long flags;
-	unsigned long objects;
-	struct kmem_cache_cpu *c;
-
-	local_irq_save(flags);
-	slab_lock(page);
-
-	BUG_ON(!PageSlab(page));	/* Must be s slab page */
-	BUG_ON(!SlabFrozen(page));	/* Slab must have been frozen earlier */
-
-	s = page->slab;
-	objects = page->objects;
-	map = scratch + objects * sizeof(void **);
-	if (!page->inuse || !s->kick || !SlabKickable(page)) {
-		c = get_cpu_slab(s, smp_processor_id());
-		stat(c, SHRINK_SLAB_SKIPPED);
-		goto out;
-	}
-
-	/* Determine used objects */
-	bitmap_fill(map, objects);
-	for_each_free_object(p, s, page->freelist)
-		__clear_bit(slab_index(p, s, addr), map);
-
-	/* Build vector of pointers to objects */
-	count = 0;
-	memset(vector, 0, objects * sizeof(void **));
-	for_each_object(p, s, addr, objects)
-		if (test_bit(slab_index(p, s, addr), map))
-			vector[count++] = p;
-
-	private = s->get(s, count, vector);
-
-	/*
-	 * Got references. Now we can drop the slab lock. The slab
-	 * is frozen so it cannot vanish from under us nor will
-	 * allocations be performed on the slab. However, unlocking the
-	 * slab will allow concurrent slab_frees to proceed.
-	 */
-	slab_unlock(page);
-	local_irq_restore(flags);
-
-	/*
-	 * Perform the KICK callbacks to remove the objects.
-	 */
-	s->kick(s, count, vector, private);
-
-	local_irq_save(flags);
-	slab_lock(page);
-out:
-	/*
-	 * Check the result and unfreeze the slab
-	 */
-	leftover = page->inuse;
-	c = get_cpu_slab(s, smp_processor_id());
-	if (leftover) {
-		/* Unsuccessful reclaim. Avoid future reclaim attempts. */
-		stat(c, SHRINK_OBJECT_RECLAIM_FAILED);
-		ClearSlabKickable(page);
-	} else
-		stat(c, SHRINK_SLAB_RECLAIMED);
-	unfreeze_slab(s, page, leftover > 0);
-	local_irq_restore(flags);
-	return leftover;
-}
-
-/*
- * Remove objects from a list of slab pages that have been gathered.
- * Must be called with slabs that have been isolated before.
- *
- * kmem_cache_reclaim() is never called from an atomic context. It
- * allocates memory for temporary storage. We are holding the
- * slub_lock semaphore which prevents another call into
- * the defrag logic.
- */
-int kmem_cache_reclaim(struct list_head *zaplist)
+int kmem_cache_shrink(struct kmem_cache *s)
 {
-	int freed = 0;
-	void **scratch;
+	int node;
+	int i;
+	struct kmem_cache_node *n;
 	struct page *page;
-	struct page *page2;
-
-	if (list_empty(zaplist))
-		return 0;
+	struct page *t;
+	int objects = oo_objects(s->max);
+	struct list_head *slabs_by_inuse =
+		kmalloc(sizeof(struct list_head) * objects, GFP_KERNEL);
+	unsigned long flags;
 
-	scratch = alloc_scratch();
-	if (!scratch)
-		return 0;
+	if (!slabs_by_inuse)
+		return -ENOMEM;
 
-	list_for_each_entry_safe(page, page2, zaplist, lru) {
-		list_del(&page->lru);
-		if (kmem_cache_vacate(page, scratch) == 0)
-			freed++;
-	}
-	kfree(scratch);
-	return freed;
-}
+	flush_all(s);
+	for_each_node_state(node, N_NORMAL_MEMORY) {
+		n = get_node(s, node);
 
-/*
- * Shrink the slab cache on a particular node of the cache
- * by releasing slabs with zero objects and trying to reclaim
- * slabs with less than the configured percentage of objects allocated.
- */
-static unsigned long __kmem_cache_shrink(struct kmem_cache *s, int node,
-							unsigned long limit)
-{
-	unsigned long flags;
-	struct page *page, *page2;
-	LIST_HEAD(zaplist);
-	int freed = 0;
-	struct kmem_cache_node *n = get_node(s, node);
-	struct kmem_cache_cpu *c;
+		if (!n->nr_partial)
+			continue;
 
-	if (n->nr_partial <= limit)
-		return 0;
+		for (i = 0; i < objects; i++)
+			INIT_LIST_HEAD(slabs_by_inuse + i);
 
-	spin_lock_irqsave(&n->list_lock, flags);
-	c = get_cpu_slab(s, smp_processor_id());
-	stat(c, SHRINK_CALLS);
-	list_for_each_entry_safe(page, page2, &n->partial, lru) {
-		if (!slab_trylock(page))
-			/* Busy slab. Get out of the way */
-			continue;
+		spin_lock_irqsave(&n->list_lock, flags);
 
-		if (page->inuse) {
-			if (!SlabKickable(page) || page->inuse * 100 >=
-					s->defrag_ratio * page->objects) {
-				slab_unlock(page);
+		/*
+		 * Build lists indexed by the items in use in each slab.
+		 *
+		 * Note that concurrent frees may occur while we hold the
+		 * list_lock. page->inuse here is the upper limit.
+		 */
+		list_for_each_entry_safe(page, t, &n->partial, lru) {
+			if (!page->inuse && slab_trylock(page)) {
 				/*
-				 * Slab contains enough objects
-				 * or we alrady tried reclaim before and
-				 * it failed. Skip this one.
+				 * Must hold slab lock here because slab_free
+				 * may have freed the last object and be
+				 * waiting to release the slab.
 				 */
-				continue;
-			}
-
-			list_move(&page->lru, &zaplist);
-			if (s->kick) {
-				stat(c, SHRINK_ATTEMPT_DEFRAG);
+				list_del(&page->lru);
 				n->nr_partial--;
-				SetSlabFrozen(page);
+				slab_unlock(page);
+				discard_slab(s, page);
+			} else {
+				list_move(&page->lru,
+				slabs_by_inuse + page->inuse);
 			}
-			slab_unlock(page);
-		} else {
-			/* Empty slab page */
-			stat(c, SHRINK_EMPTY_SLAB);
-			list_del(&page->lru);
-			n->nr_partial--;
-			slab_unlock(page);
-			discard_slab(s, page);
-			freed++;
 		}
-	}
-
-	if (!s->kick)
-		/*
-		 * No defrag methods. By simply putting the zaplist at the
-		 * end of the partial list we can let them simmer longer
-		 * and thus increase the chance of all objects being
-		 * reclaimed.
-		 *
-		 * We have effectively sorted the partial list and put
-		 * the slabs with more objects first. As soon as they
-		 * are allocated they are going to be removed from the
-		 * partial list.
-		 */
-		list_splice(&zaplist, n->partial.prev);
-
-
-	spin_unlock_irqrestore(&n->list_lock, flags);
-
-	if (s->kick)
-		freed += kmem_cache_reclaim(&zaplist);
-
-	return freed;
-}
-
-/*
- * Defrag slabs conditional on the amount of fragmentation in a page.
- */
-int kmem_cache_defrag(int node)
-{
-	struct kmem_cache *s;
-	unsigned long slabs = 0;
-
-	/*
-	 * kmem_cache_defrag may be called from the reclaim path which may be
-	 * called for any page allocator alloc. So there is the danger that we
-	 * get called in a situation where slub already acquired the slub_lock
-	 * for other purposes.
-	 */
-	if (!down_read_trylock(&slub_lock))
-		return 0;
-
-	list_for_each_entry(s, &slab_caches, list) {
-		unsigned long reclaimed;
 
 		/*
-		 * Defragmentable caches come first. If the slab cache is not
-		 * defragmentable then we can stop traversing the list.
+		 * Rebuild the partial list with the slabs filled up most
+		 * first and the least used slabs at the end.
 		 */
-		if (!s->kick)
-			break;
+		for (i = objects - 1; i >= 0; i--)
+			list_splice(slabs_by_inuse + i, n->partial.prev);
 
-		if (node == -1) {
-			int nid;
-
-			for_each_node_state(nid, N_NORMAL_MEMORY)
-				reclaimed = __kmem_cache_shrink(s, nid,
-								MAX_PARTIAL);
-		} else
-			reclaimed = __kmem_cache_shrink(s, node, MAX_PARTIAL);
-
-		slabs += reclaimed;
+		spin_unlock_irqrestore(&n->list_lock, flags);
 	}
-	up_read(&slub_lock);
-	return slabs;
-}
-EXPORT_SYMBOL(kmem_cache_defrag);
-
-/*
- * kmem_cache_shrink removes empty slabs from the partial lists.
- * If the slab cache supports defragmentation then objects are
- * reclaimed.
- */
-int kmem_cache_shrink(struct kmem_cache *s)
-{
-	int node;
-
-	flush_all(s);
-	for_each_node_state(node, N_NORMAL_MEMORY)
-		__kmem_cache_shrink(s, node, 0);
 
+	kfree(slabs_by_inuse);
 	return 0;
 }
 EXPORT_SYMBOL(kmem_cache_shrink);
@@ -3295,7 +3057,7 @@ static int slab_unmergeable(struct kmem_
 	if (slub_nomerge || (s->flags & SLUB_NEVER_MERGE))
 		return 1;
 
-	if (s->ctor || s->kick || s->get)
+	if (s->ctor)
 		return 1;
 
 	/*
@@ -3385,7 +3147,7 @@ struct kmem_cache *kmem_cache_create(con
 	if (s) {
 		if (kmem_cache_open(s, GFP_KERNEL, name,
 				size, align, flags, ctor)) {
-			list_add_tail(&s->list, &slab_caches);
+			list_add(&s->list, &slab_caches);
 			up_write(&slub_lock);
 			if (sysfs_slab_add(s))
 				goto err;
@@ -4070,32 +3832,16 @@ static ssize_t order_show(struct kmem_ca
 }
 SLAB_ATTR(order);
 
-static ssize_t ops_show(struct kmem_cache *s, char *buf)
+static ssize_t ctor_show(struct kmem_cache *s, char *buf)
 {
-	int x = 0;
-
 	if (s->ctor) {
-		x += sprintf(buf + x, "ctor : ");
-		x += sprint_symbol(buf + x, (unsigned long)s->ctor);
-		x += sprintf(buf + x, "\n");
-	}
-
-	if (s->get) {
-		x += sprintf(buf + x, "get : ");
-		x += sprint_symbol(buf + x,
-				(unsigned long)s->get);
-		x += sprintf(buf + x, "\n");
-	}
-
-	if (s->kick) {
-		x += sprintf(buf + x, "kick : ");
-		x += sprint_symbol(buf + x,
-				(unsigned long)s->kick);
-		x += sprintf(buf + x, "\n");
+		int n = sprint_symbol(buf, (unsigned long)s->ctor);
+
+		return n + sprintf(buf + n, "\n");
 	}
-	return x;
+	return 0;
 }
-SLAB_ATTR_RO(ops);
+SLAB_ATTR_RO(ctor);
 
 static ssize_t aliases_show(struct kmem_cache *s, char *buf)
 {
@@ -4315,27 +4061,6 @@ static ssize_t free_calls_show(struct km
 }
 SLAB_ATTR_RO(free_calls);
 
-static ssize_t defrag_ratio_show(struct kmem_cache *s, char *buf)
-{
-	return sprintf(buf, "%d\n", s->defrag_ratio);
-}
-
-static ssize_t defrag_ratio_store(struct kmem_cache *s,
-				const char *buf, size_t length)
-{
-	unsigned long ratio;
-	int err;
-
-	err = strict_strtoul(buf, 10, &ratio);
-	if (err)
-		return err;
-
-	if (ratio < 100)
-		s->defrag_ratio = ratio;
-	return length;
-}
-SLAB_ATTR(defrag_ratio);
-
 #ifdef CONFIG_NUMA
 static ssize_t remote_node_defrag_ratio_show(struct kmem_cache *s, char *buf)
 {
@@ -4415,12 +4140,6 @@ STAT_ATTR(DEACTIVATE_TO_HEAD, deactivate
 STAT_ATTR(DEACTIVATE_TO_TAIL, deactivate_to_tail);
 STAT_ATTR(DEACTIVATE_REMOTE_FREES, deactivate_remote_frees);
 STAT_ATTR(ORDER_FALLBACK, order_fallback);
-STAT_ATTR(SHRINK_CALLS, shrink_calls);
-STAT_ATTR(SHRINK_ATTEMPT_DEFRAG, shrink_attempt_defrag);
-STAT_ATTR(SHRINK_EMPTY_SLAB, shrink_empty_slab);
-STAT_ATTR(SHRINK_SLAB_SKIPPED, shrink_slab_skipped);
-STAT_ATTR(SHRINK_SLAB_RECLAIMED, shrink_slab_reclaimed);
-STAT_ATTR(SHRINK_OBJECT_RECLAIM_FAILED, shrink_object_reclaim_failed);
 #endif
 
 static struct attribute *slab_attrs[] = {
@@ -4434,7 +4153,7 @@ static struct attribute *slab_attrs[] = 
 	&slabs_attr.attr,
 	&partial_attr.attr,
 	&cpu_slabs_attr.attr,
-	&ops_attr.attr,
+	&ctor_attr.attr,
 	&aliases_attr.attr,
 	&align_attr.attr,
 	&sanity_checks_attr.attr,
@@ -4449,7 +4168,6 @@ static struct attribute *slab_attrs[] = 
 	&shrink_attr.attr,
 	&alloc_calls_attr.attr,
 	&free_calls_attr.attr,
-	&defrag_ratio_attr.attr,
 #ifdef CONFIG_ZONE_DMA
 	&cache_dma_attr.attr,
 #endif
@@ -4475,12 +4193,6 @@ static struct attribute *slab_attrs[] = 
 	&deactivate_to_tail_attr.attr,
 	&deactivate_remote_frees_attr.attr,
 	&order_fallback_attr.attr,
-	&shrink_calls_attr.attr,
-	&shrink_attempt_defrag_attr.attr,
-	&shrink_empty_slab_attr.attr,
-	&shrink_slab_skipped_attr.attr,
-	&shrink_slab_reclaimed_attr.attr,
-	&shrink_object_reclaim_failed_attr.attr,
 #endif
 	NULL
 };
diff -puN mm/vmscan.c~revert-git-pekka mm/vmscan.c
--- a/mm/vmscan.c~revert-git-pekka
+++ a/mm/vmscan.c
@@ -149,14 +149,6 @@ void unregister_shrinker(struct shrinker
 EXPORT_SYMBOL(unregister_shrinker);
 
 #define SHRINK_BATCH 128
-
-/*
- * Trigger a call into slab defrag if the sum of the returns from
- * shrinkers cross this value.
- */
-int slab_defrag_limit = 1000;
-int slab_defrag_counter;
-
 /*
  * Call the shrink functions to age shrinkable caches
  *
@@ -174,18 +166,10 @@ int slab_defrag_counter;
  * are eligible for the caller's allocation attempt.  It is used for balancing
  * slab reclaim versus page reclaim.
  *
- * zone is the zone for which we are shrinking the slabs. If the intent
- * is to do a global shrink then zone may be NULL. Specification of a
- * zone is currently only used to limit slab defragmentation to a NUMA node.
- * The performace of shrink_slab would be better (in particular under NUMA)
- * if it could be targeted as a whole to the zone that is under memory
- * pressure but the VFS infrastructure does not allow that at the present
- * time.
- *
  * Returns the number of slab objects which we shrunk.
  */
 unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
-			unsigned long lru_pages, struct zone *zone)
+			unsigned long lru_pages)
 {
 	struct shrinker *shrinker;
 	unsigned long ret = 0;
@@ -242,39 +226,6 @@ unsigned long shrink_slab(unsigned long 
 		shrinker->nr += total_scan;
 	}
 	up_read(&shrinker_rwsem);
-
-
-	/* Avoid dirtying cachelines */
-	if (!ret)
-		return 0;
-
-	/*
-	 * "ret" doesnt really contain the freed object count. The shrinkers
-	 * fake it. Gotta go with what we are getting though.
-	 *
-	 * Handling of the defrag_counter is also racy. If we get the
-	 * wrong counts then we may unnecessarily do a defrag pass or defer
-	 * one. "ret" is already faked. So this is just increasing
-	 * the already existing fuzziness to get some notion as to when
-	 * to initiate slab defrag which will hopefully be okay.
-	 */
-	if (zone) {
-		/* balance_pgdat running on a zone so we only scan one node */
-		zone->slab_defrag_counter += ret;
-		if (zone->slab_defrag_counter > slab_defrag_limit &&
-						(gfp_mask & __GFP_FS)) {
-			zone->slab_defrag_counter = 0;
-			kmem_cache_defrag(zone_to_nid(zone));
-		}
-	} else {
-		/* Direct (and thus global) reclaim. Scan all nodes */
-		slab_defrag_counter += ret;
-		if (slab_defrag_counter > slab_defrag_limit &&
-						(gfp_mask & __GFP_FS)) {
-			slab_defrag_counter = 0;
-			kmem_cache_defrag(-1);
-		}
-	}
 	return ret;
 }
 
@@ -1391,7 +1342,7 @@ static unsigned long do_try_to_free_page
 		 * over limit cgroups
 		 */
 		if (scan_global_lru(sc)) {
-			shrink_slab(sc->nr_scanned, sc->gfp_mask, lru_pages, NULL);
+			shrink_slab(sc->nr_scanned, sc->gfp_mask, lru_pages);
 			if (reclaim_state) {
 				nr_reclaimed += reclaim_state->reclaimed_slab;
 				reclaim_state->reclaimed_slab = 0;
@@ -1616,7 +1567,7 @@ loop_again:
 				nr_reclaimed += shrink_zone(priority, zone, &sc);
 			reclaim_state->reclaimed_slab = 0;
 			nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
-						lru_pages, zone);
+						lru_pages);
 			nr_reclaimed += reclaim_state->reclaimed_slab;
 			total_scanned += sc.nr_scanned;
 			if (zone_is_all_unreclaimable(zone))
@@ -1855,7 +1806,7 @@ unsigned long shrink_all_memory(unsigned
 	/* If slab caches are huge, it's better to hit them first */
 	while (nr_slab >= lru_pages) {
 		reclaim_state.reclaimed_slab = 0;
-		shrink_slab(nr_pages, sc.gfp_mask, lru_pages, NULL);
+		shrink_slab(nr_pages, sc.gfp_mask, lru_pages);
 		if (!reclaim_state.reclaimed_slab)
 			break;
 
@@ -1893,7 +1844,7 @@ unsigned long shrink_all_memory(unsigned
 
 			reclaim_state.reclaimed_slab = 0;
 			shrink_slab(sc.nr_scanned, sc.gfp_mask,
-					count_lru_pages(), NULL);
+					count_lru_pages());
 			ret += reclaim_state.reclaimed_slab;
 			if (ret >= nr_pages)
 				goto out;
@@ -1910,8 +1861,7 @@ unsigned long shrink_all_memory(unsigned
 	if (!ret) {
 		do {
 			reclaim_state.reclaimed_slab = 0;
-			shrink_slab(nr_pages, sc.gfp_mask,
-					count_lru_pages(), NULL);
+			shrink_slab(nr_pages, sc.gfp_mask, count_lru_pages());
 			ret += reclaim_state.reclaimed_slab;
 		} while (ret < nr_pages && reclaim_state.reclaimed_slab > 0);
 	}
@@ -2073,8 +2023,7 @@ static int __zone_reclaim(struct zone *z
 		 * Note that shrink_slab will free memory on all zones and may
 		 * take a long time.
 		 */
-		while (shrink_slab(sc.nr_scanned, gfp_mask, order,
-						zone) &&
+		while (shrink_slab(sc.nr_scanned, gfp_mask, order) &&
 			zone_page_state(zone, NR_SLAB_RECLAIMABLE) >
 				slab_reclaimable - nr_pages)
 			;
diff -puN mm/vmstat.c~revert-git-pekka mm/vmstat.c
--- a/mm/vmstat.c~revert-git-pekka
+++ a/mm/vmstat.c
@@ -713,11 +713,9 @@ static void zoneinfo_show_print(struct s
 #endif
 	}
 	seq_printf(m,
-		   "\n  slab_defrag_count: %lu"
 		   "\n  all_unreclaimable: %u"
 		   "\n  prev_priority:     %i"
 		   "\n  start_pfn:         %lu",
-			   zone->slab_defrag_counter,
 			   zone_is_all_unreclaimable(zone),
 		   zone->prev_priority,
 		   zone->zone_start_pfn);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-x1205-fix-alarm-set-fix.patch
update-ntfs-help-text-fix.patch
cgroups-document-the-effect-of-attaching-pid-0-to-a-cgroup-fix.patch
spi-fix-the-read-path-in-spidev-cleanup.patch
security-filesystem-capabilities-fix-fragile-setuid-fixup-code-checkpatch-fixes.patch
doc-document-the-relax_domain_level-kernel-boot-argument-fix.patch
revert-introduce-rculisth.patch
linux-next.patch
next-remove-localversion.patch
linux-next-fixups.patch
revert-git-pekka.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
kvm-is-busted-on-ia64.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-arm.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
git-thumb2.patch
git-pcmcia.patch
git-powerpc.patch
git-dvb.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-hid.patch
tick-schedc-suppress-needless-timer-reprogramming-checkpatch-fixes.patch
git-input.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
git-kvm.patch
git-leds.patch
git-mmc.patch
mmc-sd-host-driver-for-ricoh-bay1controllers.patch
drivers-mtd-devices-block2mtdc-suppress-warning.patch
git-ubifs.patch
git-net-next.patch
bug-in-random32c-all-zero-outputs-with-probability-1-232-other-seeding-bugs-checkpatch-fixes.patch
sundance-set-carrier-status-on-link-change-events.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
git-ocfs2.patch
git-pci-next.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
pktcdvd-push-bkl-down-into-driver-fix.patch
block-fix-bio_add_page-for-non-trivial-merge_bvec_fn-case-fix.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-logfs-fixup.patch
watchdog-wdt501-pci-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
spufs-use-the-new-vm_ops-access-fix.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
mapping_set_error-add-unlikely.patch
huge-page-private-reservation-review-cleanups-fix.patch
sync_file_range_write-may-and-will-block-document-that-fix.patch
vmallocinfo-add-numa-information-fix.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlb-override-default-huge-page-size-ia64-build.patch
linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-add-debugging-framework-fix.patch
bootmem-clean-up-free_all_bootmem_core-fix.patch
bootmem-free-reserve-helpers-fix.patch
revert-revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-factor-out-the-marking-of-a-pfn-range-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-v850-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
security-protect-legacy-applications-from-executing-with-insufficient-privilege-checkpatch-fixes.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
build-kernel-profileo-only-when-requested-cleanups.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
seq_file-fix-bug-when-seq_read-reads-nothing-fix.patch
remove-bkl-from-remote_llseek-v2-fix.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha.patch
spi-au1550_spi-improve-pio-transfer-mode-checkpatch-fixes.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes.patch
fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact-fix.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup.patch
ext3-handle-corrupted-orphan-list-at-mount-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix.patch
jbd-dont-abort-if-flushing-file-data-failed-fix.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-checkpatch-fixes.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
jbd2-fix-race-between-jbd2_journal_try_to_free_buffers-and-jbd2-commit-transaction-cleanup.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary-checkpatch-fixes.patch
tpm-increase-size-of-internal-tpm-response-buffers-checkpatch-fixes.patch
memstick-allow-set_param-method-to-return-an-error-code-checkpatch-fixes.patch
memstick-use-fully-asynchronous-request-processing-fix.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
define-page_file_cache-function-fix.patch
unevictable-lru-infrastructure-fix.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

