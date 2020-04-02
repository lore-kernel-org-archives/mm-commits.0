From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 026/155] revert "topology: add support for
 node_to_mem_node() to determine the fallback node"
Date: Wed, 01 Apr 2020 21:04:30 -0700
Message-ID: <20200402040430.KbIxSa9RQ%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEEd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:04:33 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bharata@linux.ibm.com, cl@linux.com, iamjoonsoo.kim@lge.com, ktkhai@virtuozzo.com, linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, nathanl@linux.ibm.com, penberg@kernel.org, puvichakravarthy@in.ibm.com, rientjes@google.com, sachinp@linux.vnet.ibm.com, srikar@linux.vnet.ibm.com, torvalds@linux-foundation.org, vbabka@suse.cz

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
