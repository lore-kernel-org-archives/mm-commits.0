From: akpm@linux-foundation.org
Subject: + generic-debug-pagealloc-v4.patch added to -mm tree
Date: Mon, 09 Mar 2009 12:09:00 -0700
Message-ID: <200903091909.n29J90eX028581__47057.244127109$1236625846$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752421AbZCITJE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Mar 2009 15:09:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, linux-arch@vger.kernel.org


The patch titled
     generic debug pagealloc
has been added to the -mm tree.  Its filename is
     generic-debug-pagealloc-v4.patch

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
Subject: generic debug pagealloc
From: Akinobu Mita <akinobu.mita@gmail.com>

CONFIG_DEBUG_PAGEALLOC is now supported by x86, powerpc, sparc64, and
s390.  This patch implements it for the rest of the architectures by
filling the pages with poison byte patterns after free_pages() and
verifying the poison patterns before alloc_pages().

This generic one cannot detect invalid page accesses immediately but
invalid read access may cause invalid dereference by poisoned memory and
invalid write access can be detected after a long delay.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/mm/fault.c            |   18 ----
 arch/powerpc/Kconfig             |    3 
 arch/powerpc/Kconfig.debug       |    1 
 arch/s390/Kconfig                |    3 
 arch/s390/Kconfig.debug          |    1 
 arch/sparc/Kconfig               |    3 
 arch/sparc/Kconfig.debug         |    3 
 arch/x86/Kconfig                 |    3 
 arch/x86/Kconfig.debug           |    1 
 include/linux/mm_types.h         |    4 
 include/linux/page-debug-flags.h |   30 ++++++
 include/linux/poison.h           |    3 
 lib/Kconfig.debug                |    1 
 mm/Kconfig.debug                 |   12 ++
 mm/Makefile                      |    1 
 mm/debug-pagealloc.c             |  129 +++++++++++++++++++++++++++++
 16 files changed, 197 insertions(+), 19 deletions(-)

diff -puN arch/avr32/mm/fault.c~generic-debug-pagealloc-v4 arch/avr32/mm/fault.c
--- a/arch/avr32/mm/fault.c~generic-debug-pagealloc-v4
+++ a/arch/avr32/mm/fault.c
@@ -250,21 +250,3 @@ asmlinkage void do_bus_error(unsigned lo
 	dump_dtlb();
 	die("Bus Error", regs, SIGKILL);
 }
-
-/*
- * This functionality is currently not possible to implement because
- * we're using segmentation to ensure a fixed mapping of the kernel
- * virtual address space.
- *
- * It would be possible to implement this, but it would require us to
- * disable segmentation at startup and load the kernel mappings into
- * the TLB like any other pages. There will be lots of trickery to
- * avoid recursive invocation of the TLB miss handler, though...
- */
-#ifdef CONFIG_DEBUG_PAGEALLOC
-void kernel_map_pages(struct page *page, int numpages, int enable)
-{
-
-}
-EXPORT_SYMBOL(kernel_map_pages);
-#endif
diff -puN arch/powerpc/Kconfig~generic-debug-pagealloc-v4 arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~generic-debug-pagealloc-v4
+++ a/arch/powerpc/Kconfig
@@ -228,6 +228,9 @@ config PPC_OF_PLATFORM_PCI
 	depends on PPC64 # not supported on 32 bits yet
 	default n
 
+config ARCH_SUPPORTS_DEBUG_PAGEALLOC
+	def_bool y
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff -puN arch/powerpc/Kconfig.debug~generic-debug-pagealloc-v4 arch/powerpc/Kconfig.debug
--- a/arch/powerpc/Kconfig.debug~generic-debug-pagealloc-v4
+++ a/arch/powerpc/Kconfig.debug
@@ -30,6 +30,7 @@ config DEBUG_STACK_USAGE
 config DEBUG_PAGEALLOC
         bool "Debug page memory allocations"
         depends on DEBUG_KERNEL && !HIBERNATION
+	depends on ARCH_SUPPORTS_DEBUG_PAGEALLOC
         help
           Unmap pages from the kernel linear mapping after free_pages().
           This results in a large slowdown, but helps to find certain types
diff -puN arch/s390/Kconfig~generic-debug-pagealloc-v4 arch/s390/Kconfig
--- a/arch/s390/Kconfig~generic-debug-pagealloc-v4
+++ a/arch/s390/Kconfig
@@ -72,6 +72,9 @@ config PGSTE
 config VIRT_CPU_ACCOUNTING
 	def_bool y
 
+config ARCH_SUPPORTS_DEBUG_PAGEALLOC
+	def_bool y
+
 mainmenu "Linux Kernel Configuration"
 
 config S390
diff -puN arch/s390/Kconfig.debug~generic-debug-pagealloc-v4 arch/s390/Kconfig.debug
--- a/arch/s390/Kconfig.debug~generic-debug-pagealloc-v4
+++ a/arch/s390/Kconfig.debug
@@ -9,6 +9,7 @@ source "lib/Kconfig.debug"
 config DEBUG_PAGEALLOC
 	bool "Debug page memory allocations"
 	depends on DEBUG_KERNEL
+	depends on ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	help
 	  Unmap pages from the kernel linear mapping after free_pages().
 	  This results in a slowdown, but helps to find certain types of
diff -puN arch/sparc/Kconfig~generic-debug-pagealloc-v4 arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~generic-debug-pagealloc-v4
+++ a/arch/sparc/Kconfig
@@ -124,6 +124,9 @@ config ARCH_NO_VIRT_TO_BUS
 config OF
 	def_bool y
 
+config ARCH_SUPPORTS_DEBUG_PAGEALLOC
+	def_bool y if SPARC64
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff -puN arch/sparc/Kconfig.debug~generic-debug-pagealloc-v4 arch/sparc/Kconfig.debug
--- a/arch/sparc/Kconfig.debug~generic-debug-pagealloc-v4
+++ a/arch/sparc/Kconfig.debug
@@ -24,7 +24,8 @@ config STACK_DEBUG
 
 config DEBUG_PAGEALLOC
 	bool "Debug page memory allocations"
-	depends on SPARC64 && DEBUG_KERNEL && !HIBERNATION
+	depends on DEBUG_KERNEL && !HIBERNATION
+	depends on ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	help
 	  Unmap pages from the kernel linear mapping after free_pages().
 	  This results in a large slowdown, but helps to find certain types
diff -puN arch/x86/Kconfig~generic-debug-pagealloc-v4 arch/x86/Kconfig
--- a/arch/x86/Kconfig~generic-debug-pagealloc-v4
+++ a/arch/x86/Kconfig
@@ -166,6 +166,9 @@ config AUDIT_ARCH
 config ARCH_SUPPORTS_OPTIMIZED_INLINING
 	def_bool y
 
+config ARCH_SUPPORTS_DEBUG_PAGEALLOC
+	def_bool y
+
 # Use the generic interrupt handling code in kernel/irq/:
 config GENERIC_HARDIRQS
 	bool
diff -puN arch/x86/Kconfig.debug~generic-debug-pagealloc-v4 arch/x86/Kconfig.debug
--- a/arch/x86/Kconfig.debug~generic-debug-pagealloc-v4
+++ a/arch/x86/Kconfig.debug
@@ -76,6 +76,7 @@ config DEBUG_PAGEALLOC
 	bool "Debug page memory allocations"
 	depends on DEBUG_KERNEL
 	depends on !KMEMCHECK
+	depends on ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	---help---
 	  Unmap pages from the kernel linear mapping after free_pages().
 	  This results in a large slowdown, but helps to find certain types
diff -puN include/linux/mm_types.h~generic-debug-pagealloc-v4 include/linux/mm_types.h
--- a/include/linux/mm_types.h~generic-debug-pagealloc-v4
+++ a/include/linux/mm_types.h
@@ -11,6 +11,7 @@
 #include <linux/rwsem.h>
 #include <linux/completion.h>
 #include <linux/cpumask.h>
+#include <linux/page-debug-flags.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
 
@@ -102,6 +103,9 @@ struct page {
 	 */
 	void *shadow;
 #endif
+#ifdef CONFIG_WANT_PAGE_DEBUG_FLAGS
+ 	unsigned long debug_flags;	/* Use atomic bitops on this */
+#endif
 };
 
 /*
diff -puN /dev/null include/linux/page-debug-flags.h
--- /dev/null
+++ a/include/linux/page-debug-flags.h
@@ -0,0 +1,30 @@
+#ifndef LINUX_PAGE_DEBUG_FLAGS_H
+#define  LINUX_PAGE_DEBUG_FLAGS_H
+
+/*
+ * page->debug_flags bits:
+ *
+ * PAGE_DEBUG_FLAG_POISON is set for poisoned pages. This is used to
+ * implement generic debug pagealloc feature. The pages are filled with
+ * poison patterns and set this flag after free_pages(). The poisoned
+ * pages are verified whether the patterns are not corrupted and clear
+ * the flag before alloc_pages().
+ */
+
+enum page_debug_flags {
+	PAGE_DEBUG_FLAG_POISON,		/* Page is poisoned */
+};
+
+/*
+ * Ensure that CONFIG_WANT_PAGE_DEBUG_FLAGS reliably
+ * gets turned off when no debug features are enabling it!
+ */
+
+#ifdef CONFIG_WANT_PAGE_DEBUG_FLAGS
+#if !defined(CONFIG_PAGE_POISONING) \
+/* && !defined(CONFIG_PAGE_DEBUG_SOMETHING_ELSE) && ... */
+#error WANT_PAGE_DEBUG_FLAGS is turned on with no debug features!
+#endif
+#endif /* CONFIG_WANT_PAGE_DEBUG_FLAGS */
+
+#endif /* LINUX_PAGE_DEBUG_FLAGS_H */
diff -puN include/linux/poison.h~generic-debug-pagealloc-v4 include/linux/poison.h
--- a/include/linux/poison.h~generic-debug-pagealloc-v4
+++ a/include/linux/poison.h
@@ -29,6 +29,9 @@
  */
 #define TIMER_ENTRY_STATIC	((void *) 0x74737461)
 
+/********** mm/debug-pagealloc.c **********/
+#define PAGE_POISON 0xaa
+
 /********** mm/slab.c **********/
 /*
  * Magic nums for obj red zoning.
diff -puN lib/Kconfig.debug~generic-debug-pagealloc-v4 lib/Kconfig.debug
--- a/lib/Kconfig.debug~generic-debug-pagealloc-v4
+++ a/lib/Kconfig.debug
@@ -887,6 +887,7 @@ config SYSCTL_SYSCALL_CHECK
 	  to properly maintain and use. This enables checks that help
 	  you to keep things correct.
 
+source mm/Kconfig.debug
 source kernel/trace/Kconfig
 
 config PROVIDE_OHCI1394_DMA_INIT
diff -puN /dev/null mm/Kconfig.debug
--- /dev/null
+++ a/mm/Kconfig.debug
@@ -0,0 +1,12 @@
+config WANT_PAGE_DEBUG_FLAGS
+	bool
+
+config PAGE_POISONING
+	bool "Debug page memory allocations"
+	depends on !ARCH_SUPPORTS_DEBUG_PAGEALLOC
+	select DEBUG_PAGEALLOC
+	select WANT_PAGE_DEBUG_FLAGS
+	help
+	   Fill the pages with poison patterns after free_pages() and verify
+	   the patterns before alloc_pages(). This results in a large slowdown,
+	   but helps to find certain types of memory corruptions.
diff -puN mm/Makefile~generic-debug-pagealloc-v4 mm/Makefile
--- a/mm/Makefile~generic-debug-pagealloc-v4
+++ a/mm/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_SPARSEMEM_VMEMMAP) += spars
 obj-$(CONFIG_TMPFS_POSIX_ACL) += shmem_acl.o
 obj-$(CONFIG_SLOB) += slob.o
 obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o
+obj-$(CONFIG_PAGE_POISONING) += debug-pagealloc.o
 obj-$(CONFIG_SLAB) += slab.o
 obj-$(CONFIG_SLUB) += slub.o
 obj-$(CONFIG_SLQB) += slqb.o
diff -puN /dev/null mm/debug-pagealloc.c
--- /dev/null
+++ a/mm/debug-pagealloc.c
@@ -0,0 +1,129 @@
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/page-debug-flags.h>
+#include <linux/poison.h>
+
+static inline void set_page_poison(struct page *page)
+{
+	__set_bit(PAGE_DEBUG_FLAG_POISON, &page->debug_flags);
+}
+
+static inline void clear_page_poison(struct page *page)
+{
+	__clear_bit(PAGE_DEBUG_FLAG_POISON, &page->debug_flags);
+}
+
+static inline bool page_poison(struct page *page)
+{
+	return test_bit(PAGE_DEBUG_FLAG_POISON, &page->debug_flags);
+}
+
+static void poison_highpage(struct page *page)
+{
+	/*
+	 * Page poisoning for highmem pages is not implemented.
+	 *
+	 * This can be called from interrupt contexts.
+	 * So we need to create a new kmap_atomic slot for this
+	 * application and it will need interrupt protection.
+	 */
+}
+
+static void poison_page(struct page *page)
+{
+	void *addr;
+
+	if (PageHighMem(page)) {
+		poison_highpage(page);
+		return;
+	}
+	set_page_poison(page);
+	addr = page_address(page);
+	memset(addr, PAGE_POISON, PAGE_SIZE);
+}
+
+static void poison_pages(struct page *page, int n)
+{
+	int i;
+
+	for (i = 0; i < n; i++)
+		poison_page(page + i);
+}
+
+static bool single_bit_flip(unsigned char a, unsigned char b)
+{
+	unsigned char error = a ^ b;
+
+	return error && !(error & (error - 1));
+}
+
+static void check_poison_mem(unsigned char *mem, size_t bytes)
+{
+	unsigned char *start;
+	unsigned char *end;
+
+	for (start = mem; start < mem + bytes; start++) {
+		if (*start != PAGE_POISON)
+			break;
+	}
+	if (start == mem + bytes)
+		return;
+
+	for (end = mem + bytes - 1; end > start; end--) {
+		if (*end != PAGE_POISON)
+			break;
+	}
+
+	if (!printk_ratelimit())
+		return;
+	else if (start == end && single_bit_flip(*start, PAGE_POISON))
+		printk(KERN_ERR "pagealloc: single bit error\n");
+	else
+		printk(KERN_ERR "pagealloc: memory corruption\n");
+
+	print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 16, 1, start,
+			end - start + 1, 1);
+	dump_stack();
+}
+
+static void unpoison_highpage(struct page *page)
+{
+	/*
+	 * See comment in poison_highpage().
+	 * Highmem pages should not be poisoned for now
+	 */
+	BUG_ON(page_poison(page));
+}
+
+static void unpoison_page(struct page *page)
+{
+	if (PageHighMem(page)) {
+		unpoison_highpage(page);
+		return;
+	}
+	if (page_poison(page)) {
+		void *addr = page_address(page);
+
+		check_poison_mem(addr, PAGE_SIZE);
+		clear_page_poison(page);
+	}
+}
+
+static void unpoison_pages(struct page *page, int n)
+{
+	int i;
+
+	for (i = 0; i < n; i++)
+		unpoison_page(page + i);
+}
+
+void kernel_map_pages(struct page *page, int numpages, int enable)
+{
+	if (!debug_pagealloc_enabled)
+		return;
+
+	if (enable)
+		unpoison_pages(page, numpages);
+	else
+		poison_pages(page, numpages);
+}
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

generic-debug-pagealloc-v4.patch
loop-add-ioctl-to-resize-a-loop-device.patch

