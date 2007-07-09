From: akpm@linux-foundation.org
Subject: - change-zonelist-order-documentaion.patch removed from -mm tree
Date: Mon, 09 Jul 2007 13:34:57 -0700
Message-ID: <200707092034.l69KYvj7009736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59386 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754335AbXGIUfK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 16:35:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, ak@suse.de, clameter@sgi.com, jesse.barnes@intel.com, lee.schermerhorn@hp.com, mm-commits@vger.kernel.org


The patch titled
     change zonelist order: documentation
has been removed from the -mm tree.  Its filename was
     change-zonelist-order-documentaion.patch

This patch was dropped because it was folded into change-zonelist-order-zonelist-order-selection-logic.patch

------------------------------------------------------
Subject: change zonelist order: documentation
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Documentation for numa_zonelist_order.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "jesse.barnes@intel.com" <jesse.barnes@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    5 ++
 Documentation/sysctl/vm.txt         |   45 ++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff -puN Documentation/kernel-parameters.txt~change-zonelist-order-documentaion Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~change-zonelist-order-documentaion
+++ a/Documentation/kernel-parameters.txt
@@ -1245,6 +1245,11 @@ and is between 256 and 4096 characters. 
 
 	nowb		[ARM]
 
+	numa_zonelist_order= [KNL, BOOT] Select zonelist order for NUMA.
+			one of ['zone', 'node', 'default'] can be specified
+			This can be set from sysctl after boot.
+			See Documentation/sysctl/vm.txt for details.
+
 	nr_uarts=	[SERIAL] maximum number of UARTs to be registered.
 
 	opl3=		[HW,OSS]
diff -puN Documentation/sysctl/vm.txt~change-zonelist-order-documentaion Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~change-zonelist-order-documentaion
+++ a/Documentation/sysctl/vm.txt
@@ -32,6 +32,7 @@ Currently, these files are in /proc/sys/
 - min_slab_ratio
 - panic_on_oom
 - mmap_min_address
+- numa_zonelist_order
 
 ==============================================================
 
@@ -231,3 +232,47 @@ security module.  Setting this value to 
 vast majority of applications to work correctly and provide defense in depth
 against future potential kernel bugs.
 
+==============================================================
+
+numa_zonelist_order
+
+This sysctl is only for NUMA.
+'where the memory is allocated from' is controlled by zonelists.
+(This documentation ignores ZONE_HIGHMEM/ZONE_DMA32 for simple explanation.
+ you may be able to read ZONE_DMA as ZONE_DMA32...)
+
+In non-NUMA case, a zonelist for GFP_KERNEL is ordered as following.
+ZONE_NORMAL -> ZONE_DMA
+This means that a memory allocation request for GFP_KERNEL will
+get memory from ZONE_DMA only when ZONE_NORMAL is not available.
+
+In NUMA case, you can think of following 2 types of order.
+Assume 2 node NUMA and below is zonelist of Node(0)'s GFP_KERNEL
+
+(A) Node(0) ZONE_NORMAL -> Node(0) ZONE_DMA -> Node(1) ZONE_NORMAL
+(B) Node(0) ZONE_NORMAL -> Node(1) ZONE_NORMAL -> Node(0) ZONE_DMA.
+
+Type(A) offers the best locality for processes on Node(0), but ZONE_DMA
+will be used before ZONE_NORMAL exhaustion. This increases possibility of
+out-of-memory(OOM) of ZONE_DMA because ZONE_DMA is tend to be small.
+
+Type(B) cannot offer the best locality but is more robust against OOM of
+the DMA zone.
+
+Type(A) is called as "Node" order. Type (B) is "Zone" order.
+
+"Node order" orders the zonelists by node, then by zone within each node.
+Specify "[Nn]ode" for zone order
+
+"Zone Order" orders the zonelists by zone type, then by node within each
+zone.  Specify "[Zz]one"for zode order.
+
+Specify "[Dd]efault" to request automatic configuration.  Autoconfiguration
+will select "node" order in following case.
+(1) if the DMA zone does not exist or
+(2) if the DMA zone comprises greater than 50% of the available memory or
+(3) if any node's DMA zone comprises greater than 60% of its local memory and
+    the amount of local memory is big enough.
+
+Otherwise, "zone" order will be selected. Default order is recommended unless
+this is causing problems for your system/application.
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-documentaion.patch
memory-unplug-v7-migration-by-kernel.patch
memory-unplug-v7-isolate_lru_page-fix.patch
memory-unplug-v7-memory-hotplug-cleanup.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-unplug-v7-ia64-interface.patch
