From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-fix-a-bug-on-dev-mem-for-64-bit-kernels.patch removed from -mm tree
Date: Wed, 03 Feb 2010 09:55:17 -0800
Message-ID: <201002031755.o13HtHPn008972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932806Ab0BCR4M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 12:56:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohui.zheng@intel.com, ak@linux.intel.com, fengguang.wu@intel.com, haicheng.li@intel.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu, tglx@linutronix.de, mm-commit


The patch titled
     memory hotplug: fix a bug on /dev/mem for 64-bit kernels
has been removed from the -mm tree.  Its filename was
     memory-hotplug-fix-a-bug-on-dev-mem-for-64-bit-kernels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug: fix a bug on /dev/mem for 64-bit kernels
From: Shaohui Zheng <shaohui.zheng@intel.com>

Newly added memory can not be accessed via /dev/mem, because we do not
update the variables high_memory, max_pfn and max_low_pfn.

Add a function update_end_of_memory_vars() to update these variables for
64-bit kernels.

[akpm@linux-foundation.org: simplify comment]
Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Li Haicheng <haicheng.li@intel.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff -puN arch/x86/mm/init_64.c~memory-hotplug-fix-a-bug-on-dev-mem-for-64-bit-kernels arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~memory-hotplug-fix-a-bug-on-dev-mem-for-64-bit-kernels
+++ a/arch/x86/mm/init_64.c
@@ -49,6 +49,7 @@
 #include <asm/numa.h>
 #include <asm/cacheflush.h>
 #include <asm/init.h>
+#include <linux/bootmem.h>
 
 static unsigned long dma_reserve __initdata;
 
@@ -616,6 +617,21 @@ void __init paging_init(void)
  */
 #ifdef CONFIG_MEMORY_HOTPLUG
 /*
+ * After memory hotplug the variables max_pfn, max_low_pfn and high_memory need
+ * updating.
+ */
+static void  update_end_of_memory_vars(u64 start, u64 size)
+{
+	unsigned long end_pfn = PFN_UP(start + size);
+
+	if (end_pfn > max_pfn) {
+		max_pfn = end_pfn;
+		max_low_pfn = end_pfn;
+		high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
+	}
+}
+
+/*
  * Memory is added always to NORMAL zone. This means you will never get
  * additional DMA/DMA32 memory.
  */
@@ -634,6 +650,9 @@ int arch_add_memory(int nid, u64 start, 
 	ret = __add_pages(nid, zone, start_pfn, nr_pages);
 	WARN_ON_ONCE(ret);
 
+	/* update max_pfn, max_low_pfn and high_memory */
+	update_end_of_memory_vars(start, size);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(arch_add_memory);
_

Patches currently in -mm which might be from shaohui.zheng@intel.com are

origin.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch

