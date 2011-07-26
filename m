From: akpm@linux-foundation.org
Subject: [merged] x86-olpc-add-xo-1-suspend-resume-support.patch removed from -mm tree
Date: Tue, 26 Jul 2011 13:33:53 -0700
Message-ID: <201107262032.p6QKWoJ4007278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753643Ab1GZUdL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 16:33:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dsd@laptop.org, dilinger@queued.net, grant.likely@secretlab.ca, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86, olpc: add XO-1 suspend/resume support
has been removed from the -mm tree.  Its filename was
     x86-olpc-add-xo-1-suspend-resume-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86, olpc: add XO-1 suspend/resume support
From: Daniel Drake <dsd@laptop.org>

Add code needed for basic suspend/resume of the XO-1 laptop.  Based on
earlier work by Jordan Crouse, Andres Salomon, and others.

This patch incorporates all earlier feedback from Thomas Gleixner.  To
clarify a certain point (now more obvious in the code itself): On resume,
OpenFirmware returns execution to Linux in protected mode with a
kernel-compatible GDT already set up.  The changes and simplifications
suggested have all been included.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Andres Salomon <dilinger@queued.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                     |    4 
 arch/x86/include/asm/olpc.h          |   15 ++-
 arch/x86/platform/olpc/Makefile      |    2 
 arch/x86/platform/olpc/olpc-xo1-pm.c |   92 ++++++++++++++++++
 arch/x86/platform/olpc/xo1-wakeup.S  |  124 +++++++++++++++++++++++++
 include/linux/cs5535.h               |    3 
 6 files changed, 234 insertions(+), 6 deletions(-)

diff -puN arch/x86/Kconfig~x86-olpc-add-xo-1-suspend-resume-support arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-olpc-add-xo-1-suspend-resume-support
+++ a/arch/x86/Kconfig
@@ -2027,10 +2027,10 @@ config OLPC
 
 config OLPC_XO1_PM
 	bool "OLPC XO-1 Power Management"
-	depends on OLPC && MFD_CS5535
+	depends on OLPC && MFD_CS5535 && PM_SLEEP
 	select MFD_CORE
 	---help---
-	  Add support for poweroff of the OLPC XO-1 laptop.
+	  Add support for poweroff and suspend of the OLPC XO-1 laptop.
 
 config ALIX
 	bool "PCEngines ALIX System Support (LED setup)"
diff -puN arch/x86/include/asm/olpc.h~x86-olpc-add-xo-1-suspend-resume-support arch/x86/include/asm/olpc.h
--- a/arch/x86/include/asm/olpc.h~x86-olpc-add-xo-1-suspend-resume-support
+++ a/arch/x86/include/asm/olpc.h
@@ -76,6 +76,12 @@ static inline int olpc_has_dcon(void)
 
 #endif
 
+#ifdef CONFIG_OLPC_XO1_PM
+extern void do_olpc_suspend_lowlevel(void);
+extern void olpc_xo1_pm_wakeup_set(u16 value);
+extern void olpc_xo1_pm_wakeup_clear(u16 value);
+#endif
+
 extern int pci_olpc_init(void);
 
 /* EC related functions */
@@ -88,9 +94,12 @@ extern int olpc_ec_mask_unset(uint8_t bi
 
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
 
diff -puN arch/x86/platform/olpc/Makefile~x86-olpc-add-xo-1-suspend-resume-support arch/x86/platform/olpc/Makefile
--- a/arch/x86/platform/olpc/Makefile~x86-olpc-add-xo-1-suspend-resume-support
+++ a/arch/x86/platform/olpc/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_OLPC)		+= olpc.o olpc_ofw.o olpc_dt.o
-obj-$(CONFIG_OLPC_XO1_PM)		+= olpc-xo1-pm.o
+obj-$(CONFIG_OLPC_XO1_PM)		+= olpc-xo1-pm.o xo1-wakeup.o
diff -puN arch/x86/platform/olpc/olpc-xo1-pm.c~x86-olpc-add-xo-1-suspend-resume-support arch/x86/platform/olpc/olpc-xo1-pm.c
--- a/arch/x86/platform/olpc/olpc-xo1-pm.c~x86-olpc-add-xo-1-suspend-resume-support
+++ a/arch/x86/platform/olpc/olpc-xo1-pm.c
@@ -16,6 +16,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/mfd/core.h>
+#include <linux/suspend.h>
 
 #include <asm/io.h>
 #include <asm/olpc.h>
@@ -25,6 +26,85 @@
 static unsigned long acpi_base;
 static unsigned long pms_base;
 
+static u16 wakeup_mask = CS5536_PM_PWRBTN;
+
+static struct {
+	unsigned long address;
+	unsigned short segment;
+} ofw_bios_entry = { 0xF0000 + PAGE_OFFSET, __KERNEL_CS };
+
+/* Set bits in the wakeup mask */
+void olpc_xo1_pm_wakeup_set(u16 value)
+{
+	wakeup_mask |= value;
+}
+EXPORT_SYMBOL_GPL(olpc_xo1_pm_wakeup_set);
+
+/* Clear bits in the wakeup mask */
+void olpc_xo1_pm_wakeup_clear(u16 value)
+{
+	wakeup_mask &= ~value;
+}
+EXPORT_SYMBOL_GPL(olpc_xo1_pm_wakeup_clear);
+
+static int xo1_power_state_enter(suspend_state_t pm_state)
+{
+	unsigned long saved_sci_mask;
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
+	/*
+	 * Save SCI mask (this gets lost since PM1_EN is used as a mask for
+	 * wakeup events, which is not necessarily the same event set)
+	 */
+	saved_sci_mask = inl(acpi_base + CS5536_PM1_STS);
+	saved_sci_mask &= 0xffff0000;
+
+	/* Save CPU state */
+	do_olpc_suspend_lowlevel();
+
+	/* Resume path starts here */
+
+	/* Restore SCI mask (using dword access to CS5536_PM1_EN) */
+	outl(saved_sci_mask, acpi_base + CS5536_PM1_STS);
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
+asmlinkage int xo1_do_sleep(u8 sleep_state)
+{
+	void *pgd_addr = __va(read_cr3());
+
+	/* Program wakeup mask (using dword access to CS5536_PM1_EN) */
+	outl(wakeup_mask << 16, acpi_base + CS5536_PM1_STS);
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
 static void xo1_power_off(void)
 {
 	printk(KERN_INFO "OLPC XO-1 power off sequence...\n");
@@ -43,6 +123,17 @@ static void xo1_power_off(void)
 	outl(0x00002000, acpi_base + CS5536_PM1_CNT);
 }
 
+static int xo1_power_state_valid(suspend_state_t pm_state)
+{
+	/* suspend-to-RAM only */
+	return pm_state == PM_SUSPEND_MEM;
+}
+
+static const struct platform_suspend_ops xo1_suspend_ops = {
+	.valid = xo1_power_state_valid,
+	.enter = xo1_power_state_enter,
+};
+
 static int __devinit xo1_pm_probe(struct platform_device *pdev)
 {
 	struct resource *res;
@@ -68,6 +159,7 @@ static int __devinit xo1_pm_probe(struct
 
 	/* If we have both addresses, we can override the poweroff hook */
 	if (pms_base && acpi_base) {
+		suspend_set_ops(&xo1_suspend_ops);
 		pm_power_off = xo1_power_off;
 		printk(KERN_INFO "OLPC XO-1 support registered\n");
 	}
diff -puN /dev/null arch/x86/platform/olpc/xo1-wakeup.S
--- /dev/null
+++ a/arch/x86/platform/olpc/xo1-wakeup.S
@@ -0,0 +1,124 @@
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
+wakeup_start:
+	# OFW lands us here, running in protected mode, with a
+	# kernel-compatible GDT already setup.
+
+	# Clear any dangerous flags
+	pushl $0
+	popfl
+
+	writepost 0x31
+
+	# Set up %cr3
+	movl $initial_page_table - __PAGE_OFFSET, %eax
+	movl %eax, %cr3
+
+	movl saved_cr4, %eax
+	movl %eax, %cr4
+
+	movl saved_cr0, %eax
+	movl %eax, %cr0
+
+	# Control registers were modified, pipeline resync is needed
+	jmp 1f
+1:
+
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
+ENTRY(do_olpc_suspend_lowlevel)
+	call	save_processor_state
+	call	save_registers
+
+	# This is the stack context we want to remember
+	movl %esp, saved_context_esp
+
+	pushl	$3
+	call	xo1_do_sleep
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
diff -puN include/linux/cs5535.h~x86-olpc-add-xo-1-suspend-resume-support include/linux/cs5535.h
--- a/include/linux/cs5535.h~x86-olpc-add-xo-1-suspend-resume-support
+++ a/include/linux/cs5535.h
@@ -70,6 +70,9 @@
 #define CS5536_PM1_CNT		0x08
 #define CS5536_PM_GPE0_STS	0x18
 
+/* CS5536_PM1_EN bits */
+#define CS5536_PM_PWRBTN	(1 << 8)
+
 /* VSA2 magic values */
 #define VSA_VRC_INDEX		0xAC1C
 #define VSA_VRC_DATA		0xAC1E
_

Patches currently in -mm which might be from dsd@laptop.org are

origin.patch
linux-next.patch

