From: akpm@linux-foundation.org
Subject: + mem-hotplug-introduce-movable_node-boot-option.patch added to
 -mm tree
Date: Fri, 11 Oct 2013 13:39:16 -0700
Message-ID: <525861f4.3fJey/E8ViLBw2p9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47146 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932790Ab3JKUjS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Oct 2013 16:39:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, wency@cn.fujitsu.com, trenn@suse.de, toshi.kani@hp.com, tj@kernel.org, tglx@linutronix.de, riel@redhat.com, mingo@kernel.org, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, laijs@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, tangchen@cn.fujitsu.com

Subject: + mem-hotplug-introduce-movable_node-boot-option.patch added to -mm tree
To: tangchen@cn.fujitsu.com,hannes@cmpxchg.org,hpa@zytor.com,isimatu.yasuaki@jp.fujitsu.com,izumi.taku@jp.fujitsu.com,jiang.liu@huawei.com,kamezawa.hiroyu@jp.fujitsu.com,laijs@cn.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,mingo@kernel.org,riel@redhat.com,tglx@linutronix.de,tj@kernel.org,toshi.kani@hp.com,trenn@suse.de,wency@cn.fujitsu.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Fri, 11 Oct 2013 13:39:16 -0700


The patch titled
     Subject: mem-hotplug: introduce movable_node boot option
has been added to the -mm tree.  Its filename is
     mem-hotplug-introduce-movable_node-boot-option.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mem-hotplug-introduce-movable_node-boot-option.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mem-hotplug-introduce-movable_node-boot-option.patch

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
Subject: mem-hotplug: introduce movable_node boot option

The hot-Pluggable field in SRAT specifies which memory is hotpluggable. 
As we mentioned before, if hotpluggable memory is used by the kernel, it
cannot be hot-removed.  So memory hotplug users may want to set all
hotpluggable memory in ZONE_MOVABLE so that the kernel won't use it.

Memory hotplug users may also set a node as movable node, which has
ZONE_MOVABLE only, so that the whole node can be hot-removed.

But the kernel cannot use memory in ZONE_MOVABLE.  By doing this, the
kernel cannot use memory in movable nodes.  This will cause NUMA
performance down.  And other users may be unhappy.

So we need a way to allow users to enable and disable this functionality. 
In this patch, we introduce movable_node boot option to allow users to
choose to not to consume hotpluggable memory at early boot time and later
we can set it as ZONE_MOVABLE.

To achieve this, the movable_node boot option will control the memblock
allocation direction.  That said, after memblock is ready, before SRAT is
parsed, we should allocate memory near the kernel image as we explained in
the previous patches.  So if movable_node boot option is set, the kernel
does the following:

1. After memblock is ready, make memblock allocate memory bottom up.
2. After SRAT is parsed, make memblock behave as default, allocate memory
   top down.

Users can specify "movable_node" in kernel commandline to enable this
functionality.  For those who don't use memory hotplug or who don't want
to lose their NUMA performance, just don't specify anything.  The kernel
will work as before.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Suggested-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Suggested-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Toshi Kani <toshi.kani@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    3 ++
 arch/x86/mm/numa.c                  |   11 +++++++++
 mm/Kconfig                          |   17 ++++++++++----
 mm/memory_hotplug.c                 |   31 ++++++++++++++++++++++++++
 4 files changed, 57 insertions(+), 5 deletions(-)

diff -puN Documentation/kernel-parameters.txt~mem-hotplug-introduce-movable_node-boot-option Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~mem-hotplug-introduce-movable_node-boot-option
+++ a/Documentation/kernel-parameters.txt
@@ -1773,6 +1773,9 @@ bytes respectively. Such letter suffixes
 			that the amount of memory usable for all allocations
 			is not too small.
 
+	movable_node	[KNL,X86] Boot-time switch to enable the effects
+			of CONFIG_MOVABLE_NODE=y. See mm/Kconfig for details.
+
 	MTD_Partition=	[MTD]
 			Format: <name>,<region-number>,<size>,<offset>
 
diff -puN arch/x86/mm/numa.c~mem-hotplug-introduce-movable_node-boot-option arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~mem-hotplug-introduce-movable_node-boot-option
+++ a/arch/x86/mm/numa.c
@@ -567,6 +567,17 @@ static int __init numa_init(int (*init_f
 	ret = init_func();
 	if (ret < 0)
 		return ret;
+
+	/*
+	 * We reset memblock back to the top-down direction
+	 * here because if we configured ACPI_NUMA, we have
+	 * parsed SRAT in init_func(). It is ok to have the
+	 * reset here even if we did't configure ACPI_NUMA
+	 * or acpi numa init fails and fallbacks to dummy
+	 * numa init.
+	 */
+	memblock_set_bottom_up(false);
+
 	ret = numa_cleanup_meminfo(&numa_meminfo);
 	if (ret < 0)
 		return ret;
diff -puN mm/Kconfig~mem-hotplug-introduce-movable_node-boot-option mm/Kconfig
--- a/mm/Kconfig~mem-hotplug-introduce-movable_node-boot-option
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
+	  be hot-removed. (need movable_node boot option specified).
+	  - After the system is up, the option allows users to online all the
+	  memory of a node as movable memory so that the whole node can be
+	  hot-removed.
+
+	  Users who don't use the memory hotplug feature are fine with this
+	  option on since they don't specify movable_node boot option or they
+	  don't online memory as movable.
 
 	  Say Y here if you want to hotplug a whole node.
 	  Say N here if you want kernel to use memory on all nodes evenly.
diff -puN mm/memory_hotplug.c~mem-hotplug-introduce-movable_node-boot-option mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mem-hotplug-introduce-movable_node-boot-option
+++ a/mm/memory_hotplug.c
@@ -31,6 +31,7 @@
 #include <linux/firmware-map.h>
 #include <linux/stop_machine.h>
 #include <linux/hugetlb.h>
+#include <linux/memblock.h>
 
 #include <asm/tlbflush.h>
 
@@ -1422,6 +1423,36 @@ static bool can_offline_normal(struct zo
 }
 #endif /* CONFIG_MOVABLE_NODE */
 
+static int __init cmdline_parse_movable_node(char *p)
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
+	pr_warn("movable_node option not supported\n");
+#endif
+	return 0;
+}
+early_param("movable_node", cmdline_parse_movable_node);
+
 /* check which state of node_states will be changed when offline memory */
 static void node_states_check_changes_offline(unsigned long nr_pages,
 		struct zone *zone, struct memory_notify *arg)
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

mm-sparsemem-use-pages_per_section-to-remove-redundant-nr_pages-parameter.patch
mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap.patch
mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap-v2.patch
memblock-factor-out-of-top-down-allocation.patch
memblock-introduce-bottom-up-allocation-mode.patch
x86-mm-factor-out-of-top-down-direct-mapping-setup.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up.patch
x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch
mem-hotplug-introduce-movable_node-boot-option.patch
linux-next.patch

