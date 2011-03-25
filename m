From: akpm@linux-foundation.org
Subject: [merged] crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:27:07 -0700
Message-ID: <201103250727.p2P7R1UR026206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933600Ab1CYH13 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:27:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olaf@aepfle.de, benh@kernel.crashing.org, hannes@cmpxchg.org, hpa@zytor.com, lethal@linux-sh.org, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, tony.luck@intel.com, mm-comm


The patch titled
     crash_dump: export is_kdump_kernel to modules, consolidate elfcorehdr_addr, setup_elfcorehdr and saved_max_pfn
has been removed from the -mm tree.  Its filename was
     crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: crash_dump: export is_kdump_kernel to modules, consolidate elfcorehdr_addr, setup_elfcorehdr and saved_max_pfn
From: Olaf Hering <olaf@aepfle.de>

The Xen PV drivers in a crashed HVM guest can not connect to the dom0
backend drivers because both frontend and backend drivers are still in
connected state.  To run the connection reset function only in case of a
crashdump, the is_kdump_kernel() function needs to be available for the PV
driver modules.

Consolidate elfcorehdr_addr, setup_elfcorehdr and saved_max_pfn into
kernel/crash_dump.c Also export elfcorehdr_addr to make is_kdump_kernel()
usable for modules.

Leave 'elfcorehdr' as early_param().  This changes powerpc from __setup()
to early_param().  It adds an address range check from x86 also on ia64
and powerpc.

[akpm@linux-foundation.org: additional #includes]
[akpm@linux-foundation.org: remove elfcorehdr_addr export]
[akpm@linux-foundation.org: fix for Tejun's mm/nobootmem.c changes]
Signed-off-by: Olaf Hering <olaf@aepfle.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/crash_dump.c     |    3 --
 arch/arm/kernel/setup.c          |   24 --------------------
 arch/ia64/kernel/crash_dump.c    |    3 --
 arch/ia64/kernel/efi.c           |    1 
 arch/ia64/kernel/setup.c         |   18 ---------------
 arch/powerpc/kernel/crash_dump.c |   17 --------------
 arch/sh/kernel/crash_dump.c      |   22 ------------------
 arch/x86/kernel/crash_dump_32.c  |    3 --
 arch/x86/kernel/crash_dump_64.c  |    3 --
 arch/x86/kernel/e820.c           |    1 
 arch/x86/kernel/setup.c          |   22 ------------------
 include/linux/bootmem.h          |    4 ---
 kernel/Makefile                  |    1 
 kernel/crash_dump.c              |   34 +++++++++++++++++++++++++++++
 mm/bootmem.c                     |    8 ------
 mm/nobootmem.c                   |    8 ------
 16 files changed, 37 insertions(+), 135 deletions(-)

diff -puN arch/arm/kernel/crash_dump.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn arch/arm/kernel/crash_dump.c
--- a/arch/arm/kernel/crash_dump.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn
+++ a/arch/arm/kernel/crash_dump.c
@@ -18,9 +18,6 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 
-/* stores the physical address of elf header of crash image */
-unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
-
 /**
  * copy_oldmem_page() - copy one page from old kernel memory
  * @pfn: page frame number to be copied
diff -puN arch/arm/kernel/setup.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn arch/arm/kernel/setup.c
--- a/arch/arm/kernel/setup.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn
+++ a/arch/arm/kernel/setup.c
@@ -788,30 +788,6 @@ static void __init reserve_crashkernel(v
 static inline void reserve_crashkernel(void) {}
 #endif /* CONFIG_KEXEC */
 
-/*
- * Note: elfcorehdr_addr is not just limited to vmcore. It is also used by
- * is_kdump_kernel() to determine if we are booting after a panic. Hence
- * ifdef it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
- */
-
-#ifdef CONFIG_CRASH_DUMP
-/*
- * elfcorehdr= specifies the location of elf core header stored by the crashed
- * kernel. This option will be passed by kexec loader to the capture kernel.
- */
-static int __init setup_elfcorehdr(char *arg)
-{
-	char *end;
-
-	if (!arg)
-		return -EINVAL;
-
-	elfcorehdr_addr = memparse(arg, &end);
-	return end > arg ? 0 : -EINVAL;
-}
-early_param("elfcorehdr", setup_elfcorehdr);
-#endif /* CONFIG_CRASH_DUMP */
-
 static void __init squash_mem_tags(struct tag *tag)
 {
 	for (; tag->hdr.size; tag = tag_next(tag))
diff -puN arch/ia64/kernel/crash_dump.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn arch/ia64/kernel/crash_dump.c
--- a/arch/ia64/kernel/crash_dump.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn
+++ a/arch/ia64/kernel/crash_dump.c
@@ -13,9 +13,6 @@
 #include <asm/page.h>
 #include <asm/uaccess.h>
 
-/* Stores the physical address of elf header of crash image. */
-unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
-
 /**
  * copy_oldmem_page - copy one page from "oldmem"
  * @pfn: page frame number to be copied
diff -puN arch/ia64/kernel/efi.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn arch/ia64/kernel/efi.c
--- a/arch/ia64/kernel/efi.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn
+++ a/arch/ia64/kernel/efi.c
@@ -23,6 +23,7 @@
  */
 #include <linux/module.h>
 #include <linux/bootmem.h>
+#include <linux/crash_dump.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/types.h>
diff -puN arch/ia64/kernel/setup.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn arch/ia64/kernel/setup.c
--- a/arch/ia64/kernel/setup.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn
+++ a/arch/ia64/kernel/setup.c
@@ -479,25 +479,7 @@ static __init int setup_nomca(char *s)
 }
 early_param("nomca", setup_nomca);
 
-/*
- * Note: elfcorehdr_addr is not just limited to vmcore. It is also used by
- * is_kdump_kernel() to determine if we are booting after a panic. Hence
- * ifdef it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
- */
 #ifdef CONFIG_CRASH_DUMP
-/* elfcorehdr= specifies the location of elf core header
- * stored by the crashed kernel.
- */
-static int __init parse_elfcorehdr(char *arg)
-{
-	if (!arg)
-		return -EINVAL;
-
-        elfcorehdr_addr = memparse(arg, &arg);
-	return 0;
-}
-early_param("elfcorehdr", parse_elfcorehdr);
-
 int __init reserve_elfcorehdr(u64 *start, u64 *end)
 {
 	u64 length;
diff -puN arch/powerpc/kernel/crash_dump.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn arch/powerpc/kernel/crash_dump.c
--- a/arch/powerpc/kernel/crash_dump.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn
+++ a/arch/powerpc/kernel/crash_dump.c
@@ -28,9 +28,6 @@
 #define DBG(fmt...)
 #endif
 
-/* Stores the physical address of elf header of crash image. */
-unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
-
 #ifndef CONFIG_RELOCATABLE
 void __init reserve_kdump_trampoline(void)
 {
@@ -72,20 +69,6 @@ void __init setup_kdump_trampoline(void)
 }
 #endif /* CONFIG_RELOCATABLE */
 
-/*
- * Note: elfcorehdr_addr is not just limited to vmcore. It is also used by
- * is_kdump_kernel() to determine if we are booting after a panic. Hence
- * ifdef it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
- */
-static int __init parse_elfcorehdr(char *p)
-{
-	if (p)
-		elfcorehdr_addr = memparse(p, &p);
-
-	return 1;
-}
-__setup("elfcorehdr=", parse_elfcorehdr);
-
 static int __init parse_savemaxmem(char *p)
 {
 	if (p)
diff -puN arch/sh/kernel/crash_dump.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn arch/sh/kernel/crash_dump.c
--- a/arch/sh/kernel/crash_dump.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn
+++ a/arch/sh/kernel/crash_dump.c
@@ -9,28 +9,6 @@
 #include <linux/io.h>
 #include <asm/uaccess.h>
 
-/* Stores the physical address of elf header of crash image. */
-unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
-
-/*
- * Note: elfcorehdr_addr is not just limited to vmcore. It is also used by
- * is_kdump_kernel() to determine if we are booting after a panic. Hence
- * ifdef it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
- *
- * elfcorehdr= specifies the location of elf core header
- * stored by the crashed kernel.
- */
-static int __init parse_elfcorehdr(char *arg)
-{
-	if (!arg)
-		return -EINVAL;
-
-	elfcorehdr_addr = memparse(arg, &arg);
-
-	return 0;
-}
-early_param("elfcorehdr", parse_elfcorehdr);
-
 /**
  * copy_oldmem_page - copy one page from "oldmem"
  * @pfn: page frame number to be copied
diff -puN arch/x86/kernel/crash_dump_32.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn arch/x86/kernel/crash_dump_32.c
--- a/arch/x86/kernel/crash_dump_32.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn
+++ a/arch/x86/kernel/crash_dump_32.c
@@ -14,9 +14,6 @@
 
 static void *kdump_buf_page;
 
-/* Stores the physical address of elf header of crash image. */
-unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
-
 static inline bool is_crashed_pfn_valid(unsigned long pfn)
 {
 #ifndef CONFIG_X86_PAE
diff -puN arch/x86/kernel/crash_dump_64.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn arch/x86/kernel/crash_dump_64.c
--- a/arch/x86/kernel/crash_dump_64.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn
+++ a/arch/x86/kernel/crash_dump_64.c
@@ -10,9 +10,6 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 
-/* Stores the physical address of elf header of crash image. */
-unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
-
 /**
  * copy_oldmem_page - copy one page from "oldmem"
  * @pfn: page frame number to be copied
diff -puN arch/x86/kernel/e820.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn arch/x86/kernel/e820.c
--- a/arch/x86/kernel/e820.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn
+++ a/arch/x86/kernel/e820.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/init.h>
+#include <linux/crash_dump.h>
 #include <linux/bootmem.h>
 #include <linux/pfn.h>
 #include <linux/suspend.h>
diff -puN arch/x86/kernel/setup.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn
+++ a/arch/x86/kernel/setup.c
@@ -619,28 +619,6 @@ void __init reserve_standard_io_resource
 
 }
 
-/*
- * Note: elfcorehdr_addr is not just limited to vmcore. It is also used by
- * is_kdump_kernel() to determine if we are booting after a panic. Hence
- * ifdef it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
- */
-
-#ifdef CONFIG_CRASH_DUMP
-/* elfcorehdr= specifies the location of elf core header
- * stored by the crashed kernel. This option will be passed
- * by kexec loader to the capture kernel.
- */
-static int __init setup_elfcorehdr(char *arg)
-{
-	char *end;
-	if (!arg)
-		return -EINVAL;
-	elfcorehdr_addr = memparse(arg, &end);
-	return end > arg ? 0 : -EINVAL;
-}
-early_param("elfcorehdr", setup_elfcorehdr);
-#endif
-
 static __init void reserve_ibft_region(void)
 {
 	unsigned long addr, size = 0;
diff -puN include/linux/bootmem.h~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn include/linux/bootmem.h
--- a/include/linux/bootmem.h~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn
+++ a/include/linux/bootmem.h
@@ -19,10 +19,6 @@ extern unsigned long min_low_pfn;
  */
 extern unsigned long max_pfn;
 
-#ifdef CONFIG_CRASH_DUMP
-extern unsigned long saved_max_pfn;
-#endif
-
 #ifndef CONFIG_NO_BOOTMEM
 /*
  * node_bootmem_map is a map pointer - the bits represent all physical 
diff -puN kernel/Makefile~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn kernel/Makefile
--- a/kernel/Makefile~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn
+++ a/kernel/Makefile
@@ -107,6 +107,7 @@ obj-$(CONFIG_PERF_EVENTS) += perf_event.
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
+obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff -puN /dev/null kernel/crash_dump.c
--- /dev/null
+++ a/kernel/crash_dump.c
@@ -0,0 +1,34 @@
+#include <linux/kernel.h>
+#include <linux/crash_dump.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+
+/*
+ * If we have booted due to a crash, max_pfn will be a very low value. We need
+ * to know the amount of memory that the previous kernel used.
+ */
+unsigned long saved_max_pfn;
+
+/*
+ * stores the physical address of elf header of crash image
+ *
+ * Note: elfcorehdr_addr is not just limited to vmcore. It is also used by
+ * is_kdump_kernel() to determine if we are booting after a panic. Hence put
+ * it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
+ */
+unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
+
+/*
+ * elfcorehdr= specifies the location of elf core header stored by the crashed
+ * kernel. This option will be passed by kexec loader to the capture kernel.
+ */
+static int __init setup_elfcorehdr(char *arg)
+{
+	char *end;
+	if (!arg)
+		return -EINVAL;
+	elfcorehdr_addr = memparse(arg, &end);
+	return end > arg ? 0 : -EINVAL;
+}
+early_param("elfcorehdr", setup_elfcorehdr);
diff -puN mm/bootmem.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn mm/bootmem.c
--- a/mm/bootmem.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn
+++ a/mm/bootmem.c
@@ -34,14 +34,6 @@ unsigned long max_low_pfn;
 unsigned long min_low_pfn;
 unsigned long max_pfn;
 
-#ifdef CONFIG_CRASH_DUMP
-/*
- * If we have booted due to a crash, max_pfn will be a very low value. We need
- * to know the amount of memory that the previous kernel used.
- */
-unsigned long saved_max_pfn;
-#endif
-
 bootmem_data_t bootmem_node_data[MAX_NUMNODES] __initdata;
 
 static struct list_head bdata_list __initdata = LIST_HEAD_INIT(bdata_list);
diff -puN mm/nobootmem.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn mm/nobootmem.c
--- a/mm/nobootmem.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn
+++ a/mm/nobootmem.c
@@ -32,14 +32,6 @@ unsigned long max_low_pfn;
 unsigned long min_low_pfn;
 unsigned long max_pfn;
 
-#ifdef CONFIG_CRASH_DUMP
-/*
- * If we have booted due to a crash, max_pfn will be a very low value. We need
- * to know the amount of memory that the previous kernel used.
- */
-unsigned long saved_max_pfn;
-#endif
