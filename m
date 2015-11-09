From: akpm@linux-foundation.org
Subject: [to-be-updated]
 sgi-xp-replace-cpu_to_node-with-cpu_to_mem-to-support-memoryless-node.patch removed from -mm tree
Date: Mon, 09 Nov 2015 13:52:33 -0800
Message-ID: <564115a1.ypMqDJ9YFs6sroE7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbbKIVwe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 16:52:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiang.liu@linux.intel.com, hpa@zytor.com, mgorman@suse.de, mingo@elte.hu, peterz@infradead.org, rafael.j.wysocki@intel.com, rientjes@google.com, tangchen@cn.fujitsu.com, tglx@linutronix.de, tj@kernel.org, tony.luck@intel.com, umgwanakikbuti@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sgi-xp: replace cpu_to_node() with cpu_to_mem() to support memoryless node
has been removed from the -mm tree.  Its filename was
     sgi-xp-replace-cpu_to_node-with-cpu_to_mem-to-support-memoryless-node.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: sgi-xp: replace cpu_to_node() with cpu_to_mem() to support memoryless node

xpc_create_gru_mq_uv() allocates memory with __GFP_THISNODE flag set,
which may cause permanent memory allocation failure on memoryless node. 
So replace cpu_to_node() with cpu_to_mem() to better support memoryless
node.  For node with memory, cpu_to_mem() is the same as cpu_to_node().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
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

 drivers/misc/sgi-xp/xpc_uv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-replace-cpu_to_node-with-cpu_to_mem-to-support-memoryless-node drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-replace-cpu_to_node-with-cpu_to_mem-to-support-memoryless-node
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -238,7 +238,7 @@ xpc_create_gru_mq_uv(unsigned int mq_siz
 
 	mq->mmr_blade = uv_cpu_to_blade_id(cpu);
 
-	nid = cpu_to_node(cpu);
+	nid = cpu_to_mem(cpu);
 	page = __alloc_pages_node(nid,
 				      GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE,
 				      pg_order);
_

Patches currently in -mm which might be from jiang.liu@linux.intel.com are

openvswitch-replace-cpu_to_node-with-cpu_to_mem-to-support-memoryless-node.patch
x86-numa-kill-useless-code-to-improve-code-readability.patch
mm-update-_mem_id_-for-every-possible-cpu-when-memory-configuration-changes.patch
mm-x86-enable-memoryless-node-support-to-better-support-cpu-memory-hotplug.patch

