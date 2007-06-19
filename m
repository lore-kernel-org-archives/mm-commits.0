From: akpm@linux-foundation.org
Subject: + slub-fix-behavior-if-the-text-output-of-list_locations-overflows-page_size.patch added to -mm tree
Date: Tue, 19 Jun 2007 12:52:05 -0700
Message-ID: <200706191952.l5JJq5tF019673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34087 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761182AbXFSTwN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 15:52:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: fix behavior if the text output of list_locations overflows PAGE_SIZE
has been added to the -mm tree.  Its filename is
     slub-fix-behavior-if-the-text-output-of-list_locations-overflows-page_size.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: fix behavior if the text output of list_locations overflows PAGE_SIZE
From: Christoph Lameter <clameter@sgi.com>

If slabs are allocated or freed from a large set of call sites (typical for
the kmalloc area) then we may create more output than fits into a single
PAGE and sysfs only gives us one page.  The output should be truncated. 
This patch fixes the checks to do the truncation properly.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/slub.c~slub-fix-behavior-if-the-text-output-of-list_locations-overflows-page_size mm/slub.c
--- a/mm/slub.c~slub-fix-behavior-if-the-text-output-of-list_locations-overflows-page_size
+++ a/mm/slub.c
@@ -3042,13 +3042,15 @@ static int list_locations(struct kmem_ca
 			n += sprintf(buf + n, " pid=%ld",
 				l->min_pid);
 
-		if (num_online_cpus() > 1 && !cpus_empty(l->cpus)) {
+		if (num_online_cpus() > 1 && !cpus_empty(l->cpus) &&
+				n < PAGE_SIZE - 60) {
 			n += sprintf(buf + n, " cpus=");
 			n += cpulist_scnprintf(buf + n, PAGE_SIZE - n - 50,
 					l->cpus);
 		}
 
-		if (num_online_nodes() > 1 && !nodes_empty(l->nodes)) {
+		if (num_online_nodes() > 1 && !nodes_empty(l->nodes) &&
+				n < PAGE_SIZE - 60) {
 			n += sprintf(buf + n, " nodes=");
 			n += nodelist_scnprintf(buf + n, PAGE_SIZE - n - 50,
 					l->nodes);
_

Patches currently in -mm which might be from clameter@sgi.com are

slub-fix-behavior-if-the-text-output-of-list_locations-overflows-page_size.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
make-proc-slabinfo-use-seq_list_xxx-helpers-fix.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
slub-support-slub_debug-on-by-default.patch
slub-support-slub_debug-on-by-default-tidy.patch
numa-mempolicy-dynamic-interleave-map-for-system-init.patch
gfph-gfp_thisnode-can-go-to-other-nodes-if-some-are-unpopulated.patch
numa-mempolicy-trivial-debug-fixes.patch
add-populated_map-to-account-for-memoryless-nodes.patch
add-populated_map-to-account-for-memoryless-nodes-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely-fix.patch
slub-remove-useless-export_symbol.patch
slub-use-list_for_each_entry-for-loops-over-all-slabs.patch
slub-slab-validation-move-tracking-information-alloc-outside-of.patch
slub-ensure-that-the-object-per-slabs-stays-low-for-high-orders.patch
slub-debug-fix-initial-object-debug-state-of-numa-bootstrap-objects.patch
slab-allocators-consolidate-code-for-krealloc-in-mm-utilc.patch
slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics.patch
slab-allocators-support-__gfp_zero-in-all-allocators.patch
slab-allocators-cleanup-zeroing-allocations.patch
slab-allocators-replace-explicit-zeroing-with-__gfp_zero.patch
slub-add-some-more-inlines-and-ifdef-config_slub_debug.patch
slub-extract-dma_kmalloc_cache-from-get_cache.patch
slub-do-proper-locking-during-dma-slab-creation.patch
slub-faster-more-efficient-slab-determination-for-__kmalloc.patch
define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
