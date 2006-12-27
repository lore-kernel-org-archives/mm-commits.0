From: akpm@osdl.org
Subject: + fix-oom-killer-kills-current-every-time-if-there-is.patch added to -mm tree
Date: Tue, 26 Dec 2006 22:58:03 -0800
Message-ID: <200612270658.kBR6w3dU003801@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34838 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932940AbWL0G6J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 01:58:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, clameter@engr.sgi.com, pj@sgi.com


The patch titled
     fix oom killer kills current every time if there is memory-less-node take2
has been added to the -mm tree.  Its filename is
     fix-oom-killer-kills-current-every-time-if-there-is.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix oom killer kills current every time if there is memory-less-node take2
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

constrained_alloc(), which is called to detect where oom is from, checks
passed zone_list().  If zone_list doesn't include all nodes, it thinks oom
is from mempolicy.

But there is memory-less-node.  memory-less-node's zones are never included
in zonelist[].

contstrained_alloc() should get memory_less_node into count.  Otherwise, it
always thinks 'oom is from mempolicy'.  This means that current process
dies at any time.  This patch fix it.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/oom_kill.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/oom_kill.c~fix-oom-killer-kills-current-every-time-if-there-is mm/oom_kill.c
--- a/mm/oom_kill.c~fix-oom-killer-kills-current-every-time-if-there-is
+++ a/mm/oom_kill.c
@@ -174,7 +174,12 @@ static inline int constrained_alloc(stru
 {
 #ifdef CONFIG_NUMA
 	struct zone **z;
-	nodemask_t nodes = node_online_map;
+	nodemask_t nodes;
+	int node;
+	/* node has memory ? */
+	for_each_online_node(node)
+		if (NODE_DATA(node)->node_present_pages)
+			node_set(node, nodes);
 
 	for (z = zonelist->zones; *z; z++)
 		if (cpuset_zone_allowed_softwall(*z, gfp_mask))
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

fix-oom-killer-kills-current-every-time-if-there-is.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
reiser4-hardirq-include-fix.patch

