From: akpm@linux-foundation.org
Subject: - slub-slabinfo-remove-hackname.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:00:39 -0700
Message-ID: <200704301900.l3UJ0dg0012175@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946641AbXD3TAz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:00:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB slabinfo: Remove hackname()
has been removed from the -mm tree.  Its filename was
     slub-slabinfo-remove-hackname.patch

This patch was dropped because it was folded into slub-add-slabinfo-tool.patch

------------------------------------------------------
Subject: SLUB slabinfo: Remove hackname()
From: Christoph Lameter <clameter@sgi.com>

hackname() is no longer needed since we changed the way to generate the unique
id.

Fixup SLUB totals display.  Add some comments to explain what all these code
done.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/slabinfo.c |  244 ++++++++++++++++++++--------------
 1 files changed, 149 insertions(+), 95 deletions(-)

diff -puN Documentation/vm/slabinfo.c~slub-slabinfo-remove-hackname Documentation/vm/slabinfo.c
--- a/Documentation/vm/slabinfo.c~slub-slabinfo-remove-hackname
+++ a/Documentation/vm/slabinfo.c
@@ -42,6 +42,7 @@ struct aliasinfo {
 
 int slabs = 0;
 int aliases = 0;
+int alias_targets = 0;
 int highest_node = 0;
 
 char buffer[4096];
@@ -211,24 +212,6 @@ void decode_numa_list(int *numa, char *t
 	}
 }
 
-char *hackname(struct slabinfo *s)
-{
-	char *n = s->name;
-
-	if (n[0] == ':') {
-		char *nn = malloc(20);
-		char *p;
-
-		strncpy(nn, n, 20);
-		n = nn;
-		p = n + 4;
-		while (*p && *p !=':')
-			p++;
-		*p = 0;
-	}
-	return n;
-}
-
 void slab_validate(struct slabinfo *s)
 {
 	set_obj(s, "validate", 1);
@@ -281,7 +264,6 @@ void slabcache(struct slabinfo *s)
 	char dist_str[40];
 	char flags[20];
 	char *p = flags;
-	char *n;
 
 	if (skip_zero && !s->slabs)
 		return;
@@ -312,19 +294,17 @@ void slabcache(struct slabinfo *s)
 		*p++ = 'T';
 
 	*p = 0;
-	n = hackname(s);
 	printf("%-21s %8ld %7d %8s %14s %4d %1d %3ld %3ld %s\n",
-			n, s->objects, s->object_size, size_str, dist_str,
-			s->objs_per_slab, s->order,
-			s->slabs ? (s->partial * 100) / s->slabs : 100,
-			s->slabs ? (s->objects * s->object_size * 100) /
-				(s->slabs * (page_size << s->order)) : 100,
-			flags);
+		s->name, s->objects, s->object_size, size_str, dist_str,
+		s->objs_per_slab, s->order,
+		s->slabs ? (s->partial * 100) / s->slabs : 100,
+		s->slabs ? (s->objects * s->object_size * 100) /
+			(s->slabs * (page_size << s->order)) : 100,
+		flags);
 }
 
 void slab_numa(struct slabinfo *s)
 {
-	char *n;
 	int node;
 
 	if (!highest_node)
@@ -332,7 +312,6 @@ void slab_numa(struct slabinfo *s)
 
 	if (skip_zero && !s->slabs)
 		return;
-	n = hackname(s);
 
 	if (!line) {
 		printf("\nSlab             Node ");
@@ -343,7 +322,7 @@ void slab_numa(struct slabinfo *s)
 			printf("-----");
 		printf("\n");
 	}
-	printf("%-21s ", n);
+	printf("%-21s ", s->name);
 	for(node = 0; node <= highest_node; node++) {
 		char b[20];
 
@@ -374,27 +353,61 @@ void totals(void)
 
 	int used_slabs = 0;
 	char b1[20], b2[20], b3[20], b4[20];
-	unsigned long long min_objsize = 0, max_objsize = 0, avg_objsize;
-	unsigned long long min_partial = 0, max_partial = 0, avg_partial, total_partial = 0;
-	unsigned long long min_slabs = 0, max_slabs = 0, avg_slabs, total_slabs = 0;
-	unsigned long long min_size = 0, max_size = 0, avg_size, total_size = 0;
-	unsigned long long min_waste = 0, max_waste = 0, avg_waste, total_waste = 0;
-	unsigned long long min_objects = 0, max_objects = 0, avg_objects, total_objects = 0;
-	unsigned long long min_objwaste = 0, max_objwaste = 0, avg_objwaste;
-	unsigned long long min_used = 0, max_used = 0, avg_used, total_used = 0;
-	unsigned long min_ppart = 0, max_ppart = 0, avg_ppart, total_ppart = 0;
-	unsigned long min_partobj = 0, max_partobj = 0, avg_partobj;
-	unsigned long total_objects_in_partial = 0;
+	unsigned long long max = 1ULL << 63;
+
+	/* Object size */
+	unsigned long long min_objsize = max, max_objsize = 0, avg_objsize;
+
+	/* Number of partial slabs in a slabcache */
+	unsigned long long min_partial = max, max_partial = 0,
+				avg_partial, total_partial = 0;
+
+	/* Number of slabs in a slab cache */
+	unsigned long long min_slabs = max, max_slabs = 0,
+				avg_slabs, total_slabs = 0;
+
+	/* Size of the whole slab */
+	unsigned long long min_size = max, max_size = 0,
+				avg_size, total_size = 0;
+
+	/* Bytes used for object storage in a slab */
+	unsigned long long min_used = max, max_used = 0, avg_used, total_used = 0;
+
+	/* Waste: Bytes used for aligned and padding */
+	unsigned long long min_waste = max, max_waste = 0,
+				avg_waste, total_waste = 0;
+	/* Number of objects in a slab */
+	unsigned long long min_objects = max, max_objects = 0,
+				avg_objects, total_objects = 0;
+	/* Waste per object */
+	unsigned long long min_objwaste = max,
+				max_objwaste = 0, avg_objwaste;
+
+	/* Memory per object */
+	unsigned long long min_memobj = max,
+				max_memobj = 0, avg_memobj;
+
+	/* Percentage of partial slabs per slab */
+	unsigned long min_ppart = 100, max_ppart = 0,
+				avg_ppart, total_ppart = 0;
+
+	/* Number of objects in partial slabs */
+	unsigned long min_partobj = max, max_partobj = 0,
+				avg_partobj, total_partobj = 0;
+
+	/* Percentage of partial objects of all objects in a slab */
+	unsigned long min_ppartobj = 100, max_ppartobj = 0,
+				avg_ppartobj, total_ppartobj = 0;
+
 
 	for (s = slabinfo; s < slabinfo + slabs; s++) {
 		unsigned long long size;
-		unsigned long partial;
-		unsigned long slabs;
 		unsigned long used;
 		unsigned long long wasted;
 		unsigned long long objwaste;
-		long long objects_in_partial;
-		unsigned long percentage_partial;
+		long long objects_in_partial_slabs;
+		unsigned long percentage_partial_slabs;
+		unsigned long percentage_partial_objs;
 
 		if (!s->slabs || !s->objects)
 			continue;
@@ -402,49 +415,58 @@ void totals(void)
 		used_slabs++;
 
 		size = slab_size(s);
-		partial = s->partial << s->order;
-		slabs = s->slabs << s->order;
 		used = s->objects * s->object_size;
 		wasted = size - used;
-		objwaste = wasted / s->objects;
+		objwaste = s->slab_size - s->object_size;
+
+		objects_in_partial_slabs = s->objects -
+			(s->slabs - s->partial - s ->cpu_slabs) *
+			s->objs_per_slab;
 
-		objects_in_partial = s->objects - (s->slabs - s->partial - s ->cpu_slabs)
-					* s->objs_per_slab;
+		if (objects_in_partial_slabs < 0)
+			objects_in_partial_slabs = 0;
 
-		if (objects_in_partial < 0)
-			objects_in_partial = 0;
+		percentage_partial_slabs = s->partial * 100 / s->slabs;
+		if (percentage_partial_slabs > 100)
+			percentage_partial_slabs = 100;
 
-		percentage_partial = objects_in_partial * 100 / s->objects;
-		if (percentage_partial > 100)
-			percentage_partial = 100;
+		percentage_partial_objs = objects_in_partial_slabs * 100
+							/ s->objects;
 
-		if (s->object_size < min_objsize || !min_objsize)
+		if (percentage_partial_objs > 100)
+			percentage_partial_objs = 100;
+
+		if (s->object_size < min_objsize)
 			min_objsize = s->object_size;
-		if (partial && (partial < min_partial || !min_partial))
-			min_partial = partial;
-		if (slabs < min_slabs || !min_partial)
-			min_slabs = slabs;
+		if (s->partial < min_partial)
+			min_partial = s->partial;
+		if (s->slabs < min_slabs)
+			min_slabs = s->slabs;
 		if (size < min_size)
 			min_size = size;
-		if (wasted < min_waste && !min_waste)
+		if (wasted < min_waste)
 			min_waste = wasted;
-		if (objwaste < min_objwaste || !min_objwaste)
+		if (objwaste < min_objwaste)
 			min_objwaste = objwaste;
-		if (s->objects < min_objects || !min_objects)
+		if (s->objects < min_objects)
 			min_objects = s->objects;
-		if (used < min_used || !min_used)
+		if (used < min_used)
 			min_used = used;
-		if (objects_in_partial < min_partobj || !min_partobj)
-			min_partobj = objects_in_partial;
-		if (percentage_partial < min_ppart || !min_ppart)
-			min_ppart = percentage_partial;
+		if (objects_in_partial_slabs < min_partobj)
+			min_partobj = objects_in_partial_slabs;
+		if (percentage_partial_slabs < min_ppart)
+			min_ppart = percentage_partial_slabs;
+		if (percentage_partial_objs < min_ppartobj)
+			min_ppartobj = percentage_partial_objs;
+		if (s->slab_size < min_memobj)
+			min_memobj = s->slab_size;
 
 		if (s->object_size > max_objsize)
 			max_objsize = s->object_size;
-		if (partial > max_partial)
-			max_partial = partial;
-		if (slabs > max_slabs)
-			max_slabs = slabs;
+		if (s->partial > max_partial)
+			max_partial = s->partial;
+		if (s->slabs > max_slabs)
+			max_slabs = s->slabs;
 		if (size > max_size)
 			max_size = size;
 		if (wasted > max_waste)
@@ -455,19 +477,25 @@ void totals(void)
 			max_objects = s->objects;
 		if (used > max_used)
 			max_used = used;
-		if (objects_in_partial > max_partobj)
-			max_partobj = objects_in_partial;
-		if (percentage_partial > max_ppart)
-			max_ppart = percentage_partial;
+		if (objects_in_partial_slabs > max_partobj)
+			max_partobj = objects_in_partial_slabs;
+		if (percentage_partial_slabs > max_ppart)
+			max_ppart = percentage_partial_slabs;
+		if (percentage_partial_objs > max_ppartobj)
+			max_ppartobj = percentage_partial_objs;
+		if (s->slab_size > max_memobj)
+			max_memobj = s->slab_size;
+
+		total_partial += s->partial;
+		total_slabs += s->slabs;
+		total_size += size;
+		total_waste += wasted;
 
 		total_objects += s->objects;
-		total_partial += partial;
-		total_slabs += slabs;
 		total_used += used;
-		total_waste += wasted;
-		total_size += size;
-		total_ppart += percentage_partial;
-		total_objects_in_partial += objects_in_partial;
+		total_partobj += objects_in_partial_slabs;
+		total_ppart += percentage_partial_slabs;
+		total_ppartobj += percentage_partial_objs;
 	}
 
 	if (!total_objects) {
@@ -478,29 +506,36 @@ void totals(void)
 		printf("No slabs\n");
 		return;
 	}
+
+	/* Per slab averages */
 	avg_partial = total_partial / used_slabs;
 	avg_slabs = total_slabs / used_slabs;
+	avg_size = total_size / used_slabs;
 	avg_waste = total_waste / used_slabs;
-	avg_size = total_waste / used_slabs;
+
 	avg_objects = total_objects / used_slabs;
 	avg_used = total_used / used_slabs;
+	avg_partobj = total_partobj / used_slabs;
 	avg_ppart = total_ppart / used_slabs;
-	avg_partobj = total_objects_in_partial / used_slabs;
+	avg_ppartobj = total_ppartobj / used_slabs;
 
+	/* Per object object sizes */
 	avg_objsize = total_used / total_objects;
 	avg_objwaste = total_waste / total_objects;
+	avg_partobj = total_partobj * 100 / total_objects;
+	avg_memobj = total_size / total_objects;
 
 	printf("Slabcache Totals\n");
 	printf("----------------\n");
-	printf("Slabcaches : %3d      Aliases  : %3d      Active: %3d\n",
-			slabs, aliases, used_slabs);
+	printf("Slabcaches : %3d      Aliases  : %3d->%-3d Active: %3d\n",
+			slabs, aliases, alias_targets, used_slabs);
 
-	store_size(b1, total_used);store_size(b2, total_waste);
+	store_size(b1, total_size);store_size(b2, total_waste);
 	store_size(b3, total_waste * 100 / total_used);
 	printf("Memory used: %6s   # Loss   : %6s   MRatio: %6s%%\n", b1, b2, b3);
 
-	store_size(b1, total_objects);store_size(b2, total_objects_in_partial);
-	store_size(b3, total_objects_in_partial * 100 / total_objects);
+	store_size(b1, total_objects);store_size(b2, total_partobj);
+	store_size(b3, total_partobj * 100 / total_objects);
 	printf("# Objects  : %6s   # PartObj: %6s   ORatio: %6s%%\n", b1, b2, b3);
 
 	printf("\n");
@@ -509,22 +544,35 @@ void totals(void)
 
 	store_size(b1, avg_objects);store_size(b2, min_objects);
 	store_size(b3, max_objects);store_size(b4, total_objects);
-	printf("# Objects %10s  %10s  %10s  %10s\n",
+	printf("#Objects  %10s  %10s  %10s  %10s\n",
 			b1,	b2,	b3,	b4);
 
 	store_size(b1, avg_slabs);store_size(b2, min_slabs);
 	store_size(b3, max_slabs);store_size(b4, total_slabs);
-	printf("# Slabs   %10s  %10s  %10s  %10s\n",
+	printf("#Slabs    %10s  %10s  %10s  %10s\n",
 			b1,	b2,	b3,	b4);
 
 	store_size(b1, avg_partial);store_size(b2, min_partial);
 	store_size(b3, max_partial);store_size(b4, total_partial);
-	printf("# Partial %10s  %10s  %10s  %10s\n",
+	printf("#PartSlab %10s  %10s  %10s  %10s\n",
 			b1,	b2,	b3,	b4);
 	store_size(b1, avg_ppart);store_size(b2, min_ppart);
 	store_size(b3, max_ppart);
-	printf("%% Partial %10s%% %10s%% %10s%%\n",
-			b1,	b2,	b3);
+	store_size(b4, total_partial * 100  / total_slabs);
+	printf("%%PartSlab %10s%% %10s%% %10s%% %10s%%\n",
+			b1,	b2,	b3,	b4);
+
+	store_size(b1, avg_partobj);store_size(b2, min_partobj);
+	store_size(b3, max_partobj);
+	store_size(b4, total_partobj);
+	printf("PartObjs  %10s  %10s  %10s  %10s\n",
+			b1,	b2,	b3,	b4);
+
+	store_size(b1, avg_ppartobj);store_size(b2, min_ppartobj);
+	store_size(b3, max_ppartobj);
+	store_size(b4, total_partobj * 100 / total_objects);
+	printf("%% PartObj %10s%% %10s%% %10s%% %10s%%\n",
+			b1,	b2,	b3,	b4);
 
 	store_size(b1, avg_size);store_size(b2, min_size);
 	store_size(b3, max_size);store_size(b4, total_size);
@@ -545,14 +593,18 @@ void totals(void)
 	printf("Per Object   Average         Min         Max\n");
 	printf("---------------------------------------------\n");
 
+	store_size(b1, avg_memobj);store_size(b2, min_memobj);
+	store_size(b3, max_memobj);
+	printf("Memory    %10s  %10s  %10s\n",
+			b1,	b2,	b3);
 	store_size(b1, avg_objsize);store_size(b2, min_objsize);
 	store_size(b3, max_objsize);
-	printf("Size      %10s  %10s  %10s\n",
+	printf("User      %10s  %10s  %10s\n",
 			b1,	b2,	b3);
 
 	store_size(b1, avg_objwaste);store_size(b2, min_objwaste);
 	store_size(b3, max_objwaste);
-	printf("Loss      %10s  %10s  %10s\n",
+	printf("Waste     %10s  %10s  %10s\n",
 			b1,	b2,	b3);
 }
 
@@ -739,6 +791,8 @@ void read_slab_dir(void)
 			slab->store_user = get_obj("store_user");
 			slab->trace = get_obj("trace");
 			chdir("..");
+			if (slab->name[0] == ':')
+				alias_targets++;
 			slab++;
 			break;
 		   default :
_

Patches currently in -mm which might be from clameter@sgi.com are

extend-print_symbol-capability.patch
slab-introduce-krealloc.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix-2.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
make-page-private-usable-in-compound-pages-v1.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
slub-enable-tracking-of-full-slabs.patch
slub-validation-of-slabs-metadata-and-guard-zones.patch
slub-add-min_partial.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch
slub-remove-object-activities-out-of-checking-functions.patch
slub-user-documentation.patch
slub-add-slabinfo-tool.patch
slub-slabinfo-remove-hackname.patch
slub-slabinfo-more-statistic-fixes-and-handling-fixes.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
quicklists-for-page-table-pages.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion-fix.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
slab-allocators-remove-obsolete-slab_must_hwcache_align.patch
kmem_cache-simplify-slab-cache-creation.patch
slab-allocators-remove-slab_debug_initial-flag.patch
slab-allocators-remove-slab_debug_initial-flag-locks-fix.patch
slab-allocators-remove-multiple-alignment-specifications.patch
slab-allocators-remove-slab_ctor_atomic.patch
fault-injection-fix-failslab-with-config_numa.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
slub-i386-support.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
readahead-state-based-method-aging-accounting.patch
