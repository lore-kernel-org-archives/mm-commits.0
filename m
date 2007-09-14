From: akpm@linux-foundation.org
Subject: + fix-panic-of-cpu-online-with-memory-less-node.patch added to -mm tree
Date: Thu, 13 Sep 2007 22:00:53 -0700
Message-ID: <200709140500.l8E50rfj022201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56605 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259AbXINFBA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 01:01:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: y-goto@jp.fujitsu.com


The patch titled
     Fix panic of cpu online with memory less node
has been added to the -mm tree.  Its filename is
     fix-panic-of-cpu-online-with-memory-less-node.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1698,9 +1698,11 @@ static int __devinit cpu_callback(struct
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

clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
update-n_high_memory-node-state-for-memory-hotadd-fix.patch
fix-panic-of-cpu-online-with-memory-less-node.patch
move-free-pages-between-lists-on-steal.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap-update.patch
