From: akpm@linux-foundation.org
Subject: [merged] numa-add-config_movable_node-for-movable-dedicated-node.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:29:12 -0800
Message-ID: <20121214232913.6C625200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:51032 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668Ab2LNX3R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:29:17 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so208426fae.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:29:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, greg@kroah.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, minchan.kim@gmail.com, rientjes@google.com, rusty@rustcorp.com.au, wency@cn.fujitsu.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: numa: add CONFIG_MOVABLE_NODE for movable-dedicated node
has been removed from the -mm tree.  Its filename was
     numa-add-config_movable_node-for-movable-dedicated-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: numa: add CONFIG_MOVABLE_NODE for movable-dedicated node

We need a node which only contains movable memory.  This feature is very
important for node hotplug.  If a node has normal/highmem, the memory may
be used by the kernel and can't be offlined.  If the node only contains
movable memory, we can offline the memory and the node.

All are prepared, we can actually introduce N_MEMORY.
add CONFIG_MOVABLE_NODE make we can use it for movable-dedicated node

[akpm@linux-foundation.org: fix Kconfig text]
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Tested-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c      |    6 ++++++
 include/linux/nodemask.h |    4 ++++
 mm/Kconfig               |    8 ++++++++
 mm/page_alloc.c          |    3 +++
 4 files changed, 21 insertions(+)

diff -puN drivers/base/node.c~numa-add-config_movable_node-for-movable-dedicated-node drivers/base/node.c
--- a/drivers/base/node.c~numa-add-config_movable_node-for-movable-dedicated-node
+++ a/drivers/base/node.c
@@ -644,6 +644,9 @@ static struct node_attr node_state_attr[
 #ifdef CONFIG_HIGHMEM
 	[N_HIGH_MEMORY] = _NODE_ATTR(has_high_memory, N_HIGH_MEMORY),
 #endif
+#ifdef CONFIG_MOVABLE_NODE
+	[N_MEMORY] = _NODE_ATTR(has_memory, N_MEMORY),
+#endif
 	[N_CPU] = _NODE_ATTR(has_cpu, N_CPU),
 };
 
@@ -654,6 +657,9 @@ static struct attribute *node_state_attr
 #ifdef CONFIG_HIGHMEM
 	&node_state_attr[N_HIGH_MEMORY].attr.attr,
 #endif
+#ifdef CONFIG_MOVABLE_NODE
+	&node_state_attr[N_MEMORY].attr.attr,
+#endif
 	&node_state_attr[N_CPU].attr.attr,
 	NULL
 };
diff -puN include/linux/nodemask.h~numa-add-config_movable_node-for-movable-dedicated-node include/linux/nodemask.h
--- a/include/linux/nodemask.h~numa-add-config_movable_node-for-movable-dedicated-node
+++ a/include/linux/nodemask.h
@@ -380,7 +380,11 @@ enum node_states {
 #else
 	N_HIGH_MEMORY = N_NORMAL_MEMORY,
 #endif
+#ifdef CONFIG_MOVABLE_NODE
+	N_MEMORY,		/* The node has memory(regular, high, movable) */
+#else
 	N_MEMORY = N_HIGH_MEMORY,
+#endif
 	N_CPU,		/* The node has one or more cpus */
 	NR_NODE_STATES
 };
diff -puN mm/Kconfig~numa-add-config_movable_node-for-movable-dedicated-node mm/Kconfig
--- a/mm/Kconfig~numa-add-config_movable_node-for-movable-dedicated-node
+++ a/mm/Kconfig
@@ -143,6 +143,14 @@ config NO_BOOTMEM
 config MEMORY_ISOLATION
 	boolean
 
+config MOVABLE_NODE
+	boolean "Enable to assign a node which has only movable memory"
+	depends on HAVE_MEMBLOCK
+	depends on NO_BOOTMEM
+	depends on X86_64
+	depends on NUMA
+	default y
+
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
diff -puN mm/page_alloc.c~numa-add-config_movable_node-for-movable-dedicated-node mm/page_alloc.c
--- a/mm/page_alloc.c~numa-add-config_movable_node-for-movable-dedicated-node
+++ a/mm/page_alloc.c
@@ -90,6 +90,9 @@ nodemask_t node_states[NR_NODE_STATES] _
 #ifdef CONFIG_HIGHMEM
 	[N_HIGH_MEMORY] = { { [0] = 1UL } },
 #endif
+#ifdef CONFIG_MOVABLE_NODE
+	[N_MEMORY] = { { [0] = 1UL } },
+#endif
 	[N_CPU] = { { [0] = 1UL } },
 #endif	/* NUMA */
 };
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch

