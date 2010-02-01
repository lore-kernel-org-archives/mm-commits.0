From: akpm@linux-foundation.org
Subject: + memory-hotplug-fix-a-bug-on-dev-mem-for-64-bit-kernels.patch added to -mm tree
Date: Mon, 01 Feb 2010 13:55:23 -0800
Message-ID: <201002012155.o11LtOQB014801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753283Ab0BAV6H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 16:58:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohui.zheng@intel.com, ak@linux.intel.com, fengguang.wu@intel.com, haicheng.li@intel.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     memory hotplug: fix a bug on /dev/mem for 64-bit kernels
has been added to the -mm tree.  Its filename is
     memory-hotplug-fix-a-bug-on-dev-mem-for-64-bit-kernels.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug: fix a bug on /dev/mem for 64-bit kernels
From: Shaohui Zheng <shaohui.zheng@intel.com>

Newly added memory can not be accessed via /dev/mem, because we do not
update the variables high_memory, max_pfn and max_low_pfn.

Add a function update_end_of_memory_vars() to update these variables for
64-bit kernels.

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
+ * After memory hotplug, the variables max_pfn, max_low_pfn and high_memory will
+ * be affected, they will be updated in this function.
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

memory-hotplug-fix-a-bug-on-dev-mem-for-64-bit-kernels.patch
memory-hotplug-fix-a-bug-on-dev-mem-for-64-bit-kernels-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch

