From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mem-hotplug-introduce-movablenode-boot-option.patch removed from -mm tree
Date: Thu, 03 Oct 2013 11:59:24 -0700
Message-ID: <524dbe8c.rKvNUVkcFMWibbdn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56503 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab3JCS7Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Oct 2013 14:59:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, wency@cn.fujitsu.com, trenn@suse.de, toshi.kani@hp.com, tj@kernel.org, tglx@linutronix.de, rjw@sisk.pl, riel@redhat.com, mingo@elte.hu, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, lenb@kernel.org, laijs@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, tangchen@cn.fujitsu.com

Subject: [to-be-updated] mem-hotplug-introduce-movablenode-boot-option.patch removed from -mm tree
To: tangchen@cn.fujitsu.com,hannes@cmpxchg.org,hpa@zytor.com,isimatu.yasuaki@jp.fujitsu.com,izumi.taku@jp.fujitsu.com,jiang.liu@huawei.com,kamezawa.hiroyu@jp.fujitsu.com,laijs@cn.fujitsu.com,lenb@kernel.org,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,mingo@elte.hu,riel@redhat.com,rjw@sisk.pl,tglx@linutronix.de,tj@kernel.org,toshi.kani@hp.com,trenn@suse.de,wency@cn.fujitsu.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Oct 2013 11:59:24 -0700


The patch titled
     Subject: mem-hotplug: introduce movablenode boot option
has been removed from the -mm tree.  Its filename was
     mem-hotplug-introduce-movablenode-boot-option.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: mem-hotplug: introduce movablenode boot option

The hot-Pluggable field in SRAT specifies which memory is hotpluggable. 
As we mentioned before, if hotpluggable memory is used by the kernel, it
cannot be hot-removed.  So memory hotplug users may want to set all
hotpluggable memory in ZONE_MOVABLE so that the kernel won't use it.

Memory hotplug users may also set a node as movable node, which has
ZONE_MOVABLE only, so that the whole node can be hot-removed.

But the kernel cannot use memory in ZONE_MOVABLE.  By doing this, the
kernel cannot use memory in movable nodes.  This will cause NUMA
performance to suffer.  And other users may be unhappy.

So we need a way to allow users to enable and disable this functionality. 
In this patch, we introduce movablenode boot option to allow users to
choose to not to consume hotpluggable memory at early boot time and later
we can set it as ZONE_MOVABLE.

To achieve this, the movablenode boot option will control the memblock
allocation direction.  That said, after memblock is ready, before SRAT is
parsed, we should allocate memory near the kernel image as we explained in
the previous patches.  So if movablenode boot option is set, the kernel
does the following:

1. After memblock is ready, make memblock allocate memory bottom up.
2. After SRAT is parsed, make memblock behave as default, allocate memory
   top down.

Users can specify "movablenode" on the kernel command line to enable this
functionality.  For those who don't use memory hotplug or who don't want
to lose their NUMA performance, just don't specify anything.  The kernel
will work as before.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Suggested-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   15 ++++++++++++
 arch/x86/kernel/setup.c             |    7 +++++
 mm/memory_hotplug.c                 |   31 ++++++++++++++++++++++++++
 3 files changed, 53 insertions(+)

diff -puN Documentation/kernel-parameters.txt~mem-hotplug-introduce-movablenode-boot-option Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~mem-hotplug-introduce-movablenode-boot-option
+++ a/Documentation/kernel-parameters.txt
@@ -1773,6 +1773,21 @@ bytes respectively. Such letter suffixes
 			that the amount of memory usable for all allocations
 			is not too small.
 
+	movablenode		[KNL,X86] This parameter enables/disables the
+			kernel to arrange hotpluggable memory ranges recorded
+			in ACPI SRAT(System Resource Affinity Table) as
+			ZONE_MOVABLE. And these memory can be hot-removed when
+			the system is up.
+			By specifying this option, all the hotpluggable memory
+			will be in ZONE_MOVABLE, which the kernel cannot use.
+			This will cause NUMA performance down. For users who
+			care about NUMA performance, just don't use it.
+			If all the memory ranges in the system are hotpluggable,
+			then the ones used by the kernel at early time, such as
+			kernel code and data segments, initrd file and so on,
+			won't be set as ZONE_MOVABLE, and won't be hotpluggable.
+			Otherwise the kernel won't have enough memory to boot.
+
 	MTD_Partition=	[MTD]
 			Format: <name>,<region-number>,<size>,<offset>
 
diff -puN arch/x86/kernel/setup.c~mem-hotplug-introduce-movablenode-boot-option arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~mem-hotplug-introduce-movablenode-boot-option
+++ a/arch/x86/kernel/setup.c
@@ -1132,6 +1132,13 @@ void __init setup_arch(char **cmdline_p)
 	early_acpi_boot_init();
 
 	initmem_init();
+
+	/*
+	 * When ACPI SRAT is parsed, which is done in initmem_init(),
+	 * set memblock back to the top-down direction.
+	 */
+	memblock_set_bottom_up(false);
+
 	memblock_find_dma_reserve();
 
 	/*
diff -puN mm/memory_hotplug.c~mem-hotplug-introduce-movablenode-boot-option mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mem-hotplug-introduce-movablenode-boot-option
+++ a/mm/memory_hotplug.c
@@ -31,6 +31,7 @@
 #include <linux/firmware-map.h>
 #include <linux/stop_machine.h>
 #include <linux/hugetlb.h>
+#include <linux/memblock.h>
 
 #include <asm/tlbflush.h>
 
@@ -1423,6 +1424,36 @@ static bool can_offline_normal(struct zo
 }
 #endif /* CONFIG_MOVABLE_NODE */
 
+static int __init cmdline_parse_movablenode(char *p)
+{
+#ifdef CONFIG_MOVABLE_NODE
+	/*
+	 * Memory used by the kernel cannot be hot-removed because Linux
+	 * cannot migrate the kernel pages. When memory hotplug is
+	 * enabled, we should prevent memblock from allocating memory
+	 * for the kernel.
+	 *
+	 * ACPI SRAT records all hotpluggable memory ranges. But before
+	 * SRAT is parsed, we don't know about it.
+	 *
+	 * The kernel image is loaded into memory at very early time. We
+	 * cannot prevent this anyway. So on NUMA system, we set any
+	 * node the kernel resides in as un-hotpluggable.
+	 *
+	 * Since on modern servers, one node could have double-digit
+	 * gigabytes memory, we can assume the memory around the kernel
+	 * image is also un-hotpluggable. So before SRAT is parsed, just
+	 * allocate memory near the kernel image to try the best to keep
+	 * the kernel away from hotpluggable memory.
+	 */
+	memblock_set_bottom_up(true);
+#else
+	pr_warn("movablenode option not supported");
+#endif
+	return 0;
+}
+early_param("movablenode", cmdline_parse_movablenode);
+
 /* check which state of node_states will be changed when offline memory */
 static void node_states_check_changes_offline(unsigned long nr_pages,
 		struct zone *zone, struct memory_notify *arg)
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

mem-hotplug-introduce-movablenode-boot-option-fix.patch
memblock-factor-out-of-top-down-allocation-hack.patch
linux-next.patch
x86-mm-factor-out-of-top-down-direct-mapping-setup-next-fix.patch

