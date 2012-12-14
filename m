From: akpm@linux-foundation.org
Subject: [merged] vmstat-use-n_memory-instead-n_high_memory.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:28:33 -0800
Message-ID: <20121214232834.344D9200083@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:37578 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2LNX2h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:28:37 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so208146eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:28:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, cl@linux.com, dhillf@gmail.com, linfeng@cn.fujitsu.com, rientjes@google.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmstat: use N_MEMORY instead N_HIGH_MEMORY
has been removed from the -mm tree.  Its filename was
     vmstat-use-n_memory-instead-n_high_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: vmstat: use N_MEMORY instead N_HIGH_MEMORY

N_HIGH_MEMORY stands for the nodes that has normal or high memory.
N_MEMORY stands for the nodes that has any memory.

The code here need to handle with the nodes which have memory, we should
use N_MEMORY instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Lin Feng <linfeng@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmstat.c~vmstat-use-n_memory-instead-n_high_memory mm/vmstat.c
--- a/mm/vmstat.c~vmstat-use-n_memory-instead-n_high_memory
+++ a/mm/vmstat.c
@@ -932,7 +932,7 @@ static int pagetypeinfo_show(struct seq_
 	pg_data_t *pgdat = (pg_data_t *)arg;
 
 	/* check memoryless node */
-	if (!node_state(pgdat->node_id, N_HIGH_MEMORY))
+	if (!node_state(pgdat->node_id, N_MEMORY))
 		return 0;
 
 	seq_printf(m, "Page block order: %d\n", pageblock_order);
@@ -1294,7 +1294,7 @@ static int unusable_show(struct seq_file
 	pg_data_t *pgdat = (pg_data_t *)arg;
 
 	/* check memoryless node */
-	if (!node_state(pgdat->node_id, N_HIGH_MEMORY))
+	if (!node_state(pgdat->node_id, N_MEMORY))
 		return 0;
 
 	walk_zones_in_node(m, pgdat, unusable_show_print);
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch

