From: akpm@linux-foundation.org
Subject: [to-be-updated] numa-hotplug-emulator-add-node-hotplug-emulation.patch removed from -mm tree
Date: Thu, 23 Dec 2010 15:17:24 -0800
Message-ID: <201012232350.oBNNoXf6018256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751656Ab0LWXwZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Dec 2010 18:52:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, dave@linux.vnet.ibm.com, emunson@mgebm.net, gregkh@suse.de, haicheng.li@intel.com, hpa@zytor.com, len.brown@intel.com, lethal@linux-sh.org, mingo@elte.hu, randy.d


The patch titled
     NUMA hotplug emulator: add node hotplug emulation
has been removed from the -mm tree.  Its filename was
     numa-hotplug-emulator-add-node-hotplug-emulation.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: NUMA hotplug emulator: add node hotplug emulation
From: David Rientjes <rientjes@google.com>

Add an interface to allow new nodes to be added when performing memory
hot-add.  This provides a convenient interface to test memory hotplug
notifier callbacks and surrounding hotplug code when new nodes are onlined
without actually having a machine with such hotpluggable SRAT entries.

This adds a new debugfs interface at
/sys/kernel/debug/mem_hotplug/add_node that behaves in a similar way to
the memory hot-add "probe" interface.  Its format is size@start, where
"size" is the size of the new node to be added and "start" is the physical
address of the new memory.

The new node id is a currently offline, but possible, node.  The bit must
be set in node_possible_map so that nr_node_ids is sized appropriately.

For emulation on x86, for example, it would be possible to set aside
memory for hotplugged nodes (say, anything above 2G) and to add an
additional four nodes as being possible on boot with

	mem=2G numa=possible=4

and then creating a new 128M node at runtime:

	# echo 128M@0x80000000 > /sys/kernel/debug/mem_hotplug/add_node
	On node 1 totalpages: 0
	init_memory_mapping: 0000000080000000-0000000088000000
	 0080000000 - 0088000000 page 2M

Once the new node has been added, its memory can be onlined.  If this
memory represents memory section 16, for example:

	# echo online > /sys/devices/system/memory/memory16/state
	Built 2 zonelists in Node order, mobility grouping on.  Total pages: 514846
	Policy zone: Normal
 [ The memory section(s) mapped to a particular node are visible via
   /sys/kernel/debug/mem_hotplug/node1, in this example. ]

The new node is now hotplugged and ready for testing.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: Haicheng Li <haicheng.li@intel.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/memory-hotplug.txt |   24 +++++++++++
 mm/memory_hotplug.c              |   60 +++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)

diff -puN Documentation/memory-hotplug.txt~numa-hotplug-emulator-add-node-hotplug-emulation Documentation/memory-hotplug.txt
--- a/Documentation/memory-hotplug.txt~numa-hotplug-emulator-add-node-hotplug-emulation
+++ a/Documentation/memory-hotplug.txt
@@ -18,6 +18,7 @@ be changed often.
 4. Physical memory hot-add phase
   4.1 Hardware(Firmware) Support
   4.2 Notify memory hot-add event by hand
+  4.3 Node hotplug emulation
 5. Logical Memory hot-add phase
   5.1. State of memory
   5.2. How to online memory
@@ -215,6 +216,29 @@ current implementation). You'll have to 
 Please see "How to online memory" in this text.
 
 
+4.3 Node hotplug emulation
+------------
+With debugfs, it is possible to test node hotplug by assigning the newly
+added memory to a new node id when using a different interface with a similar
+behavior to "probe" described in section 4.2.  If a node id is possible
+(there are bits in /sys/devices/system/memory/possible that are not online),
+then it may be used to emulate a newly added node as the result of memory
+hotplug by using the debugfs "add_node" interface.
+
+The add_node interface is located at "mem_hotplug/add_node" at the debugfs
+mount point.
+
+You can create a new node of a specified size starting at the physical
+address of new memory by
+
+% echo size@start_address_of_new_memory > /sys/kernel/debug/mem_hotplug/add_node
+
+Where "size" can be represented in megabytes or gigabytes (for example,
+"128M" or "1G").  The minumum size is that of a memory section.
+
+Once the new node has been added, it is possible to online the memory by
+toggling the "state" of its memory section(s) as described in section 5.1.
+
 
 ------------------------------
 5. Logical Memory hot-add phase
diff -puN mm/memory_hotplug.c~numa-hotplug-emulator-add-node-hotplug-emulation mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~numa-hotplug-emulator-add-node-hotplug-emulation
+++ a/mm/memory_hotplug.c
@@ -927,3 +927,63 @@ int remove_memory(u64 start, u64 size)
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 EXPORT_SYMBOL_GPL(remove_memory);
+
+#ifdef CONFIG_DEBUG_FS
+#include <linux/debugfs.h>
+
+static struct dentry *memhp_debug_root;
+
+static ssize_t add_node_store(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	nodemask_t mask;
+	u64 start, size;
+	char buffer[64];
+	char *p;
+	int nid;
+	int ret;
+
+	memset(buffer, 0, sizeof(buffer));
+	if (count > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+	if (copy_from_user(buffer, buf, count))
+		return -EFAULT;
+
+	size = memparse(buffer, &p);
+	if (size < (PAGES_PER_SECTION << PAGE_SHIFT))
+		return -EINVAL;
+	if (*p != '@')
+		return -EINVAL;
+
+	start = simple_strtoull(p + 1, NULL, 0);
+
+	nodes_andnot(mask, node_possible_map, node_online_map);
+	nid = first_node(mask);
+	if (nid == MAX_NUMNODES)
+		return -ENOMEM;
+
+	ret = add_memory(nid, start, size);
+	return ret ? ret : count;
+}
+
+static const struct file_operations add_node_file_ops = {
+	.write		= add_node_store,
+	.llseek		= generic_file_llseek,
+};
+
+static int __init node_debug_init(void)
+{
+	if (!memhp_debug_root)
+		memhp_debug_root = debugfs_create_dir("mem_hotplug", NULL);
+	if (!memhp_debug_root)
+		return -ENOMEM;
+
+	if (!debugfs_create_file("add_node", S_IWUSR, memhp_debug_root,
+			NULL, &add_node_file_ops))
+		return -ENOMEM;
+
+	return 0;
+}
+
+module_init(node_debug_init);
+#endif /* CONFIG_DEBUG_FS */
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch
mm-remove-unused-get_vm_area_node.patch
mm-remove-gfp-mask-from-pcpu_get_vm_areas.patch
mm-unify-module_alloc-code-for-vmalloc.patch
oom-allow-a-non-cap_sys_resource-proces-to-oom_score_adj-down.patch
thp-transparent-hugepage-sysfs-meminfo.patch
numa-hotplug-emulator-abstract-cpu-register-functions.patch
numa-hotplug-emulator-support-cpu-probe-release-in-x86_64.patch
numa-hotplug-emulator-fake-cpu-socket-with-logical-cpu-on-x86.patch
numa-hotplug-emulator-implement-per-node-add_memory-debugfs-interface.patch
flex_array-export-symbols-to-modules.patch
jbd-remove-dependency-on-__gfp_nofail.patch
memcg-fix-unit-mismatch-in-memcg-oom-limit-calculation.patch
proc-use-single_open-correctly.patch

