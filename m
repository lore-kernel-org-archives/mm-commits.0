From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-memory_hotplug-optimize-memory-hotplug.patch
 removed from -mm tree
Date: Thu, 15 Feb 2018 14:45:21 -0800
Message-ID: <5a860d81.z2Gzg7/LkHIwLJjB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39452 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756371AbeBOWpY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Feb 2018 17:45:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, bharata@linux.vnet.ibm.com, bhe@redhat.com, daniel.m.jordan@oracle.com, dan.j.williams@intel.com, gregkh@linuxfoundation.org, hpa@zytor.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, mingo@elte.hu, steven.sistare@oracle.com, tglx@linutronix.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: optimize memory hotplug
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-optimize-memory-hotplug.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: mm/memory_hotplug: optimize memory hotplug

This patch was inspired by the discussion of this problem:
http://lkml.kernel.org/r/20180130083006.GB1245@in.ibm.com

Currently, during memory hotplugging we traverse struct pages several
times:

1. memset(0) in sparse_add_one_section()
2. loop in __add_section() to set do: set_page_node(page, nid); and
   SetPageReserved(page);
3. loop in pages_correctly_reserved() to check that SetPageReserved is set.
4. loop in memmap_init_zone() to call __init_single_pfn()

This patch removes loops 1, 2, and 3 and only leaves the loop 4, where all
struct page fields are initialized in one go, the same as it is now done
during boot.

The benefits:
- We improve the memory hotplug performance because we are not evicting
  cache several times and also reduce loop branching overheads.

- Remove condition from hotpath in __init_single_pfn(), that was added in
  order to fix the problem that was reported by Bharata in the above email
  thread, thus also improve the performance during normal boot.

- Make memory hotplug more similar to boot memory initialization path
  because we zero and initialize struct pages only in one function.

- Simplifies memory hotplug strut page initialization code, and thus
  enables future improvements, such as multi-threading the initialization
  of struct pages in order to improve the hotplug performance even further
  on larger machines.

Link: http://lkml.kernel.org/r/20180213193159.14606-5-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |   38 +++++++++++++++++--------------
 drivers/base/node.c            |   17 ++++++++-----
 include/linux/memory_hotplug.h |    2 +
 include/linux/node.h           |    4 +--
 mm/memory_hotplug.c            |   21 +----------------
 mm/page_alloc.c                |   28 ++++++++--------------
 mm/sparse.c                    |   29 +++++++++++++++++++++--
 7 files changed, 73 insertions(+), 66 deletions(-)

diff -puN drivers/base/memory.c~mm-memory_hotplug-optimize-memory-hotplug drivers/base/memory.c
--- a/drivers/base/memory.c~mm-memory_hotplug-optimize-memory-hotplug
+++ a/drivers/base/memory.c
@@ -187,13 +187,14 @@ int memory_isolate_notify(unsigned long
 }
 
 /*
- * The probe routines leave the pages reserved, just as the bootmem code does.
- * Make sure they're still that way.
+ * The probe routines leave the pages uninitialized, just as the bootmem code
+ * does. Make sure we do not access them, but instead use only information from
+ * within sections.
  */
-static bool pages_correctly_reserved(unsigned long start_pfn)
+static bool pages_correctly_probed(unsigned long start_pfn)
 {
-	int i, j;
-	struct page *page;
+	unsigned long section_nr = pfn_to_section_nr(start_pfn);
+	unsigned long section_nr_end = section_nr + sections_per_block;
 	unsigned long pfn = start_pfn;
 
 	/*
@@ -201,21 +202,24 @@ static bool pages_correctly_reserved(uns
 	 * SPARSEMEM_VMEMMAP. We lookup the page once per section
 	 * and assume memmap is contiguous within each section
 	 */
-	for (i = 0; i < sections_per_block; i++, pfn += PAGES_PER_SECTION) {
+	for (; section_nr < section_nr_end; section_nr++) {
 		if (WARN_ON_ONCE(!pfn_valid(pfn)))
 			return false;
-		page = pfn_to_page(pfn);
-
-		for (j = 0; j < PAGES_PER_SECTION; j++) {
-			if (PageReserved(page + j))
-				continue;
-
-			printk(KERN_WARNING "section number %ld page number %d "
-				"not reserved, was it already online?\n",
-				pfn_to_section_nr(pfn), j);
 
+		if (!present_section_nr(section_nr)) {
+			pr_warn("section %ld pfn[%lx, %lx) not present",
+				section_nr, pfn, pfn + PAGES_PER_SECTION);
+			return false;
+		} else if (!valid_section_nr(section_nr)) {
+			pr_warn("section %ld pfn[%lx, %lx) no valid memmap",
+				section_nr, pfn, pfn + PAGES_PER_SECTION);
+			return false;
+		} else if (online_section_nr(section_nr)) {
+			pr_warn("section %ld pfn[%lx, %lx) is already online",
+				section_nr, pfn, pfn + PAGES_PER_SECTION);
 			return false;
 		}
+		pfn += PAGES_PER_SECTION;
 	}
 
 	return true;
@@ -237,7 +241,7 @@ memory_block_action(unsigned long phys_i
 
 	switch (action) {
 	case MEM_ONLINE:
-		if (!pages_correctly_reserved(start_pfn))
+		if (!pages_correctly_probed(start_pfn))
 			return -EBUSY;
 
 		ret = online_pages(start_pfn, nr_pages, online_type);
@@ -727,7 +731,7 @@ int register_new_memory(int nid, struct
 	}
 
 	if (mem->section_count == sections_per_block)
-		ret = register_mem_sect_under_node(mem, nid);
+		ret = register_mem_sect_under_node(mem, nid, false);
 out:
 	mutex_unlock(&mem_sysfs_mutex);
 	return ret;
diff -puN drivers/base/node.c~mm-memory_hotplug-optimize-memory-hotplug drivers/base/node.c
--- a/drivers/base/node.c~mm-memory_hotplug-optimize-memory-hotplug
+++ a/drivers/base/node.c
@@ -397,7 +397,8 @@ static int __ref get_nid_for_pfn(unsigne
 }
 
 /* register memory section under specified node if it spans that node */
-int register_mem_sect_under_node(struct memory_block *mem_blk, int nid)
+int register_mem_sect_under_node(struct memory_block *mem_blk, int nid,
+				 bool check_nid)
 {
 	int ret;
 	unsigned long pfn, sect_start_pfn, sect_end_pfn;
@@ -423,11 +424,13 @@ int register_mem_sect_under_node(struct
 			continue;
 		}
 
-		page_nid = get_nid_for_pfn(pfn);
-		if (page_nid < 0)
-			continue;
-		if (page_nid != nid)
-			continue;
+		if (check_nid) {
+			page_nid = get_nid_for_pfn(pfn);
+			if (page_nid < 0)
+				continue;
+			if (page_nid != nid)
+				continue;
+		}
 		ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
 					&mem_blk->dev.kobj,
 					kobject_name(&mem_blk->dev.kobj));
@@ -502,7 +505,7 @@ int link_mem_sections(int nid, unsigned
 
 		mem_blk = find_memory_block_hinted(mem_sect, mem_blk);
 
-		ret = register_mem_sect_under_node(mem_blk, nid);
+		ret = register_mem_sect_under_node(mem_blk, nid, true);
 		if (!err)
 			err = ret;
 
diff -puN include/linux/memory_hotplug.h~mm-memory_hotplug-optimize-memory-hotplug include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-optimize-memory-hotplug
+++ a/include/linux/memory_hotplug.h
@@ -234,6 +234,8 @@ void put_online_mems(void);
 void mem_hotplug_begin(void);
 void mem_hotplug_done(void);
 
+int get_section_nid(unsigned long section_nr);
+
 extern void set_zone_contiguous(struct zone *zone);
 extern void clear_zone_contiguous(struct zone *zone);
 
diff -puN include/linux/node.h~mm-memory_hotplug-optimize-memory-hotplug include/linux/node.h
--- a/include/linux/node.h~mm-memory_hotplug-optimize-memory-hotplug
+++ a/include/linux/node.h
@@ -67,7 +67,7 @@ extern void unregister_one_node(int nid)
 extern int register_cpu_under_node(unsigned int cpu, unsigned int nid);
 extern int unregister_cpu_under_node(unsigned int cpu, unsigned int nid);
 extern int register_mem_sect_under_node(struct memory_block *mem_blk,
-						int nid);
+						int nid, bool check_nid);
 extern int unregister_mem_sect_under_nodes(struct memory_block *mem_blk,
 					   unsigned long phys_index);
 
@@ -97,7 +97,7 @@ static inline int unregister_cpu_under_n
 	return 0;
 }
 static inline int register_mem_sect_under_node(struct memory_block *mem_blk,
-							int nid)
+							int nid, bool check_nid)
 {
 	return 0;
 }
diff -puN mm/memory_hotplug.c~mm-memory_hotplug-optimize-memory-hotplug mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-optimize-memory-hotplug
+++ a/mm/memory_hotplug.c
@@ -250,7 +250,6 @@ static int __meminit __add_section(int n
 		struct vmem_altmap *altmap, bool want_memblock)
 {
 	int ret;
-	int i;
 
 	if (pfn_valid(phys_start_pfn))
 		return -EEXIST;
@@ -259,23 +258,6 @@ static int __meminit __add_section(int n
 	if (ret < 0)
 		return ret;
 
-	/*
-	 * Make all the pages reserved so that nobody will stumble over half
-	 * initialized state.
-	 * FIXME: We also have to associate it with a node because page_to_nid
-	 * relies on having page with the proper node.
-	 */
-	for (i = 0; i < PAGES_PER_SECTION; i++) {
-		unsigned long pfn = phys_start_pfn + i;
-		struct page *page;
-		if (!pfn_valid(pfn))
-			continue;
-
-		page = pfn_to_page(pfn);
-		set_page_node(page, nid);
-		SetPageReserved(page);
-	}
-
 	if (!want_memblock)
 		return 0;
 
@@ -913,7 +895,8 @@ int __ref online_pages(unsigned long pfn
 	int ret;
 	struct memory_notify arg;
 
-	nid = pfn_to_nid(pfn);
+	nid = get_section_nid(pfn_to_section_nr(pfn));
+
 	/* associate pfn range with the zone */
 	zone = move_pfn_range(online_type, nid, pfn, nr_pages);
 
diff -puN mm/page_alloc.c~mm-memory_hotplug-optimize-memory-hotplug mm/page_alloc.c
--- a/mm/page_alloc.c~mm-memory_hotplug-optimize-memory-hotplug
+++ a/mm/page_alloc.c
@@ -1139,10 +1139,9 @@ static void free_one_page(struct zone *z
 }
 
 static void __meminit __init_single_page(struct page *page, unsigned long pfn,
-				unsigned long zone, int nid, bool zero)
+				unsigned long zone, int nid)
 {
-	if (zero)
-		mm_zero_struct_page(page);
+	mm_zero_struct_page(page);
 	set_page_links(page, zone, nid, pfn);
 	init_page_count(page);
 	page_mapcount_reset(page);
@@ -1156,12 +1155,6 @@ static void __meminit __init_single_page
 #endif
 }
 
-static void __meminit __init_single_pfn(unsigned long pfn, unsigned long zone,
-					int nid, bool zero)
-{
-	return __init_single_page(pfn_to_page(pfn), pfn, zone, nid, zero);
-}
-
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static void __meminit init_reserved_page(unsigned long pfn)
 {
@@ -1180,7 +1173,7 @@ static void __meminit init_reserved_page
 		if (pfn >= zone->zone_start_pfn && pfn < zone_end_pfn(zone))
 			break;
 	}
-	__init_single_pfn(pfn, zid, nid, true);
+	__init_single_page(pfn_to_page(pfn), pfn, zid, nid);
 }
 #else
 static inline void init_reserved_page(unsigned long pfn)
@@ -1497,7 +1490,7 @@ static unsigned long  __init deferred_in
 		} else {
 			page++;
 		}
-		__init_single_page(page, pfn, zid, nid, true);
+		__init_single_page(page, pfn, zid, nid);
 		nr_pages++;
 	}
 	return (nr_pages);
@@ -5417,6 +5410,7 @@ void __meminit memmap_init_zone(unsigned
 	pg_data_t *pgdat = NODE_DATA(nid);
 	unsigned long pfn;
 	unsigned long nr_initialised = 0;
+	struct page *page;
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	struct memblock_region *r = NULL, *tmp;
 #endif
@@ -5478,6 +5472,11 @@ void __meminit memmap_init_zone(unsigned
 #endif
 
 not_early:
+		page = pfn_to_page(pfn);
+		__init_single_page(page, pfn, zone, nid);
+		if (context == MEMMAP_HOTPLUG)
+			SetPageReserved(page);
+
 		/*
 		 * Mark the block movable so that blocks are reserved for
 		 * movable at startup. This will force kernel allocations
@@ -5494,15 +5493,8 @@ not_early:
 		 * because this is done early in sparse_add_one_section
 		 */
 		if (!(pfn & (pageblock_nr_pages - 1))) {
-			struct page *page = pfn_to_page(pfn);
-
-			__init_single_page(page, pfn, zone, nid,
-					context != MEMMAP_HOTPLUG);
 			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 			cond_resched();
-		} else {
-			__init_single_pfn(pfn, zone, nid,
-					context != MEMMAP_HOTPLUG);
 		}
 	}
 }
diff -puN mm/sparse.c~mm-memory_hotplug-optimize-memory-hotplug mm/sparse.c
--- a/mm/sparse.c~mm-memory_hotplug-optimize-memory-hotplug
+++ a/mm/sparse.c
@@ -30,11 +30,14 @@ struct mem_section mem_section[NR_SECTIO
 #endif
 EXPORT_SYMBOL(mem_section);
 
-#ifdef NODE_NOT_IN_PAGE_FLAGS
+#if defined(NODE_NOT_IN_PAGE_FLAGS) || defined(CONFIG_MEMORY_HOTPLUG)
 /*
  * If we did not store the node number in the page then we have to
  * do a lookup in the section_to_node_table in order to find which
  * node the page belongs to.
+ *
+ * We also use this data in case memory hotplugging is enabled to be
+ * able to determine nid while struct pages are not yet initialized.
  */
 #if MAX_NUMNODES <= 256
 static u8 section_to_node_table[NR_MEM_SECTIONS] __cacheline_aligned;
@@ -42,17 +45,28 @@ static u8 section_to_node_table[NR_MEM_S
 static u16 section_to_node_table[NR_MEM_SECTIONS] __cacheline_aligned;
 #endif
 
+#ifdef NODE_NOT_IN_PAGE_FLAGS
 int page_to_nid(const struct page *page)
 {
 	return section_to_node_table[page_to_section(page)];
 }
 EXPORT_SYMBOL(page_to_nid);
+#endif /* NODE_NOT_IN_PAGE_FLAGS */
 
 static void set_section_nid(unsigned long section_nr, int nid)
 {
 	section_to_node_table[section_nr] = nid;
 }
-#else /* !NODE_NOT_IN_PAGE_FLAGS */
+
+/* Return NID for given section number */
+int get_section_nid(unsigned long section_nr)
+{
+	if (WARN_ON(section_nr >= NR_MEM_SECTIONS))
+		return 0;
+	return section_to_node_table[section_nr];
+}
+EXPORT_SYMBOL(get_section_nid);
+#else /* ! (NODE_NOT_IN_PAGE_FLAGS || CONFIG_MEMORY_HOTPLUG) */
 static inline void set_section_nid(unsigned long section_nr, int nid)
 {
 }
@@ -816,7 +830,14 @@ int __meminit sparse_add_one_section(str
 		goto out;
 	}
 
-	memset(memmap, 0, sizeof(struct page) * PAGES_PER_SECTION);
+#ifdef CONFIG_DEBUG_VM
+	/*
+	 * poison uninitialized struct pages in order to catch invalid flags
+	 * combinations.
+	 */
+	memset(memmap, PAGE_POISON_PATTERN,
+	       sizeof(struct page) * PAGES_PER_SECTION);
+#endif
 
 	section_mark_present(ms);
 
@@ -827,6 +848,8 @@ out:
 	if (ret <= 0) {
 		kfree(usemap);
 		__kfree_section_memmap(memmap, altmap);
+	} else {
+		set_section_nid(section_nr, pgdat->node_id);
 	}
 	return ret;
 }
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

mm-initialize-pages-on-demand-during-boot.patch
mm-initialize-pages-on-demand-during-boot-fix-3.patch
mm-memory_hotplug-enforce-block-size-aligned-range-check.patch
x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory.patch
x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory-v4.patch
mm-uninitialized-struct-page-poisoning-sanity-checking.patch
mm-uninitialized-struct-page-poisoning-sanity-checking-v4.patch
mm-memory_hotplug-optimize-probe-routine.patch
mm-memory_hotplug-dont-read-nid-from-struct-page-during-hotplug.patch
sparc64-ng4-memset-32-bits-overflow.patch

