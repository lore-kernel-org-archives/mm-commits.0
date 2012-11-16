From: akpm@linux-foundation.org
Subject: + procfs-use-n_memory-instead-n_high_memory.patch added to -mm tree
Date: Thu, 15 Nov 2012 16:34:29 -0800
Message-ID: <20121116003430.9E38420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:60880 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab2KPAee (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Nov 2012 19:34:34 -0500
Received: by mail-we0-f202.google.com with SMTP id x43so145512wey.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Nov 2012 16:34:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, cl@linux.com, dhillf@gmail.com, linfeng@cn.fujitsu.com, rientjes@google.com, wency@cn.fujitsu.com


The patch titled
     Subject: procfs: use N_MEMORY instead N_HIGH_MEMORY
has been added to the -mm tree.  Its filename is
     procfs-use-n_memory-instead-n_high_memory.patch

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
Subject: procfs: use N_MEMORY instead N_HIGH_MEMORY

N_HIGH_MEMORY stands for the nodes that has normal or high memory.
N_MEMORY stands for the nodes that has any memory.

The code here need to handle with the nodes which have memory, we should
use N_MEMORY instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Lin Feng <linfeng@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c    |    2 +-
 fs/proc/task_mmu.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/proc/kcore.c~procfs-use-n_memory-instead-n_high_memory fs/proc/kcore.c
--- a/fs/proc/kcore.c~procfs-use-n_memory-instead-n_high_memory
+++ a/fs/proc/kcore.c
@@ -249,7 +249,7 @@ static int kcore_update_ram(void)
 	/* Not inialized....update now */
 	/* find out "max pfn" */
 	end_pfn = 0;
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		unsigned long node_end;
 		node_end  = NODE_DATA(nid)->node_start_pfn +
 			NODE_DATA(nid)->node_spanned_pages;
diff -puN fs/proc/task_mmu.c~procfs-use-n_memory-instead-n_high_memory fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~procfs-use-n_memory-instead-n_high_memory
+++ a/fs/proc/task_mmu.c
@@ -1126,7 +1126,7 @@ static struct page *can_gather_numa_stat
 		return NULL;
 
 	nid = page_to_nid(page);
-	if (!node_isset(nid, node_states[N_HIGH_MEMORY]))
+	if (!node_isset(nid, node_states[N_MEMORY]))
 		return NULL;
 
 	return page;
@@ -1279,7 +1279,7 @@ static int show_numa_map(struct seq_file
 	if (md->writeback)
 		seq_printf(m, " writeback=%lu", md->writeback);
 
-	for_each_node_state(n, N_HIGH_MEMORY)
+	for_each_node_state(n, N_MEMORY)
 		if (md->node[n])
 			seq_printf(m, " N%d=%lu", n, md->node[n]);
 out:
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

