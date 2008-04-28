From: akpm@linux-foundation.org
Subject: - memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch removed from -mm tree
Date: Mon, 28 Apr 2008 11:16:14 -0700
Message-ID: <200804281816.m3SIGEcN008105@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964853AbYD1SRK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 14:17:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     memory hotplug: add "removable" to /sysfs to show memblock removability
has been removed from the -mm tree.  Its filename was
     memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch

This patch was dropped because I don't want to carry it forever...

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug: add "removable" to /sysfs to show memblock removability
From: Badari Pulavarty <pbadari@us.ibm.com>

Each section of the memory has attributes in /sysfs.  This patch adds file
"removable" to show if this memory block is removable.  This helps
user-level agents to identify section of the memory for hotplug memory
remove.

Sections with MOVABLE pageblocks are removable.  And also pageblock that is
entirely free may be removed regardless of the pageblock type.  Similarly,
a pageblock that starts with a reserved page will not be removable no
matter what the pageblock type is.  Detect these two situations when
reporting whether a section may be removed or not.

Sample output:

./memory/memory0/removable: 0
./memory/memory1/removable: 0
./memory/memory2/removable: 0
./memory/memory3/removable: 0
./memory/memory4/removable: 0
./memory/memory5/removable: 0
./memory/memory6/removable: 0
./memory/memory7/removable: 1
./memory/memory8/removable: 0
./memory/memory9/removable: 0
./memory/memory10/removable: 0
./memory/memory11/removable: 0
./memory/memory12/removable: 0
./memory/memory13/removable: 0
./memory/memory14/removable: 0
./memory/memory15/removable: 0
./memory/memory16/removable: 0
./memory/memory17/removable: 1
./memory/memory18/removable: 1
./memory/memory19/removable: 1
./memory/memory20/removable: 1
./memory/memory21/removable: 1
./memory/memory22/removable: 1

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |   19 ++++++++++
 include/linux/memory_hotplug.h |   12 ++++++
 mm/memory_hotplug.c            |   56 +++++++++++++++++++++++++++++++
 3 files changed, 87 insertions(+)

diff -puN drivers/base/memory.c~memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability
+++ a/drivers/base/memory.c
@@ -98,6 +98,21 @@ static ssize_t show_mem_phys_index(struc
 }
 
 /*
+ * show memory migrate type
+ */
+static ssize_t show_mem_removable(struct sys_device *dev, char *buf)
+{
+	unsigned long start_pfn;
+	int ret;
+	struct memory_block *mem =
+		container_of(dev, struct memory_block, sysdev);
+
+	start_pfn = section_nr_to_pfn(mem->phys_index);
+	ret = is_mem_section_removable(start_pfn, PAGES_PER_SECTION);
+	return sprintf(buf, "%d\n", ret);
+}
+
+/*
  * online, offline, going offline, etc.
  */
 static ssize_t show_mem_state(struct sys_device *dev, char *buf)
@@ -256,6 +271,7 @@ static ssize_t show_phys_device(struct s
 static SYSDEV_ATTR(phys_index, 0444, show_mem_phys_index, NULL);
 static SYSDEV_ATTR(state, 0644, show_mem_state, store_mem_state);
 static SYSDEV_ATTR(phys_device, 0444, show_phys_device, NULL);
+static SYSDEV_ATTR(removable, 0444, show_mem_removable, NULL);
 
 #define mem_create_simple_file(mem, attr_name)	\
 	sysdev_create_file(&mem->sysdev, &attr_##attr_name)
@@ -344,6 +360,8 @@ static int add_memory_block(unsigned lon
 		ret = mem_create_simple_file(mem, state);
 	if (!ret)
 		ret = mem_create_simple_file(mem, phys_device);
+	if (!ret)
+		ret = mem_create_simple_file(mem, removable);
 
 	return ret;
 }
@@ -388,6 +406,7 @@ int remove_memory_block(unsigned long no
 	mem_remove_simple_file(mem, phys_index);
 	mem_remove_simple_file(mem, state);
 	mem_remove_simple_file(mem, phys_device);
+	mem_remove_simple_file(mem, removable);
 	unregister_memory(mem, section);
 
 	return 0;
diff -puN include/linux/memory_hotplug.h~memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability
+++ a/include/linux/memory_hotplug.h
@@ -199,6 +199,18 @@ static inline void register_page_bootmem
 
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
+
+extern int is_mem_section_removable(unsigned long pfn, unsigned long nr_pages);
+
+#else
+static inline int is_mem_section_removable(unsigned long pfn,
+					unsigned long nr_pages)
+{
+	return 0;
+}
+#endif /* CONFIG_MEMORY_HOTREMOVE */
+
 extern int add_memory(int nid, u64 start, u64 size);
 extern int arch_add_memory(int nid, u64 start, u64 size);
 extern int remove_memory(u64 start, u64 size);
diff -puN mm/memory_hotplug.c~memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability
+++ a/mm/memory_hotplug.c
@@ -26,6 +26,7 @@
 #include <linux/delay.h>
 #include <linux/migrate.h>
 #include <linux/page-isolation.h>
+#include "internal.h"
 
 #include <asm/tlbflush.h>
 
@@ -510,6 +511,61 @@ error:
 EXPORT_SYMBOL_GPL(add_memory);
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
+/* Returns true if the pageblock contains only free pages */
+static inline int pageblock_free(struct page *page)
+{
+	return PageBuddy(page) && page_order(page) >= pageblock_order;
+}
+
+/* Move to the next pageblock that is in use */
+static struct page *next_active_pageblock(struct page *page)
+{
+	/* Moving forward by at least 1 * pageblock_nr_pages */
+	int order = 1;
+
+	/* If the entire pageblock is free, move to the end of free page */
+	if (pageblock_free(page) && page_order(page) > pageblock_order)
+		order += page_order(page) - pageblock_order;
+
+	return page + (order * pageblock_nr_pages);
+}
+
+/*
+ * Find out if this section of the memory is removable.
+ */
+int is_mem_section_removable(unsigned long start_pfn, unsigned long nr_pages)
+{
+	int type;
+	struct page *page, *end_page;
+
+	/*
+	 * Check all pageblocks in the section to ensure they are all
+	 * removable.
+	 */
+	page = pfn_to_page(start_pfn);
+	end_page = page + nr_pages;
+
+	for (; page < end_page; page = next_active_pageblock(page)) {
+		type = get_pageblock_migratetype(page);
+
+		/*
+		 * For now, we can remove sections with only MOVABLE pages
+		 * or contain free pages
+		 */
+		if (type != MIGRATE_MOVABLE && !pageblock_free(page))
+			return 0;
+
+		/*
+		 * Check if the first page is reserved, this can happen
+		 * for bootmem reserved pages pageblocks
+		 */
+		if (PageReserved(page))
+			return 0;
+	}
+
+	return 1;
+}
+
 /*
  * Confirm all pages in a range [start, end) is belongs to the same zone.
  */
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

origin.patch
hotplug-memory-remove-generic-__remove_pages-support.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret.patch
memory-hotplug-register-section-node-id-to-free.patch
memory-hotplug-align-memmap-to-page-size.patch
memory-hotplug-make-alloc_bootmem_section.patch
memory-hotplugallocate-usemap-on-the-section-with-pgdat.patch
memory-hotplug-free-memmaps-allocated-by-bootmem.patch
powerpc-hotplug-memory-notifications-for-ppc.patch
powerpc-update-lmb-for-hotplug-memory-add-remove.patch
powerpc-provide-walk_memory_resource-for-ppc.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
fs-aioc-make-3-functions-static.patch

