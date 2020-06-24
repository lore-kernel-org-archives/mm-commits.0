From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-keep-memoryless-cpuless-node-0-offline.patch added to -mm tree
Date: Wed, 24 Jun 2020 12:42:51 -0700
Message-ID: <20200624194251.vctcB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404915AbgFXTmw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 15:42:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, sathnaga@linux.vnet.ibm.com, mpe@ellerman.id.au, mhocko@suse.com, mgorman@suse.de, kirill@shutemov.name, ego@linux.vnet.ibm.com, david@redhat.com, cl@linux.com, srikar@linux.vnet.ibm.com


The patch titled
     Subject: mm/page_alloc: keep memoryless cpuless node 0 offline
has been added to the -mm tree.  Its filename is
     mm-page_alloc-keep-memoryless-cpuless-node-0-offline.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-keep-memoryless-cpuless-node-0-offline.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-keep-memoryless-cpuless-node-0-offline.patch

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
Subject: mm/page_alloc: keep memoryless cpuless node 0 offline

Currently Linux kernel with CONFIG_NUMA on a system with multiple possible
nodes, marks node 0 as online at boot.  However in practice, there are
systems which have node 0 as memoryless and cpuless.

This can cause numa_balancing to be enabled on systems with only one node
with memory and CPUs.  The existence of this dummy node which is cpuless
and memoryless node can confuse users/scripts looking at output of lscpu /
numactl.

By marking, N_ONLINE as NODE_MASK_NONE, lets stop assuming that Node 0 is
always online.

v5.8-rc2
 available: 2 nodes (0,2)
 node 0 cpus:
 node 0 size: 0 MB
 node 0 free: 0 MB
 node 2 cpus: 0 1 2 3 4 5 6 7
 node 2 size: 32625 MB
 node 2 free: 31490 MB
 node distances:
 node   0   2
   0:  10  20
   2:  20  10

proc and sys files
------------------
 /sys/devices/system/node/online:            0,2
 /proc/sys/kernel/numa_balancing:            1
 /sys/devices/system/node/has_cpu:           2
 /sys/devices/system/node/has_memory:        2
 /sys/devices/system/node/has_normal_memory: 2
 /sys/devices/system/node/possible:          0-31

v5.8-rc2 + patch
------------------
 available: 1 nodes (2)
 node 2 cpus: 0 1 2 3 4 5 6 7
 node 2 size: 32625 MB
 node 2 free: 31487 MB
 node distances:
 node   2
   2:  10

proc and sys files
------------------
/sys/devices/system/node/online:            2
/proc/sys/kernel/numa_balancing:            0
/sys/devices/system/node/has_cpu:           2
/sys/devices/system/node/has_memory:        2
/sys/devices/system/node/has_normal_memory: 2
/sys/devices/system/node/possible:          0-31

Note: On Powerpc, cpu_to_node of possible but not present cpus would
previously return 0.  Hence this commit depends on commit ("powerpc/numa:
Set numa_node for all possible cpus") and commit ("powerpc/numa: Prefer
node id queried from vphn").  Without the 2 commits, Powerpc system might
crash.

1. User space applications like Numactl, lscpu, that parse the sysfs
   tend to believe there is an extra online node.  This tends to confuse
   users and applications.  Other user space applications start believing
   that system was not able to use all the resources (i.e missing
   resources) or the system was not setup correctly.

2. Also existence of dummy node also leads to inconsistent
   information.  The number of online nodes is inconsistent with the
   information in the device-tree and resource-dump

3. When the dummy node is present, single node non-Numa systems end up
   showing up as NUMA systems and numa_balancing gets enabled.  This will
   mean we take the hit from the unnecessary numa hinting faults.

Link: http://lkml.kernel.org/r/20200624092846.9194-4-srikar@linux.vnet.ibm.com
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

 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-keep-memoryless-cpuless-node-0-offline
+++ a/mm/page_alloc.c
@@ -118,8 +118,10 @@ EXPORT_SYMBOL(latent_entropy);
  */
 nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 	[N_POSSIBLE] = NODE_MASK_ALL,
+#ifdef CONFIG_NUMA
+	[N_ONLINE] = NODE_MASK_NONE,
+#else
 	[N_ONLINE] = { { [0] = 1UL } },
-#ifndef CONFIG_NUMA
 	[N_NORMAL_MEMORY] = { { [0] = 1UL } },
 #ifdef CONFIG_HIGHMEM
 	[N_HIGH_MEMORY] = { { [0] = 1UL } },
_

Patches currently in -mm which might be from srikar@linux.vnet.ibm.com are

powerpc-numa-set-numa_node-for-all-possible-cpus.patch
powerpc-numa-prefer-node-id-queried-from-vphn.patch
mm-page_alloc-keep-memoryless-cpuless-node-0-offline.patch
