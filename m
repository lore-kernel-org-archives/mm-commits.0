From: akpm@linux-foundation.org
Subject: +
 x86-mem-hotplug-support-initialize-page-tables-in-bottom-up.patch added to
 -mm tree
Date: Fri, 11 Oct 2013 13:39:13 -0700
Message-ID: <525861f1.e7ZAAFZ7bBbJwjS+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932790Ab3JKUjO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Oct 2013 16:39:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, wency@cn.fujitsu.com, trenn@suse.de, toshi.kani@hp.com, tj@kernel.org, tglx@linutronix.de, riel@redhat.com, mingo@elte.hu, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, laijs@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, tangchen@cn.fujitsu.com

Subject: + x86-mem-hotplug-support-initialize-page-tables-in-bottom-up.patch added to -mm tree
To: tangchen@cn.fujitsu.com,hannes@cmpxchg.org,hpa@zytor.com,isimatu.yasuaki@jp.fujitsu.com,izumi.taku@jp.fujitsu.com,jiang.liu@huawei.com,kamezawa.hiroyu@jp.fujitsu.com,laijs@cn.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,mingo@elte.hu,riel@redhat.com,tglx@linutronix.de,tj@kernel.org,toshi.kani@hp.com,trenn@suse.de,wency@cn.fujitsu.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Fri, 11 Oct 2013 13:39:13 -0700


The patch titled
     Subject: x86/mem-hotplug: support initialize page tables in bottom-up
has been added to the -mm tree.  Its filename is
     x86-mem-hotplug-support-initialize-page-tables-in-bottom-up.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mem-hotplug-support-initialize-page-tables-in-bottom-up.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mem-hotplug-support-initialize-page-tables-in-bottom-up.patch

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
Subject: x86/mem-hotplug: support initialize page tables in bottom-up

The Linux kernel cannot migrate pages used by the kernel.  As a result,
kernel pages cannot be hot-removed.  So we cannot allocate hotpluggable
memory for the kernel.

In a memory hotplug system, any numa node the kernel resides in should be
unhotpluggable.  And for a modern server, each node could have at least
16GB memory.  So memory around the kernel image is highly likely
unhotpluggable.

ACPI SRAT (System Resource Affinity Table) contains the memory hotplug
info.  But before SRAT is parsed, memblock has already started to allocate
memory for the kernel.  So we need to prevent memblock from doing this.

So direct memory mapping page tables setup is the case. 
init_mem_mapping() is called before SRAT is parsed.  To prevent page
tables being allocated within hotpluggable memory, we will use bottom-up
direction to allocate page tables from the end of kernel image to the
higher memory.

Note:
As for allocating page tables in lower memory, TJ said:

: This is an optional behavior which is triggered by a very specific kernel
: boot param, which I suspect is gonna need to stick around to support
: memory hotplug in the current setup unless we add another layer of address
: translation to support memory hotplug.

As for page tables may occupy too much lower memory if using 4K mapping
(CONFIG_DEBUG_PAGEALLOC and CONFIG_KMEMCHECK both disable using >4k
pages), TJ said:

: But as I said in the same paragraph, parsing SRAT earlier doesn't solve
: the problem in itself either.  Ignoring the option if 4k mapping is
: required and memory consumption would be prohibitive should work, no? 
: Something like that would be necessary if we're gonna worry about cases
: like this no matter how we implement it, but, frankly, I'm not sure this
: is something worth worrying about.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Toshi Kani <toshi.kani@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
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
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init.c |   66 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 64 insertions(+), 2 deletions(-)

diff -puN arch/x86/mm/init.c~x86-mem-hotplug-support-initialize-page-tables-in-bottom-up arch/x86/mm/init.c
--- a/arch/x86/mm/init.c~x86-mem-hotplug-support-initialize-page-tables-in-bottom-up
+++ a/arch/x86/mm/init.c
@@ -458,6 +458,51 @@ static void __init memory_map_top_down(u
 		init_range_memory_mapping(real_end, map_end);
 }
 
+/**
+ * memory_map_bottom_up - Map [map_start, map_end) bottom up
+ * @map_start: start address of the target memory range
+ * @map_end: end address of the target memory range
+ *
+ * This function will setup direct mapping for memory range
+ * [map_start, map_end) in bottom-up. Since we have limited the
+ * bottom-up allocation above the kernel, the page tables will
+ * be allocated just above the kernel and we map the memory
+ * in [map_start, map_end) in bottom-up.
+ */
+static void __init memory_map_bottom_up(unsigned long map_start,
+					unsigned long map_end)
+{
+	unsigned long next, new_mapped_ram_size, start;
+	unsigned long mapped_ram_size = 0;
+	/* step_size need to be small so pgt_buf from BRK could cover it */
+	unsigned long step_size = PMD_SIZE;
+
+	start = map_start;
+	min_pfn_mapped = start >> PAGE_SHIFT;
+
+	/*
+	 * We start from the bottom (@map_start) and go to the top (@map_end).
+	 * The memblock_find_in_range() gets us a block of RAM from the
+	 * end of RAM in [min_pfn_mapped, max_pfn_mapped) used as new pages
+	 * for page table.
+	 */
+	while (start < map_end) {
+		if (map_end - start > step_size) {
+			next = round_up(start + 1, step_size);
+			if (next > map_end)
+				next = map_end;
+		} else
+			next = map_end;
+
+		new_mapped_ram_size = init_range_memory_mapping(start, next);
+		start = next;
+
+		if (new_mapped_ram_size > mapped_ram_size)
+			step_size <<= STEP_SIZE_SHIFT;
+		mapped_ram_size += new_mapped_ram_size;
+	}
+}
+
 void __init init_mem_mapping(void)
 {
 	unsigned long end;
@@ -473,8 +518,25 @@ void __init init_mem_mapping(void)
 	/* the ISA range is always mapped regardless of memory holes */
 	init_memory_mapping(0, ISA_END_ADDRESS);
 
-	/* setup direct mapping for range [ISA_END_ADDRESS, end) in top-down*/
-	memory_map_top_down(ISA_END_ADDRESS, end);
+	/*
+	 * If the allocation is in bottom-up direction, we setup direct mapping
+	 * in bottom-up, otherwise we setup direct mapping in top-down.
+	 */
+	if (memblock_bottom_up()) {
+		unsigned long kernel_end = __pa_symbol(_end);
+
+		/*
+		 * we need two separate calls here. This is because we want to
+		 * allocate page tables above the kernel. So we first map
+		 * [kernel_end, end) to make memory above the kernel be mapped
+		 * as soon as possible. And then use page tables allocated above
+		 * the kernel to map [ISA_END_ADDRESS, kernel_end).
+		 */
+		memory_map_bottom_up(kernel_end, end);
+		memory_map_bottom_up(ISA_END_ADDRESS, kernel_end);
+	} else {
+		memory_map_top_down(ISA_END_ADDRESS, end);
+	}
 
 #ifdef CONFIG_X86_64
 	if (max_pfn > max_low_pfn) {
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

