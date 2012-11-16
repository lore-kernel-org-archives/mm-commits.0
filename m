From: akpm@linux-foundation.org
Subject: + node_states-introduce-n_memory.patch added to -mm tree
Date: Thu, 15 Nov 2012 16:34:19 -0800
Message-ID: <20121116003420.5C76120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:36884 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab2KPAeX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Nov 2012 19:34:23 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so7360bkc.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Nov 2012 16:34:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, cl@linux.com, dhillf@gmail.com, linfeng@cn.fujitsu.com, rientjes@google.com, wency@cn.fujitsu.com


The patch titled
     Subject: mm: node_states: introduce N_MEMORY
has been added to the -mm tree.  Its filename is
     node_states-introduce-n_memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
drivers-base-nodec-cleanup-node_state_attr.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch
memory_hotplug-handle-empty-zone-when-online_movable-online_kernel.patch
memory_hotplug-ensure-every-online-node-has-normal-memory.patch
node_states-introduce-n_memory.patch
cpuset-use-n_memory-instead-n_high_memory.patch
procfs-use-n_memory-instead-n_high_memory.patch
memcontrol-use-n_memory-instead-n_high_memory.patch
oom-use-n_memory-instead-n_high_memory.patch
mmmigrate-use-n_memory-instead-n_high_memory.patch
mempolicy-use-n_memory-instead-n_high_memory.patch
hugetlb-use-n_memory-instead-n_high_memory.patch
vmstat-use-n_memory-instead-n_high_memory.patch
kthread-use-n_memory-instead-n_high_memory.patch
init-use-n_memory-instead-n_high_memory.patch
vmscan-use-n_memory-instead-n_high_memory.patch
page_alloc-use-n_memory-instead-n_high_memory-change-the-node_states-initialization.patch
hotplug-update-nodemasks-management.patch

