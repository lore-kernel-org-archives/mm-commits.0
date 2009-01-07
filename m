From: akpm@linux-foundation.org
Subject: - mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:11:47 -0800
Message-ID: <200901072211.n07MBlFh012042@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754830AbZAGWL5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:11:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: garyhade@us.ibm.com, mingo@elte.hu, pbadari@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     mm: show node to memory section relationship with symlinks in sysfs
has been removed from the -mm tree.  Its filename was
     mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: show node to memory section relationship with symlinks in sysfs
From: Gary Hade <garyhade@us.ibm.com>

Show node to memory section relationship with symlinks in sysfs

Add /sys/devices/system/node/nodeX/memoryY symlinks for all
the memory sections located on nodeX.  For example:
/sys/devices/system/node/node1/memory135 -> ../../memory/memory135
indicates that memory section 135 resides on node1.

Also revises documentation to cover this change as well as updating
Documentation/ABI/testing/sysfs-devices-memory to include descriptions
of memory hotremove files 'phys_device', 'phys_index', and 'state'
that were previously not described there.

In addition to it always being a good policy to provide users with
the maximum possible amount of physical location information for
resources that can be hot-added and/or hot-removed, the following
are some (but likely not all) of the user benefits provided by
this change.
Immediate:
  - Provides information needed to determine the specific node
    on which a defective DIMM is located.  This will reduce system
    downtime when the node or defective DIMM is swapped out.
  - Prevents unintended onlining of a memory section that was
    previously offlined due to a defective DIMM.  This could happen
    during node hot-add when the user or node hot-add assist script
    onlines _all_ offlined sections due to user or script inability
    to identify the specific memory sections located on the hot-added
    node.  The consequences of reintroducing the defective memory
    could be ugly.
  - Provides information needed to vary the amount and distribution
    of memory on specific nodes for testing or debugging purposes.
Future:
  - Will provide information needed to identify the memory
    sections that need to be offlined prior to physical removal
    of a specific node.

Symlink creation during boot was tested on 2-node x86_64, 2-node
ppc64, and 2-node ia64 systems.  Symlink creation during physical
memory hot-add tested on a 2-node x86_64 system.

Signed-off-by: Gary Hade <garyhade@us.ibm.com>
Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-devices-memory |   51 +++++++
 Documentation/memory-hotplug.txt               |   16 +-
 arch/ia64/mm/init.c                            |    2 
 arch/powerpc/mm/mem.c                          |    2 
 arch/s390/mm/init.c                            |    2 
 arch/sh/mm/init.c                              |    3 
 arch/x86/mm/init_32.c                          |    2 
 arch/x86/mm/init_64.c                          |    2 
 drivers/base/memory.c                          |   19 +-
 drivers/base/node.c                            |  103 +++++++++++++++
 include/linux/memory.h                         |    6 
 include/linux/memory_hotplug.h                 |    2 
 include/linux/node.h                           |   13 +
 mm/memory_hotplug.c                            |   11 -
 14 files changed, 209 insertions(+), 25 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-devices-memory~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs Documentation/ABI/testing/sysfs-devices-memory
--- a/Documentation/ABI/testing/sysfs-devices-memory~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs
+++ a/Documentation/ABI/testing/sysfs-devices-memory
@@ -6,7 +6,6 @@ Description:
 		internal state of the kernel memory blocks. Files could be
 		added or removed dynamically to represent hot-add/remove
 		operations.
-
 Users:		hotplug memory add/remove tools
 		https://w3.opensource.ibm.com/projects/powerpc-utils/
 
@@ -19,6 +18,56 @@ Description:
 		This is useful for a user-level agent to determine
 		identify removable sections of the memory before attempting
 		potentially expensive hot-remove memory operation
+Users:		hotplug memory remove tools
+		https://w3.opensource.ibm.com/projects/powerpc-utils/
+
+What:		/sys/devices/system/memory/memoryX/phys_device
+Date:		September 2008
+Contact:	Badari Pulavarty <pbadari@us.ibm.com>
+Description:
+		The file /sys/devices/system/memory/memoryX/phys_device
+		is read-only and is designed to show the name of physical
+		memory device.  Implementation is currently incomplete.
 
+What:		/sys/devices/system/memory/memoryX/phys_index
+Date:		September 2008
+Contact:	Badari Pulavarty <pbadari@us.ibm.com>
+Description:
+		The file /sys/devices/system/memory/memoryX/phys_index
+		is read-only and contains the section ID in hexadecimal
+		which is equivalent to decimal X contained in the
+		memory section directory name.
+
+What:		/sys/devices/system/memory/memoryX/state
+Date:		September 2008
+Contact:	Badari Pulavarty <pbadari@us.ibm.com>
+Description:
+		The file /sys/devices/system/memory/memoryX/state
+		is read-write.  When read, it's contents show the
+		online/offline state of the memory section.  When written,
+		root can toggle the the online/offline state of a removable
+		memory section (see removable file description above)
+		using the following commands.
+		# echo online > /sys/devices/system/memory/memoryX/state
+		# echo offline > /sys/devices/system/memory/memoryX/state
+
+		For example, if /sys/devices/system/memory/memory22/removable
+		contains a value of 1 and
+		/sys/devices/system/memory/memory22/state contains the
+		string "online" the following command can be executed by
+		by root to offline that section.
+		# echo offline > /sys/devices/system/memory/memory22/state
 Users:		hotplug memory remove tools
 		https://w3.opensource.ibm.com/projects/powerpc-utils/
+
+What:		/sys/devices/system/node/nodeX/memoryY
+Date:		September 2008
+Contact:	Gary Hade <garyhade@us.ibm.com>
+Description:
+		When CONFIG_NUMA is enabled
+		/sys/devices/system/node/nodeX/memoryY is a symbolic link that
+		points to the corresponding /sys/devices/system/memory/memoryY
+		memory section directory.  For example, the following symbolic
+		link is created for memory section 9 on node0.
+		/sys/devices/system/node/node0/memory9 -> ../../memory/memory9
+
diff -puN Documentation/memory-hotplug.txt~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs Documentation/memory-hotplug.txt
--- a/Documentation/memory-hotplug.txt~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs
+++ a/Documentation/memory-hotplug.txt
@@ -124,7 +124,7 @@ config options.
     This option can be kernel module too.
 
 --------------------------------
-3 sysfs files for memory hotplug
+4 sysfs files for memory hotplug
 --------------------------------
 All sections have their device information under /sys/devices/system/memory as
 
@@ -138,11 +138,12 @@ For example, assume 1GiB section size. A
 (0x100000000 / 1Gib = 4)
 This device covers address range [0x100000000 ... 0x140000000)
 
-Under each section, you can see 3 files.
+Under each section, you can see 4 files.
 
 /sys/devices/system/memory/memoryXXX/phys_index
 /sys/devices/system/memory/memoryXXX/phys_device
 /sys/devices/system/memory/memoryXXX/state
+/sys/devices/system/memory/memoryXXX/removable
 
 'phys_index' : read-only and contains section id, same as XXX.
 'state'      : read-write
@@ -150,10 +151,20 @@ Under each section, you can see 3 files.
                at write: user can specify "online", "offline" command
 'phys_device': read-only: designed to show the name of physical memory device.
                This is not well implemented now.
+'removable'  : read-only: contains an integer value indicating
+               whether the memory section is removable or not
+               removable.  A value of 1 indicates that the memory
+               section is removable and a value of 0 indicates that
+               it is not removable.
 
 NOTE:
   These directories/files appear after physical memory hotplug phase.
 
+If CONFIG_NUMA is enabled the
+/sys/devices/system/memory/memoryXXX memory section
+directories can also be accessed via symbolic links located in
+the /sys/devices/system/node/node* directories.  For example:
+/sys/devices/system/node/node0/memory9 -> ../../memory/memory9
 
 --------------------------------
 4. Physical memory hot-add phase
@@ -365,7 +376,6 @@ node if necessary.
   - allowing memory hot-add to ZONE_MOVABLE. maybe we need some switch like
     sysctl or new control file.
   - showing memory section and physical device relationship.
-  - showing memory section and node relationship (maybe good for NUMA)
   - showing memory section is under ZONE_MOVABLE or not
   - test and make it better memory offlining.
   - support HugeTLB page migration and offlining.
diff -puN arch/ia64/mm/init.c~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs
+++ a/arch/ia64/mm/init.c
@@ -692,7 +692,7 @@ int arch_add_memory(int nid, u64 start, 
 	pgdat = NODE_DATA(nid);
 
 	zone = pgdat->node_zones + ZONE_NORMAL;
-	ret = __add_pages(zone, start_pfn, nr_pages);
+	ret = __add_pages(nid, zone, start_pfn, nr_pages);
 
 	if (ret)
 		printk("%s: Problem encountered in __add_pages() as ret=%d\n",
diff -puN arch/powerpc/mm/mem.c~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs
+++ a/arch/powerpc/mm/mem.c
@@ -132,7 +132,7 @@ int arch_add_memory(int nid, u64 start, 
 	/* this should work for most non-highmem platforms */
 	zone = pgdata->node_zones;
 
-	return __add_pages(zone, start_pfn, nr_pages);
+	return __add_pages(nid, zone, start_pfn, nr_pages);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
diff -puN arch/s390/mm/init.c~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs arch/s390/mm/init.c
--- a/arch/s390/mm/init.c~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs
+++ a/arch/s390/mm/init.c
@@ -183,7 +183,7 @@ int arch_add_memory(int nid, u64 start, 
 	rc = vmem_add_mapping(start, size);
 	if (rc)
 		return rc;
-	rc = __add_pages(zone, PFN_DOWN(start), PFN_DOWN(size));
+	rc = __add_pages(nid, zone, PFN_DOWN(start), PFN_DOWN(size));
 	if (rc)
 		vmem_remove_mapping(start, size);
 	return rc;
diff -puN arch/sh/mm/init.c~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs
+++ a/arch/sh/mm/init.c
@@ -311,7 +311,8 @@ int arch_add_memory(int nid, u64 start, 
 	pgdat = NODE_DATA(nid);
 
 	/* We only have ZONE_NORMAL, so this is easy.. */
-	ret = __add_pages(pgdat->node_zones + ZONE_NORMAL, start_pfn, nr_pages);
+	ret = __add_pages(nid, pgdat->node_zones + ZONE_NORMAL,
+				start_pfn, nr_pages);
 	if (unlikely(ret))
 		printk("%s: Failed, __add_pages() == %d\n", __func__, ret);
 
diff -puN arch/x86/mm/init_32.c~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs
+++ a/arch/x86/mm/init_32.c
@@ -1079,7 +1079,7 @@ int arch_add_memory(int nid, u64 start, 
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	return __add_pages(zone, start_pfn, nr_pages);
+	return __add_pages(nid, zone, start_pfn, nr_pages);
 }
 #endif
 
diff -puN arch/x86/mm/init_64.c~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs
+++ a/arch/x86/mm/init_64.c
@@ -857,7 +857,7 @@ int arch_add_memory(int nid, u64 start, 
 	if (last_mapped_pfn > max_pfn_mapped)
 		max_pfn_mapped = last_mapped_pfn;
 
-	ret = __add_pages(zone, start_pfn, nr_pages);
+	ret = __add_pages(nid, zone, start_pfn, nr_pages);
 	WARN_ON_ONCE(ret);
 
 	return ret;
diff -puN drivers/base/memory.c~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs drivers/base/memory.c
--- a/drivers/base/memory.c~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs
+++ a/drivers/base/memory.c
@@ -347,8 +347,9 @@ static inline int memory_probe_init(void
  * section belongs to...
  */
 
-static int add_memory_block(unsigned long node_id, struct mem_section *section,
-		     unsigned long state, int phys_device)
+static int add_memory_block(int nid, struct mem_section *section,
+			unsigned long state, int phys_device,
+			enum mem_add_context context)
 {
 	struct memory_block *mem = kzalloc(sizeof(*mem), GFP_KERNEL);
 	int ret = 0;
@@ -370,6 +371,10 @@ static int add_memory_block(unsigned lon
 		ret = mem_create_simple_file(mem, phys_device);
 	if (!ret)
 		ret = mem_create_simple_file(mem, removable);
+	if (!ret) {
+		if (context == HOTPLUG)
+			ret = register_mem_sect_under_node(mem, nid);
+	}
 
 	return ret;
 }
@@ -382,7 +387,7 @@ static int add_memory_block(unsigned lon
  *
  * This could be made generic for all sysdev classes.
  */
-static struct memory_block *find_memory_block(struct mem_section *section)
+struct memory_block *find_memory_block(struct mem_section *section)
 {
 	struct kobject *kobj;
 	struct sys_device *sysdev;
@@ -411,6 +416,7 @@ int remove_memory_block(unsigned long no
 	struct memory_block *mem;
 
 	mem = find_memory_block(section);
+	unregister_mem_sect_under_nodes(mem);
 	mem_remove_simple_file(mem, phys_index);
 	mem_remove_simple_file(mem, state);
 	mem_remove_simple_file(mem, phys_device);
@@ -424,9 +430,9 @@ int remove_memory_block(unsigned long no
  * need an interface for the VM to add new memory regions,
  * but without onlining it.
  */
-int register_new_memory(struct mem_section *section)
+int register_new_memory(int nid, struct mem_section *section)
 {
-	return add_memory_block(0, section, MEM_OFFLINE, 0);
+	return add_memory_block(nid, section, MEM_OFFLINE, 0, HOTPLUG);
 }
 
 int unregister_memory_section(struct mem_section *section)
@@ -458,7 +464,8 @@ int __init memory_dev_init(void)
 	for (i = 0; i < NR_MEM_SECTIONS; i++) {
 		if (!present_section_nr(i))
 			continue;
-		err = add_memory_block(0, __nr_to_section(i), MEM_ONLINE, 0);
+		err = add_memory_block(0, __nr_to_section(i), MEM_ONLINE,
+					0, BOOT);
 		if (!ret)
 			ret = err;
 	}
diff -puN drivers/base/node.c~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs drivers/base/node.c
--- a/drivers/base/node.c~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs
+++ a/drivers/base/node.c
@@ -6,6 +6,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/mm.h>
+#include <linux/memory.h>
 #include <linux/node.h>
 #include <linux/hugetlb.h>
 #include <linux/cpumask.h>
@@ -248,6 +249,105 @@ int unregister_cpu_under_node(unsigned i
 	return 0;
 }
 
+#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
+#define page_initialized(page)  (page->lru.next)
+
+static int get_nid_for_pfn(unsigned long pfn)
+{
+	struct page *page;
+
+	if (!pfn_valid_within(pfn))
+		return -1;
+	page = pfn_to_page(pfn);
+	if (!page_initialized(page))
+		return -1;
+	return pfn_to_nid(pfn);
+}
+
+/* register memory section under specified node if it spans that node */
+int register_mem_sect_under_node(struct memory_block *mem_blk, int nid)
+{
+	unsigned long pfn, sect_start_pfn, sect_end_pfn;
+
+	if (!mem_blk)
+		return -EFAULT;
+	if (!node_online(nid))
+		return 0;
+	sect_start_pfn = section_nr_to_pfn(mem_blk->phys_index);
+	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
+	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
+		int page_nid;
+
+		page_nid = get_nid_for_pfn(pfn);
+		if (page_nid < 0)
+			continue;
+		if (page_nid != nid)
+			continue;
+		return sysfs_create_link_nowarn(&node_devices[nid].sysdev.kobj,
+					&mem_blk->sysdev.kobj,
+					kobject_name(&mem_blk->sysdev.kobj));
+	}
+	/* mem section does not span the specified node */
+	return 0;
+}
+
+/* unregister memory section under all nodes that it spans */
+int unregister_mem_sect_under_nodes(struct memory_block *mem_blk)
+{
+	nodemask_t unlinked_nodes;
+	unsigned long pfn, sect_start_pfn, sect_end_pfn;
+
+	if (!mem_blk)
+		return -EFAULT;
+	nodes_clear(unlinked_nodes);
+	sect_start_pfn = section_nr_to_pfn(mem_blk->phys_index);
+	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
+	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
+		unsigned int nid;
+
+		nid = get_nid_for_pfn(pfn);
+		if (nid < 0)
+			continue;
+		if (!node_online(nid))
+			continue;
+		if (node_test_and_set(nid, unlinked_nodes))
+			continue;
+		sysfs_remove_link(&node_devices[nid].sysdev.kobj,
+			 kobject_name(&mem_blk->sysdev.kobj));
+	}
+	return 0;
+}
+
+static int link_mem_sections(int nid)
+{
+	unsigned long start_pfn = NODE_DATA(nid)->node_start_pfn;
+	unsigned long end_pfn = start_pfn + NODE_DATA(nid)->node_spanned_pages;
+	unsigned long pfn;
+	int err = 0;
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
+		unsigned long section_nr = pfn_to_section_nr(pfn);
+		struct mem_section *mem_sect;
+		struct memory_block *mem_blk;
+		int ret;
+
+		if (!present_section_nr(section_nr))
+			continue;
+		mem_sect = __nr_to_section(section_nr);
+		mem_blk = find_memory_block(mem_sect);
+		ret = register_mem_sect_under_node(mem_blk, nid);
+		if (!err)
+			err = ret;
+
+		/* discard ref obtained in find_memory_block() */
+		kobject_put(&mem_blk->sysdev.kobj);
+	}
+	return err;
+}
+#else
+static int link_mem_sections(int nid) { return 0; }
+#endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
+
 int register_one_node(int nid)
 {
 	int error = 0;
@@ -267,6 +367,9 @@ int register_one_node(int nid)
 			if (cpu_to_node(cpu) == nid)
 				register_cpu_under_node(cpu, nid);
 		}
+
+		/* link memory sections under this node */
+		error = link_mem_sections(nid);
 	}
 
 	return error;
diff -puN include/linux/memory.h~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs include/linux/memory.h
--- a/include/linux/memory.h~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs
+++ a/include/linux/memory.h
@@ -79,14 +79,14 @@ static inline int memory_notify(unsigned
 #else
 extern int register_memory_notifier(struct notifier_block *nb);
 extern void unregister_memory_notifier(struct notifier_block *nb);
-extern int register_new_memory(struct mem_section *);
+extern int register_new_memory(int, struct mem_section *);
 extern int unregister_memory_section(struct mem_section *);
 extern int memory_dev_init(void);
 extern int remove_memory_block(unsigned long, struct mem_section *, int);
 extern int memory_notify(unsigned long val, void *v);
+extern struct memory_block *find_memory_block(struct mem_section *);
 #define CONFIG_MEM_BLOCK_SIZE	(PAGES_PER_SECTION<<PAGE_SHIFT)
-
-
+enum mem_add_context { BOOT, HOTPLUG };
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
 #ifdef CONFIG_MEMORY_HOTPLUG
diff -puN include/linux/memory_hotplug.h~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs
+++ a/include/linux/memory_hotplug.h
@@ -72,7 +72,7 @@ extern void __offline_isolated_pages(uns
 extern int offline_pages(unsigned long, unsigned long, unsigned long);
 
 /* reasonably generic interface to expand the physical pages in a zone  */
-extern int __add_pages(struct zone *zone, unsigned long start_pfn,
+extern int __add_pages(int nid, struct zone *zone, unsigned long start_pfn,
 	unsigned long nr_pages);
 extern int __remove_pages(struct zone *zone, unsigned long start_pfn,
 	unsigned long nr_pages);
diff -puN include/linux/node.h~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs include/linux/node.h
--- a/include/linux/node.h~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs
+++ a/include/linux/node.h
@@ -26,6 +26,7 @@ struct node {
 	struct sys_device	sysdev;
 };
 
+struct memory_block;
 extern struct node node_devices[];
 
 extern int register_node(struct node *, int, struct node *);
@@ -35,6 +36,9 @@ extern int register_one_node(int nid);
 extern void unregister_one_node(int nid);
 extern int register_cpu_under_node(unsigned int cpu, unsigned int nid);
 extern int unregister_cpu_under_node(unsigned int cpu, unsigned int nid);
+extern int register_mem_sect_under_node(struct memory_block *mem_blk,
+						int nid);
+extern int unregister_mem_sect_under_nodes(struct memory_block *mem_blk);
 #else
 static inline int register_one_node(int nid)
 {
@@ -52,6 +56,15 @@ static inline int unregister_cpu_under_n
 {
 	return 0;
 }
+static inline int register_mem_sect_under_node(struct memory_block *mem_blk,
+							int nid)
+{
+	return 0;
+}
+static inline int unregister_mem_sect_under_nodes(struct memory_block *mem_blk)
+{
+	return 0;
+}
 #endif
 
 #define to_node(sys_device) container_of(sys_device, struct node, sysdev)
diff -puN mm/memory_hotplug.c~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs
+++ a/mm/memory_hotplug.c
@@ -216,7 +216,8 @@ static int __meminit __add_zone(struct z
 	return 0;
 }
 
-static int __meminit __add_section(struct zone *zone, unsigned long phys_start_pfn)
+static int __meminit __add_section(int nid, struct zone *zone,
+					unsigned long phys_start_pfn)
 {
 	int nr_pages = PAGES_PER_SECTION;
 	int ret;
@@ -234,7 +235,7 @@ static int __meminit __add_section(struc
 	if (ret < 0)
 		return ret;
 
-	return register_new_memory(__pfn_to_section(phys_start_pfn));
+	return register_new_memory(nid, __pfn_to_section(phys_start_pfn));
 }
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
@@ -273,8 +274,8 @@ static int __remove_section(struct zone 
  * call this function after deciding the zone to which to
  * add the new pages.
  */
-int __ref __add_pages(struct zone *zone, unsigned long phys_start_pfn,
-		 unsigned long nr_pages)
+int __ref __add_pages(int nid, struct zone *zone, unsigned long phys_start_pfn,
+			unsigned long nr_pages)
 {
 	unsigned long i;
 	int err = 0;
@@ -284,7 +285,7 @@ int __ref __add_pages(struct zone *zone,
 	end_sec = pfn_to_section_nr(phys_start_pfn + nr_pages - 1);
 
 	for (i = start_sec; i <= end_sec; i++) {
-		err = __add_section(zone, i << PFN_SECTION_SHIFT);
+		err = __add_section(nid, zone, i << PFN_SECTION_SHIFT);
 
 		/*
 		 * EEXIST is finally dealt with by ioresource collision
_

Patches currently in -mm which might be from garyhade@us.ibm.com are

origin.patch

