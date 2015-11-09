From: akpm@linux-foundation.org
Subject: [to-be-updated]
 openvswitch-replace-cpu_to_node-with-cpu_to_mem-to-support-memoryless-node.patch removed from -mm tree
Date: Mon, 09 Nov 2015 13:52:36 -0800
Message-ID: <564115a4.8j4hCtPHOWKXWvVy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbbKIVwh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 16:52:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiang.liu@linux.intel.com, hpa@zytor.com, mgorman@suse.de, mingo@elte.hu, peterz@infradead.org, pshelar@nicira.com, rafael.j.wysocki@intel.com, rientjes@google.com, tangchen@cn.fujitsu.com, tglx@linutronix.de, tj@kernel.org, tony.luck@intel.com, umgwanakikbuti@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: openvswitch: replace cpu_to_node() with cpu_to_mem() to support memoryless node
has been removed from the -mm tree.  Its filename was
     openvswitch-replace-cpu_to_node-with-cpu_to_mem-to-support-memoryless-node.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: openvswitch: replace cpu_to_node() with cpu_to_mem() to support memoryless node

ovs_flow_stats_update() allocates memory with __GFP_THISNODE flag set,
which may cause permanent memory allocation failure on memoryless node. 
So replace cpu_to_node() with cpu_to_mem() to better support memoryless
node.  For node with memory, cpu_to_mem() is the same as cpu_to_node().

This change only affects performance and shouldn't affect functionality.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Acked-by: Pravin B Shelar <pshelar@nicira.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/openvswitch/flow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/openvswitch/flow.c~openvswitch-replace-cpu_to_node-with-cpu_to_mem-to-support-memoryless-node net/openvswitch/flow.c
--- a/net/openvswitch/flow.c~openvswitch-replace-cpu_to_node-with-cpu_to_mem-to-support-memoryless-node
+++ a/net/openvswitch/flow.c
@@ -71,7 +71,7 @@ void ovs_flow_stats_update(struct sw_flo
 			   const struct sk_buff *skb)
 {
 	struct flow_stats *stats;
-	int node = numa_node_id();
+	int node = numa_mem_id();
 	int len = skb->len + (skb_vlan_tag_present(skb) ? VLAN_HLEN : 0);
 
 	stats = rcu_dereference(flow->stats[node]);
_

Patches currently in -mm which might be from jiang.liu@linux.intel.com are

x86-numa-kill-useless-code-to-improve-code-readability.patch
mm-update-_mem_id_-for-every-possible-cpu-when-memory-configuration-changes.patch
mm-x86-enable-memoryless-node-support-to-better-support-cpu-memory-hotplug.patch

