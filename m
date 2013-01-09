From: akpm@linux-foundation.org
Subject: + memory-hotplug-remove-redundant-codes.patch added to -mm tree
Date: Wed, 09 Jan 2013 15:33:22 -0800
Message-ID: <20130109233322.DFF5E200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:43701 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758181Ab3AIXd1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jan 2013 18:33:27 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so146145bkc.3
        for <mm-commits@vger.kernel.org>; Wed, 09 Jan 2013 15:33:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, tangchen@cn.fujitsu.com, tglx@linutronix.de, wujianguo@huawei.com


The patch titled
     Subject: memory-hotplug: remove redundant codes
has been added to the -mm tree.  Its filename is
     memory-hotplug-remove-redundant-codes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
-			kobject_put(&mem->dev.kobj);
-			unlock_memory_hotplug();
-			return ret;
-		}
+	ret = walk_memory_range(start_pfn, end_pfn, NULL,
+				is_memblock_offlined_cb);
+	if (ret) {
+		unlock_memory_hotplug();
+		return ret;
 	}
 
-	if (mem)
-		kobject_put(&mem->dev.kobj);
 	unlock_memory_hotplug();
 
 	return 0;
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

x86-numa-dont-check-if-node-is-numa_no_node.patch
x86-fix-the-argument-passed-to-sync_global_pgds.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
memory-hotplug-try-to-offline-the-memory-twice-to-avoid-dependence.patch
memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory.patch
memory-hotplug-remove-redundant-codes.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch
memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-remove-page-table-of-x86_64-architecture.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap.patch
memory-hotplug-integrated-__remove_section-of-config_sparsemem_vmemmap.patch
memory_hotplug-clear-zone-when-removing-the-memory.patch
memory-hotplug-remove-sysfs-file-of-node.patch
memory-hotplug-free-node_data-when-a-node-is-offlined.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch

