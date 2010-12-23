From: akpm@linux-foundation.org
Subject: [to-be-updated] numa-hotplug-emulator-implement-per-node-add_memory-debugfs-interface.patch removed from -mm tree
Date: Thu, 23 Dec 2010 15:17:38 -0800
Message-ID: <201012232350.oBNNolU4018276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751882Ab0LWXvW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Dec 2010 18:51:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohui.zheng@intel.com, dave@linux.vnet.ibm.com, emunson@mgebm.net, gregkh@suse.de, haicheng.li@intel.com, hpa@zytor.com, len.brown@intel.com, lethal@linux-sh.org, mingo@elte.hu, ran


The patch titled
     NUMA hotplug emulator: implement per-node add_memory debugfs interface
has been removed from the -mm tree.  Its filename was
     numa-hotplug-emulator-implement-per-node-add_memory-debugfs-interface.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: NUMA hotplug emulator: implement per-node add_memory debugfs interface
From: Shaohui Zheng <shaohui.zheng@intel.com>

Add add_memory interface to support to memory hotplug emulation for each
online node under debugfs.  The reserved memory can be added into desired
node with this interface.

The layout on debugfs:
	mem_hotplug/node0/add_memory
	mem_hotplug/node1/add_memory
	mem_hotplug/node2/add_memory
	...

Add a memory section(128M) to node 3(boots with mem=1024m)

	echo 0x40000000 > mem_hotplug/node3/add_memory

Signed-off-by: Haicheng Li <haicheng.li@intel.com>
Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/memory-hotplug.txt |   20 +++++++
 mm/memory_hotplug.c              |   77 +++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+)

diff -puN Documentation/memory-hotplug.txt~numa-hotplug-emulator-implement-per-node-add_memory-debugfs-interface Documentation/memory-hotplug.txt
--- a/Documentation/memory-hotplug.txt~numa-hotplug-emulator-implement-per-node-add_memory-debugfs-interface
+++ a/Documentation/memory-hotplug.txt
@@ -19,6 +19,7 @@ be changed often.
   4.1 Hardware(Firmware) Support
   4.2 Notify memory hot-add event by hand
   4.3 Node hotplug emulation
+  4.4 Memory hotplug emulation
 5. Logical Memory hot-add phase
   5.1. State of memory
   5.2. How to online memory
@@ -239,6 +240,25 @@ Where "size" can be represented in megab
 Once the new node has been added, it is possible to online the memory by
 toggling the "state" of its memory section(s) as described in section 5.1.
 
+4.4 Memory hotplug emulation
+------------
+With debugfs, it is possible to test memory hotplug with software method, we
+can add memory section to desired node with add_memory interface. It is a much
+more powerful interface than "probe" described in section 4.2.
+
+There is an add_memory interface for each online node at the debugfs mount
+point.
+	mem_hotplug/node0/add_memory
+	mem_hotplug/node1/add_memory
+	mem_hotplug/node2/add_memory
+	...
+
+Add a memory section(128M) to node 3(boots with mem=1024m)
+
+	echo 0x40000000 > mem_hotplug/node3/add_memory
+
+Once the new memory section has been added, it is possible to online the memory
+by toggling the "state" described in section 5.1.
 
 ------------------------------
 5. Logical Memory hot-add phase
diff -puN mm/memory_hotplug.c~numa-hotplug-emulator-implement-per-node-add_memory-debugfs-interface mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~numa-hotplug-emulator-implement-per-node-add_memory-debugfs-interface
+++ a/mm/memory_hotplug.c
@@ -933,6 +933,81 @@ EXPORT_SYMBOL_GPL(remove_memory);
 
 static struct dentry *memhp_debug_root;
 
+#ifdef CONFIG_ARCH_MEMORY_PROBE
+
+static ssize_t add_memory_store(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	u64 phys_addr = 0;
+	int nid = file->private_data - NULL;
+	int ret;
+
+	printk(KERN_INFO "Add a memory section to node: %d.\n", nid);
+	phys_addr = simple_strtoull(buf, NULL, 0);
+
+	ret = add_memory(nid, phys_addr, PAGES_PER_SECTION << PAGE_SHIFT);
+	if (ret)
+		count = ret;
+
+	return count;
+}
+
+static int add_memory_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static const struct file_operations add_memory_file_ops = {
+	.open		= add_memory_open,
+	.write		= add_memory_store,
+	.llseek		= generic_file_llseek,
+};
+
+/*
+ * Create add_memory debugfs entry under specified node
+ */
+static int debugfs_create_add_memory_entry(int nid)
+{
+	char buf[32];
+	static struct dentry *node_debug_root;
+
+	snprintf(buf, sizeof(buf), "node%d", nid);
+	node_debug_root = debugfs_create_dir(buf, memhp_debug_root);
+	if (!node_debug_root)
+		return -ENOMEM;
+
+	/* the nid information was represented by the offset of pointer(NULL+nid) */
+	if (!debugfs_create_file("add_memory", S_IWUSR, node_debug_root,
+			NULL + nid, &add_memory_file_ops))
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int __init memory_debug_init(void)
+{
+	int nid;
+
+	if (!memhp_debug_root)
+		memhp_debug_root = debugfs_create_dir("mem_hotplug", NULL);
+	if (!memhp_debug_root)
+		return -ENOMEM;
+
+	for_each_online_node(nid)
+		 debugfs_create_add_memory_entry(nid);
+
+	return 0;
+}
+
+module_init(memory_debug_init);
+#else
+static debugfs_create_add_memory_entry(int nid)
+{
+	return 0;
+}
+#endif /* CONFIG_ARCH_MEMORY_PROBE */
+
 static ssize_t add_node_store(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
@@ -963,6 +1038,8 @@ static ssize_t add_node_store(struct fil
 		return -ENOMEM;
 
 	ret = add_memory(nid, start, size);
+
+	debugfs_create_add_memory_entry(nid);
 	return ret ? ret : count;
 }
 
_

Patches currently in -mm which might be from shaohui.zheng@intel.com are


