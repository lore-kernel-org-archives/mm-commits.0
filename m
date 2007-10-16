From: akpm@linux-foundation.org
Subject: - add-node-states-sysfs-class-attributes-v5.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:36:14 -0700
Message-ID: <200710162036.l9GKaEs5015132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51678 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934697AbXJPVhE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:37:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, clameter@sgi.com, lee.schermerhorn@hp.com, mm-commits@vger.kernel.org


The patch titled
     mm: add node states sysfs class attributeS
has been removed from the -mm tree.  Its filename was
     add-node-states-sysfs-class-attributes-v5.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: add node states sysfs class attributeS
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Add a per node state sysfs class attribute file to /sys/devices/system/node
to display node state masks.

E.g., on a 4-cell HP ia64 NUMA platform, we have 5 nodes: 4 representing
the actual hardware cells and one memory-only pseudo-node representing a
small amount [512MB] of "hardware interleaved" memory.  With this patch, in
/sys/devices/system/node we see:

#ls -1F /sys/devices/system/node
has_cpu
has_normal_memory
node0/
node1/
node2/
node3/
node4/
online
possible
#cat /sys/devices/system/node/possible
0-255
#cat /sys/devices/system/node/online
0-4
#cat /sys/devices/system/node/has_normal_memory
0-4
#cat /sys/devices/system/node/has_cpu
0-3

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |   91 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 90 insertions(+), 1 deletion(-)

diff -puN drivers/base/node.c~add-node-states-sysfs-class-attributes-v5 drivers/base/node.c
--- a/drivers/base/node.c~add-node-states-sysfs-class-attributes-v5
+++ a/drivers/base/node.c
@@ -12,6 +12,7 @@
 #include <linux/topology.h>
 #include <linux/nodemask.h>
 #include <linux/cpu.h>
+#include <linux/device.h>
 
 static struct sysdev_class node_class = {
 	set_kset_name("node"),
@@ -232,8 +233,96 @@ void unregister_one_node(int nid)
 	unregister_node(&node_devices[nid]);
 }
 
+/*
+ * node states attributes
+ */
+
+static ssize_t print_nodes_state(enum node_states state, char *buf)
+{
+	int n;
+
+	n = nodelist_scnprintf(buf, PAGE_SIZE, node_states[state]);
+	if (n > 0 && PAGE_SIZE > n + 1) {
+		*(buf + n++) = '\n';
+		*(buf + n++) = '\0';
+	}
+	return n;
+}
+
+static ssize_t print_nodes_possible(struct sysdev_class *class, char *buf)
+{
+	return print_nodes_state(N_POSSIBLE, buf);
+}
+
+static ssize_t print_nodes_online(struct sysdev_class *class, char *buf)
+{
+	return print_nodes_state(N_ONLINE, buf);
+}
+
+static ssize_t print_nodes_has_normal_memory(struct sysdev_class *class,
+						char *buf)
+{
+	return print_nodes_state(N_NORMAL_MEMORY, buf);
+}
+
+static ssize_t print_nodes_has_cpu(struct sysdev_class *class, char *buf)
+{
+	return print_nodes_state(N_CPU, buf);
+}
+
+static SYSDEV_CLASS_ATTR(possible, 0444, print_nodes_possible, NULL);
+static SYSDEV_CLASS_ATTR(online, 0444, print_nodes_online, NULL);
+static SYSDEV_CLASS_ATTR(has_normal_memory, 0444, print_nodes_has_normal_memory,
+									NULL);
+static SYSDEV_CLASS_ATTR(has_cpu, 0444, print_nodes_has_cpu, NULL);
+
+#ifdef CONFIG_HIGHMEM
+static ssize_t print_nodes_has_high_memory(struct sysdev_class *class,
+						 char *buf)
+{
+	return print_nodes_state(N_HIGH_MEMORY, buf);
+}
+
+static SYSDEV_CLASS_ATTR(has_high_memory, 0444, print_nodes_has_high_memory,
+									 NULL);
+#endif
+
+struct sysdev_class_attribute *node_state_attr[] = {
+	&attr_possible,
+	&attr_online,
+	&attr_has_normal_memory,
+#ifdef CONFIG_HIGHMEM
+	&attr_has_high_memory,
+#endif
+	&attr_has_cpu,
+};
+
+static int node_states_init(void)
+{
+	int i;
+	int err = 0;
+
+	for (i = 0;  i < NR_NODE_STATES; i++) {
+		int ret;
+		ret = sysdev_class_create_file(&node_class, node_state_attr[i]);
+		if (!err)
+			err = ret;
+	}
+	return err;
+}
+
 static int __init register_node_type(void)
 {
-	return sysdev_class_register(&node_class);
+	int ret;
+
+	ret = sysdev_class_register(&node_class);
+	if (!ret)
+		ret = node_states_init();
+
+	/*
+	 * Note:  we're not going to unregister the node class if we fail
+	 * to register the node state class attribute files.
+	 */
+	return ret;
 }
 postcore_initcall(register_node_type);
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

origin.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix-2.patch
