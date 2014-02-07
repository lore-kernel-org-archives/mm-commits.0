From: akpm@linux-foundation.org
Subject: [merged]
 numa-mem-hotplug-fix-array-index-overflow-when-synchronizing-nid-to-memblockreserved.patch removed from -mm tree
Date: Fri, 07 Feb 2014 12:18:47 -0800
Message-ID: <52f53fa7.8RTJO3vr02TCrLVn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbaBGUSw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Feb 2014 15:18:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rientjes@google.com, mingo@elte.hu, hpa@zytor.com, guz.fnst@cn.fujitsu.com, davej@redhat.com, tangchen@cn.fujitsu.com

Subject: [merged] numa-mem-hotplug-fix-array-index-overflow-when-synchronizing-nid-to-memblockreserved.patch removed from -mm tree
To: tangchen@cn.fujitsu.com,davej@redhat.com,guz.fnst@cn.fujitsu.com,hpa@zytor.com,mingo@elte.hu,rientjes@google.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 07 Feb 2014 12:18:47 -0800


The patch titled
     Subject: arch/x86/mm/numa.c: fix array index overflow when synchronizing nid to memblock.reserved.
has been removed from the -mm tree.  Its filename was
     numa-mem-hotplug-fix-array-index-overflow-when-synchronizing-nid-to-memblockreserved.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: arch/x86/mm/numa.c: fix array index overflow when synchronizing nid to memblock.reserved.

The following path will cause array out of bound.

memblock_add_region() will always set nid in memblock.reserved to
MAX_NUMNODES.  In numa_register_memblks(), after we set all nid to correct
valus in memblock.reserved, we called setup_node_data(), and used
memblock_alloc_nid() to allocate memory, with nid set to MAX_NUMNODES.

The nodemask_t type can be seen as a bit array.  And the index is 0 ~
MAX_NUMNODES-1.

After that, when we call node_set() in numa_clear_kernel_node_hotplug(),
the nodemask_t got an index of value MAX_NUMNODES, which is out of [0 ~
MAX_NUMNODES-1].

See below:

numa_init()
 |---> numa_register_memblks()
 |      |---> memblock_set_node(memory)		set correct nid in memblock.memory
 |      |---> memblock_set_node(reserved)	set correct nid in memblock.reserved
 |      |......
 |      |---> setup_node_data()
 |             |---> memblock_alloc_nid()	here, nid is set to MAX_NUMNODES (1024)
 |......
 |---> numa_clear_kernel_node_hotplug()
        |---> node_set()			here, we have an index 1024, and overflowed

This patch moves nid setting to numa_clear_kernel_node_hotplug() to fix
this problem.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Reported-by: Dave Jones <davej@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Tested-by: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN arch/x86/mm/numa.c~numa-mem-hotplug-fix-array-index-overflow-when-synchronizing-nid-to-memblockreserved arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~numa-mem-hotplug-fix-array-index-overflow-when-synchronizing-nid-to-memblockreserved
+++ a/arch/x86/mm/numa.c
@@ -493,14 +493,6 @@ static int __init numa_register_memblks(
 		struct numa_memblk *mb = &mi->blk[i];
 		memblock_set_node(mb->start, mb->end - mb->start,
 				  &memblock.memory, mb->nid);
-
-		/*
-		 * At this time, all memory regions reserved by memblock are
-		 * used by the kernel. Set the nid in memblock.reserved will
-		 * mark out all the nodes the kernel resides in.
-		 */
-		memblock_set_node(mb->start, mb->end - mb->start,
-				  &memblock.reserved, mb->nid);
 	}
 
 	/*
@@ -569,6 +561,17 @@ static void __init numa_clear_kernel_nod
 	unsigned long start, end;
 	struct memblock_type *type = &memblock.reserved;
 
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
 	/* Mark all kernel nodes. */
 	for (i = 0; i < type->cnt; i++)
 		node_set(type->regions[i].nid, numa_kernel_nodes);
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch

