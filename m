From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?revert-topology-add-support-for-node=5Fto=5Fmem=5Fnode-to-d?=
 =?US-ASCII?Q?etermine-the-fallback-node.patch?= removed from -mm tree
Date: Fri, 03 Apr 2020 13:35:58 -0700
Message-ID: <20200403203558.zo9AfzWC8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUgA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:36:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bharata@linux.ibm.com, cl@linux.com, iamjoonsoo.kim@lge.com, ktkhai@virtuozzo.com, mgorman@techsingularity.net, mhocko@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, nathanl@linux.ibm.com, penberg@kernel.org, puvichakravarthy@in.ibm.com, rientjes@google.com, sachinp@linux.vnet.ibm.com, srikar@linux.vnet.ibm.com, vbabka@suse.cz


The patch titled
     Subject: revert "topology: add support for node_to_mem_node() to determine the fallback node"
has been removed from the -mm tree.  Its filename was
     revert-topology-add-support-for-node_to_mem_node-to-determine-the-fallback-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: revert "topology: add support for node_to_mem_node() to determine the fallback node"

This reverts commit ad2c8144418c6a81cefe65379fd47bbe8344cef2.

The function node_to_mem_node() was introduced by that commit for use in SLUB
on systems with memoryless nodes, but it turned out to be unreliable on some
architectures/configurations and a simpler solution exists than fixing it up.

Thus commit 0715e6c516f1 ("mm, slub: prevent kmalloc_node crashes and
memory leaks") removed the only user of node_to_mem_node() and we can
revert the commit that introduced the function.

Link: http://lkml.kernel.org/r/20200320115533.9604-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: PUVICHAKRAVARTHY RAMACHANDRAN <puvichakravarthy@in.ibm.com>
Cc: Sachin Sant <sachinp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/topology.h |   17 -----------------
 mm/page_alloc.c          |    1 -
 2 files changed, 18 deletions(-)

--- a/include/linux/topology.h~revert-topology-add-support-for-node_to_mem_node-to-determine-the-fallback-node
+++ a/include/linux/topology.h
@@ -130,20 +130,11 @@ static inline int numa_node_id(void)
  * Use the accessor functions set_numa_mem(), numa_mem_id() and cpu_to_mem().
  */
 DECLARE_PER_CPU(int, _numa_mem_);
-extern int _node_numa_mem_[MAX_NUMNODES];
 
 #ifndef set_numa_mem
 static inline void set_numa_mem(int node)
 {
 	this_cpu_write(_numa_mem_, node);
-	_node_numa_mem_[numa_node_id()] = node;
-}
-#endif
-
-#ifndef node_to_mem_node
-static inline int node_to_mem_node(int node)
-{
-	return _node_numa_mem_[node];
 }
 #endif
 
@@ -166,7 +157,6 @@ static inline int cpu_to_mem(int cpu)
 static inline void set_cpu_numa_mem(int cpu, int node)
 {
 	per_cpu(_numa_mem_, cpu) = node;
-	_node_numa_mem_[cpu_to_node(cpu)] = node;
 }
 #endif
 
@@ -180,13 +170,6 @@ static inline int numa_mem_id(void)
 }
 #endif
 
-#ifndef node_to_mem_node
-static inline int node_to_mem_node(int node)
-{
-	return node;
-}
-#endif
