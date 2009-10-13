From: akpm@linux-foundation.org
Subject: + hugetlb-add-generic-definition-of-numa_no_node.patch added to -mm tree
Date: Tue, 13 Oct 2009 12:32:52 -0700
Message-ID: <200910131932.n9DJWqF8032176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934206AbZJMTeh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 15:34:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, agl@us.ibm.com, andi@firstfloor.org, apw@canonical.com, cl@linux-foundation.org, eric.whitney@hp.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, nacc@us.ibm.com, randy.dunlap@oracle.com, rientjes@google.com


The patch titled
     hugetlb: add generic definition of NUMA_NO_NODE
has been added to the -mm tree.  Its filename is
     hugetlb-add-generic-definition-of-numa_no_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: add generic definition of NUMA_NO_NODE
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Move definition of NUMA_NO_NODE from ia64 and x86_64 arch specific headers
to generic header 'linux/numa.h' for use in generic code.  NUMA_NO_NODE
replaces bare '-1' where it's used in this series to indicate "no node id
specified".  Ultimately, it can be used to replace the -1 elsewhere where
it is used similarly.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Andi Kleen <andi@firstfloor.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Eric Whitney <eric.whitney@hp.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/ia64/include/asm/numa.h~hugetlb-add-generic-definition-of-numa_no_node arch/ia64/include/asm/numa.h
--- a/arch/ia64/include/asm/numa.h~hugetlb-add-generic-definition-of-numa_no_node
+++ a/arch/ia64/include/asm/numa.h
@@ -22,8 +22,6 @@
 
 #include <asm/mmzone.h>
 
-#define NUMA_NO_NODE	-1
-
 extern u16 cpu_to_node_map[NR_CPUS] __cacheline_aligned;
 extern cpumask_t node_to_cpu_mask[MAX_NUMNODES] __cacheline_aligned;
 extern pg_data_t *pgdat_list[MAX_NUMNODES];
diff -puN arch/x86/include/asm/topology.h~hugetlb-add-generic-definition-of-numa_no_node arch/x86/include/asm/topology.h
--- a/arch/x86/include/asm/topology.h~hugetlb-add-generic-definition-of-numa_no_node
+++ a/arch/x86/include/asm/topology.h
@@ -35,11 +35,16 @@
 # endif
 #endif
 
-/* Node not present */
-#define NUMA_NO_NODE	(-1)
+/*
+ * to preserve the visibility of NUMA_NO_NODE definition,
+ * moved to there from here.  May be used independent of
+ * CONFIG_NUMA.
+ */
+#include <linux/numa.h>
 
 #ifdef CONFIG_NUMA
 #include <linux/cpumask.h>
+
 #include <asm/mpspec.h>
 
 #ifdef CONFIG_X86_32
diff -puN include/linux/numa.h~hugetlb-add-generic-definition-of-numa_no_node include/linux/numa.h
--- a/include/linux/numa.h~hugetlb-add-generic-definition-of-numa_no_node
+++ a/include/linux/numa.h
@@ -10,4 +10,6 @@
 
 #define MAX_NUMNODES    (1 << NODES_SHIFT)
 
+#define	NUMA_NO_NODE	(-1)
+
 #endif /* _LINUX_NUMA_H */
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

nodemask-make-nodemask_alloc-more-general.patch
hugetlb-rework-hstate_next_node_-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix.patch
hugetlb-factor-init_nodemask_of_node.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch
hugetlb-add-generic-definition-of-numa_no_node.patch
hugetlb-add-per-node-hstate-attributes.patch
hugetlb-update-hugetlb-documentation-for-numa-controls.patch
hugetlb-use-only-nodes-with-memory-for-huge-pages.patch
mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch
hugetlb-handle-memory-hot-plug-events.patch
hugetlb-offload-per-node-attribute-registrations.patch
mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch

