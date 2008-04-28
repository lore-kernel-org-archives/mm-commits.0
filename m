From: akpm@linux-foundation.org
Subject: - hotplug-memory-remove-generic-__remove_pages-support.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:50:29 -0700
Message-ID: <200804282150.m3SLoTNx017478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934614AbYD1VvH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:51:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@us.ibm.com, benh@kernel.crashing.org, paulus@samba.org, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     hotplug memory remove: generic __remove_pages() support
has been removed from the -mm tree.  Its filename was
     hotplug-memory-remove-generic-__remove_pages-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hotplug memory remove: generic __remove_pages() support
From: Badari Pulavarty <pbadari@us.ibm.com>

Generic helper function to remove section mappings and sysfs entries for the
section of the memory we are removing.  offline_pages() correctly adjusted
zone and marked the pages reserved.

TODO: Yasunori Goto is working on patches to free up allocations from bootmem.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    6 ++-
 mm/memory_hotplug.c            |   55 +++++++++++++++++++++++++++++++
 mm/sparse.c                    |   45 +++++++++++++++++++++++--
 3 files changed, 102 insertions(+), 4 deletions(-)

diff -puN include/linux/memory_hotplug.h~hotplug-memory-remove-generic-__remove_pages-support include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~hotplug-memory-remove-generic-__remove_pages-support
+++ a/include/linux/memory_hotplug.h
@@ -8,6 +8,7 @@
 struct page;
 struct zone;
 struct pglist_data;
+struct mem_section;
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 /*
@@ -64,9 +65,11 @@ extern int offline_pages(unsigned long, 
 /* reasonably generic interface to expand the physical pages in a zone  */
 extern int __add_pages(struct zone *zone, unsigned long start_pfn,
 	unsigned long nr_pages);
+extern int __remove_pages(struct zone *zone, unsigned long start_pfn,
+	unsigned long nr_pages);
 
 /*
- * Walk thorugh all memory which is registered as resource.
+ * Walk through all memory which is registered as resource.
  * arg is (start_pfn, nr_pages, private_arg_pointer)
  */
 extern int walk_memory_resource(unsigned long start_pfn,
@@ -176,5 +179,6 @@ extern int arch_add_memory(int nid, u64 
 extern int remove_memory(u64 start, u64 size);
 extern int sparse_add_one_section(struct zone *zone, unsigned long start_pfn,
 								int nr_pages);
+extern void sparse_remove_one_section(struct zone *zone, struct mem_section *ms);
 
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
diff -puN mm/memory_hotplug.c~hotplug-memory-remove-generic-__remove_pages-support mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~hotplug-memory-remove-generic-__remove_pages-support
+++ a/mm/memory_hotplug.c
@@ -101,6 +101,25 @@ static int __add_section(struct zone *zo
 	return register_new_memory(__pfn_to_section(phys_start_pfn));
 }
 
+static int __remove_section(struct zone *zone, struct mem_section *ms)
+{
+	unsigned long flags;
+	struct pglist_data *pgdat = zone->zone_pgdat;
+	int ret = -EINVAL;
+
+	if (!valid_section(ms))
+		return ret;
+
+	ret = unregister_memory_section(ms);
+	if (ret)
+		return ret;
+
+	pgdat_resize_lock(pgdat, &flags);
+	sparse_remove_one_section(zone, ms);
+	pgdat_resize_unlock(pgdat, &flags);
+	return 0;
+}
+
 /*
  * Reasonably generic function for adding memory.  It is
  * expected that archs that support memory hotplug will
@@ -134,6 +153,42 @@ int __add_pages(struct zone *zone, unsig
 }
 EXPORT_SYMBOL_GPL(__add_pages);
 
+/**
+ * __remove_pages() - remove sections of pages from a zone
+ * @zone: zone from which pages need to be removed
+ * @phys_start_pfn: starting pageframe (must be aligned to start of a section)
+ * @nr_pages: number of pages to remove (must be multiple of section size)
+ *
+ * Generic helper function to remove section mappings and sysfs entries
+ * for the section of the memory we are removing. Caller needs to make
+ * sure that pages are marked reserved and zones are adjust properly by
+ * calling offline_pages().
+ */
+int __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
+		 unsigned long nr_pages)
+{
+	unsigned long i, ret = 0;
+	int sections_to_remove;
+
+	/*
+	 * We can only remove entire sections
+	 */
+	BUG_ON(phys_start_pfn & ~PAGE_SECTION_MASK);
+	BUG_ON(nr_pages % PAGES_PER_SECTION);
+
+	release_mem_region(phys_start_pfn << PAGE_SHIFT, nr_pages * PAGE_SIZE);
+
+	sections_to_remove = nr_pages / PAGES_PER_SECTION;
+	for (i = 0; i < sections_to_remove; i++) {
+		unsigned long pfn = phys_start_pfn + i*PAGES_PER_SECTION;
+		ret = __remove_section(zone, __pfn_to_section(pfn));
+		if (ret)
+			break;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__remove_pages);
+
 static void grow_zone_span(struct zone *zone,
 		unsigned long start_pfn, unsigned long end_pfn)
 {
diff -puN mm/sparse.c~hotplug-memory-remove-generic-__remove_pages-support mm/sparse.c
--- a/mm/sparse.c~hotplug-memory-remove-generic-__remove_pages-support
+++ a/mm/sparse.c
@@ -208,12 +208,13 @@ static unsigned long sparse_encode_mem_m
 }
 
 /*
- * We need this if we ever free the mem_maps.  While not implemented yet,
- * this function is included for parity with its sibling.
+ * Decode mem_map from the coded memmap
  */
-static __attribute((unused))
+static
 struct page *sparse_decode_mem_map(unsigned long coded_mem_map, unsigned long pnum)
 {
+	/* mask off the extra low bits of information */
+	coded_mem_map &= SECTION_MAP_MASK;
 	return ((struct page *)coded_mem_map) + section_nr_to_pfn(pnum);
 }
 
@@ -404,6 +405,28 @@ static void __kfree_section_memmap(struc
 }
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
+static void free_section_usemap(struct page *memmap, unsigned long *usemap)
+{
+	if (!usemap)
+		return;
+
+	/*
+	 * Check to see if allocation came from hot-plug-add
+	 */
+	if (PageSlab(virt_to_page(usemap))) {
+		kfree(usemap);
+		if (memmap)
+			__kfree_section_memmap(memmap, PAGES_PER_SECTION);
+		return;
+	}
+
+	/*
+	 * TODO: Allocations came from bootmem - how do I free up ?
+	 */
+	printk(KERN_WARNING "Not freeing up allocations from bootmem "
+			"- leaking memory\n");
+}
+
 /*
  * returns the number of sections whose mem_maps were properly
  * set.  If this is <=0, then that means that the passed-in
@@ -456,4 +479,20 @@ out:
 	}
 	return ret;
 }
+
+void sparse_remove_one_section(struct zone *zone, struct mem_section *ms)
+{
+	struct page *memmap = NULL;
+	unsigned long *usemap = NULL;
+
+	if (ms->section_mem_map) {
+		usemap = ms->pageblock_flags;
+		memmap = sparse_decode_mem_map(ms->section_mem_map,
+						__section_nr(ms));
+		ms->section_mem_map = 0;
+		ms->pageblock_flags = NULL;
+	}
+
+	free_section_usemap(memmap, usemap);
+}
 #endif
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

origin.patch
powerpc-hotplug-memory-notifications-for-ppc.patch
powerpc-update-lmb-for-hotplug-memory-add-remove.patch
powerpc-provide-walk_memory_resource-for-ppc.patch
fs-aioc-make-3-functions-static.patch

