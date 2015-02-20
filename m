From: akpm@linux-foundation.org
Subject: + mm-hide-per-cpu-lists-in-output-of-show_mem.patch added to -mm
 tree
Date: Fri, 20 Feb 2015 13:46:07 -0800
Message-ID: <54e7ab1f.VgStcKquviQWBxDf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107AbbBTVqI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Feb 2015 16:46:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hide per-cpu lists in output of show_mem()
has been added to the -mm tree.  Its filename is
     mm-hide-per-cpu-lists-in-output-of-show_mem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hide-per-cpu-lists-in-output-of-show_mem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hide-per-cpu-lists-in-output-of-show_mem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: mm: hide per-cpu lists in output of show_mem()

This makes show_mem() much less verbose on huge machines.  Instead of huge
and almost useless dump of counters for each per-zone per-cpu lists this
patch prints the sum of these counters for each zone (free_pcp) and size
of per-cpu list for current cpu (local_pcp).

The filter flag SHOW_MEM_PERCPU_LISTS reverts to the old verbose mode.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 mm/page_alloc.c    |   32 +++++++++++++++++++++++++-------
 2 files changed, 26 insertions(+), 7 deletions(-)

diff -puN include/linux/mm.h~mm-hide-per-cpu-lists-in-output-of-show_mem include/linux/mm.h
--- a/include/linux/mm.h~mm-hide-per-cpu-lists-in-output-of-show_mem
+++ a/include/linux/mm.h
@@ -1126,6 +1126,7 @@ extern void pagefault_out_of_memory(void
  * various contexts.
  */
 #define SHOW_MEM_FILTER_NODES		(0x0001u)	/* disallowed nodes */
+#define SHOW_MEM_PERCPU_LISTS		(0x0002u)	/* per-zone per-cpu */
 
 extern void show_free_areas(unsigned int flags);
 extern bool skip_free_areas_node(unsigned int flags, int nid);
diff -puN mm/page_alloc.c~mm-hide-per-cpu-lists-in-output-of-show_mem mm/page_alloc.c
--- a/mm/page_alloc.c~mm-hide-per-cpu-lists-in-output-of-show_mem
+++ a/mm/page_alloc.c
@@ -3248,20 +3248,29 @@ static void show_migration_types(unsigne
  */
 void show_free_areas(unsigned int filter)
 {
+	unsigned long free_pcp = 0;
 	int cpu;
 	struct zone *zone;
 
 	for_each_populated_zone(zone) {
 		if (skip_free_areas_node(filter, zone_to_nid(zone)))
 			continue;
-		show_node(zone);
-		printk("%s per-cpu:\n", zone->name);
+
+		if (filter & SHOW_MEM_PERCPU_LISTS) {
+			show_node(zone);
+			printk("%s per-cpu:\n", zone->name);
+		}
 
 		for_each_online_cpu(cpu) {
 			struct per_cpu_pageset *pageset;
 
 			pageset = per_cpu_ptr(zone->pageset, cpu);
 
+			free_pcp += pageset->pcp.count;
+
+			if (!(filter & SHOW_MEM_PERCPU_LISTS))
+				continue;
+
 			printk("CPU %4d: hi:%5d, btch:%4d usd:%4d\n",
 			       cpu, pageset->pcp.high,
 			       pageset->pcp.batch, pageset->pcp.count);
@@ -3270,11 +3279,10 @@ void show_free_areas(unsigned int filter
 
 	printk("active_anon:%lu inactive_anon:%lu isolated_anon:%lu\n"
 		" active_file:%lu inactive_file:%lu isolated_file:%lu\n"
-		" unevictable:%lu"
-		" dirty:%lu writeback:%lu unstable:%lu\n"
-		" free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
+		" unevictable:%lu dirty:%lu writeback:%lu unstable:%lu\n"
+		" slab_reclaimable:%lu slab_unreclaimable:%lu\n"
 		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n"
-		" free_cma:%lu\n",
+		" free:%lu free_pcp:%lu free_cma:%lu\n",
 		global_page_state(NR_ACTIVE_ANON),
 		global_page_state(NR_INACTIVE_ANON),
 		global_page_state(NR_ISOLATED_ANON),
@@ -3285,13 +3293,14 @@ void show_free_areas(unsigned int filter
 		global_page_state(NR_FILE_DIRTY),
 		global_page_state(NR_WRITEBACK),
 		global_page_state(NR_UNSTABLE_NFS),
-		global_page_state(NR_FREE_PAGES),
 		global_page_state(NR_SLAB_RECLAIMABLE),
 		global_page_state(NR_SLAB_UNRECLAIMABLE),
 		global_page_state(NR_FILE_MAPPED),
 		global_page_state(NR_SHMEM),
 		global_page_state(NR_PAGETABLE),
 		global_page_state(NR_BOUNCE),
+		global_page_state(NR_FREE_PAGES),
+		free_pcp,
 		global_page_state(NR_FREE_CMA_PAGES));
 
 	for_each_populated_zone(zone) {
@@ -3299,6 +3308,11 @@ void show_free_areas(unsigned int filter
 
 		if (skip_free_areas_node(filter, zone_to_nid(zone)))
 			continue;
+
+		free_pcp = 0;
+		for_each_online_cpu(cpu)
+			free_pcp += per_cpu_ptr(zone->pageset, cpu)->pcp.count;
+
 		show_node(zone);
 		printk("%s"
 			" free:%lukB"
@@ -3325,6 +3339,8 @@ void show_free_areas(unsigned int filter
 			" pagetables:%lukB"
 			" unstable:%lukB"
 			" bounce:%lukB"
+			" free_pcp:%lukB"
+			" local_pcp:%ukB"
 			" free_cma:%lukB"
 			" writeback_tmp:%lukB"
 			" pages_scanned:%lu"
@@ -3356,6 +3372,8 @@ void show_free_areas(unsigned int filter
 			K(zone_page_state(zone, NR_PAGETABLE)),
 			K(zone_page_state(zone, NR_UNSTABLE_NFS)),
 			K(zone_page_state(zone, NR_BOUNCE)),
+			K(free_pcp),
+			K(this_cpu_read(zone->pageset->pcp.count)),
 			K(zone_page_state(zone, NR_FREE_CMA_PAGES)),
 			K(zone_page_state(zone, NR_WRITEBACK_TEMP)),
 			K(zone_page_state(zone, NR_PAGES_SCANNED)),
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

origin.patch
page_writeback-cleanup-mess-around-cancel_dirty_page.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch

