From: akpm@linux-foundation.org
Subject: +
 acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch added to
 -mm tree
Date: Tue, 03 Dec 2013 15:54:43 -0800
Message-ID: <529e6f43.NYD1zA9Md5NBuLp5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab3LCXyp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Dec 2013 18:54:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, wency@cn.fujitsu.com, vasilis.liaskovitis@profitbricks.com, trenn@suse.de, toshi.kani@hp.com, tj@kernel.org, tglx@linutronix.de, rjw@sisk.pl, riel@redhat.com, prarit@redhat.com, mingo@elte.hu, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, lwoodman@redhat.com, liwanp@linux.vnet.ibm.com, lenb@kernel.org, laijs@cn.fujitsu.com, jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, imtangchen@gmail.com, hpa@zytor.com, hannes@cmpxchg.org, gong.chen@linux.intel.com, tangchen@cn.fujitsu.com

Subject: + acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch added to -mm tree
To: tangchen@cn.fujitsu.com,gong.chen@linux.intel.com,hannes@cmpxchg.org,hpa@zytor.com,imtangchen@gmail.com,isimatu.yasuaki@jp.fujitsu.com,izumi.taku@jp.fujitsu.com,jiang.liu@huawei.com,laijs@cn.fujitsu.com,lenb@kernel.org,liwanp@linux.vnet.ibm.com,lwoodman@redhat.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,mingo@elte.hu,prarit@redhat.com,riel@redhat.com,rjw@sisk.pl,tglx@linutronix.de,tj@kernel.org,toshi.kani@hp.com,trenn@suse.de,vasilis.liaskovitis@profitbricks.com,wency@cn.fujitsu.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Tue, 03 Dec 2013 15:54:43 -0800


The patch titled
     Subject: acpi, numa, mem_hotplug: mark hotpluggable memory in memblock
has been added to the -mm tree.  Its filename is
     acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch

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
Subject: acpi, numa, mem_hotplug: mark hotpluggable memory in memblock

When parsing SRAT, we know that which memory area is hotpluggable.  So we
invoke function memblock_mark_hotplug() introduced by previous patch to
mark hotpluggable memory in memblock.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
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
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa.c |    2 ++
 arch/x86/mm/srat.c |    5 +++++
 2 files changed, 7 insertions(+)

diff -puN arch/x86/mm/numa.c~acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock
+++ a/arch/x86/mm/numa.c
@@ -569,6 +569,8 @@ static int __init numa_init(int (*init_f
 	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
 	WARN_ON(memblock_set_node(0, ULLONG_MAX, &memblock.memory,
 				  MAX_NUMNODES));
+	/* In case that parsing SRAT failed. */
+	WARN_ON(memblock_clear_hotplug(0, ULLONG_MAX));
 	numa_reset_distance();
 
 	ret = init_func();
diff -puN arch/x86/mm/srat.c~acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock arch/x86/mm/srat.c
--- a/arch/x86/mm/srat.c~acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock
+++ a/arch/x86/mm/srat.c
@@ -181,6 +181,11 @@ acpi_numa_memory_affinity_init(struct ac
 		(unsigned long long) start, (unsigned long long) end - 1,
 		hotpluggable ? " hotplug" : "");
 
+	/* Mark hotplug range in memblock. */
+	if (hotpluggable && memblock_mark_hotplug(start, ma->length))
+		pr_warn("SRAT: Failed to mark hotplug range [mem %#010Lx-%#010Lx] in memblock\n",
+			(unsigned long long) start, (unsigned long long) end - 1);
+
 	return 0;
 out_err_bad_srat:
 	bad_srat();
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

