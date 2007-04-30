From: akpm@linux-foundation.org
Subject: - slub-slabinfo-more-statistic-fixes-and-handling-fixes.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:00:43 -0700
Message-ID: <200704301900.l3UJ0hOn012181@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946633AbXD3TAt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:00:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB slabinfo: More statistic fixes and handling fixes
has been removed from the -mm tree.  Its filename was
     slub-slabinfo-more-statistic-fixes-and-handling-fixes.patch

This patch was dropped because it was folded into slub-add-slabinfo-tool.patch

------------------------------------------------------
Subject: SLUB slabinfo: More statistic fixes and handling fixes
From: Christoph Lameter <clameter@sgi.com>

Make -s be shrink. -r is kind of strange. Free up -s by making the rarely
used --slab option use -l as an abbreviation.

Fix some additional issues with the total statistics that showed up
during NUMA testing.

Replace "Waste" items by "Loss" lest one gets the wrong idea.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/slabinfo.c |   44 +++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff -puN Documentation/vm/slabinfo.c~slub-slabinfo-more-statistic-fixes-and-handling-fixes Documentation/vm/slabinfo.c
--- a/Documentation/vm/slabinfo.c~slub-slabinfo-more-statistic-fixes-and-handling-fixes
+++ a/Documentation/vm/slabinfo.c
@@ -80,12 +80,12 @@ void usage(void)
 		"-a|--aliases           Show aliases\n"
 		"-h|--help              Show usage information\n"
 		"-n|--numa              Show NUMA information\n"
-		"-r|--reduce	        Shrink slabs\n"
+		"-s|--shrink            Shrink slabs\n"
 		"-v|--validate          Validate slabs\n"
 		"-t|--tracking          Show alloc/free information\n"
-		"-T|--Totals		Show summary information\n"
-		"-s|--slabs             Show slabs\n"
-		"-S|--Size		Sort by size\n"
+		"-T|--Totals            Show summary information\n"
+		"-l|--slabs             Show slabs\n"
+		"-S|--Size              Sort by size\n"
 		"-z|--zero              Include empty slabs\n"
 		"-f|--first-alias       Show first alias\n"
 		"-i|--inverted          Inverted list\n"
@@ -371,9 +371,10 @@ void totals(void)
 				avg_size, total_size = 0;
 
 	/* Bytes used for object storage in a slab */
-	unsigned long long min_used = max, max_used = 0, avg_used, total_used = 0;
+	unsigned long long min_used = max, max_used = 0,
+				avg_used, total_used = 0;
 
-	/* Waste: Bytes used for aligned and padding */
+	/* Waste: Bytes used for alignment and padding */
 	unsigned long long min_waste = max, max_waste = 0,
 				avg_waste, total_waste = 0;
 	/* Number of objects in a slab */
@@ -381,11 +382,13 @@ void totals(void)
 				avg_objects, total_objects = 0;
 	/* Waste per object */
 	unsigned long long min_objwaste = max,
-				max_objwaste = 0, avg_objwaste;
+				max_objwaste = 0, avg_objwaste,
+				total_objwaste = 0;
 
 	/* Memory per object */
 	unsigned long long min_memobj = max,
-				max_memobj = 0, avg_memobj;
+				max_memobj = 0, avg_memobj,
+				total_objsize = 0;
 
 	/* Percentage of partial slabs per slab */
 	unsigned long min_ppart = 100, max_ppart = 0,
@@ -496,6 +499,9 @@ void totals(void)
 		total_partobj += objects_in_partial_slabs;
 		total_ppart += percentage_partial_slabs;
 		total_ppartobj += percentage_partial_objs;
+
+		total_objwaste += s->objects * objwaste;
+		total_objsize += s->objects * s->slab_size;
 	}
 
 	if (!total_objects) {
@@ -521,9 +527,9 @@ void totals(void)
 
 	/* Per object object sizes */
 	avg_objsize = total_used / total_objects;
-	avg_objwaste = total_waste / total_objects;
+	avg_objwaste = total_objwaste / total_objects;
 	avg_partobj = total_partobj * 100 / total_objects;
-	avg_memobj = total_size / total_objects;
+	avg_memobj = total_objsize / total_objects;
 
 	printf("Slabcache Totals\n");
 	printf("----------------\n");
@@ -584,9 +590,9 @@ void totals(void)
 	printf("Used      %10s  %10s  %10s  %10s\n",
 			b1,	b2,	b3,	b4);
 
-	store_size(b1, avg_slabs);store_size(b2, min_slabs);
-	store_size(b3, max_slabs);store_size(b4, total_slabs);
-	printf("Waste     %10s  %10s  %10s  %10s\n",
+	store_size(b1, avg_waste);store_size(b2, min_waste);
+	store_size(b3, max_waste);store_size(b4, total_waste);
+	printf("Loss      %10s  %10s  %10s  %10s\n",
 			b1,	b2,	b3,	b4);
 
 	printf("\n");
@@ -604,7 +610,7 @@ void totals(void)
 
 	store_size(b1, avg_objwaste);store_size(b2, min_objwaste);
 	store_size(b3, max_objwaste);
-	printf("Waste     %10s  %10s  %10s\n",
+	printf("Loss      %10s  %10s  %10s\n",
 			b1,	b2,	b3);
 }
 
@@ -838,13 +844,13 @@ void output_slabs(void)
 
 struct option opts[] = {
 	{ "aliases", 0, NULL, 'a' },
-	{ "slabs", 0, NULL, 's' },
+	{ "slabs", 0, NULL, 'l' },
 	{ "numa", 0, NULL, 'n' },
 	{ "zero", 0, NULL, 'z' },
 	{ "help", 0, NULL, 'h' },
 	{ "validate", 0, NULL, 'v' },
 	{ "first-alias", 0, NULL, 'f' },
-	{ "reduce", 0, NULL, 'r' },
+	{ "shrink", 0, NULL, 's' },
 	{ "track", 0, NULL, 't'},
 	{ "inverted", 0, NULL, 'i'},
 	{ "1ref", 0, NULL, '1'},
@@ -861,7 +867,7 @@ int main(int argc, char *argv[])
 	if (chdir("/sys/slab"))
 		fatal("This kernel does not have SLUB support.\n");
 
-	while ((c = getopt_long(argc, argv, "afhi1nprstvzTS", opts, NULL)) != -1)
+	while ((c = getopt_long(argc, argv, "afhil1npstvzTS", opts, NULL)) != -1)
 	switch(c) {
 		case '1':
 			show_single_ref = 1;
@@ -881,10 +887,10 @@ int main(int argc, char *argv[])
 		case 'n':
 			show_numa = 1;
 			break;
-		case 'r':
+		case 's':
 			shrink = 1;
 			break;
-		case 's':
+		case 'l':
 			show_slab = 1;
 			break;
 		case 't':
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
