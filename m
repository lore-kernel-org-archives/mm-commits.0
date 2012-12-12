From: akpm@linux-foundation.org
Subject: [merged] slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:58:05 -0800
Message-ID: <20121212195806.1CFAF100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:62454 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2LLT6H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:58:07 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so116516ggn.3
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:58:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, akpm@linux-foundation.org, cl@linux.com, gregkh@suse.de, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kay.sievers@vrfy.org, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, minchan.kim@gmail.com, penberg@kernel.org, rientjes@google.com, rob@landley.net, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub, hotplug: ignore unrelated node's hot-adding and hot-removing
has been removed from the -mm tree.  Its filename was
     slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: slub, hotplug: ignore unrelated node's hot-adding and hot-removing

SLUB only focuses on the nodes which have normal memory and it ignores the
other node's hot-adding and hot-removing.

Aka: if some memory of a node which has no onlined memory is online, but
this new memory onlined is not normal memory (for example, highmem), we
should not allocate kmem_cache_node for SLUB.

And if the last normal memory is offlined, but the node still has memory,
we should remove kmem_cache_node for that node.  (The current code delays
it when all of the memory is offlined)

So we only do something when marg->status_change_nid_normal > 0. 
marg->status_change_nid is not suitable here.

The same problem doesn't exist in SLAB, because SLAB allocates kmem_list3
for every node even the node don't have normal memory, SLAB tolerates
kmem_list3 on alien nodes.  SLUB only focuses on the nodes which have
normal memory, it don't tolerate alien kmem_cache_node.  The patch makes
SLUB become self-compatible and avoids WARNs and BUGs in rare conditions.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slub.c~slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing mm/slub.c
--- a/mm/slub.c~slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing
+++ a/mm/slub.c
@@ -3573,7 +3573,7 @@ static void slab_mem_offline_callback(vo
 	struct memory_notify *marg = arg;
 	int offline_node;
 
-	offline_node = marg->status_change_nid;
+	offline_node = marg->status_change_nid_normal;
 
 	/*
 	 * If the node still has available memory. we need kmem_cache_node
@@ -3606,7 +3606,7 @@ static int slab_mem_going_online_callbac
 	struct kmem_cache_node *n;
 	struct kmem_cache *s;
 	struct memory_notify *marg = arg;
-	int nid = marg->status_change_nid;
+	int nid = marg->status_change_nid_normal;
 	int ret = 0;
 
 	/*
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
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
hotplug-update-nodemasks-management-fix.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch
linux-next.patch

