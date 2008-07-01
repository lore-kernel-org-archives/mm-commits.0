From: akpm@linux-foundation.org
Subject: + memory-hotplug-add-sysfs-removable-attribute-for-hotplug-memory-remove.patch added to -mm tree
Date: Tue, 01 Jul 2008 16:17:26 -0700
Message-ID: <200807012317.m61NHlWq020074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752805AbYGAXSI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 19:18:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pbadari@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     memory-hotplug: add sysfs removable attribute for hotplug memory remove
has been added to the -mm tree.  Its filename is
     memory-hotplug-add-sysfs-removable-attribute-for-hotplug-memory-remove.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory-hotplug: add sysfs removable attribute for hotplug memory remove
From: Badari Pulavarty <pbadari@us.ibm.com>

Memory may be hot-removed on a per-memory-block basis, particularly on
POWER where the SPARSEMEM section size often matches the memory-block
size.  A user-level agent must be able to identify which sections of
memory are likely to be removable before attempting the potentially
expensive operation.  This patch adds a file called "removable" to the
memory directory in sysfs to help such an agent.  In this patch, a memory
block is considered removable if;

o It contains only MOVABLE pageblocks
o It contains only pageblocks with free pages regardless of pageblock type

On the other hand, a memory block starting with a PageReserved() page will
never be considered removable.  Without this patch, the user-agent is
forced to choose a memory block to remove randomly.

Sample output of the sysfs files:

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

 Documentation/ABI/testing/sysfs-devices-memory |   24 ++++++
 drivers/base/memory.c                          |   19 ++++
 include/linux/memory_hotplug.h                 |   12 +++
 mm/memory_hotplug.c                            |   60 +++++++++++++++
 4 files changed, 115 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/sysfs-devices-memory
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-devices-memory
@@ -0,0 +1,24 @@
+What:		/sys/devices/system/memory
+Date:		June 2008
+Contact:	Badari Pulavarty <pbadari@us.ibm.com>
+Description:
+		The /sys/devices/system/memory contains a snapshot of the
+		internal state of the kernel memory blocks. Files could be
+		added or removed dynamically to represent hot-add/remove
+		operations.
+
+Users:		hotplug memory add/remove tools
+		https://w3.opensource.ibm.com/projects/powerpc-utils/
+
+What:		/sys/devices/system/memory/memoryX/removable
+Date:		June 2008
+Contact:	Badari Pulavarty <pbadari@us.ibm.com>
+Description:
+		The file /sys/devices/system/memory/memoryX/removable
+		indicates whether this memory block is removable or not.
+		This is useful for a user-level agent to determine
+		identify removable sections of the memory before attempting
+		potentially expensive hot-remove memory operation
+
+Users:		hotplug memory remove tools
+		https://w3.opensource.ibm.com/projects/powerpc-utils/
diff -puN drivers/base/memory.c~memory-hotplug-add-sysfs-removable-attribute-for-hotplug-memory-remove drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-add-sysfs-removable-attribute-for-hotplug-memory-remove
+++ a/drivers/base/memory.c
@@ -100,6 +100,21 @@ static ssize_t show_mem_phys_index(struc
 }
 
 /*
+ * Show whether the section of memory is likely to be hot-removable
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
@@ -258,6 +273,7 @@ static ssize_t show_phys_device(struct s
 static SYSDEV_ATTR(phys_index, 0444, show_mem_phys_index, NULL);
 static SYSDEV_ATTR(state, 0644, show_mem_state, store_mem_state);
 static SYSDEV_ATTR(phys_device, 0444, show_phys_device, NULL);
+static SYSDEV_ATTR(removable, 0444, show_mem_removable, NULL);
 
 #define mem_create_simple_file(mem, attr_name)	\
 	sysdev_create_file(&mem->sysdev, &attr_##attr_name)
@@ -346,6 +362,8 @@ static int add_memory_block(unsigned lon
 		ret = mem_create_simple_file(mem, state);
 	if (!ret)
 		ret = mem_create_simple_file(mem, phys_device);
+	if (!ret)
+		ret = mem_create_simple_file(mem, removable);
 
 	return ret;
 }
@@ -390,6 +408,7 @@ int remove_memory_block(unsigned long no
 	mem_remove_simple_file(mem, phys_index);
 	mem_remove_simple_file(mem, state);
 	mem_remove_simple_file(mem, phys_device);
+	mem_remove_simple_file(mem, removable);
 	unregister_memory(mem, section);
 
 	return 0;
diff -puN include/linux/memory_hotplug.h~memory-hotplug-add-sysfs-removable-attribute-for-hotplug-memory-remove include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~memory-hotplug-add-sysfs-removable-attribute-for-hotplug-memory-remove
+++ a/include/linux/memory_hotplug.h
@@ -199,6 +199,18 @@ extern int walk_memory_resource(unsigned
 			unsigned long nr_pages, void *arg,
 			int (*func)(unsigned long, unsigned long, void *));
 
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
diff -puN mm/memory_hotplug.c~memory-hotplug-add-sysfs-removable-attribute-for-hotplug-memory-remove mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-add-sysfs-removable-attribute-for-hotplug-memory-remove
+++ a/mm/memory_hotplug.c
@@ -523,6 +523,66 @@ EXPORT_SYMBOL_GPL(add_memory);
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
 /*
+ * A free page on the buddy free lists (not the per-cpu lists) has PageBuddy
+ * set and the size of the free page is given by page_order(). Using this,
+ * the function determines if the pageblock contains only free pages.
+ * Due to buddy contraints, a free page at least the size of a pageblock will
+ * be located at the start of the pageblock
+ */
+static inline int pageblock_free(struct page *page)
+{
+	return PageBuddy(page) && page_order(page) >= pageblock_order;
+}
+
+/* Return the start of the next active pageblock after a given page */
+static struct page *next_active_pageblock(struct page *page)
+{
+	int pageblocks_stride;
+
+	/* Ensure the starting page is pageblock-aligned */
+	BUG_ON(page_to_pfn(page) & (pageblock_nr_pages - 1));
+
+	/* Move forward by at least 1 * pageblock_nr_pages */
+	pageblocks_stride = 1;
+
+	/* If the entire pageblock is free, move to the end of free page */
+	if (pageblock_free(page))
+		pageblocks_stride += page_order(page) - pageblock_order;
+
+	return page + (pageblocks_stride * pageblock_nr_pages);
+}
+
+/* Checks if this range of memory is likely to be hot-removable. */
+int is_mem_section_removable(unsigned long start_pfn, unsigned long nr_pages)
+{
+	int type;
+	struct page *page = pfn_to_page(start_pfn);
+	struct page *end_page = page + nr_pages;
+
+	/* Check the starting page of each pageblock within the range */
+	for (; page < end_page; page = next_active_pageblock(page)) {
+		type = get_pageblock_migratetype(page);
+
+		/*
+		 * A pageblock containing MOVABLE or free pages is considered
+		 * removable
+		 */
+		if (type != MIGRATE_MOVABLE && !pageblock_free(page))
+			return 0;
+
+		/*
+		 * A pageblock starting with a PageReserved page is not
+		 * considered removable.
+		 */
+		if (PageReserved(page))
+			return 0;
+	}
+
+	/* All pageblocks in the memory block are likely to be hot-removable */
+	return 1;
+}
+
+/*
  * Confirm all pages in a range [start, end) is belongs to the same zone.
  */
 static int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn)
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

generic_file_aio_read-cleanups.patch
tmpfs-support-aio.patch
memory-hotplugallocate-usemap-on-the-section-with-pgdat-take-4.patch
memory-hotplug-small-fixes-to-bootmem-freeing-for-memory-hotremove.patch
memory-hotplug-add-sysfs-removable-attribute-for-hotplug-memory-remove.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction.patch
jbd2-fix-race-between-jbd2_journal_try_to_free_buffers-and-jbd2-commit-transaction-cleanup.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch

