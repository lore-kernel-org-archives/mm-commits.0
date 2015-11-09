From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-update-_mem_id_-for-every-possible-cpu-when-memory-configuration-changes.patch removed from -mm tree
Date: Mon, 09 Nov 2015 13:52:42 -0800
Message-ID: <564115aa.xKjKaXjaepRgbaig%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbbKIVwn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 16:52:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiang.liu@linux.intel.com, hpa@zytor.com, mgorman@suse.de, mingo@elte.hu, peterz@infradead.org, rafael.j.wysocki@intel.com, rientjes@google.com, tangchen@cn.fujitsu.com, tglx@linutronix.de, tj@kernel.org, tony.luck@intel.com, umgwanakikbuti@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: update _mem_id_[] for every possible CPU when memory configuration changes
has been removed from the -mm tree.  Its filename was
     mm-update-_mem_id_-for-every-possible-cpu-when-memory-configuration-changes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: mm: update _mem_id_[] for every possible CPU when memory configuration changes

Current kernel only updates _mem_id_[cpu] for onlined CPUs when memory
configuration changes.  So kernel may allocate memory from remote node for
a CPU if the CPU is still in absent or offline state even if the node
associated with the CPU has already been onlined.  This patch tries to
improve performance by updating _mem_id_[cpu] for each possible CPU when
memory configuration changes, thus kernel could always allocate from local
node once the node is onlined.

We check node_online(cpu_to_node(cpu)) because:
1) local_memory_node(nid) needs to access NODE_DATA(nid)
2) try_offline_node(nid) just zeroes out NODE_DATA(nid) instead of free it

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/page_alloc.c~mm-update-_mem_id_-for-every-possible-cpu-when-memory-configuration-changes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-update-_mem_id_-for-every-possible-cpu-when-memory-configuration-changes
+++ a/mm/page_alloc.c
@@ -4323,13 +4323,13 @@ static int __build_all_zonelists(void *d
 		/*
 		 * We now know the "local memory node" for each node--
 		 * i.e., the node of the first zone in the generic zonelist.
-		 * Set up numa_mem percpu variable for on-line cpus.  During
-		 * boot, only the boot cpu should be on-line;  we'll init the
-		 * secondary cpus' numa_mem as they come on-line.  During
-		 * node/memory hotplug, we'll fixup all on-line cpus.
+		 * Set up numa_mem percpu variable for all possible cpus
+		 * if associated node has been onlined.
 		 */
-		if (cpu_online(cpu))
+		if (node_online(cpu_to_node(cpu)))
 			set_cpu_numa_mem(cpu, local_memory_node(cpu_to_node(cpu)));
+		else
+			set_cpu_numa_mem(cpu, NUMA_NO_NODE);
 #endif
 	}
 
_

Patches currently in -mm which might be from jiang.liu@linux.intel.com are

mm-x86-enable-memoryless-node-support-to-better-support-cpu-memory-hotplug.patch

