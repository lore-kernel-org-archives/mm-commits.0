From: akpm@linux-foundation.org
Subject: - i386-text-edit-lock.patch removed from -mm tree
Date: Fri, 06 Jul 2007 17:26:09 -0700
Message-ID: <200707070030.l670UKGh029688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55184 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751100AbXGGAah (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 20:30:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386: Text Edit Lock
has been removed from the -mm tree.  Its filename was
     i386-text-edit-lock.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: i386: Text Edit Lock
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Interface to use for code patching : uses a mutex to insure mutual edit
exclusion and makes sure the page is writable.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mm/init.c           |   69 ++++++++++++++++++++++++++------
 include/asm-i386/cacheflush.h |    4 +
 2 files changed, 61 insertions(+), 12 deletions(-)

diff -puN arch/i386/mm/init.c~i386-text-edit-lock arch/i386/mm/init.c
--- a/arch/i386/mm/init.c~i386-text-edit-lock
+++ a/arch/i386/mm/init.c
@@ -31,6 +31,7 @@
 #include <linux/memory_hotplug.h>
 #include <linux/initrd.h>
 #include <linux/cpumask.h>
+#include <linux/mutex.h>
 
 #include <asm/processor.h>
 #include <asm/system.h>
@@ -53,6 +54,13 @@ unsigned long highstart_pfn, highend_pfn
 
 static int noinline do_test_wp_bit(void);
 
+/* spin lock protecting text section modification (dynamic code patching) */
+static DEFINE_SPINLOCK(text_lock);
+
+#ifdef CONFIG_DEBUG_RODATA
+static int rodata_marked;
+#endif
+
 /*
  * Creates a middle page table and puts a pointer to it in the
  * given global directory entry. This only returns the gd entry
@@ -802,18 +810,11 @@ void mark_rodata_ro(void)
 	unsigned long start = PFN_ALIGN(_text);
 	unsigned long size = PFN_ALIGN(_etext) - start;
 
-#ifndef CONFIG_KPROBES
-#ifdef CONFIG_HOTPLUG_CPU
-	/* It must still be possible to apply SMP alternatives. */
-	if (num_possible_cpus() <= 1)
-#endif
-	{
-		change_page_attr(virt_to_page(start),
-		                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
-		printk("Write protecting the kernel text: %luk\n", size >> 10);
-		kernel_text_is_ro = 1;
-	}
-#endif
+	change_page_attr(virt_to_page(start),
+	                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
+	printk("Write protecting the kernel text: %luk\n", size >> 10);
+	kernel_text_is_ro = 1;
+
 	start += size;
 	size = (unsigned long)__end_rodata - start;
 	change_page_attr(virt_to_page(start),
@@ -828,8 +829,52 @@ void mark_rodata_ro(void)
 	 * of who is the culprit.
 	 */
 	global_flush_tlb();
+	rodata_marked = 1;
+}
+#endif
+
+/*
+ * Lock the kernel text for mutual write exclusion.
+ * Make sure the pages are writable.
+ */
+void kernel_text_lock(unsigned long address, size_t len)
+{
+	spin_lock(&text_lock);
+#if defined(CONFIG_DEBUG_RODATA)
+	if (rodata_marked && address >= PFN_ALIGN(_text)
+			&& (address + len) <= PFN_ALIGN(_etext)) {
+		unsigned long nr_pages;
+		nr_pages = ((address + len) >> PAGE_SHIFT)
+				- (address >> PAGE_SHIFT) + 1;
+		change_page_attr(virt_to_page(address), nr_pages,
+				PAGE_KERNEL_EXEC);
+		mb();
+		global_flush_tlb();
+		mb();
+	}
+#endif
 }
+EXPORT_SYMBOL_GPL(kernel_text_lock);
+
+void kernel_text_unlock(unsigned long address, size_t len)
+{
+#if defined(CONFIG_DEBUG_RODATA)
+	if (rodata_marked && address >= PFN_ALIGN(_text)
+			&& (address + len) <= PFN_ALIGN(_etext)) {
+		unsigned long nr_pages;
+		wmb();
+		nr_pages = ((address + len) >> PAGE_SHIFT)
+				- (address >> PAGE_SHIFT) + 1;
+		mb();
+		change_page_attr(virt_to_page(address), nr_pages,
+				PAGE_KERNEL_RX);
+		mb();
+		global_flush_tlb();
+	}
 #endif
+	spin_unlock(&text_lock);
+}
+EXPORT_SYMBOL_GPL(kernel_text_unlock);
 
 void free_init_pages(char *what, unsigned long begin, unsigned long end)
 {
diff -puN include/asm-i386/cacheflush.h~i386-text-edit-lock include/asm-i386/cacheflush.h
--- a/include/asm-i386/cacheflush.h~i386-text-edit-lock
+++ a/include/asm-i386/cacheflush.h
@@ -36,4 +36,8 @@ void kernel_map_pages(struct page *page,
 void mark_rodata_ro(void);
 #endif
 
+/* lock kernel text and mark pages writable */
+extern void kernel_text_lock(unsigned long address, size_t len);
+extern void kernel_text_unlock(unsigned long address, size_t len);
+
 #endif /* _I386_CACHEFLUSH_H */
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

powerpc-promc-remove-undef-printk.patch
i386-text-edit-lock.patch
i386-text-edit-lock-alternative-instructions.patch
i386-text-edit-lock-kprobes.patch
immediate-values-global-modules-list-and-module-mutex.patch
immediate-value-architecture-independent-code.patch
immediate-values-non-optimized-architectures.patch
immediate-value-add-kconfig-menus.patch
immediate-values-kprobe-header-fix.patch
immediate-value-i386-optimization.patch
immediate-value-powerpc-optimization.patch
immediate-value-documentation.patch
f00f-bug-fixup-for-i386-use-immediate-values.patch
scheduler-profiling-use-immediate-values.patch
scheduler-profiling-use-immediate-values-fix.patch
cxgb3-vs-immediate-stuff.patch
use-data_data-in-cris.patch
add-missing-data_data-in-powerpc.patch
use-data_data-in-xtensa.patch
linux-kernel-markers-architecture-independent-code.patch
linux-kernel-markers-add-kconfig-menus-for-the-marker-code.patch
linux-kernel-markers-documentation.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
port-of-blktrace-to-the-linux-kernel-markers-fix.patch
