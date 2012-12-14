From: akpm@linux-foundation.org
Subject: [merged] oom-use-n_memory-instead-n_high_memory.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:28:15 -0800
Message-ID: <20121214232816.31B7E200086@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:56976 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932750Ab2LNX2T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:28:19 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so209294wey.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:28:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, cl@linux.com, dhillf@gmail.com, linfeng@cn.fujitsu.com, rientjes@google.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: use N_MEMORY instead N_HIGH_MEMORY
has been removed from the -mm tree.  Its filename was
     oom-use-n_memory-instead-n_high_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: oom: use N_MEMORY instead N_HIGH_MEMORY

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

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/oom_kill.c~oom-use-n_memory-instead-n_high_memory mm/oom_kill.c
--- a/mm/oom_kill.c~oom-use-n_memory-instead-n_high_memory
+++ a/mm/oom_kill.c
@@ -215,7 +215,7 @@ static enum oom_constraint constrained_a
 	 * the page allocator means a mempolicy is in effect.  Cpuset policy
 	 * is enforced in get_page_from_freelist().
 	 */
-	if (nodemask && !nodes_subset(node_states[N_HIGH_MEMORY], *nodemask)) {
+	if (nodemask && !nodes_subset(node_states[N_MEMORY], *nodemask)) {
 		*totalpages = total_swap_pages;
 		for_each_node_mask(nid, *nodemask)
 			*totalpages += node_spanned_pages(nid);
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch

