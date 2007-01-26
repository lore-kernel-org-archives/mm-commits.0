From: akpm@osdl.org
Subject: + drop-free_pages.patch added to -mm tree
Date: Thu, 25 Jan 2007 22:16:42 -0800
Message-ID: <200701260616.l0Q6GgKi009156@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47733 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030777AbXAZGQo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 01:16:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Drop free_pages()
has been added to the -mm tree.  Its filename is
     drop-free_pages.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Drop free_pages()
From: Christoph Lameter <clameter@sgi.com>

nr_free_pages is now a simple access to a global variable.  Make it a macro
instead of a function.

The nr_free_pages now requires vmstat.h to be included.  There is one
occurrence in power management where we need to add the include.  Directly
refrer to global_page_state() there to clarify why the #include was added.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/swap.h |    5 ++++-
 kernel/power/main.c  |    4 +++-
 mm/page_alloc.c      |   10 ----------
 3 files changed, 7 insertions(+), 12 deletions(-)

diff -puN include/linux/swap.h~drop-free_pages include/linux/swap.h
--- a/include/linux/swap.h~drop-free_pages
+++ a/include/linux/swap.h
@@ -170,11 +170,14 @@ extern void swapin_readahead(swp_entry_t
 extern unsigned long totalram_pages;
 extern unsigned long totalreserve_pages;
 extern long nr_swap_pages;
-extern unsigned int nr_free_pages(void);
 extern unsigned int nr_free_pages_pgdat(pg_data_t *pgdat);
 extern unsigned int nr_free_buffer_pages(void);
 extern unsigned int nr_free_pagecache_pages(void);
 
+/* Definition of global_page_state not available yet */
+#define nr_free_pages() global_page_state(NR_FREE_PAGES)
+
+
 /* linux/mm/swap.c */
 extern void FASTCALL(lru_cache_add(struct page *));
 extern void FASTCALL(lru_cache_add_active(struct page *));
diff -puN kernel/power/main.c~drop-free_pages kernel/power/main.c
--- a/kernel/power/main.c~drop-free_pages
+++ a/kernel/power/main.c
@@ -20,6 +20,7 @@
 #include <linux/cpu.h>
 #include <linux/resume-trace.h>
 #include <linux/freezer.h>
+#include <linux/vmstat.h>
 
 #include "power.h"
 
@@ -72,7 +73,8 @@ static int suspend_prepare(suspend_state
 		goto Thaw;
 	}
 
-	if ((free_pages = nr_free_pages()) < FREE_PAGE_NUMBER) {
+	if ((free_pages = global_page_state(NR_FREE_PAGES))
+			< FREE_PAGE_NUMBER) {
 		pr_debug("PM: free some memory\n");
 		shrink_all_memory(FREE_PAGE_NUMBER - free_pages);
 		if (nr_free_pages() < FREE_PAGE_NUMBER) {
diff -puN mm/page_alloc.c~drop-free_pages mm/page_alloc.c
--- a/mm/page_alloc.c~drop-free_pages
+++ a/mm/page_alloc.c
@@ -1441,16 +1441,6 @@ fastcall void free_pages(unsigned long a
 
 EXPORT_SYMBOL(free_pages);
 
-/*
- * Total amount of free (allocatable) RAM:
- */
-unsigned int nr_free_pages(void)
-{
-	return global_page_state(NR_FREE_PAGES);
-}
-
-EXPORT_SYMBOL(nr_free_pages);
-
 #ifdef CONFIG_NUMA
 unsigned int nr_free_pages_pgdat(pg_data_t *pgdat)
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
