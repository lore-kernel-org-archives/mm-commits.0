From: akpm@linux-foundation.org
Subject: [merged]
 cpumask-fix-spurious-cpumask_of_node-on-non-numa-multi-node-configs.patch
 removed from -mm tree
Date: Tue, 29 Aug 2017 11:14:42 -0700
Message-ID: <20170829181442.u0lvRwKx0%akpm__37353.359317831$1504030492$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55892 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751186AbdH2SOn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Aug 2017 14:14:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, mm-commits@vger.kernel.org, stable@vger.kernel.org, tj@kernel.org


The patch titled
     Subject: cpumask: fix spurious cpumask_of_node() on non-NUMA multi-node configs
has been removed from the -mm tree.  Its filename was
     cpumask-fix-spurious-cpumask_of_node-on-non-numa-multi-node-configs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: cpumask: fix spurious cpumask_of_node() on non-NUMA multi-node configs

When !CONFIG_NUMA, cpumask_of_node(@node) equals cpu_online_mask
regardless of @node.  The assumption seems that if !NUMA, there shouldn't
be more than one node and thus reporting cpu_online_mask regardless of
@node is correct.  However, that assumption was broken years ago to
support CONFIG_DISCONTIGMEM and whether a system has multiple nodes or not
is separately controlled by CONFIG_NEED_MULTIPLE_NODES.

This means that, on a system with !CONFIG_NUMA &&
CONFIG_NEED_MULTIPLE_NODES, cpumask_of_node() will report cpu_online_mask
for all possible nodes, indicating that the CPUs are associated with
multiple nodes which is an impossible configuration.

This bug has been around forever but doesn't look like it has caused any
noticeable symptoms.  However, it triggers a WARN recently added to
workqueue to verify NUMA affinity configuration.

Fix it by reporting empty cpumask on non-zero nodes if !NUMA.

Link: http://lkml.kernel.org/r/20170828215127.GC491396@devbig577.frc2.facebook.com
Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/topology.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN include/asm-generic/topology.h~cpumask-fix-spurious-cpumask_of_node-on-non-numa-multi-node-configs include/asm-generic/topology.h
--- a/include/asm-generic/topology.h~cpumask-fix-spurious-cpumask_of_node-on-non-numa-multi-node-configs
+++ a/include/asm-generic/topology.h
@@ -48,7 +48,11 @@
 #define parent_node(node)	((void)(node),0)
 #endif
 #ifndef cpumask_of_node
-#define cpumask_of_node(node)	((void)node, cpu_online_mask)
+  #ifdef CONFIG_NEED_MULTIPLE_NODES
+    #define cpumask_of_node(node)	((node) == 0 ? cpu_online_mask : cpu_none_mask)
+  #else
+    #define cpumask_of_node(node)	((void)node, cpu_online_mask)
+  #endif
 #endif
 #ifndef pcibus_to_node
 #define pcibus_to_node(bus)	((void)(bus), -1)
_

Patches currently in -mm which might be from tj@kernel.org are


