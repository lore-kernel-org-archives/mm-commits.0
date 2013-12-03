From: akpm@linux-foundation.org
Subject: +
 x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
 added to -mm tree
Date: Tue, 03 Dec 2013 15:54:49 -0800
Message-ID: <529e6f49.6bbjqfBHAOJjxviT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125Ab3LCXyv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Dec 2013 18:54:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, wency@cn.fujitsu.com, vasilis.liaskovitis@profitbricks.com, trenn@suse.de, toshi.kani@hp.com, tj@kernel.org, tglx@linutronix.de, rjw@sisk.pl, riel@redhat.com, prarit@redhat.com, mingo@elte.hu, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, lwoodman@redhat.com, liwanp@linux.vnet.ibm.com, lenb@kernel.org, laijs@cn.fujitsu.com, jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, imtangchen@gmail.com, hpa@zytor.com, hannes@cmpxchg.org, gong.chen@linux.intel.com, tangchen@cn.fujitsu.com

Subject: + x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch added to -mm tree
To: tangchen@cn.fujitsu.com,gong.chen@linux.intel.com,hannes@cmpxchg.org,hpa@zytor.com,imtangchen@gmail.com,isimatu.yasuaki@jp.fujitsu.com,izumi.taku@jp.fujitsu.com,jiang.liu@huawei.com,laijs@cn.fujitsu.com,lenb@kernel.org,liwanp@linux.vnet.ibm.com,lwoodman@redhat.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,mingo@elte.hu,prarit@redhat.com,riel@redhat.com,rjw@sisk.pl,tglx@linutronix.de,tj@kernel.org,toshi.kani@hp.com,trenn@suse.de,vasilis.liaskovitis@profitbricks.com,wency@cn.fujitsu.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Tue, 03 Dec 2013 15:54:49 -0800


The patch titled
     Subject: x86, numa, acpi, memory-hotplug: make movable_node have higher priority
has been added to the -mm tree.  Its filename is
     x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch

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
Subject: x86, numa, acpi, memory-hotplug: make movable_node have higher priority

If users specify the original movablecore=nn@ss boot option, the kernel
will arrange [ss, ss+nn) as ZONE_MOVABLE.  The kernelcore=nn@ss boot
option is similar except it specifies ZONE_NORMAL ranges.

Now, if users specify "movable_node" in kernel commandline, the kernel
will arrange hotpluggable memory in SRAT as ZONE_MOVABLE.  And if users do
this, all the other movablecore=nn@ss and kernelcore=nn@ss options should
be ignored.

For those who don't want this, just specify nothing.  The kernel will act
as before.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Chen Tang <imtangchen@gmail.com>
Cc: Gong Chen <gong.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Liu Jiang <jiang.liu@huawei.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority mm/page_alloc.c
--- a/mm/page_alloc.c~x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority
+++ a/mm/page_alloc.c
@@ -5019,9 +5019,33 @@ static void __init find_zone_movable_pfn
 	nodemask_t saved_node_state = node_states[N_MEMORY];
 	unsigned long totalpages = early_calculate_totalpages();
 	int usable_nodes = nodes_weight(node_states[N_MEMORY]);
+	struct memblock_type *type = &memblock.memory;
+
+	/* Need to find movable_zone earlier when movable_node is specified. */
+	find_usable_zone_for_movable();
+
+	/*
+	 * If movable_node is specified, ignore kernelcore and movablecore
+	 * options.
+	 */
+	if (movable_node_is_enabled()) {
+		for (i = 0; i < type->cnt; i++) {
+			if (!memblock_is_hotpluggable(&type->regions[i]))
+				continue;
+
+			nid = type->regions[i].nid;
+
+			usable_startpfn = PFN_DOWN(type->regions[i].base);
+			zone_movable_pfn[nid] = zone_movable_pfn[nid] ?
+				min(usable_startpfn, zone_movable_pfn[nid]) :
+				usable_startpfn;
+		}
+
+		goto out2;
+	}
 
 	/*
-	 * If movablecore was specified, calculate what size of
+	 * If movablecore=nn[KMG] was specified, calculate what size of
 	 * kernelcore that corresponds so that memory usable for
 	 * any allocation type is evenly spread. If both kernelcore
 	 * and movablecore are specified, then the value of kernelcore
@@ -5047,7 +5071,6 @@ static void __init find_zone_movable_pfn
 		goto out;
 
 	/* usable_startpfn is the lowest possible pfn ZONE_MOVABLE can be at */
-	find_usable_zone_for_movable();
 	usable_startpfn = arch_zone_lowest_possible_pfn[movable_zone];
 
 restart:
@@ -5138,6 +5161,7 @@ restart:
 	if (usable_nodes && required_kernelcore > usable_nodes)
 		goto restart;
 
+out2:
 	/* Align start of ZONE_MOVABLE on all nids to MAX_ORDER_NR_PAGES */
 	for (nid = 0; nid < MAX_NUMNODES; nid++)
 		zone_movable_pfn[nid] =
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

x86-get-pg_data_ts-memory-from-other-node.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch

