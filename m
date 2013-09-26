From: akpm@linux-foundation.org
Subject: + x86-mm-factor-out-of-top-down-direct-mapping-setup.patch added
 to -mm tree
Date: Wed, 25 Sep 2013 17:05:24 -0700
Message-ID: <52437a44.I/idP31T/AcGnKbW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab3IZAF0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 20:05:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, wency@cn.fujitsu.com, trenn@suse.de, toshi.kani@hp.com, tj@kernel.org, tglx@linutronix.de, rjw@sisk.pl, riel@redhat.com, mingo@elte.hu, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, lenb@kernel.org, laijs@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, tangchen@cn.fujitsu.com

Subject: + x86-mm-factor-out-of-top-down-direct-mapping-setup.patch added to -mm tree
To: tangchen@cn.fujitsu.com,hannes@cmpxchg.org,hpa@zytor.com,isimatu.yasuaki@jp.fujitsu.com,izumi.taku@jp.fujitsu.com,jiang.liu@huawei.com,kamezawa.hiroyu@jp.fujitsu.com,laijs@cn.fujitsu.com,lenb@kernel.org,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,mingo@elte.hu,riel@redhat.com,rjw@sisk.pl,tglx@linutronix.de,tj@kernel.org,toshi.kani@hp.com,trenn@suse.de,wency@cn.fujitsu.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 17:05:24 -0700


The patch titled
     Subject: x86/mm: factor out top-down direct mapping setup
has been added to the -mm tree.  Its filename is
     x86-mm-factor-out-of-top-down-direct-mapping-setup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-factor-out-of-top-down-direct-mapping-setup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-factor-out-of-top-down-direct-mapping-setup.patch

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
Subject: x86/mm: factor out top-down direct mapping setup

Create a new function memory_map_top_down to factor out of the top-down
direct memory mapping pagetable setup.  This is also a preparation for the
following patch, which will introduce the bottom-up memory mapping.  That
said, we will put the two ways of pagetable setup into separate functions,
and choose to use which way in init_mem_mapping, which makes the code more
clear.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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

 arch/x86/mm/init.c |   58 ++++++++++++++++++++++++++++---------------
 1 file changed, 38 insertions(+), 20 deletions(-)

diff -puN arch/x86/mm/init.c~x86-mm-factor-out-of-top-down-direct-mapping-setup arch/x86/mm/init.c
--- a/arch/x86/mm/init.c~x86-mm-factor-out-of-top-down-direct-mapping-setup
+++ a/arch/x86/mm/init.c
@@ -401,27 +401,26 @@ static unsigned long __init init_range_m
 
 /* (PUD_SHIFT-PMD_SHIFT)/2 */
 #define STEP_SIZE_SHIFT 5
-void __init init_mem_mapping(void)
+
+/**
+ * memory_map_top_down - Map [map_start, map_end) top down
+ * @map_start: start address of the target memory range
+ * @map_end: end address of the target memory range
+ *
+ * This function will setup direct mapping for memory range
+ * [map_start, map_end) in top-down.
+ */
+static void __init memory_map_top_down(unsigned long map_start,
+				       unsigned long map_end)
 {
-	unsigned long end, real_end, start, last_start;
+	unsigned long real_end, start, last_start;
 	unsigned long step_size;
 	unsigned long addr;
 	unsigned long mapped_ram_size = 0;
 	unsigned long new_mapped_ram_size;
 
-	probe_page_size_mask();
-
-#ifdef CONFIG_X86_64
-	end = max_pfn << PAGE_SHIFT;
-#else
-	end = max_low_pfn << PAGE_SHIFT;
-#endif
-
-	/* the ISA range is always mapped regardless of memory holes */
-	init_memory_mapping(0, ISA_END_ADDRESS);
-
 	/* xen has big range in reserved near end of ram, skip it at first.*/
-	addr = memblock_find_in_range(ISA_END_ADDRESS, end, PMD_SIZE, PMD_SIZE);
+	addr = memblock_find_in_range(map_start, map_end, PMD_SIZE, PMD_SIZE);
 	real_end = addr + PMD_SIZE;
 
 	/* step_size need to be small so pgt_buf from BRK could cover it */
@@ -436,13 +435,13 @@ void __init init_mem_mapping(void)
 	 * end of RAM in [min_pfn_mapped, max_pfn_mapped) used as new pages
 	 * for page table.
 	 */
-	while (last_start > ISA_END_ADDRESS) {
+	while (last_start > map_start) {
 		if (last_start > step_size) {
 			start = round_down(last_start - 1, step_size);
-			if (start < ISA_END_ADDRESS)
-				start = ISA_END_ADDRESS;
+			if (start < map_start)
+				start = map_start;
 		} else
-			start = ISA_END_ADDRESS;
+			start = map_start;
 		new_mapped_ram_size = init_range_memory_mapping(start,
 							last_start);
 		last_start = start;
@@ -453,8 +452,27 @@ void __init init_mem_mapping(void)
 		mapped_ram_size += new_mapped_ram_size;
 	}
 
-	if (real_end < end)
-		init_range_memory_mapping(real_end, end);
+	if (real_end < map_end)
+		init_range_memory_mapping(real_end, map_end);
+}
+
+void __init init_mem_mapping(void)
+{
+	unsigned long end;
+
+	probe_page_size_mask();
+
+#ifdef CONFIG_X86_64
+	end = max_pfn << PAGE_SHIFT;
+#else
+	end = max_low_pfn << PAGE_SHIFT;
+#endif
+
+	/* the ISA range is always mapped regardless of memory holes */
+	init_memory_mapping(0, ISA_END_ADDRESS);
+
+	/* setup direct mapping for range [ISA_END_ADDRESS, end) in top-down*/
+	memory_map_top_down(ISA_END_ADDRESS, end);
 
 #ifdef CONFIG_X86_64
 	if (max_pfn > max_low_pfn) {
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

memblock-factor-out-of-top-down-allocation.patch
memblock-introduce-bottom-up-allocation-mode.patch
x86-mm-factor-out-of-top-down-direct-mapping-setup.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up.patch
x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch
mem-hotplug-introduce-movablenode-boot-option.patch

