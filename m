From: akpm@linux-foundation.org
Subject: [merged]
 mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:22:42 -0700
Message-ID: <543d69f2.ymEs8bqi2xGTLL8G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbaJNSWl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:22:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, davej@redhat.com, guz.fnst@cn.fujitsu.com, hpa@zytor.com, mingo@elte.hu, tangchen@cn.fujitsu.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/mm/numa.c: fix boot failure when all nodes are hotpluggable
has been removed from the -mm tree.  Its filename was
     mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: arch/x86/mm/numa.c: fix boot failure when all nodes are hotpluggable

If all the nodes are marked hotpluggable, alloc node data will fail. 
Because __next_mem_range_rev() will skip the hotpluggable memory regions. 
numa_clear_kernel_node_hotplug() is called after alloc node data.

numa_init()
	...
	ret = init_func();  // this will mark hotpluggable flag from SRAT
	...
	memblock_set_bottom_up(false);
	...
	ret = numa_register_memblks(&numa_meminfo);  // this will alloc node data(pglist_data)
	...
	numa_clear_kernel_node_hotplug();  // in case all the nodes are hotpluggable
	...

numa_register_memblks()
	setup_node_data()
		memblock_find_in_range_node()
			__memblock_find_range_top_down()
				for_each_mem_range_rev()
					__next_mem_range_rev()

This patch moves numa_clear_kernel_node_hotplug() into
numa_register_memblks(), clear kernel node hotpluggable flag before alloc
node data, then alloc node data won't fail even all the nodes are
hotpluggable.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa.c |   89 +++++++++++++++++++++----------------------
 1 file changed, 45 insertions(+), 44 deletions(-)

diff -puN arch/x86/mm/numa.c~mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable
+++ a/arch/x86/mm/numa.c
@@ -478,6 +478,42 @@ static bool __init numa_meminfo_cover_me
 	return true;
 }
 
+static void __init numa_clear_kernel_node_hotplug(void)
+{
+	int i, nid;
+	nodemask_t numa_kernel_nodes = NODE_MASK_NONE;
+	unsigned long start, end;
+	struct memblock_region *r;
+
+	/*
+	 * At this time, all memory regions reserved by memblock are
+	 * used by the kernel. Set the nid in memblock.reserved will
+	 * mark out all the nodes the kernel resides in.
+	 */
+	for (i = 0; i < numa_meminfo.nr_blks; i++) {
+		struct numa_memblk *mb = &numa_meminfo.blk[i];
+
+		memblock_set_node(mb->start, mb->end - mb->start,
+				  &memblock.reserved, mb->nid);
+	}
+
+	/* Mark all kernel nodes. */
+	for_each_memblock(reserved, r)
+		node_set(r->nid, numa_kernel_nodes);
+
+	/* Clear MEMBLOCK_HOTPLUG flag for memory in kernel nodes. */
+	for (i = 0; i < numa_meminfo.nr_blks; i++) {
+		nid = numa_meminfo.blk[i].nid;
+		if (!node_isset(nid, numa_kernel_nodes))
+			continue;
+
+		start = numa_meminfo.blk[i].start;
+		end = numa_meminfo.blk[i].end;
+
+		memblock_clear_hotplug(start, end - start);
+	}
+}
+
 static int __init numa_register_memblks(struct numa_meminfo *mi)
 {
 	unsigned long uninitialized_var(pfn_align);
@@ -496,6 +532,15 @@ static int __init numa_register_memblks(
 	}
 
 	/*
+	 * At very early time, the kernel have to use some memory such as
+	 * loading the kernel image. We cannot prevent this anyway. So any
+	 * node the kernel resides in should be un-hotpluggable.
+	 *
+	 * And when we come here, alloc node data won't fail.
+	 */
+	numa_clear_kernel_node_hotplug();
+
+	/*
 	 * If sections array is gonna be used for pfn -> nid mapping, check
 	 * whether its granularity is fine enough.
 	 */
@@ -554,41 +599,6 @@ static void __init numa_init_array(void)
 	}
 }
 
-static void __init numa_clear_kernel_node_hotplug(void)
-{
-	int i, nid;
-	nodemask_t numa_kernel_nodes = NODE_MASK_NONE;
-	unsigned long start, end;
-	struct memblock_region *r;
-
-	/*
-	 * At this time, all memory regions reserved by memblock are
-	 * used by the kernel. Set the nid in memblock.reserved will
-	 * mark out all the nodes the kernel resides in.
-	 */
-	for (i = 0; i < numa_meminfo.nr_blks; i++) {
-		struct numa_memblk *mb = &numa_meminfo.blk[i];
-		memblock_set_node(mb->start, mb->end - mb->start,
-				  &memblock.reserved, mb->nid);
-	}
-
-	/* Mark all kernel nodes. */
-	for_each_memblock(reserved, r)
-		node_set(r->nid, numa_kernel_nodes);
-
-	/* Clear MEMBLOCK_HOTPLUG flag for memory in kernel nodes. */
-	for (i = 0; i < numa_meminfo.nr_blks; i++) {
-		nid = numa_meminfo.blk[i].nid;
-		if (!node_isset(nid, numa_kernel_nodes))
-			continue;
-
-		start = numa_meminfo.blk[i].start;
-		end = numa_meminfo.blk[i].end;
-
-		memblock_clear_hotplug(start, end - start);
-	}
-}
-
 static int __init numa_init(int (*init_func)(void))
 {
 	int i;
@@ -643,15 +653,6 @@ static int __init numa_init(int (*init_f
 	}
 	numa_init_array();
 
-	/*
-	 * At very early time, the kernel have to use some memory such as
-	 * loading the kernel image. We cannot prevent this anyway. So any
-	 * node the kernel resides in should be un-hotpluggable.
-	 *
-	 * And when we come here, numa_init() won't fail.
-	 */
-	numa_clear_kernel_node_hotplug();
