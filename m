From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mem-hotplug-introduce-movablenode-boot-option-fix.patch removed from -mm
 tree
Date: Thu, 03 Oct 2013 11:59:26 -0700
Message-ID: <524dbe8e.B+NpmpbBWokiMFRi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab3JCS71 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Oct 2013 14:59:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tangchen@cn.fujitsu.com, mingo@kernel.org, kamezawa.hiroyu@jp.fujitsu.com, zhangyanfei@cn.fujitsu.com

Subject: [to-be-updated] mem-hotplug-introduce-movablenode-boot-option-fix.patch removed from -mm tree
To: zhangyanfei@cn.fujitsu.com,kamezawa.hiroyu@jp.fujitsu.com,mingo@kernel.org,tangchen@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Oct 2013 11:59:26 -0700


The patch titled
     Subject: mm, memory-hotpulg: rename movablenode boot option to movable_node
has been removed from the -mm tree.  Its filename was
     mem-hotplug-introduce-movablenode-boot-option-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm, memory-hotpulg: rename movablenode boot option to movable_node

Since we already have config MOVABLE_NODE, and the boot option movablenode
is introduced as the boot-time switch to disable the effects of
CONFIG_MOVABLE_NODE=y when the system is booting.

So rename boot option movablenode to movable_node to match the config
MOVABLE_NODE.  And also updates the description of MOVABLE_NODE in
mm/Kconfig and the description of movable_node in kernel doc.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   16 ++--------------
 mm/Kconfig                          |   17 ++++++++++++-----
 mm/memory_hotplug.c                 |    6 +++---
 3 files changed, 17 insertions(+), 22 deletions(-)

diff -puN Documentation/kernel-parameters.txt~mem-hotplug-introduce-movablenode-boot-option-fix Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~mem-hotplug-introduce-movablenode-boot-option-fix
+++ a/Documentation/kernel-parameters.txt
@@ -1773,20 +1773,8 @@ bytes respectively. Such letter suffixes
 			that the amount of memory usable for all allocations
 			is not too small.
 
-	movablenode		[KNL,X86] This parameter enables/disables the
-			kernel to arrange hotpluggable memory ranges recorded
-			in ACPI SRAT(System Resource Affinity Table) as
-			ZONE_MOVABLE. And these memory can be hot-removed when
-			the system is up.
-			By specifying this option, all the hotpluggable memory
-			will be in ZONE_MOVABLE, which the kernel cannot use.
-			This will cause NUMA performance down. For users who
-			care about NUMA performance, just don't use it.
-			If all the memory ranges in the system are hotpluggable,
-			then the ones used by the kernel at early time, such as
-			kernel code and data segments, initrd file and so on,
-			won't be set as ZONE_MOVABLE, and won't be hotpluggable.
-			Otherwise the kernel won't have enough memory to boot.
+	movable_node	[KNL,X86] Boot-time switch to disable the effects
+			of CONFIG_MOVABLE_NODE=y. See mm/Kconfig for details.
 
 	MTD_Partition=	[MTD]
 			Format: <name>,<region-number>,<size>,<offset>
diff -puN mm/Kconfig~mem-hotplug-introduce-movablenode-boot-option-fix mm/Kconfig
--- a/mm/Kconfig~mem-hotplug-introduce-movablenode-boot-option-fix
+++ a/mm/Kconfig
@@ -153,11 +153,18 @@ config MOVABLE_NODE
 	help
 	  Allow a node to have only movable memory.  Pages used by the kernel,
 	  such as direct mapping pages cannot be migrated.  So the corresponding
-	  memory device cannot be hotplugged.  This option allows users to
-	  online all the memory of a node as movable memory so that the whole
-	  node can be hotplugged.  Users who don't use the memory hotplug
-	  feature are fine with this option on since they don't online memory
-	  as movable.
+	  memory device cannot be hotplugged.  This option allows the following
+	  two things:
+	  - When the system is booting, node full of hotpluggable memory can
+	  be arranged to have only movable memory so that the whole node can
+	  be hotplugged. (need movable_node boot option specified).
+	  - After the system is up, the option allows users to online all the
+	  memory of a node as movable memory so that the whole node can be
+	  hotplugged.
+
+	  Users who don't use the memory hotplug feature are fine with this
+	  option on since they don't specify movable_node boot option or they
+	  don't online memory as movable.
 
 	  Say Y here if you want to hotplug a whole node.
 	  Say N here if you want kernel to use memory on all nodes evenly.
diff -puN mm/memory_hotplug.c~mem-hotplug-introduce-movablenode-boot-option-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mem-hotplug-introduce-movablenode-boot-option-fix
+++ a/mm/memory_hotplug.c
@@ -1424,7 +1424,7 @@ static bool can_offline_normal(struct zo
 }
 #endif /* CONFIG_MOVABLE_NODE */
 
-static int __init cmdline_parse_movablenode(char *p)
+static int __init cmdline_parse_movable_node(char *p)
 {
 #ifdef CONFIG_MOVABLE_NODE
 	/*
@@ -1448,11 +1448,11 @@ static int __init cmdline_parse_movablen
 	 */
 	memblock_set_bottom_up(true);
 #else
-	pr_warn("movablenode option not supported");
+	pr_warn("movable_node option not supported");
 #endif
 	return 0;
 }
-early_param("movablenode", cmdline_parse_movablenode);
+early_param("movable_node", cmdline_parse_movable_node);
 
 /* check which state of node_states will be changed when offline memory */
 static void node_states_check_changes_offline(unsigned long nr_pages,
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

mm-vmalloc-dont-set-area-caller-twice.patch
mm-vmalloc-fix-show-vmap_area-information-race-with-vmap_area-tear-down.patch
mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch
revert-mm-vmallocc-emit-the-failure-message-before-return.patch
memblock-factor-out-of-top-down-allocation-hack.patch
x86-mm-factor-out-of-top-down-direct-mapping-setup-next-fix.patch

