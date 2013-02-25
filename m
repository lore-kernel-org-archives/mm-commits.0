From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-remove-redundant-codes.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:49:43 -0800
Message-ID: <20130225204943.E8B405A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:61827 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759560Ab3BYUtp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:49:45 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so346464ggi.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:49:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, tangchen@cn.fujitsu.com, tglx@linutronix.de, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: remove redundant codes
has been removed from the -mm tree.  Its filename was
     memory-hotplug-remove-redundant-codes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: memory-hotplug: remove redundant codes

offlining memory blocks and checking whether memory blocks are offlined
are very similar.  This patch introduces a new function to remove
redundant codes.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Wu Jianguo <wujianguo@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |  129 ++++++++++++++++++++++++++----------------
 1 file changed, 82 insertions(+), 47 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-remove-redundant-codes mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-remove-redundant-codes
+++ a/mm/memory_hotplug.c
@@ -1380,20 +1380,26 @@ int offline_pages(unsigned long start_pf
 	return __offline_pages(start_pfn, start_pfn + nr_pages, 120 * HZ);
 }
 
-int remove_memory(u64 start, u64 size)
+/**
+ * walk_memory_range - walks through all mem sections in [start_pfn, end_pfn)
+ * @start_pfn: start pfn of the memory range
+ * @end_pfn: end pft of the memory range
+ * @arg: argument passed to func
+ * @func: callback for each memory section walked
+ *
+ * This function walks through all present mem sections in range
+ * [start_pfn, end_pfn) and call func on each mem section.
+ *
+ * Returns the return value of func.
+ */
+static int walk_memory_range(unsigned long start_pfn, unsigned long end_pfn,
+		void *arg, int (*func)(struct memory_block *, void *))
 {
 	struct memory_block *mem = NULL;
 	struct mem_section *section;
-	unsigned long start_pfn, end_pfn;
 	unsigned long pfn, section_nr;
 	int ret;
-	int return_on_error = 0;
-	int retry = 0;
 
-	start_pfn = PFN_DOWN(start);
-	end_pfn = start_pfn + PFN_DOWN(size);
-
-repeat:
 	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
 		section_nr = pfn_to_section_nr(pfn);
 		if (!present_section_nr(section_nr))
@@ -1410,22 +1416,76 @@ repeat:
 		if (!mem)
 			continue;
 
-		ret = offline_memory_block(mem);
+		ret = func(mem, arg);
 		if (ret) {
-			if (return_on_error) {
-				kobject_put(&mem->dev.kobj);
-				return ret;
-			} else {
-				retry = 1;
-			}
+			kobject_put(&mem->dev.kobj);
+			return ret;
 		}
 	}
 
 	if (mem)
 		kobject_put(&mem->dev.kobj);
 
-	if (retry) {
-		return_on_error = 1;
+	return 0;
+}
+
+/**
+ * offline_memory_block_cb - callback function for offlining memory block
+ * @mem: the memory block to be offlined
+ * @arg: buffer to hold error msg
+ *
+ * Always return 0, and put the error msg in arg if any.
+ */
+static int offline_memory_block_cb(struct memory_block *mem, void *arg)
+{
+	int *ret = arg;
+	int error = offline_memory_block(mem);
+
+	if (error != 0 && *ret == 0)
+		*ret = error;
+
+	return 0;
+}
+
+static int is_memblock_offlined_cb(struct memory_block *mem, void *arg)
+{
+	int ret = !is_memblock_offlined(mem);
+
+	if (unlikely(ret))
+		pr_warn("removing memory fails, because memory "
+			"[%#010llx-%#010llx] is onlined\n",
+			PFN_PHYS(section_nr_to_pfn(mem->start_section_nr)),
+			PFN_PHYS(section_nr_to_pfn(mem->end_section_nr + 1))-1);
+
+	return ret;
+}
+
+int remove_memory(u64 start, u64 size)
+{
+	unsigned long start_pfn, end_pfn;
+	int ret = 0;
+	int retry = 1;
+
+	start_pfn = PFN_DOWN(start);
+	end_pfn = start_pfn + PFN_DOWN(size);
+
+	/*
+	 * When CONFIG_MEMCG is on, one memory block may be used by other
+	 * blocks to store page cgroup when onlining pages. But we don't know
+	 * in what order pages are onlined. So we iterate twice to offline
+	 * memory:
+	 * 1st iterate: offline every non primary memory block.
+	 * 2nd iterate: offline primary (i.e. first added) memory block.
+	 */
+repeat:
+	walk_memory_range(start_pfn, end_pfn, &ret,
+			  offline_memory_block_cb);
+	if (ret) {
+		if (!retry)
+			return ret;
+
+		retry = 0;
+		ret = 0;
 		goto repeat;
 	}
 
@@ -1443,38 +1503,13 @@ repeat:
 	 * memory blocks are offlined.
 	 */
 
-	mem = NULL;
-	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
-		section_nr = pfn_to_section_nr(pfn);
-		if (!present_section_nr(section_nr))
-			continue;
-
-		section = __nr_to_section(section_nr);
-		/* same memblock? */
-		if (mem)
-			if ((section_nr >= mem->start_section_nr) &&
-			    (section_nr <= mem->end_section_nr))
-				continue;
-
-		mem = find_memory_block_hinted(section, mem);
-		if (!mem)
-			continue;
-
-		ret = is_memblock_offlined(mem);
-		if (!ret) {
-			pr_warn("removing memory fails, because memory "
-				"[%#010llx-%#010llx] is onlined\n",
-				PFN_PHYS(section_nr_to_pfn(mem->start_section_nr)),
-				PFN_PHYS(section_nr_to_pfn(mem->end_section_nr + 1)) - 1);
