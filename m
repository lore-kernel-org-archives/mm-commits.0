From: akpm@osdl.org
Subject: + drop-get_zone_counts.patch added to -mm tree
Date: Thu, 25 Jan 2007 22:16:46 -0800
Message-ID: <200701260616.l0Q6GkFx009165@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47743 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030782AbXAZGQs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 01:16:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Drop get_zone_counts()
has been added to the -mm tree.  Its filename is
     drop-get_zone_counts.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Drop get_zone_counts()
From: Christoph Lameter <clameter@sgi.com>

Values are available via ZVC sums.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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
 	printk("Active:%lu inactive:%lu dirty:%lu writeback:%lu "
 		"unstable:%lu free:%lu slab:%lu mapped:%lu pagetables:%lu\n",
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

mbind-restrict-nodes-to-the-currently-allowed-cpuset.patch
slab-cache_grow-cleanup.patch
use-zvc-for-inactive-and-active-counts.patch
use-zvc-for-free_pages.patch
reorder-zvcs-according-to-cacheline.patch
drop-free_pages.patch
drop-nr_free_pages_pgdat.patch
drop-__get_zone_counts.patch
drop-get_zone_counts.patch
fix-writeback-calculation.patch
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
replace-highest_possible_node_id-with-nr_node_ids.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
