From: akpm@linux-foundation.org
Subject: [merged] procfs-use-n_memory-instead-n_high_memory.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:28:06 -0800
Message-ID: <20121214232807.2CB04200089@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:47040 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422639Ab2LNX2J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:28:09 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so208133wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:28:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, cl@linux.com, dhillf@gmail.com, linfeng@cn.fujitsu.com, rientjes@google.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: use N_MEMORY instead N_HIGH_MEMORY
has been removed from the -mm tree.  Its filename was
     procfs-use-n_memory-instead-n_high_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

