From: akpm@linux-foundation.org
Subject: + mm-hotplug-avoid-compiling-memory-hotremove-functions-when-disabled.patch added to -mm tree
Date: Wed, 10 Apr 2013 15:41:48 -0700
Message-ID: <20130410224148.9DBE231C15F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:62929 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761194Ab3DJWlu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Apr 2013 18:41:50 -0400
Received: by mail-ie0-f202.google.com with SMTP id x12so159314ief.5
        for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2013 15:41:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, benh@kernel.crashing.org, gregkh@linuxfoundation.org, isimatu.yasuaki@jp.fujitsu.com, paulus@samba.org, tangchen@cn.fujitsu.com, toshi.kani@hp.com, wency@cn.fujitsu.com


The patch titled
     Subject: mm, hotplug: avoid compiling memory hotremove functions when disabled
has been added to the -mm tree.  Its filename is
     mm-hotplug-avoid-compiling-memory-hotremove-functions-when-disabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, hotplug: avoid compiling memory hotremove functions when disabled

__remove_pages() is only necessary for CONFIG_MEMORY_HOTREMOVE.  PowerPC
pseries will return -EOPNOTSUPP if unsupported.

Adding an #ifdef causes several other functions it depends on to also
become unnecessary, which saves in .text when disabled (it's disabled in
most defconfigs besides powerpc, including x86).  remove_memory_block()
becomes static since it is not referenced outside of
drivers/base/memory.c.

Build tested on x86 and powerpc with CONFIG_MEMORY_HOTREMOVE both enabled
and disabled.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Toshi Kani <toshi.kani@hp.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/hotplug-memory.c |   12 ++
 drivers/base/memory.c                           |   44 ++++----
 include/linux/memory.h                          |    3 
 include/linux/memory_hotplug.h                  |    4 
 mm/memory_hotplug.c                             |   68 ++++++-------
 mm/sparse.c                                     |   72 +++++++-------
 6 files changed, 113 insertions(+), 90 deletions(-)

diff -puN arch/powerpc/platforms/pseries/hotplug-memory.c~mm-hotplug-avoid-compiling-memory-hotremove-functions-when-disabled arch/powerpc/platforms/pseries/hotplug-memory.c
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c~mm-hotplug-avoid-compiling-memory-hotremove-functions-when-disabled
+++ a/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -72,6 +72,7 @@ unsigned long memory_block_size_bytes(vo
 	return get_memblock_size();
 }
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
 static int pseries_remove_memblock(unsigned long base, unsigned int memblock_size)
 {
 	unsigned long start, start_pfn;
@@ -153,6 +154,17 @@ static int pseries_remove_memory(struct
 	ret = pseries_remove_memblock(base, lmb_size);
 	return ret;
 }
+#else
+static inline int pseries_remove_memblock(unsigned long base,
+					  unsigned int memblock_size)
+{
+	return -EOPNOTSUPP;
+}
+static inline int pseries_remove_memory(struct device_node *np)
+{
+	return -EOPNOTSUPP;
+}
+#endif /* CONFIG_MEMORY_HOTREMOVE */
 
 static int pseries_add_memory(struct device_node *np)
 {
diff -puN drivers/base/memory.c~mm-hotplug-avoid-compiling-memory-hotremove-functions-when-disabled drivers/base/memory.c
--- a/drivers/base/memory.c~mm-hotplug-avoid-compiling-memory-hotremove-functions-when-disabled
+++ a/drivers/base/memory.c
@@ -93,16 +93,6 @@ int register_memory(struct memory_block
 	return error;
 }
 
-static void
-unregister_memory(struct memory_block *memory)
-{
-	BUG_ON(memory->dev.bus != &memory_subsys);
-
-	/* drop the ref. we got in remove_memory_block() */
-	kobject_put(&memory->dev.kobj);
-	device_unregister(&memory->dev);
-}
-
 unsigned long __weak memory_block_size_bytes(void)
 {
 	return MIN_MEMORY_BLOCK_SIZE;
@@ -637,8 +627,28 @@ static int add_memory_section(int nid, s
 	return ret;
 }
 
-int remove_memory_block(unsigned long node_id, struct mem_section *section,
-		int phys_device)
+/*
+ * need an interface for the VM to add new memory regions,
+ * but without onlining it.
+ */
+int register_new_memory(int nid, struct mem_section *section)
+{
+	return add_memory_section(nid, section, NULL, MEM_OFFLINE, HOTPLUG);
+}
+
+#ifdef CONFIG_MEMORY_HOTREMOVE
+static void
+unregister_memory(struct memory_block *memory)
+{
+	BUG_ON(memory->dev.bus != &memory_subsys);
+
+	/* drop the ref. we got in remove_memory_block() */
+	kobject_put(&memory->dev.kobj);
+	device_unregister(&memory->dev);
+}
+
+static int remove_memory_block(unsigned long node_id,
+			       struct mem_section *section, int phys_device)
 {
 	struct memory_block *mem;
 
@@ -661,15 +671,6 @@ int remove_memory_block(unsigned long no
 	return 0;
 }
 
-/*
- * need an interface for the VM to add new memory regions,
- * but without onlining it.
- */
-int register_new_memory(int nid, struct mem_section *section)
-{
-	return add_memory_section(nid, section, NULL, MEM_OFFLINE, HOTPLUG);
-}
-
 int unregister_memory_section(struct mem_section *section)
 {
 	if (!present_section(section))
@@ -677,6 +678,7 @@ int unregister_memory_section(struct mem
 
 	return remove_memory_block(0, section, 0);
 }
+#endif /* CONFIG_MEMORY_HOTREMOVE */
 
 /*
  * offline one memory block. If the memory block has been offlined, do nothing.
diff -puN include/linux/memory.h~mm-hotplug-avoid-compiling-memory-hotremove-functions-when-disabled include/linux/memory.h
--- a/include/linux/memory.h~mm-hotplug-avoid-compiling-memory-hotremove-functions-when-disabled
+++ a/include/linux/memory.h
@@ -115,9 +115,10 @@ extern void unregister_memory_notifier(s
 extern int register_memory_isolate_notifier(struct notifier_block *nb);
 extern void unregister_memory_isolate_notifier(struct notifier_block *nb);
 extern int register_new_memory(int, struct mem_section *);
+#ifdef CONFIG_MEMORY_HOTREMOVE
 extern int unregister_memory_section(struct mem_section *);
+#endif
 extern int memory_dev_init(void);
-extern int remove_memory_block(unsigned long, struct mem_section *, int);
 extern int memory_notify(unsigned long val, void *v);
 extern int memory_isolate_notify(unsigned long val, void *v);
 extern struct memory_block *find_memory_block_hinted(struct mem_section *,
diff -puN include/linux/memory_hotplug.h~mm-hotplug-avoid-compiling-memory-hotremove-functions-when-disabled include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mm-hotplug-avoid-compiling-memory-hotremove-functions-when-disabled
+++ a/include/linux/memory_hotplug.h
@@ -97,13 +97,13 @@ extern void __online_page_free(struct pa
 #ifdef CONFIG_MEMORY_HOTREMOVE
 extern bool is_pageblock_removable_nolock(struct page *page);
 extern int arch_remove_memory(u64 start, u64 size);
+extern int __remove_pages(struct zone *zone, unsigned long start_pfn,
+	unsigned long nr_pages);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 /* reasonably generic interface to expand the physical pages in a zone  */
 extern int __add_pages(int nid, struct zone *zone, unsigned long start_pfn,
 	unsigned long nr_pages);
-extern int __remove_pages(struct zone *zone, unsigned long start_pfn,
-	unsigned long nr_pages);
 
 #ifdef CONFIG_NUMA
 extern int memory_add_physaddr_to_nid(u64 start);
diff -puN mm/memory_hotplug.c~mm-hotplug-avoid-compiling-memory-hotremove-functions-when-disabled mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-hotplug-avoid-compiling-memory-hotremove-functions-when-disabled
+++ a/mm/memory_hotplug.c
@@ -436,6 +436,40 @@ static int __meminit __add_section(int n
 	return register_new_memory(nid, __pfn_to_section(phys_start_pfn));
 }
 
+/*
+ * Reasonably generic function for adding memory.  It is
+ * expected that archs that support memory hotplug will
+ * call this function after deciding the zone to which to
+ * add the new pages.
+ */
+int __ref __add_pages(int nid, struct zone *zone, unsigned long phys_start_pfn,
+			unsigned long nr_pages)
+{
+	unsigned long i;
+	int err = 0;
+	int start_sec, end_sec;
+	/* during initialize mem_map, align hot-added range to section */
+	start_sec = pfn_to_section_nr(phys_start_pfn);
+	end_sec = pfn_to_section_nr(phys_start_pfn + nr_pages - 1);
+
+	for (i = start_sec; i <= end_sec; i++) {
+		err = __add_section(nid, zone, i << PFN_SECTION_SHIFT);
+
+		/*
+		 * EEXIST is finally dealt with by ioresource collision
+		 * check. see add_memory() => register_memory_resource()
+		 * Warning will be printed if there is collision.
+		 */
+		if (err && (err != -EEXIST))
+			break;
+		err = 0;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(__add_pages);
+
+#ifdef CONFIG_MEMORY_HOTREMOVE
 /* find the smallest valid pfn in the range [start_pfn, end_pfn) */
 static int find_smallest_section_pfn(int nid, struct zone *zone,
 				     unsigned long start_pfn,
@@ -658,39 +692,6 @@ static int __remove_section(struct zone
 	return 0;
 }
 
-/*
- * Reasonably generic function for adding memory.  It is
- * expected that archs that support memory hotplug will
- * call this function after deciding the zone to which to
- * add the new pages.
- */
-int __ref __add_pages(int nid, struct zone *zone, unsigned long phys_start_pfn,
-			unsigned long nr_pages)
-{
-	unsigned long i;
-	int err = 0;
-	int start_sec, end_sec;
-	/* during initialize mem_map, align hot-added range to section */
-	start_sec = pfn_to_section_nr(phys_start_pfn);
-	end_sec = pfn_to_section_nr(phys_start_pfn + nr_pages - 1);
-
-	for (i = start_sec; i <= end_sec; i++) {
-		err = __add_section(nid, zone, i << PFN_SECTION_SHIFT);
-
-		/*
-		 * EEXIST is finally dealt with by ioresource collision
-		 * check. see add_memory() => register_memory_resource()
-		 * Warning will be printed if there is collision.
-		 */
-		if (err && (err != -EEXIST))
-			break;
-		err = 0;
-	}
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(__add_pages);
-
 /**
  * __remove_pages() - remove sections of pages from a zone
  * @zone: zone from which pages need to be removed
@@ -733,6 +734,7 @@ int __remove_pages(struct zone *zone, un
 	return ret;
 }
 EXPORT_SYMBOL_GPL(__remove_pages);
+#endif /* CONFIG_MEMORY_HOTREMOVE */
 
 int set_online_page_callback(online_page_callback_t callback)
 {
diff -puN mm/sparse.c~mm-hotplug-avoid-compiling-memory-hotremove-functions-when-disabled mm/sparse.c
--- a/mm/sparse.c~mm-hotplug-avoid-compiling-memory-hotremove-functions-when-disabled
+++ a/mm/sparse.c
@@ -620,6 +620,7 @@ static void __kfree_section_memmap(struc
 
 	vmemmap_free(start, end);
 }
+#ifdef CONFIG_MEMORY_HOTREMOVE
 static void free_map_bootmem(struct page *memmap, unsigned long nr_pages)
 {
 	unsigned long start = (unsigned long)memmap;
@@ -627,6 +628,7 @@ static void free_map_bootmem(struct page
 
 	vmemmap_free(start, end);
 }
+#endif /* CONFIG_MEMORY_HOTREMOVE */
 #else
 static struct page *__kmalloc_section_memmap(unsigned long nr_pages)
 {
@@ -664,6 +666,7 @@ static void __kfree_section_memmap(struc
 			   get_order(sizeof(struct page) * nr_pages));
 }
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
 static void free_map_bootmem(struct page *memmap, unsigned long nr_pages)
 {
 	unsigned long maps_section_nr, removing_section_nr, i;
@@ -690,40 +693,9 @@ static void free_map_bootmem(struct page
 			put_page_bootmem(page);
 	}
 }
+#endif /* CONFIG_MEMORY_HOTREMOVE */
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
-static void free_section_usemap(struct page *memmap, unsigned long *usemap)
-{
-	struct page *usemap_page;
-	unsigned long nr_pages;
-
-	if (!usemap)
-		return;
-
-	usemap_page = virt_to_page(usemap);
-	/*
-	 * Check to see if allocation came from hot-plug-add
-	 */
-	if (PageSlab(usemap_page) || PageCompound(usemap_page)) {
-		kfree(usemap);
-		if (memmap)
-			__kfree_section_memmap(memmap, PAGES_PER_SECTION);
-		return;
-	}
-
-	/*
-	 * The usemap came from bootmem. This is packed with other usemaps
-	 * on the section which has pgdat at boot time. Just keep it as is now.
-	 */
-
-	if (memmap) {
-		nr_pages = PAGE_ALIGN(PAGES_PER_SECTION * sizeof(struct page))
-			>> PAGE_SHIFT;
-
-		free_map_bootmem(memmap, nr_pages);
-	}
-}
-
 /*
  * returns the number of sections whose mem_maps were properly
  * set.  If this is <=0, then that means that the passed-in
@@ -800,6 +772,39 @@ static inline void clear_hwpoisoned_page
 }
 #endif
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
+static void free_section_usemap(struct page *memmap, unsigned long *usemap)
+{
+	struct page *usemap_page;
+	unsigned long nr_pages;
+
+	if (!usemap)
+		return;
+
+	usemap_page = virt_to_page(usemap);
+	/*
+	 * Check to see if allocation came from hot-plug-add
+	 */
+	if (PageSlab(usemap_page) || PageCompound(usemap_page)) {
+		kfree(usemap);
+		if (memmap)
+			__kfree_section_memmap(memmap, PAGES_PER_SECTION);
+		return;
+	}
+
+	/*
+	 * The usemap came from bootmem. This is packed with other usemaps
+	 * on the section which has pgdat at boot time. Just keep it as is now.
+	 */
+
+	if (memmap) {
+		nr_pages = PAGE_ALIGN(PAGES_PER_SECTION * sizeof(struct page))
+			>> PAGE_SHIFT;
+
+		free_map_bootmem(memmap, nr_pages);
+	}
+}
+
 void sparse_remove_one_section(struct zone *zone, struct mem_section *ms)
 {
 	struct page *memmap = NULL;
@@ -819,4 +824,5 @@ void sparse_remove_one_section(struct zo
 	clear_hwpoisoned_pages(memmap, PAGES_PER_SECTION);
 	free_section_usemap(memmap, usemap);
 }
-#endif
+#endif /* CONFIG_MEMORY_HOTREMOVE */
+#endif /* CONFIG_MEMORY_HOTPLUG */
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
hugetlbfs-stop-setting-vm_dontdump-in-initializing-vmavm_hugetlb.patch
fix-hugetlb-memory-check-in-vma_dump_size.patch
hugetlbfs-add-swap-entry-check-in-follow_hugetlb_page.patch
mm-show_mem-suppress-page-counts-in-non-blockable-contexts.patch
mm-hugetlb-include-hugepages-in-meminfo.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
mm-speedup-in-__early_pfn_to_nid.patch
mm-speedup-in-__early_pfn_to_nid-fix.patch
thp-fix-comment-about-memory-barrier.patch
resource-add-__adjust_resource-for-internal-use.patch
resource-add-release_mem_region_adjustable.patch
resource-add-release_mem_region_adjustable-fix.patch
resource-add-release_mem_region_adjustable-fix-fix.patch
mm-change-__remove_pages-to-call-release_mem_region_adjustable.patch
mm-hotplug-avoid-compiling-memory-hotremove-functions-when-disabled.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch
fs-proc-truncate-proc-pid-comm-writes-to-first-task_comm_len-bytes.patch

