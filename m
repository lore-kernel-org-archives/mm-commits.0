From: akpm@linux-foundation.org
Subject: +
 mm-update-_mem_id_-for-every-possible-cpu-when-memory-configuration-changes.patch added to -mm tree
Date: Mon, 17 Aug 2015 14:36:14 -0700
Message-ID: <55d253ce.rz+NMiskAbVzIL6h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbbHQVgP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Aug 2015 17:36:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiang.liu@linux.intel.com, hpa@zytor.com, mgorman@suse.de, mingo@elte.hu, peterz@infradead.org, rafael.j.wysocki@intel.com, rientjes@google.com, tangchen@cn.fujitsu.com, tglx@linutronix.de, tj@kernel.org, tony.luck@intel.com, umgwanakikbuti@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: update _mem_id_[] for every possible CPU when memory configuration changes
has been added to the -mm tree.  Its filename is
     mm-update-_mem_id_-for-every-possible-cpu-when-memory-configuration-changes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-update-_mem_id_-for-every-possible-cpu-when-memory-configuration-changes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-update-_mem_id_-for-every-possible-cpu-when-memory-configuration-changes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -4368,13 +4368,13 @@ static int __build_all_zonelists(void *d
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

linux-next.patch
x86-numa-acpi-online-node-earlier-when-doing-cpu-hot-addition.patch
kernel-profilec-replace-cpu_to_mem-with-cpu_to_node.patch
sgi-xp-replace-cpu_to_node-with-cpu_to_mem-to-support-memoryless-node.patch
openvswitch-replace-cpu_to_node-with-cpu_to_mem-to-support-memoryless-node.patch
i40e-use-numa_mem_id-to-better-support-memoryless-node.patch
i40evf-use-numa_mem_id-to-better-support-memoryless-node.patch
x86-numa-kill-useless-code-to-improve-code-readability.patch
mm-update-_mem_id_-for-every-possible-cpu-when-memory-configuration-changes.patch
mm-x86-enable-memoryless-node-support-to-better-support-cpu-memory-hotplug.patch

