From: akpm@linux-foundation.org
Subject: - convert-highest_possible_processor_id-to-nr_cpu_ids-fix.patch removed from -mm tree
Date: Tue, 20 Feb 2007 13:22:30 -0800
Message-ID: <200702202123.l1KLNtU7020121@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49897 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030433AbXBTVX6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Feb 2007 16:23:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     non SMP -> nr_cpu_ids must be one
has been removed from the -mm tree.  Its filename was
     convert-highest_possible_processor_id-to-nr_cpu_ids-fix.patch

This patch was dropped because it was folded into convert-highest_possible_processor_id-to-nr_cpu_ids.patch

------------------------------------------------------
Subject: non SMP -> nr_cpu_ids must be one
From: Christoph Lameter <clameter@sgi.com>

!SMP means that we have one processor.  Which means that we also have one
processor id.  Wonder why "any_online_cpu" is 0 but then it has worked so
far.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/cpumask.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/cpumask.h~convert-highest_possible_processor_id-to-nr_cpu_ids-fix include/linux/cpumask.h
--- a/include/linux/cpumask.h~convert-highest_possible_processor_id-to-nr_cpu_ids-fix
+++ a/include/linux/cpumask.h
@@ -402,7 +402,7 @@ extern int nr_cpu_ids;
 #define any_online_cpu(mask) __any_online_cpu(&(mask))
 int __any_online_cpu(const cpumask_t *mask);
 #else
-#define nr_cpu_ids			0
+#define nr_cpu_ids			1
 #define any_online_cpu(mask)		0
 #endif
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
fix-mempolicys-check-on-a-system-with-memory-less-node.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids-fix.patch
slab-reduce-size-of-alien-cache-to-cover-only-possible-nodes.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
mm-implement-swap-prefetching-vs-zvc-stuff.patch
mm-implement-swap-prefetching-vs-zvc-stuff-2.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-aging-accounting-vs-zvc-changes.patch
