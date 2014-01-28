From: akpm@linux-foundation.org
Subject: +
 numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug.patch added to -mm tree
Date: Tue, 28 Jan 2014 11:23:05 -0800
Message-ID: <52e80399.2ylcbfJALE9zKPmG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbaA1TXG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:23:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rientjes@google.com, mingo@elte.hu, hpa@zytor.com, guz.fnst@cn.fujitsu.com, davej@redhat.com, tangchen@cn.fujitsu.com

Subject: + numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug.patch added to -mm tree
To: tangchen@cn.fujitsu.com,davej@redhat.com,guz.fnst@cn.fujitsu.com,hpa@zytor.com,mingo@elte.hu,rientjes@google.com,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:23:05 -0800


The patch titled
     Subject: arch/x86/mm/numa.c: initialize numa_kernel_nodes in numa_clear_kernel_node_hotplug()
has been added to the -mm tree.  Its filename is
     numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: arch/x86/mm/numa.c: initialize numa_kernel_nodes in numa_clear_kernel_node_hotplug()

On-stack variable numa_kernel_nodes in numa_clear_kernel_node_hotplug()
was not initialized.  So we need to initialize it.

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

 arch/x86/mm/numa.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/mm/numa.c~numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug
+++ a/arch/x86/mm/numa.c
@@ -569,6 +569,8 @@ static void __init numa_clear_kernel_nod
 	unsigned long start, end;
 	struct memblock_type *type = &memblock.reserved;
 
+	nodes_clear(numa_kernel_nodes);
+
 	/* Mark all kernel nodes. */
 	for (i = 0; i < type->cnt; i++)
 		node_set(type->regions[i].nid, numa_kernel_nodes);
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch
numa-mem-hotplug-fix-array-index-overflow-when-synchronizing-nid-to-memblockreserved.patch

