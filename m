From: akpm@linux-foundation.org
Subject: + fix-memory-hot-remove-not-configured-case.patch added to -mm tree
Date: Tue, 18 Sep 2007 19:24:55 -0700
Message-ID: <200709190224.l8J2OtOr002599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58392 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751359AbXISCZd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Sep 2007 22:25:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     fix memory hot remove not configured case.
has been added to the -mm tree.  Its filename is
     fix-memory-hot-remove-not-configured-case.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix memory hot remove not configured case.
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, arch dependent code around CONFIG_MEMORY_HOTREMOVE is a mess.
This patch cleans up them. This is against 2.6.23-rc6-mm1.

 - fix compile failure on ia64/ CONFIG_MEMORY_HOTPLUG && !CONFIG_MEMORY_HOTREMOVE case.
 - For !CONFIG_MEMORY_HOTREMOVE, add generic no-op remove_memory(),
   which returns -EINVAL.
 - removed remove_pages() only used in powerpc.
 - removed no-op remove_memory() in i386, sh, sparc64, x86_64.

 - only powerpc returns -ENOSYS at memory hot remove(no-op). changes it
   to return -EINVAL.

Note:
Currently, only ia64 supports CONFIG_MEMORY_HOTREMOVE. I welcome other
archs if there are requirements and testers.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mm/init.c            |    5 ---
 arch/ia64/mm/init.c            |    3 +-
 arch/powerpc/mm/mem.c          |   45 -------------------------------
 arch/sh/mm/init.c              |    6 ----
 arch/sparc64/mm/init.c         |    5 ---
 arch/x86_64/mm/init.c          |    6 ----
 include/linux/memory_hotplug.h |   12 +-------
 mm/memory_hotplug.c            |    6 ++++
 8 files changed, 10 insertions(+), 78 deletions(-)

diff -puN arch/i386/mm/init.c~fix-memory-hot-remove-not-configured-case arch/i386/mm/init.c
--- a/arch/i386/mm/init.c~fix-memory-hot-remove-not-configured-case
+++ a/arch/i386/mm/init.c
@@ -735,11 +735,6 @@ int arch_add_memory(int nid, u64 start, 
 	return __add_pages(zone, start_pfn, nr_pages);
 }
 
-int remove_memory(u64 start, u64 size)
-{
-	return -EINVAL;
-}
-EXPORT_SYMBOL_GPL(remove_memory);
 #endif
 
 struct kmem_cache *pmd_cache;
diff -puN arch/ia64/mm/init.c~fix-memory-hot-remove-not-configured-case arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~fix-memory-hot-remove-not-configured-case
+++ a/arch/ia64/mm/init.c
@@ -719,7 +719,7 @@ int arch_add_memory(int nid, u64 start, 
 
 	return ret;
 }
-
+#ifdef CONFIG_MEMORY_HOTREMOVE
 int remove_memory(u64 start, u64 size)
 {
 	unsigned long start_pfn, end_pfn;
@@ -735,4 +735,5 @@ out:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(remove_memory);
+#endif /* CONFIG_MEMORY_HOTREMOVE */
 #endif
diff -puN arch/powerpc/mm/mem.c~fix-memory-hot-remove-not-configured-case arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~fix-memory-hot-remove-not-configured-case
+++ a/arch/powerpc/mm/mem.c
@@ -129,51 +129,6 @@ int __devinit arch_add_memory(int nid, u
 	return __add_pages(zone, start_pfn, nr_pages);
 }
 
-/*
- * First pass at this code will check to determine if the remove
- * request is within the RMO.  Do not allow removal within the RMO.
- */
-int __devinit remove_memory(u64 start, u64 size)
-{
-	struct zone *zone;
-	unsigned long start_pfn, end_pfn, nr_pages;
-
-	start_pfn = start >> PAGE_SHIFT;
-	nr_pages = size >> PAGE_SHIFT;
-	end_pfn = start_pfn + nr_pages;
-
-	printk("%s(): Attempting to remove memoy in range "
-			"%lx to %lx\n", __func__, start, start+size);
-	/*
-	 * check for range within RMO
-	 */
-	zone = page_zone(pfn_to_page(start_pfn));
-
-	printk("%s(): memory will be removed from "
-			"the %s zone\n", __func__, zone->name);
-
-	/*
-	 * not handling removing memory ranges that
-	 * overlap multiple zones yet
-	 */
-	if (end_pfn > (zone->zone_start_pfn + zone->spanned_pages))
-		goto overlap;
-
-	/* make sure it is NOT in RMO */
-	if ((start < lmb.rmo_size) || ((start+size) < lmb.rmo_size)) {
-		printk("%s(): range to be removed must NOT be in RMO!\n",
-			__func__);
-		goto in_rmo;
-	}
-
-	return __remove_pages(zone, start_pfn, nr_pages);
-
-overlap:
-	printk("%s(): memory range to be removed overlaps "
-		"multiple zones!!!\n", __func__);
-in_rmo:
-	return -1;
-}
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 void show_mem(void)
diff -puN arch/sh/mm/init.c~fix-memory-hot-remove-not-configured-case arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~fix-memory-hot-remove-not-configured-case
+++ a/arch/sh/mm/init.c
@@ -294,12 +294,6 @@ int arch_add_memory(int nid, u64 start, 
 }
 EXPORT_SYMBOL_GPL(arch_add_memory);
 
-int remove_memory(u64 start, u64 size)
-{
-	return -EINVAL;
-}
-EXPORT_SYMBOL_GPL(remove_memory);
-
 #ifdef CONFIG_NUMA
 int memory_add_physaddr_to_nid(u64 addr)
 {
diff -puN arch/sparc64/mm/init.c~fix-memory-hot-remove-not-configured-case arch/sparc64/mm/init.c
--- a/arch/sparc64/mm/init.c~fix-memory-hot-remove-not-configured-case
+++ a/arch/sparc64/mm/init.c
@@ -1963,9 +1963,4 @@ void online_page(struct page *page)
 	num_physpages++;
 }
 
-int remove_memory(u64 start, u64 size)
-{
-	return -EINVAL;
-}
-
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff -puN arch/x86_64/mm/init.c~fix-memory-hot-remove-not-configured-case arch/x86_64/mm/init.c
--- a/arch/x86_64/mm/init.c~fix-memory-hot-remove-not-configured-case
+++ a/arch/x86_64/mm/init.c
@@ -474,12 +474,6 @@ error:
 }
 EXPORT_SYMBOL_GPL(arch_add_memory);
 
-int remove_memory(u64 start, u64 size)
-{
-	return -EINVAL;
-}
-EXPORT_SYMBOL_GPL(remove_memory);
-
 #if !defined(CONFIG_ACPI_NUMA) && defined(CONFIG_NUMA)
 int memory_add_physaddr_to_nid(u64 start)
 {
diff -puN include/linux/memory_hotplug.h~fix-memory-hot-remove-not-configured-case include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~fix-memory-hot-remove-not-configured-case
+++ a/include/linux/memory_hotplug.h
@@ -58,10 +58,9 @@ extern int add_one_highpage(struct page 
 extern void online_page(struct page *page);
 /* VM interface that may be used by firmware interface */
 extern int online_pages(unsigned long, unsigned long);
-#ifdef CONFIG_MEMORY_HOTREMOVE
-extern int offline_pages(unsigned long, unsigned long, unsigned long);
 extern void __offline_isolated_pages(unsigned long, unsigned long);
-#endif
+extern int offline_pages(unsigned long, unsigned long, unsigned long);
+
 /* reasonably generic interface to expand the physical pages in a zone  */
 extern int __add_pages(struct zone *zone, unsigned long start_pfn,
 	unsigned long nr_pages);
@@ -171,13 +170,6 @@ static inline int mhp_notimplemented(con
 }
 
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
-static inline int __remove_pages(struct zone *zone, unsigned long start_pfn,
-	unsigned long nr_pages)
-{
-	printk(KERN_WARNING "%s() called, not yet supported\n", __FUNCTION__);
-	dump_stack();
-	return -ENOSYS;
-}
 
 extern int add_memory(int nid, u64 start, u64 size);
 extern int arch_add_memory(int nid, u64 start, u64 size);
diff -puN mm/memory_hotplug.c~fix-memory-hot-remove-not-configured-case mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~fix-memory-hot-remove-not-configured-case
+++ a/mm/memory_hotplug.c
@@ -555,4 +555,10 @@ failed_removal:
 	undo_isolate_page_range(start_pfn, end_pfn);
 	return ret;
 }
+#else
+int remove_memory(u64 start, u64 size)
+{
+	return -ENOSYS;
+}
+EXPORT_SYMBOL_GPL(remove_memory);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

git-net.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-fix.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch
sparc64-sparsemem_vmemmap-support.patch
sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
update-n_high_memory-node-state-for-memory-hotadd.patch
memoryless-nodes-fix-interleave-behavior-for-memoryless-nodes.patch
memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly.patch
memoryless-nodes-no-need-for-kswapd.patch
memoryless-nodes-slab-support.patch
memoryless-nodes-slub-support.patch
memoryless-nodes-uncached-allocator-updates.patch
memoryless-nodes-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
memoryless-nodes-add-n_cpu-node-state.patch
memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-n_high_memory-for-cpusets.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix-update.patch
memory-unplug-v7-memory-hotplug-cleanup.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-unplug-v7-ia64-interface.patch
fix-memory-hot-remove-not-configured-case.patch
memory-controller-make-charging-gfp-mask-aware-fix.patch
