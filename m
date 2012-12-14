From: akpm@linux-foundation.org
Subject: [merged] node_states-introduce-n_memory.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:27:58 -0800
Message-ID: <20121214232758.D723F100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:63817 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932689Ab2LNX2A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:28:00 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so409711vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:27:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, cl@linux.com, dhillf@gmail.com, linfeng@cn.fujitsu.com, rientjes@google.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: node_states: introduce N_MEMORY
has been removed from the -mm tree.  Its filename was
     node_states-introduce-n_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: mm: node_states: introduce N_MEMORY

We have N_NORMAL_MEMORY for standing for the nodes that have normal memory
with zone_type <= ZONE_NORMAL.

And we have N_HIGH_MEMORY for standing for the nodes that have normal or
high memory.

But we don't have any word to stand for the nodes that have *any* memory.

And we have N_CPU but without N_MEMORY.

Current code reuse the N_HIGH_MEMORY for this purpose because any node
which has memory must have high memory or normal memory currently.

A)	But this reusing is bad for *readability*. Because the name
	N_HIGH_MEMORY just stands for high or normal:

A.example 1)
	mem_cgroup_nr_lru_pages():
		for_each_node_state(nid, N_HIGH_MEMORY)

	The user will be confused(why this function just counts for high or
	normal memory node? does it counts for ZONE_MOVABLE's lru pages?)
	until someone else tell them N_HIGH_MEMORY is reused to stand for
	nodes that have any memory.

A.cont) If we introduce N_MEMORY, we can reduce this confusing
	AND make the code more clearly:

A.example 2) mm/page_cgroup.c use N_HIGH_MEMORY twice:

	One is in page_cgroup_init(void):
		for_each_node_state(nid, N_HIGH_MEMORY) {

	It means if the node have memory, we will allocate page_cgroup map for
	the node. We should use N_MEMORY instead here to gaim more clearly.

	The second using is in alloc_page_cgroup():
		if (node_state(nid, N_HIGH_MEMORY))
			addr = vzalloc_node(size, nid);

	It means if the node has high or normal memory that can be allocated
	from kernel. We should keep N_HIGH_MEMORY here, and it will be better
	if the "any memory" semantic of N_HIGH_MEMORY is removed.

B)	This reusing is out-dated if we introduce MOVABLE-dedicated node.
	The MOVABLE-dedicated node should not appear in
	node_stats[N_HIGH_MEMORY] nor node_stats[N_NORMAL_MEMORY],
	because MOVABLE-dedicated node has no high or normal memory.

	In x86_64, N_HIGH_MEMORY=N_NORMAL_MEMORY, if a MOVABLE-dedicated node
	is in node_stats[N_HIGH_MEMORY], it is also means it is in
	node_stats[N_NORMAL_MEMORY], it causes SLUB wrong.

	The slub uses
		for_each_node_state(nid, N_NORMAL_MEMORY)
	and creates kmem_cache_node for MOVABLE-dedicated node and cause problem.

In one word, we need a N_MEMORY.  We just intrude it as an alias to
N_HIGH_MEMORY and fix all im-proper usages of N_HIGH_MEMORY in late
patches.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Lin Feng <linfeng@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/nodemask.h~node_states-introduce-n_memory include/linux/nodemask.h
--- a/include/linux/nodemask.h~node_states-introduce-n_memory
+++ a/include/linux/nodemask.h
@@ -380,6 +380,7 @@ enum node_states {
 #else
 	N_HIGH_MEMORY = N_NORMAL_MEMORY,
 #endif
+	N_MEMORY = N_HIGH_MEMORY,
 	N_CPU,		/* The node has one or more cpus */
 	NR_NODE_STATES
 };
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch

