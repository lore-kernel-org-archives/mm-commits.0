From: akpm@linux-foundation.org
Subject: [merged] mm-reset-numa-stats-for-boot-pagesets.patch
 removed from -mm tree
Date: Thu, 04 Jun 2020 10:18:17 -0700
Message-ID: <20200604171817.GS3uqHJz7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730083AbgFDRSS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:18:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, khlebnikov@yandex-team.ru, kirill@shutemov.name, mhocko@suse.com, mm-commits@vger.kernel.org, sandipan@linux.ibm.com, vbabka@suse.cz


The patch titled
     Subject: mm/page_alloc.c: reset numa stats for boot pagesets
has been removed from the -mm tree.  Its filename was
     mm-reset-numa-stats-for-boot-pagesets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sandipan Das <sandipan@linux.ibm.com>
Subject: mm/page_alloc.c: reset numa stats for boot pagesets

Initially, the per-cpu pagesets of each zone are set to the boot pagesets.
The real pagesets are allocated later but before that happens, page
allocations do occur and the numa stats for the boot pagesets get
incremented since they are common to all zones at that point.

The real pagesets, however, are allocated for the populated zones only. 
Unpopulated zones, like those associated with memory-less nodes, continue
using the boot pageset and end up skewing the numa stats of the
corresponding node.

E.g.

  $ numactl -H
  available: 2 nodes (0-1)
  node 0 cpus: 0 1 2 3
  node 0 size: 0 MB
  node 0 free: 0 MB
  node 1 cpus: 4 5 6 7
  node 1 size: 8131 MB
  node 1 free: 6980 MB
  node distances:
  node   0   1
    0:  10  40
    1:  40  10

  $ numastat
                             node0           node1
  numa_hit                     108           56495
  numa_miss                      0               0
  numa_foreign                   0               0
  interleave_hit                 0            4537
  local_node                   108           31547
  other_node                     0           24948

Hence, the boot pageset stats need to be cleared after the real pagesets
are allocated.

After this point, the stats of the boot pagesets do not change as page
allocations requested for a memory-less node will either fail (if
__GFP_THISNODE is used) or get fulfilled by a preferred zone of a
different node based on the fallback zonelist.

[sandipan@linux.ibm.com: v3]
  Link: http://lkml.kernel.org/r/20200511170356.162531-1-sandipan@linux.ibm.com
Link: http://lkml.kernel.org/r/9c9c2d1b15e37f6e6bf32f99e3100035e90c4ac9.1588868430.git.sandipan@linux.ibm.com
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/mm/page_alloc.c~mm-reset-numa-stats-for-boot-pagesets
+++ a/mm/page_alloc.c
@@ -6250,10 +6250,25 @@ void __init setup_per_cpu_pageset(void)
 {
 	struct pglist_data *pgdat;
 	struct zone *zone;
+	int __maybe_unused cpu;
 
 	for_each_populated_zone(zone)
 		setup_zone_pageset(zone);
 
+#ifdef CONFIG_NUMA
+	/*
+	 * Unpopulated zones continue using the boot pagesets.
+	 * The numa stats for these pagesets need to be reset.
+	 * Otherwise, they will end up skewing the stats of
+	 * the nodes these zones are associated with.
+	 */
+	for_each_possible_cpu(cpu) {
+		struct per_cpu_pageset *pcp = &per_cpu(boot_pageset, cpu);
+		memset(pcp->vm_numa_stat_diff, 0,
+		       sizeof(pcp->vm_numa_stat_diff));
+	}
+#endif
+
 	for_each_online_pgdat(pgdat)
 		pgdat->per_cpu_nodestats =
 			alloc_percpu(struct per_cpu_nodestat);
_

Patches currently in -mm which might be from sandipan@linux.ibm.com are

selftests-vm-pkeys-use-sane-types-for-pkey-register.patch
selftests-vm-pkeys-add-helpers-for-pkey-bits.patch
selftests-vm-pkeys-use-the-correct-huge-page-size.patch
selftests-vm-pkeys-introduce-powerpc-support-fix.patch
selftests-vm-pkeys-override-access-right-definitions-on-powerpc-fix.patch
selftests-vm-pkeys-use-the-correct-page-size-on-powerpc.patch
selftests-vm-pkeys-fix-multilib-builds-for-x86.patch
