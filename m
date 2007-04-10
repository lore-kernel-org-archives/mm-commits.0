From: akpm@linux-foundation.org
Subject: + slub-core-fix-object-counting.patch added to -mm tree
Date: Tue, 10 Apr 2007 12:34:34 -0700
Message-ID: <200704101934.l3AJYYGV015624@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42659 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789AbXDJTei (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 15:34:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     slub: fix object counting
has been added to the -mm tree.  Its filename is
     slub-core-fix-object-counting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slub: fix object counting
From: Christoph Lameter <clameter@sgi.com>

Object counting did not take into account that the number of full slabs is the
total number of slabs - number of partial - number of cpu slabs.  As a results
the counts were off a bit.  This issue surfaced when slab validation was
implemented.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   61 ++++++++++++++++++++++++++++------------------------
 1 files changed, 34 insertions(+), 27 deletions(-)

diff -puN mm/slub.c~slub-core-fix-object-counting mm/slub.c
--- a/mm/slub.c~slub-core-fix-object-counting
+++ a/mm/slub.c
@@ -2348,23 +2348,34 @@ static unsigned long slab_objects(struct
 	int node;
 	int x;
 	unsigned long *nodes;
+	unsigned long *per_cpu;
 
-	nodes = kmalloc(sizeof(unsigned long) * nr_node_ids, GFP_KERNEL);
+	nodes = kzalloc(2 * sizeof(unsigned long) * nr_node_ids, GFP_KERNEL);
+	per_cpu = nodes + nr_node_ids;
+
+	for_each_possible_cpu(cpu) {
+		struct page *page = s->cpu_slab[cpu];
+		int node;
+
+		if (page) {
+			node = page_to_nid(page);
+			if (flags & SO_CPU) {
+				int x = 0;
+
+				if (flags & SO_OBJECTS)
+					x = page->inuse;
+				else
+					x = 1;
+				total += x;
+				nodes[node] += x;
+			}
+			per_cpu[node]++;
+		}
+	}
 
 	for_each_online_node(node) {
 		struct kmem_cache_node *n = get_node(s, node);
 
-		nodes[node] = 0;
-
-		if (flags & SO_FULL) {
-			if (flags & SO_OBJECTS)
-				x = atomic_read(&n->nr_slabs)
-						* s->objects;
-			else
-				x = atomic_read(&n->nr_slabs);
-			total += x;
-			nodes[node] += x;
-		}
 		if (flags & SO_PARTIAL) {
 			if (flags & SO_OBJECTS)
 				x = count_partial(n);
@@ -2373,24 +2384,20 @@ static unsigned long slab_objects(struct
 			total += x;
 			nodes[node] += x;
 		}
-	}
-
-	if (flags & SO_CPU)
-		for_each_possible_cpu(cpu) {
-			struct page *page = s->cpu_slab[cpu];
 
-			if (page) {
-				int x = 0;
-				int node = page_to_nid(page);
+		if (flags & SO_FULL) {
+			int full_slabs = atomic_read(&n->nr_slabs)
+					- per_cpu[node]
+					- n->nr_partial;
 
-				if (flags & SO_OBJECTS)
-					x = page->inuse;
-				else
-					x = 1;
-				total += x;
-				nodes[node] += x;
-			}
+			if (flags & SO_OBJECTS)
+				x = full_slabs * s->objects;
+			else
+				x = full_slabs;
+			total += x;
+			nodes[node] += x;
 		}
+	}
 
 	x = sprintf(buf, "%lu", total);
 #ifdef CONFIG_NUMA
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-fix-numa-bootstrap.patch
slub-use-correct-flags-to-check-for-dma-cache.patch
slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment.patch
slub-core-minor-fixes.patch
slub-core-use-enum-for-tracking-modes-instead-of-integers.patch
slub-core-fix-another-numa-bootstrap-issue.patch
slub-core-fix-object-counting.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
make-page-private-usable-in-compound-pages-v1.patch
make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
enable-tracking-of-full-slabs.patch
validation-of-slabs-metadata-and-guard-zones.patch
add-ability-to-list-alloc--free-callers-per-slab.patch
drop-version-number.patch
quicklists-for-page-table-pages.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
extend-print_symbol-capability-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
