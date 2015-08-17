From: akpm@linux-foundation.org
Subject: +
 sgi-xp-replace-cpu_to_node-with-cpu_to_mem-to-support-memoryless-node.patch added to -mm tree
Date: Mon, 17 Aug 2015 14:36:01 -0700
Message-ID: <55d253c1.v0jtWIjA0UCXTr30%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbbHQVgC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Aug 2015 17:36:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiang.liu@linux.intel.com, hpa@zytor.com, mgorman@suse.de, mingo@elte.hu, peterz@infradead.org, rafael.j.wysocki@intel.com, rientjes@google.com, tangchen@cn.fujitsu.com, tglx@linutronix.de, tj@kernel.org, tony.luck@intel.com, umgwanakikbuti@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sgi-xp: replace cpu_to_node() with cpu_to_mem() to support memoryless node
has been added to the -mm tree.  Its filename is
     sgi-xp-replace-cpu_to_node-with-cpu_to_mem-to-support-memoryless-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sgi-xp-replace-cpu_to_node-with-cpu_to_mem-to-support-memoryless-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sgi-xp-replace-cpu_to_node-with-cpu_to_mem-to-support-memoryless-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 	page = alloc_pages_exact_node(nid,
 				      GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE,
 				      pg_order);
_

Patches currently in -mm which might be from jiang.liu@linux.intel.com are

linux-next.patch
x86-numa-acpi-online-node-earlier-when-doing-cpu-hot-addition.patch
kernel-profilec-replace-cpu_to_mem-with-cpu_to_node.patch
sgi-xp-replace-cpu_to_node-with-cpu_to_mem-to-support-memoryless-node.patch
openvswitch-replace-cpu_to_node-with-cpu_to_mem-to-support-memoryless-node.patch
i40e-use-numa_mem_id-to-better-support-memoryless-node.patch
i40evf-use-numa_mem_id-to-better-support-memoryless-node.patch
x86-numa-kill-useless-code-to-improve-code-readability.patch
mm-update-_mem_id_-for-every-possible-cpu-when-memory-configuration-changes.patch
mm-x86-enable-memoryless-node-support-to-better-support-cpu-memory-hotplug.patch

