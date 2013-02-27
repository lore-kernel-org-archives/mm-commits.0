From: akpm@linux-foundation.org
Subject: [merged] x86-numa-dont-check-if-node-is-numa_no_node.patch removed from -mm tree
Date: Wed, 27 Feb 2013 12:50:48 -0800
Message-ID: <20130227205049.052E95A41BD@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:43627 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab3B0Uux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 15:50:53 -0500
Received: by mail-qe0-f74.google.com with SMTP id 9so111539qea.5
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 12:50:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, hpa@zytor.com, len.brown@intel.com, mingo@redhat.com, pavel@ucw.cz, rjw@sisk.pl, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86 numa: don't check if node is NUMA_NO_NODE
has been removed from the -mm tree.  Its filename was
     x86-numa-dont-check-if-node-is-numa_no_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: x86 numa: don't check if node is NUMA_NO_NODE

If we aren't debugging per_cpu maps, the cpu's node is stored in per_cpu
variable numa_node.  If `node' is NUMA_NO_NODE, it means the caller wants
to clear the cpu's node.  So we should also call set_cpu_numa_node() in
this case.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/x86/mm/numa.c~x86-numa-dont-check-if-node-is-numa_no_node arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~x86-numa-dont-check-if-node-is-numa_no_node
+++ a/arch/x86/mm/numa.c
@@ -97,8 +97,7 @@ void numa_set_node(int cpu, int node)
 #endif
 	per_cpu(x86_cpu_to_node_map, cpu) = node;
 
-	if (node != NUMA_NO_NODE)
-		set_cpu_numa_node(cpu, node);
+	set_cpu_numa_node(cpu, node);
 }
 
 void numa_clear_node(int cpu)
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

origin.patch
x86-make-mem=-option-to-work-for-efi-platform.patch

