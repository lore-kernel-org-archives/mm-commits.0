From: akpm@linux-foundation.org
Subject: [merged] page_alloc-bootmem-limit-with-movablecore_map.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:51:17 -0800
Message-ID: <20130225205117.C9CCF5A41F0@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:51560 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759615Ab3BYUvT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:51:19 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so158910yen.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:51:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, hpa@zytor.com, laijs@cn.fujitsu.com, linfeng@cn.fujitsu.com, mel@csn.ul.ie, mingo@elte.hu, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: page_alloc: bootmem limit with movablecore_map
has been removed from the -mm tree.  Its filename was
     page_alloc-bootmem-limit-with-movablecore_map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: page_alloc: bootmem limit with movablecore_map

Ensure the bootmem will not allocate memory from areas that may be
ZONE_MOVABLE.  The map info is from movablecore_map boot option.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Tested-by: Lin Feng <linfeng@cn.fujitsu.com>
Cc: Wu Jianguo <wujianguo@huawei.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    1 +
 mm/memblock.c            |   18 +++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff -puN include/linux/memblock.h~page_alloc-bootmem-limit-with-movablecore_map include/linux/memblock.h
--- a/include/linux/memblock.h~page_alloc-bootmem-limit-with-movablecore_map
+++ a/include/linux/memblock.h
@@ -42,6 +42,7 @@ struct memblock {
 
 extern struct memblock memblock;
 extern int memblock_debug;
+extern struct movablemem_map movablemem_map;
 
 #define memblock_dbg(fmt, ...) \
 	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
diff -puN mm/memblock.c~page_alloc-bootmem-limit-with-movablecore_map mm/memblock.c
--- a/mm/memblock.c~page_alloc-bootmem-limit-with-movablecore_map
+++ a/mm/memblock.c
@@ -101,6 +101,7 @@ phys_addr_t __init_memblock memblock_fin
 {
 	phys_addr_t this_start, this_end, cand;
 	u64 i;
+	int curr = movablemem_map.nr_map - 1;
 
 	/* pump up @end */
 	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
@@ -114,13 +115,28 @@ phys_addr_t __init_memblock memblock_fin
 		this_start = clamp(this_start, start, end);
 		this_end = clamp(this_end, start, end);
 
-		if (this_end < size)
+restart:
+		if (this_end <= this_start || this_end < size)
 			continue;
 
+		for (; curr >= 0; curr--) {
+			if ((movablemem_map.map[curr].start_pfn << PAGE_SHIFT)
+			    < this_end)
+				break;
+		}
+
 		cand = round_down(this_end - size, align);
+		if (curr >= 0 &&
+		    cand < movablemem_map.map[curr].end_pfn << PAGE_SHIFT) {
+			this_end = movablemem_map.map[curr].start_pfn
+				   << PAGE_SHIFT;
+			goto restart;
+		}
+
 		if (cand >= this_start)
 			return cand;
 	}
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
linux-next.patch

