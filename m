From: akpm@linux-foundation.org
Subject: [patch 049/108] mm: consider zone which is not fully
 populated to have holes
Date: Thu, 06 Jul 2017 15:37:56 -0700
Message-ID: <20170706223756.3uURXagUr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36034 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752707AbdGFWiS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:38:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, ak@linux.intel.com, akpm@linux-foundation.org, arbab@linux.vnet.ibm.com, bsingharora@gmail.com, dan.j.williams@intel.com, daniel.kiper@oracle.com, heiko.carstens@de.ibm.com, imammedo@redhat.com, isimatu.yasuaki@jp.fujitsu.com, jglisse@redhat.com, js1304@gmail.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, qiuxishi@huawei.com, rientjes@google.com, schwidefsky@de.ibm.com, tobias.regnery@gmail.com, torvalds@linux-foundation.org, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm: consider zone which is not fully populated to have holes

__pageblock_pfn_to_page has two users currently, set_zone_contiguous which
checks whether the given zone contains holes and pageblock_pfn_to_page
which then carefully returns a first valid page from the given pfn range
for the given zone.  This doesn't handle zones which are not fully
populated though.  Memory pageblocks can be offlined or might not have
been onlined yet.  In such a case the zone should be considered to have
holes otherwise pfn walkers can touch and play with offline pages.

Current callers of pageblock_pfn_to_page in compaction seem to work
properly right now because they only isolate PageBuddy
(isolate_freepages_block) or PageLRU resp.  __PageMovable
(isolate_migratepages_block) which will be always false for these pages. 
It would be safer to skip these pages altogether, though.

In order to do this patch adds a new memory section state
(SECTION_IS_ONLINE) which is set in memory_present (during boot time) or
in online_pages_range during the memory hotplug.  Similarly
offline_mem_sections clears the bit and it is called when the memory range
is offlined.

pfn_to_online_page helper is then added which check the mem section and
only returns a page if it is onlined already.

Use the new helper in __pageblock_pfn_to_page and skip the whole page
block in such a case.

[mhocko@suse.com: check valid section number in pfn_to_online_page (Vlastimil),
 mark sections online after all struct pages are initialized in
 online_pages_range (Vlastimil)]
  Link: http://lkml.kernel.org/r/20170518164210.GD18333@dhcp22.suse.cz
Link: http://lkml.kernel.org/r/20170515085827.16474-8-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Tobias Regnery <tobias.regnery@gmail.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |   22 +++++++++++++++
 include/linux/mmzone.h         |   35 +++++++++++++++++++-----
 mm/memory_hotplug.c            |    4 ++
 mm/page_alloc.c                |    5 ++-
 mm/sparse.c                    |   45 ++++++++++++++++++++++++++++++-
 5 files changed, 103 insertions(+), 8 deletions(-)

diff -puN include/linux/memory_hotplug.h~mm-consider-zone-which-is-not-fully-populated-to-have-holes include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mm-consider-zone-which-is-not-fully-populated-to-have-holes
+++ a/include/linux/memory_hotplug.h
@@ -14,6 +14,20 @@ struct memory_block;
 struct resource;
 
 #ifdef CONFIG_MEMORY_HOTPLUG
+/*
+ * Return page for the valid pfn only if the page is online. All pfn
+ * walkers which rely on the fully initialized page->flags and others
+ * should use this rather than pfn_valid && pfn_to_page
+ */
+#define pfn_to_online_page(pfn)				\
+({							\
+	struct page *___page = NULL;			\
+	unsigned long ___nr = pfn_to_section_nr(pfn);	\
+							\
+	if (___nr < NR_MEM_SECTIONS && online_section_nr(___nr))\
+		___page = pfn_to_page(pfn);		\
+	___page;					\
+})
 
 /*
  * Types for free bootmem stored in page->lru.next. These have to be in
@@ -203,6 +217,14 @@ extern void set_zone_contiguous(struct z
 extern void clear_zone_contiguous(struct zone *zone);
 
 #else /* ! CONFIG_MEMORY_HOTPLUG */
+#define pfn_to_online_page(pfn)			\
+({						\
+	struct page *___page = NULL;		\
+	if (pfn_valid(pfn))			\
+		___page = pfn_to_page(pfn);	\
+	___page;				\
+ })
+
 /*
  * Stub functions for when hotplug is off
  */
diff -puN include/linux/mmzone.h~mm-consider-zone-which-is-not-fully-populated-to-have-holes include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-consider-zone-which-is-not-fully-populated-to-have-holes
+++ a/include/linux/mmzone.h
@@ -1144,9 +1144,10 @@ extern unsigned long usemap_size(void);
  */
 #define	SECTION_MARKED_PRESENT	(1UL<<0)
 #define SECTION_HAS_MEM_MAP	(1UL<<1)
-#define SECTION_MAP_LAST_BIT	(1UL<<2)
+#define SECTION_IS_ONLINE	(1UL<<2)
+#define SECTION_MAP_LAST_BIT	(1UL<<3)
 #define SECTION_MAP_MASK	(~(SECTION_MAP_LAST_BIT-1))
-#define SECTION_NID_SHIFT	2
+#define SECTION_NID_SHIFT	3
 
 static inline struct page *__section_mem_map_addr(struct mem_section *section)
 {
@@ -1175,6 +1176,23 @@ static inline int valid_section_nr(unsig
 	return valid_section(__nr_to_section(nr));
 }
 
+static inline int online_section(struct mem_section *section)
+{
+	return (section && (section->section_mem_map & SECTION_IS_ONLINE));
+}
+
+static inline int online_section_nr(unsigned long nr)
+{
+	return online_section(__nr_to_section(nr));
+}
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+void online_mem_sections(unsigned long start_pfn, unsigned long end_pfn);
+#ifdef CONFIG_MEMORY_HOTREMOVE
+void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn);
+#endif
+#endif
+
 static inline struct mem_section *__pfn_to_section(unsigned long pfn)
 {
 	return __nr_to_section(pfn_to_section_nr(pfn));
@@ -1253,10 +1271,15 @@ unsigned long __init node_memmap_size_by
 #ifdef CONFIG_ARCH_HAS_HOLES_MEMORYMODEL
 /*
  * pfn_valid() is meant to be able to tell if a given PFN has valid memmap
- * associated with it or not. In FLATMEM, it is expected that holes always
- * have valid memmap as long as there is valid PFNs either side of the hole.
- * In SPARSEMEM, it is assumed that a valid section has a memmap for the
- * entire section.
+ * associated with it or not. This means that a struct page exists for this
+ * pfn. The caller cannot assume the page is fully initialized in general.
+ * Hotplugable pages might not have been onlined yet. pfn_to_online_page()
+ * will ensure the struct page is fully online and initialized. Special pages
+ * (e.g. ZONE_DEVICE) are never onlined and should be treated accordingly.
+ *
+ * In FLATMEM, it is expected that holes always have valid memmap as long as
+ * there is valid PFNs either side of the hole. In SPARSEMEM, it is assumed
+ * that a valid section has a memmap for the entire section.
  *
  * However, an ARM, and maybe other embedded architectures in the future
  * free memmap backing holes to save memory on the assumption the memmap is
diff -puN mm/memory_hotplug.c~mm-consider-zone-which-is-not-fully-populated-to-have-holes mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-consider-zone-which-is-not-fully-populated-to-have-holes
+++ a/mm/memory_hotplug.c
@@ -929,12 +929,16 @@ static int online_pages_range(unsigned l
 	unsigned long i;
 	unsigned long onlined_pages = *(unsigned long *)arg;
 	struct page *page;
+
 	if (PageReserved(pfn_to_page(start_pfn)))
 		for (i = 0; i < nr_pages; i++) {
 			page = pfn_to_page(start_pfn + i);
 			(*online_page_callback)(page);
 			onlined_pages++;
 		}
+
+	online_mem_sections(start_pfn, start_pfn + nr_pages);
+
 	*(unsigned long *)arg = onlined_pages;
 	return 0;
 }
diff -puN mm/page_alloc.c~mm-consider-zone-which-is-not-fully-populated-to-have-holes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-consider-zone-which-is-not-fully-populated-to-have-holes
+++ a/mm/page_alloc.c
@@ -1365,7 +1365,9 @@ struct page *__pageblock_pfn_to_page(uns
 	if (!pfn_valid(start_pfn) || !pfn_valid(end_pfn))
 		return NULL;
 
-	start_page = pfn_to_page(start_pfn);
+	start_page = pfn_to_online_page(start_pfn);
+	if (!start_page)
+		return NULL;
 
 	if (page_zone(start_page) != zone)
 		return NULL;
@@ -7656,6 +7658,7 @@ __offline_isolated_pages(unsigned long s
 			break;
 	if (pfn == end_pfn)
 		return;
+	offline_mem_sections(pfn, end_pfn);
 	zone = page_zone(pfn_to_page(pfn));
 	spin_lock_irqsave(&zone->lock, flags);
 	pfn = start_pfn;
diff -puN mm/sparse.c~mm-consider-zone-which-is-not-fully-populated-to-have-holes mm/sparse.c
--- a/mm/sparse.c~mm-consider-zone-which-is-not-fully-populated-to-have-holes
+++ a/mm/sparse.c
@@ -222,7 +222,8 @@ void __init memory_present(int nid, unsi
 
 		ms = __nr_to_section(section);
 		if (!ms->section_mem_map) {
-			ms->section_mem_map = sparse_encode_early_nid(nid);
+			ms->section_mem_map = sparse_encode_early_nid(nid) |
+							SECTION_IS_ONLINE;
 			section_mark_present(ms);
 		}
 	}
@@ -622,6 +623,48 @@ void __init sparse_init(void)
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
+
+/* Mark all memory sections within the pfn range as online */
+void online_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
+{
+	unsigned long pfn;
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
+		unsigned long section_nr = pfn_to_section_nr(start_pfn);
+		struct mem_section *ms;
+
+		/* onlining code should never touch invalid ranges */
+		if (WARN_ON(!valid_section_nr(section_nr)))
+			continue;
+
+		ms = __nr_to_section(section_nr);
+		ms->section_mem_map |= SECTION_IS_ONLINE;
+	}
+}
+
+#ifdef CONFIG_MEMORY_HOTREMOVE
+/* Mark all memory sections within the pfn range as online */
+void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
+{
+	unsigned long pfn;
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
+		unsigned long section_nr = pfn_to_section_nr(start_pfn);
+		struct mem_section *ms;
+
+		/*
+		 * TODO this needs some double checking. Offlining code makes
+		 * sure to check pfn_valid but those checks might be just bogus
+		 */
+		if (WARN_ON(!valid_section_nr(section_nr)))
+			continue;
+
+		ms = __nr_to_section(section_nr);
+		ms->section_mem_map &= ~SECTION_IS_ONLINE;
+	}
+}
+#endif
+
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 static inline struct page *kmalloc_section_memmap(unsigned long pnum, int nid)
 {
_
