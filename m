From: akpm@linux-foundation.org
Subject: - drop-get_zone_counts.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:46:28 -0800
Message-ID: <200702112246.l1BMkSCh015494@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59505 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932617AbXBKWqa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:46:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Drop get_zone_counts()
has been removed from the -mm tree.  Its filename was
     drop-get_zone_counts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Drop get_zone_counts()
From: Christoph Lameter <clameter@sgi.com>

Values are available via ZVC sums.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c |    9 ++-------
 mm/page_alloc.c     |    9 ++-------
 mm/vmstat.c         |    8 --------
 3 files changed, 4 insertions(+), 22 deletions(-)

diff -puN fs/proc/proc_misc.c~drop-get_zone_counts fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~drop-get_zone_counts
+++ a/fs/proc/proc_misc.c
@@ -121,16 +121,11 @@ static int meminfo_read_proc(char *page,
 {
 	struct sysinfo i;
 	int len;
-	unsigned long inactive;
-	unsigned long active;
-	unsigned long free;
 	unsigned long committed;
 	unsigned long allowed;
 	struct vmalloc_info vmi;
 	long cached;
 
-	get_zone_counts(&active, &inactive, &free);
-
 /*
  * display in kilobytes.
  */
@@ -187,8 +182,8 @@ static int meminfo_read_proc(char *page,
 		K(i.bufferram),
 		K(cached),
 		K(total_swapcache_pages),
-		K(active),
-		K(inactive),
+		K(global_page_state(NR_ACTIVE)),
+		K(global_page_state(NR_INACTIVE)),
 #ifdef CONFIG_HIGHMEM
 		K(i.totalhigh),
 		K(i.freehigh),
diff -puN mm/page_alloc.c~drop-get_zone_counts mm/page_alloc.c
--- a/mm/page_alloc.c~drop-get_zone_counts
+++ a/mm/page_alloc.c
@@ -1524,9 +1524,6 @@ void si_meminfo_node(struct sysinfo *val
 void show_free_areas(void)
 {
 	int cpu;
-	unsigned long active;
-	unsigned long inactive;
-	unsigned long free;
 	struct zone *zone;
 
 	for_each_zone(zone) {
@@ -1550,12 +1547,10 @@ void show_free_areas(void)
 		}
 	}
 
-	get_zone_counts(&active, &inactive, &free);
-
 	printk("Active:%lu inactive:%lu dirty:%lu writeback:%lu unstable:%lu\n"
 		" free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",
-		active,
-		inactive,
+		global_page_state(NR_ACTIVE),
+		global_page_state(NR_INACTIVE),
 		global_page_state(NR_FILE_DIRTY),
 		global_page_state(NR_WRITEBACK),
 		global_page_state(NR_UNSTABLE_NFS),
diff -puN mm/vmstat.c~drop-get_zone_counts mm/vmstat.c
--- a/mm/vmstat.c~drop-get_zone_counts
+++ a/mm/vmstat.c
@@ -13,14 +13,6 @@
 #include <linux/module.h>
 #include <linux/cpu.h>
 
-void get_zone_counts(unsigned long *active,
-		unsigned long *inactive, unsigned long *free)
-{
-	*active = global_page_state(NR_ACTIVE);
-	*inactive = global_page_state(NR_INACTIVE);
-	*free = global_page_state(NR_FREE_PAGES);
-}
-
 #ifdef CONFIG_VM_EVENT_COUNTERS
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
 EXPORT_PER_CPU_SYMBOL(vm_event_states);
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
