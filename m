From: akpm@linux-foundation.org
Subject: + x86-olpc-add-xo-1-suspend-resume-support.patch added to -mm tree
Date: Wed, 08 Dec 2010 14:40:52 -0800
Message-ID: <201012082240.oB8MeqPg013784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753406Ab0LHWlt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Dec 2010 17:41:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dsd@laptop.org, dilinger@queued.net, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: OLPC: add XO-1 suspend/resume support
has been added to the -mm tree.  Its filename is
     x86-olpc-add-xo-1-suspend-resume-support.patch

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
Subject: x86: OLPC: add XO-1 suspend/resume support
From: Daniel Drake <dsd@laptop.org>

Add code needed for basic suspend/resume of the XO-1 laptop.

As distro kernels would prefer to build XO-1 support modular, we have had
to export suspend_set_ops() and create an exported function for reading
the address of the initial page table.

Due to complications compiling asm into a module, the olpc-xo1.c file had to
be renamed to have a name different from the target module name.

Based on earlier work by Jordan Crouse, Andres Salomon, and others.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Cc: Andres Salomon <dilinger@queued.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                    |    2 
 arch/x86/include/asm/olpc.h         |    9 -
 arch/x86/include/asm/pgtable_32.h   |    1 
 arch/x86/mm/init_32.c               |    7 
 arch/x86/platform/olpc/Makefile     |    6 
 arch/x86/platform/olpc/olpc-xo1.c   |  140 ----------------
 arch/x86/platform/olpc/xo1-wakeup.S |  137 ++++++++++++++++
 arch/x86/platform/olpc/xo1.c        |  216 ++++++++++++++++++++++++++
 kernel/power/suspend.c              |    1 
 9 files changed, 374 insertions(+), 145 deletions(-)

diff -puN arch/x86/Kconfig~x86-olpc-add-xo-1-suspend-resume-support arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-olpc-add-xo-1-suspend-resume-support
+++ a/arch/x86/Kconfig
@@ -2070,7 +2070,7 @@ config OLPC
 
 config OLPC_XO1
 	tristate "OLPC XO-1 support"
-	depends on OLPC && PCI
+	depends on OLPC && PCI && PM_SLEEP
 	---help---
 	  Add support for non-essential features of the OLPC XO-1 laptop.
 
diff -puN arch/x86/include/asm/olpc.h~x86-olpc-add-xo-1-suspend-resume-support arch/x86/include/asm/olpc.h
--- a/arch/x86/include/asm/olpc.h~x86-olpc-add-xo-1-suspend-resume-support
+++ a/arch/x86/include/asm/olpc.h
@@ -88,9 +88,12 @@ extern int olpc_ec_mask_unset(uint8_t bi
 
 /* EC commands */
 
-#define EC_FIRMWARE_REV		0x08
-#define EC_WLAN_ENTER_RESET	0x35
-#define EC_WLAN_LEAVE_RESET	0x25
+#define EC_FIRMWARE_REV			0x08
+#define EC_WAKE_UP_WLAN			0x24
+#define EC_WLAN_LEAVE_RESET		0x25
+#define EC_SET_SCI_INHIBIT		0x32
+#define EC_SET_SCI_INHIBIT_RELEASE	0x34
+#define EC_WLAN_ENTER_RESET		0x35
 
 /* SCI source values */
 
diff -puN arch/x86/include/asm/pgtable_32.h~x86-olpc-add-xo-1-suspend-resume-support arch/x86/include/asm/pgtable_32.h
--- a/arch/x86/include/asm/pgtable_32.h~x86-olpc-add-xo-1-suspend-resume-support
+++ a/arch/x86/include/asm/pgtable_32.h
@@ -34,6 +34,7 @@ void paging_init(void);
 
 extern void set_pmd_pfn(unsigned long, unsigned long, pgprot_t);
 
+pgd_t *get_initial_page_table(void);
 
 /*
  * Define this if things work differently on an i386 and an i486:
diff -puN arch/x86/mm/init_32.c~x86-olpc-add-xo-1-suspend-resume-support arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~x86-olpc-add-xo-1-suspend-resume-support
+++ a/arch/x86/mm/init_32.c
@@ -52,6 +52,7 @@
 #include <asm/cacheflush.h>
 #include <asm/page_types.h>
 #include <asm/init.h>
+#include <asm/pgtable_32.h>
 
 unsigned long highstart_pfn, highend_pfn;
 
@@ -967,3 +968,9 @@ void mark_rodata_ro(void)
 }
 #endif
 
+pgd_t *get_initial_page_table(void)
+{
+	return initial_page_table;
+}
+EXPORT_SYMBOL_GPL(get_initial_page_table);
+
diff -puN arch/x86/platform/olpc/Makefile~x86-olpc-add-xo-1-suspend-resume-support arch/x86/platform/olpc/Makefile
--- a/arch/x86/platform/olpc/Makefile~x86-olpc-add-xo-1-suspend-resume-support
+++ a/arch/x86/platform/olpc/Makefile
@@ -1,3 +1,7 @@
 obj-$(CONFIG_OLPC)		+= olpc.o
-obj-$(CONFIG_OLPC_XO1)		+= olpc-xo1.o
 obj-$(CONFIG_OLPC_OPENFIRMWARE)	+= olpc_ofw.o
+
+# xo1-wakeup must be built separately as below, otherwise OLPC_XO1 cannot be
+# compiled as a module
+olpc-xo1-y			:= xo1.o xo1-wakeup.o
+obj-$(CONFIG_OLPC_XO1)		+= olpc-xo1.o
diff -puN arch/x86/platform/olpc/olpc-xo1.c~x86-olpc-add-xo-1-suspend-resume-support /dev/null
--- a/arch/x86/platform/olpc/olpc-xo1.c
+++ /dev/null
@@ -1,140 +0,0 @@
-/*
- * Support for features of the OLPC XO-1 laptop
- *
- * Copyright (C) 2010 One Laptop per Child
- * Copyright (C) 2006 Red Hat, Inc.
- * Copyright (C) 2006 Advanced Micro Devices, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/pci_ids.h>
-#include <linux/platform_device.h>
-#include <linux/pm.h>
-
-#include <asm/io.h>
-#include <asm/olpc.h>
-
-#define DRV_NAME "olpc-xo1"
-
-#define PMS_BAR		4
-#define ACPI_BAR	5
-
-/* PMC registers (PMS block) */
-#define PM_SCLK		0x10
-#define PM_IN_SLPCTL	0x20
-#define PM_WKXD		0x34
-#define PM_WKD		0x30
-#define PM_SSC		0x54
-
-/* PM registers (ACPI block) */
-#define PM1_CNT		0x08
-#define PM_GPE0_STS	0x18
-
-static unsigned long acpi_base;
-static unsigned long pms_base;
-
-static void xo1_power_off(void)
-{
-	printk(KERN_INFO "OLPC XO-1 power off sequence...\n");
-
-	/* Enable all of these controls with 0 delay */
-	outl(0x40000000, pms_base + PM_SCLK);
-	outl(0x40000000, pms_base + PM_IN_SLPCTL);
-	outl(0x40000000, pms_base + PM_WKXD);
-	outl(0x40000000, pms_base + PM_WKD);
-
-	/* Clear status bits (possibly unnecessary) */
-	outl(0x0002ffff, pms_base  + PM_SSC);
-	outl(0xffffffff, acpi_base + PM_GPE0_STS);
-
-	/* Write SLP_EN bit to start the machinery */
-	outl(0x00002000, acpi_base + PM1_CNT);
-}
-
-/* Read the base addresses from the PCI BAR info */
-static int __devinit setup_bases(struct pci_dev *pdev)
-{
-	int r;
-
-	r = pci_enable_device_io(pdev);
-	if (r) {
-		dev_err(&pdev->dev, "can't enable device IO\n");
-		return r;
-	}
-
-	r = pci_request_region(pdev, ACPI_BAR, DRV_NAME);
-	if (r) {
-		dev_err(&pdev->dev, "can't alloc PCI BAR #%d\n", ACPI_BAR);
-		return r;
-	}
-
-	r = pci_request_region(pdev, PMS_BAR, DRV_NAME);
-	if (r) {
-		dev_err(&pdev->dev, "can't alloc PCI BAR #%d\n", PMS_BAR);
-		pci_release_region(pdev, ACPI_BAR);
-		return r;
-	}
-
-	acpi_base = pci_resource_start(pdev, ACPI_BAR);
-	pms_base = pci_resource_start(pdev, PMS_BAR);
-
-	return 0;
-}
-
-static int __devinit olpc_xo1_probe(struct platform_device *pdev)
-{
-	struct pci_dev *pcidev;
-	int r;
-
-	pcidev = pci_get_device(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA,
-				NULL);
-	if (!pdev)
-		return -ENODEV;
-
-	r = setup_bases(pcidev);
-	if (r)
-		return r;
-
-	pm_power_off = xo1_power_off;
-
-	printk(KERN_INFO "OLPC XO-1 support registered\n");
-	return 0;
-}
-
-static int __devexit olpc_xo1_remove(struct platform_device *pdev)
-{
-	pm_power_off = NULL;
-	return 0;
-}
-
-static struct platform_driver olpc_xo1_driver = {
-	.driver = {
-		.name = DRV_NAME,
-		.owner = THIS_MODULE,
-	},
-	.probe = olpc_xo1_probe,
-	.remove = __devexit_p(olpc_xo1_remove),
-};
-
-static int __init olpc_xo1_init(void)
-{
-	return platform_driver_register(&olpc_xo1_driver);
-}
-
-static void __exit olpc_xo1_exit(void)
-{
-	platform_driver_unregister(&olpc_xo1_driver);
-}
-
-MODULE_AUTHOR("Daniel Drake <dsd@laptop.org>");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:olpc-xo1");
-
-module_init(olpc_xo1_init);
-module_exit(olpc_xo1_exit);
diff -puN /dev/null arch/x86/platform/olpc/xo1-wakeup.S
--- /dev/null
+++ a/arch/x86/platform/olpc/xo1-wakeup.S
@@ -0,0 +1,137 @@
+.text
+#include <linux/linkage.h>
+#include <asm/segment.h>
+#include <asm/page.h>
+#include <asm/pgtable_32.h>
+
+	.macro writepost,value
+		movb $0x34, %al
+		outb %al, $0x70
+		movb $\value, %al
+		outb %al, $0x71
+	.endm
+
+ALIGN
+	.align 4096
+
+wakeup_start:
+	cli
+	cld
+
+	# Clear any dangerous flags
+
+	pushl $0
+	popfl
+
+	writepost 0x31
+
+	# Set up %cr3
+	call get_initial_page_table
+	sub $__PAGE_OFFSET, %eax
+	movl %eax, %cr3
+
+	movl saved_cr4, %eax
+	movl %eax, %cr4
+
+	movl saved_cr0, %eax
+	movl %eax, %cr0
+
+	jmp 1f
+1:
+	ljmpl $__KERNEL_CS,$wakeup_return
+
+
+.org 0x1000
+
+wakeup_return:
+	movw    $__KERNEL_DS, %ax
+	movw    %ax, %ss
+	movw    %ax, %ds
+	movw    %ax, %es
+	movw    %ax, %fs
+	movw    %ax, %gs
+
+	lgdt    saved_gdt
+	lidt    saved_idt
+	lldt    saved_ldt
+	ljmp    $(__KERNEL_CS),$1f
+1:
+	movl    %cr3, %eax
+	movl    %eax, %cr3
+	wbinvd
+
+	# Go back to the return point
+	jmp ret_point
+
+save_registers:
+	sgdt  saved_gdt
+	sidt  saved_idt
+	sldt  saved_ldt
+
+	pushl %edx
+	movl %cr4, %edx
+	movl %edx, saved_cr4
+
+	movl %cr0, %edx
+	movl %edx, saved_cr0
+
+	popl %edx
+
+	movl %ebx, saved_context_ebx
+	movl %ebp, saved_context_ebp
+	movl %esi, saved_context_esi
+	movl %edi, saved_context_edi
+
+	pushfl
+	popl saved_context_eflags
+
+	ret
+
+
+restore_registers:
+	movl saved_context_ebp, %ebp
+	movl saved_context_ebx, %ebx
+	movl saved_context_esi, %esi
+	movl saved_context_edi, %edi
+
+	pushl saved_context_eflags
+	popfl
+
+	ret
+
+
+ENTRY(do_olpc_suspend_lowlevel)
+	call	save_processor_state
+	call	save_registers
+
+	# This is the stack context we want to remember
+	movl %esp, saved_context_esp
+
+	pushl	$3
+	call	olpc_xo1_do_sleep
+
+	jmp	wakeup_start
+	.p2align 4,,7
+ret_point:
+	movl    saved_context_esp, %esp
+
+	writepost 0x32
+
+	call	restore_registers
+	call	restore_processor_state
+	ret
+
+.data
+ALIGN
+
+saved_gdt:             .long   0,0
+saved_idt:             .long   0,0
+saved_ldt:             .long   0
+saved_cr4:             .long   0
+saved_cr0:             .long   0
+saved_context_esp:     .long   0
+saved_context_edi:     .long   0
+saved_context_esi:     .long   0
+saved_context_ebx:     .long   0
+saved_context_ebp:     .long   0
+saved_context_eflags:  .long   0
diff -puN /dev/null arch/x86/platform/olpc/xo1.c
--- /dev/null
+++ a/arch/x86/platform/olpc/xo1.c
@@ -0,0 +1,216 @@
+/*
+ * Support for features of the OLPC XO-1 laptop
+ *
+ * Copyright (C) 2010 One Laptop per Child
+ * Copyright (C) 2006 Red Hat, Inc.
+ * Copyright (C) 2006 Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+#include <linux/platform_device.h>
+#include <linux/pm.h>
+#include <linux/suspend.h>
+
+#include <asm/io.h>
+#include <asm/olpc.h>
+
+#define DRV_NAME "olpc-xo1"
+
+#define PMS_BAR		4
+#define ACPI_BAR	5
+
+/* PMC registers (PMS block) */
+#define PM_SCLK		0x10
+#define PM_IN_SLPCTL	0x20
+#define PM_WKXD		0x34
+#define PM_WKD		0x30
+#define PM_SSC		0x54
+
+/* PM registers (ACPI block) */
+#define PM1_STS		0x00
+#define PM1_CNT		0x08
+#define PM_GPE0_STS	0x18
+
+#define CS5536_PM_PWRBTN (1 << 8)
+
+extern void do_olpc_suspend_lowlevel(void);
+
+static unsigned long acpi_base;
+static unsigned long pms_base;
+
+static struct {
+	unsigned long address;
+	unsigned short segment;
+} ofw_bios_entry = { 0xF0000 + PAGE_OFFSET, __KERNEL_CS };
+
+static int xo1_power_state_enter(suspend_state_t pm_state)
+{
+	int r;
+
+	/* Only STR is supported */
+	if (pm_state != PM_SUSPEND_MEM)
+		return -EINVAL;
+
+	r = olpc_ec_cmd(EC_SET_SCI_INHIBIT, NULL, 0, NULL, 0);
+	if (r)
+		return r;
+
+	/* Save CPU state */
+	do_olpc_suspend_lowlevel();
+
+	/* Resume path starts here */
+
+	/* Tell the EC to stop inhibiting SCIs */
+	olpc_ec_cmd(EC_SET_SCI_INHIBIT_RELEASE, NULL, 0, NULL, 0);
+
+	/*
+	 * Tell the wireless module to restart USB communication.
+	 * Must be done twice.
+	 */
+	olpc_ec_cmd(EC_WAKE_UP_WLAN, NULL, 0, NULL, 0);
+	olpc_ec_cmd(EC_WAKE_UP_WLAN, NULL, 0, NULL, 0);
+
+	return 0;
+}
+
+asmlinkage int olpc_xo1_do_sleep(u8 sleep_state)
+{
+	void *pgd_addr = __va(read_cr3());
+
+	/* Enable wakeup through power button */
+	outl((CS5536_PM_PWRBTN << 16) | 0xFFFF, acpi_base + PM1_STS);
+
+	__asm__("movl %0,%%eax" : : "r" (pgd_addr));
+	__asm__("call *(%%edi); cld"
+		: : "D" (&ofw_bios_entry));
+	__asm__("movb $0x34, %al\n\t"
+		"outb %al, $0x70\n\t"
+		"movb $0x30, %al\n\t"
+		"outb %al, $0x71\n\t");
+	return 0;
+}
+
+static int xo1_power_state_valid(suspend_state_t pm_state)
+{
+	/* suspend-to-RAM only */
+	return pm_state == PM_SUSPEND_MEM;
+}
+
+static struct platform_suspend_ops xo1_suspend_ops = {
+	.valid = xo1_power_state_valid,
+	.enter = xo1_power_state_enter,
+};
+
+static void xo1_power_off(void)
+{
+	printk(KERN_INFO "OLPC XO-1 power off sequence...\n");
+
+	/* Enable all of these controls with 0 delay */
+	outl(0x40000000, pms_base + PM_SCLK);
+	outl(0x40000000, pms_base + PM_IN_SLPCTL);
+	outl(0x40000000, pms_base + PM_WKXD);
+	outl(0x40000000, pms_base + PM_WKD);
+
+	/* Clear status bits (possibly unnecessary) */
+	outl(0x0002ffff, pms_base  + PM_SSC);
+	outl(0xffffffff, acpi_base + PM_GPE0_STS);
+
+	/* Write SLP_EN bit to start the machinery */
+	outl(0x00002000, acpi_base + PM1_CNT);
+}
+
+/* Read the base addresses from the PCI BAR info */
+static int __devinit setup_bases(struct pci_dev *pdev)
+{
+	int r;
+
+	r = pci_enable_device_io(pdev);
+	if (r) {
+		dev_err(&pdev->dev, "can't enable device IO\n");
+		return r;
+	}
+
+	r = pci_request_region(pdev, ACPI_BAR, DRV_NAME);
+	if (r) {
+		dev_err(&pdev->dev, "can't alloc PCI BAR #%d\n", ACPI_BAR);
+		return r;
+	}
+
+	r = pci_request_region(pdev, PMS_BAR, DRV_NAME);
+	if (r) {
+		dev_err(&pdev->dev, "can't alloc PCI BAR #%d\n", PMS_BAR);
+		pci_release_region(pdev, ACPI_BAR);
+		return r;
+	}
+
+	acpi_base = pci_resource_start(pdev, ACPI_BAR);
+	pms_base = pci_resource_start(pdev, PMS_BAR);
+
+	return 0;
+}
+
+static int __devinit olpc_xo1_probe(struct platform_device *pdev)
+{
+	struct pci_dev *pcidev;
+	int r;
+
+	pcidev = pci_get_device(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA,
+				NULL);
+	if (!pdev)
+		return -ENODEV;
+
+	r = setup_bases(pcidev);
+	if (r)
+		return r;
+
+	/*
+	 * Take a reference on ourself to prevent module unloading. We can't
+	 * safely unload after changing the suspend handlers.
+	 */
+	__module_get(THIS_MODULE);
+
+	suspend_set_ops(&xo1_suspend_ops);
+	pm_power_off = xo1_power_off;
+
+	printk(KERN_INFO "OLPC XO-1 support registered\n");
+	return 0;
+}
+
+static int __devexit olpc_xo1_remove(struct platform_device *pdev)
+{
+	pm_power_off = NULL;
+	return 0;
+}
+
+static struct platform_driver olpc_xo1_driver = {
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+	},
+	.probe = olpc_xo1_probe,
+	.remove = __devexit_p(olpc_xo1_remove),
+};
+
+static int __init olpc_xo1_init(void)
+{
+	return platform_driver_register(&olpc_xo1_driver);
+}
+
+static void __exit olpc_xo1_exit(void)
+{
+	platform_driver_unregister(&olpc_xo1_driver);
+}
+
+MODULE_AUTHOR("Daniel Drake <dsd@laptop.org>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:olpc-xo1");
+
+module_init(olpc_xo1_init);
+module_exit(olpc_xo1_exit);
diff -puN kernel/power/suspend.c~x86-olpc-add-xo-1-suspend-resume-support kernel/power/suspend.c
--- a/kernel/power/suspend.c~x86-olpc-add-xo-1-suspend-resume-support
+++ a/kernel/power/suspend.c
@@ -42,6 +42,7 @@ void suspend_set_ops(const struct platfo
 	suspend_ops = ops;
 	mutex_unlock(&pm_mutex);
 }
+EXPORT_SYMBOL_GPL(suspend_set_ops);
 
 bool valid_state(suspend_state_t state)
 {
_

Patches currently in -mm which might be from dsd@laptop.org are

linux-next.patch
x86-olpc-add-xo-1-suspend-resume-support.patch
drivers-gpio-cs5535-gpioc-add-some-additional-cs5535-specific-gpio-functionality.patch

