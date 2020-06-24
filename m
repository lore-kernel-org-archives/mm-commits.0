From: akpm@linux-foundation.org
Subject: + powerpc-numa-set-numa_node-for-all-possible-cpus.patch
 added to -mm tree
Date: Wed, 24 Jun 2020 12:42:47 -0700
Message-ID: <20200624194247.FrCxv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404915AbgFXTmt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 15:42:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, sathnaga@linux.vnet.ibm.com, mpe@ellerman.id.au, mhocko@suse.com, mgorman@suse.de, kirill@shutemov.name, ego@linux.vnet.ibm.com, david@redhat.com, cl@linux.com, srikar@linux.vnet.ibm.com


The patch titled
     Subject: powerpc/numa: set numa_node for all possible cpus
has been added to the -mm tree.  Its filename is
     powerpc-numa-set-numa_node-for-all-possible-cpus.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-numa-set-numa_node-for-all-possible-cpus.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-numa-set-numa_node-for-all-possible-cpus.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: powerpc/numa: set numa_node for all possible cpus

Patch series "Offline memoryless cpuless node 0", v5.

Linux kernel configured with CONFIG_NUMA on a system with multiple
   possible nodes, marks node 0 as online at boot.  However in practice,
   there are systems which have node 0 as memoryless and cpuless.

This can cause
1. numa_balancing to be enabled on systems with only one online node.
2. Existence of dummy (cpuless and memoryless) node which can confuse
users/scripts looking at output of lscpu / numactl.

This patchset wants to correct this anomaly.

This should only affect systems that have CONFIG_MEMORYLESS_NODES. 
   Currently there are only 2 architectures ia64 and powerpc that have
   this config.

Note: Patch 3 in this patch series depends on patches 1 and 2.  Without
   patches 1 and 2, patch 3 might crash powerpc.


This patch (of 3):

A Powerpc system with multiple possible nodes and with CONFIG_NUMA enabled
always used to have a node 0, even if node 0 does not any cpus or memory
attached to it.  As per PAPR, node affinity of a cpu is only available
once its present / online.  For all cpus that are possible but not
present, cpu_to_node() would point to node 0.

To ensure a cpuless, memoryless dummy node is not online, powerpc need to
make sure all possible but not present cpu_to_node are set to a proper
node.

Link: http://lkml.kernel.org/r/20200624092846.9194-1-srikar@linux.vnet.ibm.com
Link: http://lkml.kernel.org/r/20200624092846.9194-2-srikar@linux.vnet.ibm.com
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Christopher Lameter <cl@linux.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Gautham R Shenoy <ego@linux.vnet.ibm.com>
Cc: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/numa.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/arch/powerpc/mm/numa.c~powerpc-numa-set-numa_node-for-all-possible-cpus
+++ a/arch/powerpc/mm/numa.c
@@ -506,6 +506,11 @@ static int numa_setup_cpu(unsigned long
 	int fcpu = cpu_first_thread_sibling(lcpu);
 	int nid = NUMA_NO_NODE;
 
+	if (!cpu_present(lcpu)) {
+		set_cpu_numa_node(lcpu, first_online_node);
+		return first_online_node;
+	}
+
 	/*
 	 * If a valid cpu-to-node mapping is already available, use it
 	 * directly instead of querying the firmware, since it represents
@@ -931,8 +936,17 @@ void __init mem_topology_setup(void)
 
 	reset_numa_cpu_lookup_table();
 
-	for_each_present_cpu(cpu)
+	for_each_possible_cpu(cpu) {
+		/*
+		 * Powerpc with CONFIG_NUMA always used to have a node 0,
+		 * even if it was memoryless or cpuless. For all cpus that
+		 * are possible but not present, cpu_to_node() would point
+		 * to node 0. To remove a cpuless, memoryless dummy node,
+		 * powerpc need to make sure all possible but not present
+		 * cpu_to_node are set to a proper node.
+		 */
 		numa_setup_cpu(cpu);
+	}
 }
 
 void __init initmem_init(void)
_

Patches currently in -mm which might be from srikar@linux.vnet.ibm.com are

powerpc-numa-set-numa_node-for-all-possible-cpus.patch
powerpc-numa-prefer-node-id-queried-from-vphn.patch
mm-page_alloc-keep-memoryless-cpuless-node-0-offline.patch
