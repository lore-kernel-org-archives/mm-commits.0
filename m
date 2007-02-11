From: akpm@linux-foundation.org
Subject: - drop-free_pages.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:46:22 -0800
Message-ID: <200702112246.l1BMkMKS015485@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59493 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932617AbXBKWqY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:46:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Drop free_pages()
has been removed from the -mm tree.  Its filename was
     drop-free_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Drop free_pages()
From: Christoph Lameter <clameter@sgi.com>

nr_free_pages is now a simple access to a global variable.  Make it a macro
instead of a function.

The nr_free_pages now requires vmstat.h to be included.  There is one
occurrence in power management where we need to add the include.  Directly
refrer to global_page_state() there to clarify why the #include was added.

[akpm@osdl.org: arm build fix]
[akpm@osdl.org: sparc64 build fix]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/mm/init.c |    4 ++--
 include/linux/swap.h   |    5 ++++-
 include/linux/vmstat.h |    1 +
 kernel/power/main.c    |    4 +++-
 mm/page_alloc.c        |   10 ----------
 5 files changed, 10 insertions(+), 14 deletions(-)

diff -puN arch/sparc64/mm/init.c~drop-free_pages arch/sparc64/mm/init.c
--- a/arch/sparc64/mm/init.c~drop-free_pages
+++ a/arch/sparc64/mm/init.c
@@ -416,7 +416,7 @@ void show_mem(void)
 	printk("Free swap:       %6ldkB\n",
 	       nr_swap_pages << (PAGE_SHIFT-10));
 	printk("%ld pages of RAM\n", num_physpages);
-	printk("%d free pages\n", nr_free_pages());
+	printk("%lu free pages\n", nr_free_pages());
 }
 
 void mmu_info(struct seq_file *m)
@@ -1593,7 +1593,7 @@ void __init mem_init(void)
 	initpages = (((unsigned long) __init_end) - ((unsigned long) __init_begin));
 	initpages = PAGE_ALIGN(initpages) >> PAGE_SHIFT;
 
-	printk("Memory: %uk available (%ldk kernel code, %ldk data, %ldk init) [%016lx,%016lx]\n",
+	printk("Memory: %luk available (%ldk kernel code, %ldk data, %ldk init) [%016lx,%016lx]\n",
 	       nr_free_pages() << (PAGE_SHIFT-10),
 	       codepages << (PAGE_SHIFT-10),
 	       datapages << (PAGE_SHIFT-10), 
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
diff -puN include/linux/vmstat.h~drop-free_pages include/linux/vmstat.h
--- a/include/linux/vmstat.h~drop-free_pages
+++ a/include/linux/vmstat.h
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include <linux/percpu.h>
+#include <linux/mm.h>
 #include <linux/mmzone.h>
 #include <asm/atomic.h>
 
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
@@ -1440,16 +1440,6 @@ fastcall void free_pages(unsigned long a
 
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
