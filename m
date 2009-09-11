From: akpm@linux-foundation.org
Subject: [to-be-updated] hugetlb-promote-numa_no_node-to-generic-constant.patch removed from -mm tree
Date: Fri, 11 Sep 2009 10:43:12 -0700
Message-ID: <200909111743.n8BHhCtB022397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754602AbZIKRoF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Sep 2009 13:44:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, agl@us.ibm.com, andi@firstfloor.org, apw@canonical.com, cl@linux-foundation.org, lee.schermerhorn@hp.com, mel@csn.ul.ie, mingo@elte.hu, nacc@us.ibm.com, rient


The patch titled
     hugetlb: promote NUMA_NO_NODE to generic constant
has been removed from the -mm tree.  Its filename was
     hugetlb-promote-numa_no_node-to-generic-constant.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: promote NUMA_NO_NODE to generic constant
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Move definition of NUMA_NO_NODE from ia64 and x86_64 arch specific headers
to generic header 'linux/numa.h' for use in generic code.  NUMA_NO_NODE
replaces bare '-1' where it's used in this series to indicate "no node id
specified".  Ultimately, it can be used to replace the -1 elsewhere where
it is used similarly.

Note that in arch/x86/include/asm/topology.h, NUMA_NO_NODE is now only
defined when CONFIG_NUMA is defined.  This seems to work for current usage
of NUMA_NO_NODE in x86_64 arch code, with or without CONFIG_NUMA defined.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/numa.h    |    2 --
 arch/x86/include/asm/topology.h |    5 ++---
 include/linux/numa.h            |    2 ++
 3 files changed, 4 insertions(+), 5 deletions(-)

diff -puN arch/ia64/include/asm/numa.h~hugetlb-promote-numa_no_node-to-generic-constant arch/ia64/include/asm/numa.h
--- a/arch/ia64/include/asm/numa.h~hugetlb-promote-numa_no_node-to-generic-constant
+++ a/arch/ia64/include/asm/numa.h
@@ -22,8 +22,6 @@
 
 #include <asm/mmzone.h>
 
-#define NUMA_NO_NODE	-1
-
 extern u16 cpu_to_node_map[NR_CPUS] __cacheline_aligned;
 extern cpumask_t node_to_cpu_mask[MAX_NUMNODES] __cacheline_aligned;
 extern pg_data_t *pgdat_list[MAX_NUMNODES];
diff -puN arch/x86/include/asm/topology.h~hugetlb-promote-numa_no_node-to-generic-constant arch/x86/include/asm/topology.h
--- a/arch/x86/include/asm/topology.h~hugetlb-promote-numa_no_node-to-generic-constant
+++ a/arch/x86/include/asm/topology.h
@@ -35,11 +35,10 @@
 # endif
 #endif
 
-/* Node not present */
-#define NUMA_NO_NODE	(-1)
-
 #ifdef CONFIG_NUMA
 #include <linux/cpumask.h>
+#include <linux/numa.h>
+
 #include <asm/mpspec.h>
 
 #ifdef CONFIG_X86_32
diff -puN include/linux/numa.h~hugetlb-promote-numa_no_node-to-generic-constant include/linux/numa.h
--- a/include/linux/numa.h~hugetlb-promote-numa_no_node-to-generic-constant
+++ a/include/linux/numa.h
@@ -10,4 +10,6 @@
 
 #define MAX_NUMNODES    (1 << NODES_SHIFT)
 
+#define	NUMA_NO_NODE	(-1)
+
 #endif /* _LINUX_NUMA_H */
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

hugetlb-restore-interleaving-of-bootmem-huge-pages-2631.patch
linux-next.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-restore-interleaving-of-bootmem-huge-pages.patch
hugetlb-promote-numa_no_node-to-generic-constant.patch
mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust.patch

