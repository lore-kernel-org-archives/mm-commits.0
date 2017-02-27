From: akpm@linux-foundation.org
Subject: [patch 77/78] mm: add arch-independent testcases for RODATA
Date: Mon, 27 Feb 2017 14:30:22 -0800
Message-ID: <58b4a87e.bTuexTMPG3EEY3JV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45912 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751862AbdB0Wzy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:55:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jinb.park7@gmail.com, arjan@linux.intel.com, hpa@zytor.com, keescook@chromium.org, labbott@redhat.com, linux@armlinux.org.uk, mingo@redhat.com, valentinrothberg@gmail.com

From: Jinbum Park <jinb.park7@gmail.com>
Subject: mm: add arch-independent testcases for RODATA

This patch makes arch-independent testcases for RODATA.  Both x86 and
x86_64 already have testcases for RODATA, But they are arch-specific
because using inline assembly directly.

And cacheflush.h is not a suitable location for rodata-test related
things.  Since they were in cacheflush.h, If someone change the state of
CONFIG_DEBUG_RODATA_TEST, It cause overhead of kernel build.

To solve the above issues, write arch-independent testcases and move it to
shared location.

[jinb.park7@gmail.com: fix config dependency]
  Link: http://lkml.kernel.org/r/20170209131625.GA16954@pjb1027-Latitude-E5410
Link: http://lkml.kernel.org/r/20170129105436.GA9303@pjb1027-Latitude-E5410
Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig.debug            |    8 --
 arch/x86/include/asm/cacheflush.h |   10 ---
 arch/x86/kernel/Makefile          |    1 
 arch/x86/kernel/test_rodata.c     |   75 ----------------------------
 arch/x86/mm/init_32.c             |    4 -
 arch/x86/mm/init_64.c             |    5 -
 include/linux/rodata_test.h       |   24 ++++++++
 init/main.c                       |    6 +-
 mm/Kconfig.debug                  |    7 ++
 mm/Makefile                       |    1 
 mm/rodata_test.c                  |   56 ++++++++++++++++++++
 11 files changed, 92 insertions(+), 105 deletions(-)

diff -puN arch/x86/Kconfig.debug~mm-add-arch-independent-testcases-for-rodata arch/x86/Kconfig.debug
--- a/arch/x86/Kconfig.debug~mm-add-arch-independent-testcases-for-rodata
+++ a/arch/x86/Kconfig.debug
@@ -74,14 +74,6 @@ config EFI_PGT_DUMP
 	  issues with the mapping of the EFI runtime regions into that
 	  table.
 
-config DEBUG_RODATA_TEST
-	bool "Testcase for the marking rodata read-only"
-	default y
-	---help---
-	  This option enables a testcase for the setting rodata read-only
-	  as well as for the change_page_attr() infrastructure.
-	  If in doubt, say "N"
-
 config DEBUG_WX
 	bool "Warn on W+X mappings at boot"
 	select X86_PTDUMP_CORE
diff -puN arch/x86/include/asm/cacheflush.h~mm-add-arch-independent-testcases-for-rodata arch/x86/include/asm/cacheflush.h
--- a/arch/x86/include/asm/cacheflush.h~mm-add-arch-independent-testcases-for-rodata
+++ a/arch/x86/include/asm/cacheflush.h
@@ -90,18 +90,8 @@ void clflush_cache_range(void *addr, uns
 
 #define mmio_flush_range(addr, size) clflush_cache_range(addr, size)
 
-extern const int rodata_test_data;
 extern int kernel_set_to_readonly;
 void set_kernel_text_rw(void);
 void set_kernel_text_ro(void);
 
-#ifdef CONFIG_DEBUG_RODATA_TEST
-int rodata_test(void);
-#else
-static inline int rodata_test(void)
-{
-	return 0;
-}
-#endif
-
 #endif /* _ASM_X86_CACHEFLUSH_H */
diff -puN arch/x86/kernel/Makefile~mm-add-arch-independent-testcases-for-rodata arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile~mm-add-arch-independent-testcases-for-rodata
+++ a/arch/x86/kernel/Makefile
@@ -100,7 +100,6 @@ obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 obj-$(CONFIG_APB_TIMER)		+= apb_timer.o
 
 obj-$(CONFIG_AMD_NB)		+= amd_nb.o
-obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
 obj-$(CONFIG_DEBUG_NMI_SELFTEST) += nmi_selftest.o
 
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o kvmclock.o
diff -puN arch/x86/kernel/test_rodata.c~mm-add-arch-independent-testcases-for-rodata /dev/null
--- a/arch/x86/kernel/test_rodata.c
+++ /dev/null
@@ -1,75 +0,0 @@
-/*
- * test_rodata.c: functional test for mark_rodata_ro function
- *
- * (C) Copyright 2008 Intel Corporation
- * Author: Arjan van de Ven <arjan@linux.intel.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; version 2
- * of the License.
- */
-#include <asm/cacheflush.h>
-#include <asm/sections.h>
-#include <asm/asm.h>
-
-int rodata_test(void)
-{
-	unsigned long result;
-	unsigned long start, end;
-
-	/* test 1: read the value */
-	/* If this test fails, some previous testrun has clobbered the state */
-	if (!rodata_test_data) {
-		printk(KERN_ERR "rodata_test: test 1 fails (start data)\n");
-		return -ENODEV;
-	}
-
-	/* test 2: write to the variable; this should fault */
-	/*
-	 * If this test fails, we managed to overwrite the data
-	 *
-	 * This is written in assembly to be able to catch the
-	 * exception that is supposed to happen in the correct
-	 * case
-	 */
-
-	result = 1;
-	asm volatile(
-		"0:	mov %[zero],(%[rodata_test])\n"
-		"	mov %[zero], %[rslt]\n"
-		"1:\n"
-		".section .fixup,\"ax\"\n"
-		"2:	jmp 1b\n"
-		".previous\n"
-		_ASM_EXTABLE(0b,2b)
-		: [rslt] "=r" (result)
-		: [rodata_test] "r" (&rodata_test_data), [zero] "r" (0UL)
-	);
-
-
-	if (!result) {
-		printk(KERN_ERR "rodata_test: test data was not read only\n");
-		return -ENODEV;
-	}
-
-	/* test 3: check the value hasn't changed */
-	/* If this test fails, we managed to overwrite the data */
-	if (!rodata_test_data) {
-		printk(KERN_ERR "rodata_test: Test 3 fails (end data)\n");
-		return -ENODEV;
-	}
-	/* test 4: check if the rodata section is 4Kb aligned */
-	start = (unsigned long)__start_rodata;
-	end = (unsigned long)__end_rodata;
-	if (start & (PAGE_SIZE - 1)) {
-		printk(KERN_ERR "rodata_test: .rodata is not 4k aligned\n");
-		return -ENODEV;
-	}
-	if (end & (PAGE_SIZE - 1)) {
-		printk(KERN_ERR "rodata_test: .rodata end is not 4k aligned\n");
-		return -ENODEV;
-	}
-
-	return 0;
-}
diff -puN arch/x86/mm/init_32.c~mm-add-arch-independent-testcases-for-rodata arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~mm-add-arch-independent-testcases-for-rodata
+++ a/arch/x86/mm/init_32.c
@@ -864,9 +864,6 @@ static noinline int do_test_wp_bit(void)
 	return flag;
 }
 
-const int rodata_test_data = 0xC3;
-EXPORT_SYMBOL_GPL(rodata_test_data);
-
 int kernel_set_to_readonly __read_mostly;
 
 void set_kernel_text_rw(void)
@@ -939,7 +936,6 @@ void mark_rodata_ro(void)
 	set_pages_ro(virt_to_page(start), size >> PAGE_SHIFT);
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 		size >> 10);
-	rodata_test();
 
 #ifdef CONFIG_CPA_DEBUG
 	printk(KERN_INFO "Testing CPA: undo %lx-%lx\n", start, start + size);
diff -puN arch/x86/mm/init_64.c~mm-add-arch-independent-testcases-for-rodata arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~mm-add-arch-independent-testcases-for-rodata
+++ a/arch/x86/mm/init_64.c
@@ -1000,9 +1000,6 @@ void __init mem_init(void)
 	mem_init_print_info(NULL);
 }
 
-const int rodata_test_data = 0xC3;
-EXPORT_SYMBOL_GPL(rodata_test_data);
-
 int kernel_set_to_readonly;
 
 void set_kernel_text_rw(void)
@@ -1071,8 +1068,6 @@ void mark_rodata_ro(void)
 	all_end = roundup((unsigned long)_brk_end, PMD_SIZE);
 	set_memory_nx(text_end, (all_end - text_end) >> PAGE_SHIFT);
 
-	rodata_test();
-
 #ifdef CONFIG_CPA_DEBUG
 	printk(KERN_INFO "Testing CPA: undo %lx-%lx\n", start, end);
 	set_memory_rw(start, (end-start) >> PAGE_SHIFT);
diff -puN /dev/null include/linux/rodata_test.h
--- /dev/null
+++ a/include/linux/rodata_test.h
@@ -0,0 +1,24 @@
+/*
+ * rodata_test.h: functional test for mark_rodata_ro function
+ *
+ * (C) Copyright 2008 Intel Corporation
+ * Author: Arjan van de Ven <arjan@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#ifndef _RODATA_TEST_H
+#define _RODATA_TEST_H
+
+#ifdef CONFIG_DEBUG_RODATA_TEST
+extern const int rodata_test_data;
+void rodata_test(void);
+#else
+static inline void rodata_test(void) {}
+#endif
+
+#endif /* _RODATA_TEST_H */
+
diff -puN init/main.c~mm-add-arch-independent-testcases-for-rodata init/main.c
--- a/init/main.c~mm-add-arch-independent-testcases-for-rodata
+++ a/init/main.c
@@ -82,6 +82,7 @@
 #include <linux/proc_ns.h>
 #include <linux/io.h>
 #include <linux/cache.h>
+#include <linux/rodata_test.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -935,9 +936,10 @@ __setup("rodata=", set_debug_rodata);
 #ifdef CONFIG_STRICT_KERNEL_RWX
 static void mark_readonly(void)
 {
-	if (rodata_enabled)
+	if (rodata_enabled) {
 		mark_rodata_ro();
-	else
+		rodata_test();
+	} else
 		pr_info("Kernel memory protection disabled.\n");
 }
 #else
diff -puN mm/Kconfig.debug~mm-add-arch-independent-testcases-for-rodata mm/Kconfig.debug
--- a/mm/Kconfig.debug~mm-add-arch-independent-testcases-for-rodata
+++ a/mm/Kconfig.debug
@@ -90,3 +90,10 @@ config DEBUG_PAGE_REF
 	  careful when enabling this feature because it adds about 30 KB to the
 	  kernel code.  However the runtime performance overhead is virtually
 	  nil until the tracepoints are actually enabled.
+
+config DEBUG_RODATA_TEST
+    bool "Testcase for the marking rodata read-only"
+    depends on STRICT_KERNEL_RWX
+    ---help---
+      This option enables a testcase for the setting rodata read-only.
+
diff -puN mm/Makefile~mm-add-arch-independent-testcases-for-rodata mm/Makefile
--- a/mm/Makefile~mm-add-arch-independent-testcases-for-rodata
+++ a/mm/Makefile
@@ -85,6 +85,7 @@ obj-$(CONFIG_MEMORY_FAILURE) += memory-f
 obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
 obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
 obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
+obj-$(CONFIG_DEBUG_RODATA_TEST) += rodata_test.o
 obj-$(CONFIG_PAGE_OWNER) += page_owner.o
 obj-$(CONFIG_CLEANCACHE) += cleancache.o
 obj-$(CONFIG_MEMORY_ISOLATION) += page_isolation.o
diff -puN /dev/null mm/rodata_test.c
--- /dev/null
+++ a/mm/rodata_test.c
@@ -0,0 +1,56 @@
+/*
+ * rodata_test.c: functional test for mark_rodata_ro function
+ *
+ * (C) Copyright 2008 Intel Corporation
+ * Author: Arjan van de Ven <arjan@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#include <linux/uaccess.h>
+#include <asm/sections.h>
+
+const int rodata_test_data = 0xC3;
+EXPORT_SYMBOL_GPL(rodata_test_data);
+
+void rodata_test(void)
+{
+	unsigned long start, end;
+	int zero = 0;
+
+	/* test 1: read the value */
+	/* If this test fails, some previous testrun has clobbered the state */
+	if (!rodata_test_data) {
+		pr_err("rodata_test: test 1 fails (start data)\n");
+		return;
+	}
+
+	/* test 2: write to the variable; this should fault */
+	if (!probe_kernel_write((void *)&rodata_test_data,
+						(void *)&zero, sizeof(zero))) {
+		pr_err("rodata_test: test data was not read only\n");
+		return;
+	}
+
+	/* test 3: check the value hasn't changed */
+	if (rodata_test_data == zero) {
+		pr_err("rodata_test: test data was changed\n");
+		return;
+	}
+
+	/* test 4: check if the rodata section is PAGE_SIZE aligned */
+	start = (unsigned long)__start_rodata;
+	end = (unsigned long)__end_rodata;
+	if (start & (PAGE_SIZE - 1)) {
+		pr_err("rodata_test: start of .rodata is not page size aligned\n");
+		return;
+	}
+	if (end & (PAGE_SIZE - 1)) {
+		pr_err("rodata_test: end of .rodata is not page size aligned\n");
+		return;
+	}
+
+	pr_info("rodata_test: all tests were successful\n");
+}
_
