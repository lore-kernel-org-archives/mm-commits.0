From: akpm@osdl.org
Subject: + drop-__get_zone_counts.patch added to -mm tree
Date: Thu, 25 Jan 2007 22:16:45 -0800
Message-ID: <200701260616.l0Q6Gjme009162@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47740 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030783AbXAZGQr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 01:16:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Drop __get_zone_counts()
has been added to the -mm tree.  Its filename is
     drop-__get_zone_counts.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Drop __get_zone_counts()
From: Christoph Lameter <clameter@sgi.com>

Values are readily available via ZVC per node and global sums.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/base/node.c    |    9 ++-------
 include/linux/mmzone.h |    2 --
 mm/readahead.c         |    8 ++------
 mm/vmstat.c            |    8 --------
 4 files changed, 4 insertions(+), 23 deletions(-)

diff -puN drivers/base/node.c~drop-__get_zone_counts drivers/base/node.c
--- a/drivers/base/node.c~drop-__get_zone_counts
+++ a/drivers/base/node.c
@@ -40,13 +40,8 @@ static ssize_t node_read_meminfo(struct 
 	int n;
 	int nid = dev->id;
 	struct sysinfo i;
-	unsigned long inactive;
-	unsigned long active;
-	unsigned long free;
 
 	si_meminfo_node(&i, nid);
-	__get_zone_counts(&active, &inactive, &free, NODE_DATA(nid));
-
 
 	n = sprintf(buf, "\n"
 		       "Node %d MemTotal:     %8lu kB\n"
@@ -74,8 +69,8 @@ static ssize_t node_read_meminfo(struct 
 		       nid, K(i.totalram),
 		       nid, K(i.freeram),
 		       nid, K(i.totalram - i.freeram),
-		       nid, K(active),
-		       nid, K(inactive),
+		       nid, node_page_state(nid, NR_ACTIVE),
+		       nid, node_page_state(nid, NR_INACTIVE),
 #ifdef CONFIG_HIGHMEM
 		       nid, K(i.totalhigh),
 		       nid, K(i.freehigh),
diff -puN include/linux/mmzone.h~drop-__get_zone_counts include/linux/mmzone.h
--- a/include/linux/mmzone.h~drop-__get_zone_counts
+++ a/include/linux/mmzone.h
@@ -444,8 +444,6 @@ typedef struct pglist_data {
 
 #include <linux/memory_hotplug.h>
 
-void __get_zone_counts(unsigned long *active, unsigned long *inactive,
-			unsigned long *free, struct pglist_data *pgdat);
 void get_zone_counts(unsigned long *active, unsigned long *inactive,
 			unsigned long *free);
 void build_all_zonelists(void);
diff -puN mm/readahead.c~drop-__get_zone_counts mm/readahead.c
--- a/mm/readahead.c~drop-__get_zone_counts
+++ a/mm/readahead.c
@@ -574,10 +574,6 @@ void handle_ra_miss(struct address_space
  */
 unsigned long max_sane_readahead(unsigned long nr)
 {
-	unsigned long active;
-	unsigned long inactive;
-	unsigned long free;
-
-	__get_zone_counts(&active, &inactive, &free, NODE_DATA(numa_node_id()));
-	return min(nr, (inactive + free) / 2);
+	return min(nr, (node_page_state(numa_node_id(), NR_INACTIVE)
+		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
 }
diff -puN mm/vmstat.c~drop-__get_zone_counts mm/vmstat.c
--- a/mm/vmstat.c~drop-__get_zone_counts
+++ a/mm/vmstat.c
@@ -13,14 +13,6 @@
 #include <linux/module.h>
 #include <linux/cpu.h>
 
-void __get_zone_counts(unsigned long *active, unsigned long *inactive,
-			unsigned long *free, struct pglist_data *pgdat)
-{
-	*active = node_page_state(pgdat->node_id, NR_ACTIVE);
-	*inactive = node_page_state(pgdat->node_id, NR_INACTIVE);
-	*free = node_page_state(pgdat->node_id, NR_FREE_PAGES);
-}
-
 void get_zone_counts(unsigned long *active,
 		unsigned long *inactive, unsigned long *free)
 {
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
