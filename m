From: akpm@linux-foundation.org
Subject: [merged] drivers-base-nodec-cleanup-node_state_attr.patch removed from -mm tree
Date: Wed, 12 Dec 2012 12:01:28 -0800
Message-ID: <20121212200128.9C30E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:40108 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab2LLUIQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 15:08:16 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so119710ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 12:08:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, rientjes@google.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/base/node.c: cleanup node_state_attr[]
has been removed from the -mm tree.  Its filename was
     drivers-base-nodec-cleanup-node_state_attr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: drivers/base/node.c: cleanup node_state_attr[]

use [index] = init_value
use N_xxxxx instead of hardcode.

Make it more readability and easier to add new state.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/base/node.c~drivers-base-nodec-cleanup-node_state_attr drivers/base/node.c
--- a/drivers/base/node.c~drivers-base-nodec-cleanup-node_state_attr
+++ a/drivers/base/node.c
@@ -638,23 +638,23 @@ static ssize_t show_node_state(struct de
 	{ __ATTR(name, 0444, show_node_state, NULL), state }
 
 static struct node_attr node_state_attr[] = {
-	_NODE_ATTR(possible, N_POSSIBLE),
-	_NODE_ATTR(online, N_ONLINE),
-	_NODE_ATTR(has_normal_memory, N_NORMAL_MEMORY),
-	_NODE_ATTR(has_cpu, N_CPU),
+	[N_POSSIBLE] = _NODE_ATTR(possible, N_POSSIBLE),
+	[N_ONLINE] = _NODE_ATTR(online, N_ONLINE),
+	[N_NORMAL_MEMORY] = _NODE_ATTR(has_normal_memory, N_NORMAL_MEMORY),
 #ifdef CONFIG_HIGHMEM
-	_NODE_ATTR(has_high_memory, N_HIGH_MEMORY),
+	[N_HIGH_MEMORY] = _NODE_ATTR(has_high_memory, N_HIGH_MEMORY),
 #endif
+	[N_CPU] = _NODE_ATTR(has_cpu, N_CPU),
 };
 
 static struct attribute *node_state_attrs[] = {
-	&node_state_attr[0].attr.attr,
-	&node_state_attr[1].attr.attr,
-	&node_state_attr[2].attr.attr,
-	&node_state_attr[3].attr.attr,
+	&node_state_attr[N_POSSIBLE].attr.attr,
+	&node_state_attr[N_ONLINE].attr.attr,
+	&node_state_attr[N_NORMAL_MEMORY].attr.attr,
 #ifdef CONFIG_HIGHMEM
-	&node_state_attr[4].attr.attr,
+	&node_state_attr[N_HIGH_MEMORY].attr.attr,
 #endif
+	&node_state_attr[N_CPU].attr.attr,
 	NULL
 };
 
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

