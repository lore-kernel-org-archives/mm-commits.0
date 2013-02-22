From: akpm@linux-foundation.org
Subject: [folded-merged] memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:35:47 -0800
Message-ID: <20130222233548.0063E5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:58984 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab3BVXft (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:35:49 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so119912yen.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:35:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linfeng@cn.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: introduce CONFIG_HAVE_BOOTMEM_INFO_NODE and revert register_page_bootmem_info_node() when platform not support
has been removed from the -mm tree.  Its filename was
     memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix.patch

This patch was dropped because it was folded into memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch

------------------------------------------------------
From: Lin Feng <linfeng@cn.fujitsu.com>
Subject: memory-hotplug: introduce CONFIG_HAVE_BOOTMEM_INFO_NODE and revert register_page_bootmem_info_node() when platform not support

It's implemented by adding a new Kconfig option named
CONFIG_HAVE_BOOTMEM_INFO_NODE, which will be automatically selected by
memory-hotplug feature fully supported archs(currently only on x86_64).

Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
Reported-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c          |    2 +-
 include/linux/memory_hotplug.h |    6 ++++++
 mm/Kconfig                     |    8 ++++++++
 mm/memory_hotplug.c            |    2 ++
 4 files changed, 17 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/init_64.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix
+++ a/arch/x86/mm/init_64.c
@@ -1034,7 +1034,7 @@ vmemmap_populate(struct page *start_page
 	return 0;
 }
 
-#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
+#if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_HAVE_BOOTMEM_INFO_NODE)
 void register_page_bootmem_memmap(unsigned long section_nr,
 				  struct page *start_page, unsigned long size)
 {
diff -puN include/linux/memory_hotplug.h~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix
+++ a/include/linux/memory_hotplug.h
@@ -174,7 +174,13 @@ static inline void arch_refresh_nodedata
 #endif /* CONFIG_NUMA */
 #endif /* CONFIG_HAVE_ARCH_NODEDATA_EXTENSION */
 
+#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
 extern void register_page_bootmem_info_node(struct pglist_data *pgdat);
+#else
+static inline void register_page_bootmem_info_node(struct pglist_data *pgdat)
+{
+}
+#endif
 extern void put_page_bootmem(struct page *page);
 extern void get_page_bootmem(unsigned long ingo, struct page *page,
 			     unsigned long type);
diff -puN mm/Kconfig~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix mm/Kconfig
--- a/mm/Kconfig~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix
+++ a/mm/Kconfig
@@ -162,10 +162,18 @@ config MOVABLE_NODE
 	  Say Y here if you want to hotplug a whole node.
 	  Say N here if you want kernel to use memory on all nodes evenly.
 
+#
+# Only be set on architectures that have completely implemented memory hotplug
+# feature. If you are not sure, don't touch it.
+#
+config HAVE_BOOTMEM_INFO_NODE
+	def_bool n
+
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
 	select MEMORY_ISOLATION
+	select HAVE_BOOTMEM_INFO_NODE if X86_64
 	depends on SPARSEMEM || X86_64_ACPI_NUMA
 	depends on HOTPLUG && ARCH_ENABLE_MEMORY_HOTPLUG
 	depends on (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)
diff -puN mm/memory_hotplug.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix
+++ a/mm/memory_hotplug.c
@@ -188,6 +188,7 @@ static void register_page_bootmem_info_s
 }
 #endif
 
+#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
 void register_page_bootmem_info_node(struct pglist_data *pgdat)
 {
 	unsigned long i, pfn, end_pfn, nr_pages;
@@ -229,6 +230,7 @@ void register_page_bootmem_info_node(str
 			register_page_bootmem_info_section(pfn);
 	}
 }
+#endif
 
 static void grow_zone_span(struct zone *zone, unsigned long start_pfn,
 			   unsigned long end_pfn)
_

Patches currently in -mm which might be from linfeng@cn.fujitsu.com are

memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix-fix-fix.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap-fix.patch
page_alloc-add-movable_memmap-kernel-parameter.patch
page_alloc-add-movable_memmap-kernel-parameter-rename-movablecore_map-to-movablemem_map.patch
page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes.patch
page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes-fix.patch
page_alloc-make-movablecore_map-has-higher-priority.patch
page_alloc-bootmem-limit-with-movablecore_map.patch

