From: akpm@linux-foundation.org
Subject: - use-parameter-passed-to-cache_reap-to-determine-pointer-to.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:46:00 -0800
Message-ID: <200702112246.l1BMk0x2015458@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59455 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932606AbXBKWqC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:46:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slab: use parameter passed to cache_reap to determine pointer to work structure
has been removed from the -mm tree.  Its filename was
     use-parameter-passed-to-cache_reap-to-determine-pointer-to.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab: use parameter passed to cache_reap to determine pointer to work structure
From: Christoph Lameter <clameter@sgi.com>

Use the pointer passed to cache_reap to determine the work pointer and
consolidate exit paths.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN mm/slab.c~use-parameter-passed-to-cache_reap-to-determine-pointer-to mm/slab.c
--- a/mm/slab.c~use-parameter-passed-to-cache_reap-to-determine-pointer-to
+++ a/mm/slab.c
@@ -4029,18 +4029,17 @@ void drain_array(struct kmem_cache *cach
  * If we cannot acquire the cache chain mutex then just give up - we'll try
  * again on the next iteration.
  */
-static void cache_reap(struct work_struct *unused)
+static void cache_reap(struct work_struct *w)
 {
 	struct kmem_cache *searchp;
 	struct kmem_list3 *l3;
 	int node = numa_node_id();
+	struct delayed_work *work =
+		container_of(w, struct delayed_work, work);
 
-	if (!mutex_trylock(&cache_chain_mutex)) {
+	if (!mutex_trylock(&cache_chain_mutex))
 		/* Give up. Setup the next iteration. */
-		schedule_delayed_work(&__get_cpu_var(reap_work),
-				      round_jiffies_relative(REAPTIMEOUT_CPUC));
-		return;
-	}
+		goto out;
 
 	list_for_each_entry(searchp, &cache_chain, next) {
 		check_irq_on();
@@ -4083,9 +4082,9 @@ next:
 	mutex_unlock(&cache_chain_mutex);
 	next_reap_node();
 	refresh_cpu_vm_stats(smp_processor_id());
+out:
 	/* Set up the next iteration */
-	schedule_delayed_work(&__get_cpu_var(reap_work),
-		round_jiffies_relative(REAPTIMEOUT_CPUC));
+	schedule_delayed_work(work, round_jiffies_relative(REAPTIMEOUT_CPUC));
 }
 
 #ifdef CONFIG_PROC_FS
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
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
