From: akpm@linux-foundation.org
Subject: - fix-panic-of-cpu-online-with-memory-less-node.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:34:14 -0700
Message-ID: <200710162034.l9GKYE1J014912@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934016AbXJPVhR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:37:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Fix panic of cpu online with memory less node
has been removed from the -mm tree.  Its filename was
     fix-panic-of-cpu-online-with-memory-less-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix panic of cpu online with memory less node
From: Yasunori Goto <y-goto@jp.fujitsu.com>

When a cpu is onlined on memory-less-node box, kernel panics due to touch
NULL pointer of pgdat->kswapd.  Current kswapd runs only nodes which have
memory.  So, calling of set_cpus_allowed() is not necessary for memory-less
node.

This is fix for it.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~fix-panic-of-cpu-online-with-memory-less-node mm/vmscan.c
--- a/mm/vmscan.c~fix-panic-of-cpu-online-with-memory-less-node
+++ a/mm/vmscan.c
@@ -1694,9 +1694,11 @@ static int __devinit cpu_callback(struct
 {
 	pg_data_t *pgdat;
 	cpumask_t mask;
+	int nid;
 
 	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN) {
-		for_each_online_pgdat(pgdat) {
+		for_each_node_state(nid, N_HIGH_MEMORY) {
+			pgdat = NODE_DATA(nid);
 			mask = node_to_cpumask(pgdat->node_id);
 			if (any_online_cpu(mask) != NR_CPUS)
 				/* One of our CPUs online: restore mask */
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

origin.patch
