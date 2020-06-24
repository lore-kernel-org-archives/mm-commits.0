From: akpm@linux-foundation.org
Subject: + powerpc-numa-prefer-node-id-queried-from-vphn.patch added
 to -mm tree
Date: Wed, 24 Jun 2020 12:42:49 -0700
Message-ID: <20200624194249.Ak2zg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404915AbgFXTmu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 15:42:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, sathnaga@linux.vnet.ibm.com, mpe@ellerman.id.au, mhocko@suse.com, mgorman@suse.de, kirill@shutemov.name, ego@linux.vnet.ibm.com, david@redhat.com, cl@linux.com, srikar@linux.vnet.ibm.com


The patch titled
     Subject: powerpc/numa: prefer node id queried from vphn
has been added to the -mm tree.  Its filename is
     powerpc-numa-prefer-node-id-queried-from-vphn.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-numa-prefer-node-id-queried-from-vphn.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-numa-prefer-node-id-queried-from-vphn.patch

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
Subject: powerpc/numa: prefer node id queried from vphn

Node id queried from the static device tree may not be correct.  For
example: it may always show 0 on a shared processor.  Hence prefer the
node id queried from vphn and fallback on the device tree based node id if
vphn query fails.

Link: http://lkml.kernel.org/r/20200624092846.9194-3-srikar@linux.vnet.ibm.com
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

 arch/powerpc/mm/numa.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/arch/powerpc/mm/numa.c~powerpc-numa-prefer-node-id-queried-from-vphn
+++ a/arch/powerpc/mm/numa.c
@@ -724,21 +724,22 @@ static int __init parse_numa_properties(
 	 */
 	for_each_present_cpu(i) {
 		struct device_node *cpu;
-		int nid;
-
-		cpu = of_get_cpu_node(i, NULL);
-		BUG_ON(!cpu);
-		nid = of_node_to_nid_single(cpu);
-		of_node_put(cpu);
+		int nid = vphn_get_nid(i);
 
 		/*
 		 * Don't fall back to default_nid yet -- we will plug
 		 * cpus into nodes once the memory scan has discovered
 		 * the topology.
 		 */
-		if (nid < 0)
-			continue;
-		node_set_online(nid);
+		if (nid == NUMA_NO_NODE) {
+			cpu = of_get_cpu_node(i, NULL);
+			BUG_ON(!cpu);
+			nid = of_node_to_nid_single(cpu);
+			of_node_put(cpu);
+		}
+
+		if (likely(nid > 0))
+			node_set_online(nid);
 	}
 
 	get_n_mem_cells(&n_mem_addr_cells, &n_mem_size_cells);
_

Patches currently in -mm which might be from srikar@linux.vnet.ibm.com are

powerpc-numa-set-numa_node-for-all-possible-cpus.patch
powerpc-numa-prefer-node-id-queried-from-vphn.patch
mm-page_alloc-keep-memoryless-cpuless-node-0-offline.patch
