From: akpm@linux-foundation.org
Subject: - fix-memory-hot-remove-not-configured-case.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:35:36 -0700
Message-ID: <200710162035.l9GKZaRP015074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34746 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965740AbXJPVce (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:32:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     fix memory hot remove not configured case.
has been removed from the -mm tree.  Its filename was
     fix-memory-hot-remove-not-configured-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 arch/ia64/mm/init.c            |    3 +-
 arch/powerpc/mm/mem.c          |   45 -------------------------------
 arch/sh/mm/init.c              |    6 ----
 arch/sparc64/mm/init.c         |    5 ---
 arch/x86/mm/init_32.c          |    5 ---
 arch/x86/mm/init_64.c          |    6 ----
 include/linux/memory_hotplug.h |   12 +-------
 mm/memory_hotplug.c            |    6 ++++
 8 files changed, 10 insertions(+), 78 deletions(-)

diff -puN arch/ia64/mm/init.c~fix-memory-hot-remove-not-configured-case arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~fix-memory-hot-remove-not-configured-case
+++ a/arch/ia64/mm/init.c
@@ -718,7 +718,7 @@ int arch_add_memory(int nid, u64 start, 
 
 	return ret;
 }
-
+#ifdef CONFIG_MEMORY_HOTREMOVE
 int remove_memory(u64 start, u64 size)
 {
 	unsigned long start_pfn, end_pfn;
@@ -734,4 +734,5 @@ out:
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
@@ -1961,9 +1961,4 @@ void online_page(struct page *page)
 	num_physpages++;
 }
 
-int remove_memory(u64 start, u64 size)
-{
-	return -EINVAL;
-}
-
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff -puN arch/x86/mm/init_32.c~fix-memory-hot-remove-not-configured-case arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~fix-memory-hot-remove-not-configured-case
+++ a/arch/x86/mm/init_32.c
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
diff -puN arch/x86/mm/init_64.c~fix-memory-hot-remove-not-configured-case arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~fix-memory-hot-remove-not-configured-case
+++ a/arch/x86/mm/init_64.c
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
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(remove_memory);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
git-sh.patch
memory-controller-make-charging-gfp-mask-aware-fix.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
add-irq-protection-in-the-percpu-counters-cpu-hotplug-callback-path.patch
