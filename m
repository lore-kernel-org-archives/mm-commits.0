From: akpm@linux-foundation.org
Subject: [merged]
 numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug.patch removed from -mm tree
Date: Fri, 07 Feb 2014 12:18:45 -0800
Message-ID: <52f53fa5.Nf+0qJ3wAaTlrGsv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58913 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbaBGUSq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Feb 2014 15:18:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rientjes@google.com, mingo@elte.hu, hpa@zytor.com, guz.fnst@cn.fujitsu.com, davej@redhat.com, tangchen@cn.fujitsu.com

Subject: [merged] numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug.patch removed from -mm tree
To: tangchen@cn.fujitsu.com,davej@redhat.com,guz.fnst@cn.fujitsu.com,hpa@zytor.com,mingo@elte.hu,rientjes@google.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 07 Feb 2014 12:18:45 -0800


The patch titled
     Subject: arch/x86/mm/numa.c: initialize numa_kernel_nodes in numa_clear_kernel_node_hotplug()
has been removed from the -mm tree.  Its filename was
     numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: arch/x86/mm/numa.c: initialize numa_kernel_nodes in numa_clear_kernel_node_hotplug()

On-stack variable numa_kernel_nodes in numa_clear_kernel_node_hotplug()
was not initialized.  So we need to initialize it.

[akpm@linux-foundation.org: use NODE_MASK_NONE, per David]
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Reported-by: Dave Jones <davej@redhat.com>
Reported-by: David Rientjes <rientjes@google.com>
Tested-by: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/mm/numa.c~numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug
+++ a/arch/x86/mm/numa.c
@@ -565,7 +565,7 @@ static void __init numa_init_array(void)
 static void __init numa_clear_kernel_node_hotplug(void)
 {
 	int i, nid;
-	nodemask_t numa_kernel_nodes;
+	nodemask_t numa_kernel_nodes = NODE_MASK_NONE;
 	unsigned long start, end;
 	struct memblock_type *type = &memblock.reserved;
 
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch

