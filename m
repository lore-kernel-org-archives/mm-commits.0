From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:49:39 -0800
Message-ID: <20130225204939.F1EB65A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:63510 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759566Ab3BYUtl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:49:41 -0500
Received: by mail-qe0-f74.google.com with SMTP id 1so120677qee.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:49:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, tangchen@cn.fujitsu.com, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: check whether all memory blocks are offlined or not when removing memory
has been removed from the -mm tree.  Its filename was
     memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: memory-hotplug: check whether all memory blocks are offlined or not when removing memory

We remove the memory like this:
1. lock memory hotplug
2. offline a memory block
3. unlock memory hotplug
4. repeat 1-3 to offline all memory blocks
5. lock memory hotplug
6. remove memory(TODO)
7. unlock memory hotplug

All memory blocks must be offlined before removing memory.  But we don't
hold the lock in the whole operation.  So we should check whether all
memory blocks are offlined before step6.  Otherwise, kernel maybe
panicked.

Offlining a memory block and removing a memory device can be two different
operations.  Users can just offline some memory blocks without removing
the memory device.  For this purpose, the kernel has held
lock_memory_hotplug() in __offline_pages().  To reuse the code for memory
hot-remove, we repeat step 1-3 to offline all the memory blocks,
repeatedly lock and unlock memory hotplug, but not hold the memory hotplug
lock in the whole operation.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Wu Jianguo <wujianguo@huawei.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |    6 +++
 include/linux/memory_hotplug.h |    1 
 mm/memory_hotplug.c            |   48 +++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+)

diff -puN drivers/base/memory.c~memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory
+++ a/drivers/base/memory.c
@@ -693,6 +693,12 @@ int offline_memory_block(struct memory_b
 	return ret;
 }
 
+/* return true if the memory block is offlined, otherwise, return false */
+bool is_memblock_offlined(struct memory_block *mem)
+{
+	return mem->state == MEM_OFFLINE;
+}
+
 /*
  * Initialize the sysfs support for memory devices...
  */
diff -puN include/linux/memory_hotplug.h~memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory
+++ a/include/linux/memory_hotplug.h
@@ -247,6 +247,7 @@ extern int add_memory(int nid, u64 start
 extern int arch_add_memory(int nid, u64 start, u64 size);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
 extern int offline_memory_block(struct memory_block *mem);
+extern bool is_memblock_offlined(struct memory_block *mem);
 extern int remove_memory(u64 start, u64 size);
 extern int sparse_add_one_section(struct zone *zone, unsigned long start_pfn,
 								int nr_pages);
diff -puN mm/memory_hotplug.c~memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory
+++ a/mm/memory_hotplug.c
@@ -1429,6 +1429,54 @@ repeat:
 		goto repeat;
 	}
 
+	lock_memory_hotplug();
+
+	/*
+	 * we have offlined all memory blocks like this:
+	 *   1. lock memory hotplug
+	 *   2. offline a memory block
+	 *   3. unlock memory hotplug
+	 *
+	 * repeat step1-3 to offline the memory block. All memory blocks
+	 * must be offlined before removing memory. But we don't hold the
+	 * lock in the whole operation. So we should check whether all
+	 * memory blocks are offlined.
+	 */
+
+	mem = NULL;
+	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
+		section_nr = pfn_to_section_nr(pfn);
+		if (!present_section_nr(section_nr))
+			continue;
+
+		section = __nr_to_section(section_nr);
+		/* same memblock? */
+		if (mem)
+			if ((section_nr >= mem->start_section_nr) &&
+			    (section_nr <= mem->end_section_nr))
+				continue;
+
+		mem = find_memory_block_hinted(section, mem);
+		if (!mem)
+			continue;
+
+		ret = is_memblock_offlined(mem);
+		if (!ret) {
+			pr_warn("removing memory fails, because memory "
+				"[%#010llx-%#010llx] is onlined\n",
+				PFN_PHYS(section_nr_to_pfn(mem->start_section_nr)),
+				PFN_PHYS(section_nr_to_pfn(mem->end_section_nr + 1)) - 1);
+
+			kobject_put(&mem->dev.kobj);
+			unlock_memory_hotplug();
+			return ret;
+		}
+	}
+
+	if (mem)
+		kobject_put(&mem->dev.kobj);
+	unlock_memory_hotplug();
+
 	return 0;
 }
 #else
_

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

origin.patch
linux-next.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
block-partitions-mac-obey-the-state-limit-constraint.patch
block-partitions-optimize-memory-allocation-in-check_partition.patch

