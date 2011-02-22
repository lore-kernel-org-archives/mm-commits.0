From: akpm@linux-foundation.org
Subject: [merged] drivers-platform-x86-intel_pmic_gpioc-fix-big-mess-with-i386-allmodconfig.patch removed from -mm tree
Date: Tue, 22 Feb 2011 14:18:17 -0800
Message-ID: <201102222218.p1MMIHxT025508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749Ab1BVWTQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Feb 2011 17:19:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mingo@elte.hu, mjg@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     drivers/platform/x86/intel_pmic_gpio.c: fix big mess with i386 allmodconfig
has been removed from the -mm tree.  Its filename was
     drivers-platform-x86-intel_pmic_gpioc-fix-big-mess-with-i386-allmodconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/platform/x86/intel_pmic_gpio.c: fix big mess with i386 allmodconfig
From: Andrew Morton <akpm@linux-foundation.org>

Fix build error:

drivers/platform/x86/intel_pmic_gpio.c:285: error: 'KERN_WARN' undeclared (first use in this function)

And a bunch of warnings:

drivers/platform/x86/intel_pmic_gpio.c: In function 'pmic_irq_handler':
drivers/platform/x86/intel_pmic_gpio.c:226: warning: no return statement in function returning non-void
drivers/platform/x86/intel_pmic_gpio.c: In function 'platform_pmic_gpio_probe':
drivers/platform/x86/intel_pmic_gpio.c:283: warning: passing argument 2 of 'request_irq' from incompatible pointer type
drivers/platform/x86/intel_pmic_gpio.c: At top level:
drivers/platform/x86/intel_pmic_gpio.c:183: warning: 'pmic_bus_lock' defined but not used
drivers/platform/x86/intel_pmic_gpio.c:190: warning: 'pmic_bus_sync_unlock' defined but not used

This repairs linux-next's "platform-drivers: x86: pmic: Use request_irq
instead of chained handler".  Please don't introduce bisection holes into
mainline!

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/intel_pmic_gpio.c |   40 ++---------------------
 1 file changed, 5 insertions(+), 35 deletions(-)

diff -puN drivers/platform/x86/intel_pmic_gpio.c~drivers-platform-x86-intel_pmic_gpioc-fix-big-mess-with-i386-allmodconfig drivers/platform/x86/intel_pmic_gpio.c
--- a/drivers/platform/x86/intel_pmic_gpio.c~drivers-platform-x86-intel_pmic_gpioc-fix-big-mess-with-i386-allmodconfig
+++ a/drivers/platform/x86/intel_pmic_gpio.c
@@ -74,19 +74,6 @@ struct pmic_gpio {
 	u32			trigger_type;
 };
 
-static void pmic_program_irqtype(int gpio, int type)
-{
-	if (type & IRQ_TYPE_EDGE_RISING)
-		intel_scu_ipc_update_register(GPIO0 + gpio, 0x20, 0x20);
-	else
-		intel_scu_ipc_update_register(GPIO0 + gpio, 0x00, 0x20);
-
-	if (type & IRQ_TYPE_EDGE_FALLING)
-		intel_scu_ipc_update_register(GPIO0 + gpio, 0x10, 0x10);
-	else
-		intel_scu_ipc_update_register(GPIO0 + gpio, 0x00, 0x10);
-};
-
 static int pmic_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 {
 	if (offset > 8) {
@@ -179,26 +166,6 @@ static int pmic_gpio_to_irq(struct gpio_
 	return pg->irq_base + offset;
 }
 
-static void pmic_bus_lock(struct irq_data *data)
-{
-	struct pmic_gpio *pg = irq_data_get_irq_chip_data(data);
-
-	mutex_lock(&pg->buslock);
-}
-
-static void pmic_bus_sync_unlock(struct irq_data *data)
-{
-	struct pmic_gpio *pg = irq_data_get_irq_chip_data(data);
-
-	if (pg->update_type) {
-		unsigned int gpio = pg->update_type & ~GPIO_UPDATE_TYPE;
-
-		pmic_program_irqtype(gpio, pg->trigger_type);
-		pg->update_type = 0;
-	}
-	mutex_unlock(&pg->buslock);
-}
-
 /* the gpiointr register is read-clear, so just do nothing. */
 static void pmic_irq_unmask(struct irq_data *data) { }
 
@@ -211,18 +178,21 @@ static struct irq_chip pmic_irqchip = {
 	.irq_set_type	= pmic_irq_type,
 };
 
-static irqreturn_t pmic_irq_handler(unsigned int irq, void *data)
+static irqreturn_t pmic_irq_handler(int irq, void *data)
 {
 	struct pmic_gpio *pg = data;
 	u8 intsts = *((u8 *)pg->gpiointr + 4);
 	int gpio;
+	irqreturn_t ret = IRQ_NONE;
 
 	for (gpio = 0; gpio < 8; gpio++) {
 		if (intsts & (1 << gpio)) {
 			pr_debug("pmic pin %d triggered\n", gpio);
 			generic_handle_irq(pg->irq_base + gpio);
+			ret = IRQ_HANDLED;
 		}
 	}
+	return ret;
 }
 
 static int __devinit platform_pmic_gpio_probe(struct platform_device *pdev)
@@ -282,7 +252,7 @@ static int __devinit platform_pmic_gpio_
 
 	retval = request_irq(pg->irq, pmic_irq_handler, 0, "pmic", pg);
 	if (retval) {
-		printk(KERN_WARN "pmic: Interrupt request failed\n");
+		printk(KERN_WARNING "pmic: Interrupt request failed\n");
 		goto err;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-platform-x86-makefile-drivers-platform-x86-intel_mid_thermalc-doesnt-exist.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
fs-ocfs2-dlm-dlmdomainc-avoid-a-gfp_atomic-allocation.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-batch-free-pcp-list-if-possible-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc-fix.patch
scatterlist-new-helper-functions.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

