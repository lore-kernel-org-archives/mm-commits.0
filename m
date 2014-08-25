From: akpm@linux-foundation.org
Subject: +
 mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable.patch
 added to -mm tree
Date: Mon, 25 Aug 2014 15:06:24 -0700
Message-ID: <53fbb360.tqimizOJw8pM9UFi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:57398 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933512AbaHYWGZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Aug 2014 18:06:25 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so3735344pab.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Aug 2014 15:06:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, davej@redhat.com, guz.fnst@cn.fujitsu.com, hpa@zytor.com, mingo@elte.hu, tangchen@cn.fujitsu.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/mm/numa.c: fix boot failure when all nodes are hotpluggable
has been added to the -mm tree.  Its filename is
     mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa.c |   88 +++++++++++++++++++++----------------------
 1 file changed, 44 insertions(+), 44 deletions(-)

diff -puN arch/x86/mm/numa.c~mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable
+++ a/arch/x86/mm/numa.c
@@ -463,6 +463,41 @@ static bool __init numa_meminfo_cover_me
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
@@ -481,6 +516,15 @@ static int __init numa_register_memblks(
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
@@ -548,41 +592,6 @@ static void __init numa_init_array(void)
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
@@ -637,15 +646,6 @@ static int __init numa_init(int (*init_f
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
