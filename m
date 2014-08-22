From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range.patch removed from -mm tree
Date: Fri, 22 Aug 2014 14:36:31 -0700
Message-ID: <53f7b7df.R/U0+3KXUeWttx2x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:35688 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaHVVgd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Aug 2014 17:36:33 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so1319472qaq.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Aug 2014 14:36:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, hpa@zytor.com, rjw@sisk.pl, tangchen@cn.fujitsu.com, tj@kernel.org, wency@cn.fujitsu.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mem-hotplug: let memblock skip the hotpluggable memory regions in __next_mem_range()
has been removed from the -mm tree.  Its filename was
     mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mem-hotplug: let memblock skip the hotpluggable memory regions in __next_mem_range()

Let memblock skip the hotpluggable memory regions in __next_mem_range(),
it is used to to prevent memblock from allocating hotpluggable memory for
the kernel at early time.  The code is the same as __next_mem_range_rev().

Clear hotpluggable flag before releasing free pages to the buddy allocator.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c  |    4 ++++
 mm/nobootmem.c |    2 ++
 2 files changed, 6 insertions(+)

diff -puN mm/memblock.c~mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range mm/memblock.c
--- a/mm/memblock.c~mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range
+++ a/mm/memblock.c
@@ -816,6 +816,10 @@ void __init_memblock __next_mem_range(u6
 		if (nid != NUMA_NO_NODE && nid != m_nid)
 			continue;
 
+		/* skip hotpluggable memory regions if needed */
+		if (movable_node_is_enabled() && memblock_is_hotpluggable(m))
+			continue;
+
 		if (!type_b) {
 			if (out_start)
 				*out_start = m_start;
diff -puN mm/nobootmem.c~mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range mm/nobootmem.c
--- a/mm/nobootmem.c~mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range
+++ a/mm/nobootmem.c
@@ -119,6 +119,8 @@ static unsigned long __init free_low_mem
 	phys_addr_t start, end;
 	u64 i;
 
+	memblock_clear_hotplug(0, ULLONG_MAX);
+
 	for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL)
 		count += __free_memory_core(start, end);
 
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

memblock-memhotplug-fix-wrong-type-in-memblock_find_in_range_node.patch

