From: akpm@linux-foundation.org
Subject: - sched-fix-next_interval-determination-in-idle_balance.patch removed from -mm tree
Date: Mon, 25 Jun 2007 02:20:50 -0700
Message-ID: <200706250920.l5P9KoLY031052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35092 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751335AbXFYJVM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 05:21:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mingo@elte.hu, paulmck@linux.vnet.ibm.com, stable@kernel.org, vatsa@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     sched: fix next_interval determination in idle_balance()
has been removed from the -mm tree.  Its filename was
     sched-fix-next_interval-determination-in-idle_balance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: fix next_interval determination in idle_balance()
From: Christoph Lameter <clameter@sgi.com>

The intervals of domains that do not have SD_BALANCE_NEWIDLE must be
considered for the calculation of the time of the next balance.  Otherwise
we may defer rebalancing forever.

Siddha also spotted that the conversion of the balance interval
to jiffies is missing. Fix that to.


also continue the loop if !(sd->flags & SD_LOAD_BALANCE).

Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

It did in fact trigger under all three of mainline, CFS, and -rt including CFS
-- see below for a couple of emails from last Friday giving results for these
three on the AMD box (where it happened) and on a single-quad NUMA-Q system
(where it did not, at least not with such severity).

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff -puN kernel/sched.c~sched-fix-next_interval-determination-in-idle_balance kernel/sched.c
--- a/kernel/sched.c~sched-fix-next_interval-determination-in-idle_balance
+++ a/kernel/sched.c
@@ -2938,17 +2938,21 @@ static void idle_balance(int this_cpu, s
 	unsigned long next_balance = jiffies + 60 *  HZ;
 
 	for_each_domain(this_cpu, sd) {
-		if (sd->flags & SD_BALANCE_NEWIDLE) {
+		unsigned long interval;
+
+		if (!(sd->flags & SD_LOAD_BALANCE))
+			continue;
+
+		if (sd->flags & SD_BALANCE_NEWIDLE)
 			/* If we've pulled tasks over stop searching: */
 			pulled_task = load_balance_newidle(this_cpu,
-							this_rq, sd);
-			if (time_after(next_balance,
-				  sd->last_balance + sd->balance_interval))
-				next_balance = sd->last_balance
-						+ sd->balance_interval;
-			if (pulled_task)
-				break;
-		}
+								this_rq, sd);
+
+		interval = msecs_to_jiffies(sd->balance_interval);
+		if (time_after(next_balance, sd->last_balance + interval))
+			next_balance = sd->last_balance + interval;
+		if (pulled_task)
+			break;
 	}
 	if (!pulled_task)
 		/*
_

Patches currently in -mm which might be from clameter@sgi.com are

git-ubi.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
pa-risc-use-page-allocator-instead-of-slab-allocator-fix.patch
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
numa-mempolicy-trivial-debug-fixes.patch
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
slub-faster-more-efficient-slab-determination-for-__kmalloc-fix.patch
add-vm_bug_on-in-case-someone-uses-page_mapping-on-a-slab-page.patch
define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
