From: akpm@linux-foundation.org
Subject: + mm-reset-numa-stats-for-boot-pagesets.patch added to
 -mm tree
Date: Thu, 07 May 2020 12:32:13 -0700
Message-ID: <20200507193213.gd_At30PN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbgEGTcP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 15:32:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, khlebnikov@yandex-team.ru, kirill@shutemov.name, mhocko@suse.com, mm-commits@vger.kernel.org, sandipan@linux.ibm.com, vbabka@suse.cz


The patch titled
     Subject: mm/page_alloc.c: reset numa stats for boot pagesets
has been added to the -mm tree.  Its filename is
     mm-reset-numa-stats-for-boot-pagesets.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-reset-numa-stats-for-boot-pagesets.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-reset-numa-stats-for-boot-pagesets.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: http://lkml.kernel.org/r/9c9c2d1b15e37f6e6bf32f99e3100035e90c4ac9.1588868430.git.sandipan@linux.ibm.com
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/mm/page_alloc.c~mm-reset-numa-stats-for-boot-pagesets
+++ a/mm/page_alloc.c
@@ -6246,6 +6246,25 @@ void __init setup_per_cpu_pageset(void)
 	for_each_populated_zone(zone)
 		setup_zone_pageset(zone);
 
+#ifdef CONFIG_NUMA
+	if (static_branch_likely(&vm_numa_stat_key)) {
+		struct per_cpu_pageset *pcp;
+		int cpu;
+
+		/*
+		 * Unpopulated zones continue using the boot pagesets.
+		 * The numa stats for these pagesets need to be reset.
+		 * Otherwise, they will end up skewing the stats of
+		 * the nodes these zones are associated with.
+		 */
+		for_each_possible_cpu(cpu) {
+			pcp = &per_cpu(boot_pageset, cpu);
+			memset(pcp->vm_numa_stat_diff, 0,
+			       sizeof(pcp->vm_numa_stat_diff));
+		}
+	}
+#endif
+
 	for_each_online_pgdat(pgdat)
 		pgdat->per_cpu_nodestats =
 			alloc_percpu(struct per_cpu_nodestat);
_

Patches currently in -mm which might be from sandipan@linux.ibm.com are

mm-reset-numa-stats-for-boot-pagesets.patch
selftests-vm-pkeys-use-sane-types-for-pkey-register.patch
selftests-vm-pkeys-add-helpers-for-pkey-bits.patch
selftests-vm-pkeys-use-the-correct-huge-page-size.patch
selftests-vm-pkeys-use-the-correct-page-size-on-powerpc.patch
selftests-vm-pkeys-fix-multilib-builds-for-x86.patch
