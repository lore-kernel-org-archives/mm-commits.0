From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 22 Feb 2011 14:13:50 -0800
Message-ID: <201102222213.p1MMDoGE025190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361Ab1BVWOU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Feb 2011 17:14:20 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p1MMDpo1003961
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2011 14:13:51 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/intel_pmic_gpio.c |   53 -----------------------
 1 file changed, 53 deletions(-)

diff -puN drivers/platform/x86/intel_pmic_gpio.c~linux-next-git-rejects drivers/platform/x86/intel_pmic_gpio.c
--- a/drivers/platform/x86/intel_pmic_gpio.c~linux-next-git-rejects
+++ a/drivers/platform/x86/intel_pmic_gpio.c
@@ -74,22 +74,6 @@ struct pmic_gpio {
 	u32			trigger_type;
 };
 
-<<<<<<< HEAD
-=======
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
->>>>>>> FETCH_HEAD
 static int pmic_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 {
 	if (offset > 8) {
@@ -182,35 +166,9 @@ static int pmic_gpio_to_irq(struct gpio_
 	return pg->irq_base + offset;
 }
 
-<<<<<<< HEAD
-/* the gpiointr register is read-clear, so just do nothing. */
-static void pmic_irq_unmask(struct irq_data *data) { }
-
-=======
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
 
->>>>>>> FETCH_HEAD
 static void pmic_irq_mask(struct irq_data *data) { }
 
 static struct irq_chip pmic_irqchip = {
@@ -220,11 +178,7 @@ static struct irq_chip pmic_irqchip = {
 	.irq_set_type	= pmic_irq_type,
 };
 
-<<<<<<< HEAD
 static irqreturn_t pmic_irq_handler(int irq, void *data)
-=======
-static irqreturn_t pmic_irq_handler(unsigned int irq, void *data)
->>>>>>> FETCH_HEAD
 {
 	struct pmic_gpio *pg = data;
 	u8 intsts = *((u8 *)pg->gpiointr + 4);
@@ -238,10 +192,7 @@ static irqreturn_t pmic_irq_handler(unsi
 			ret = IRQ_HANDLED;
 		}
 	}
-<<<<<<< HEAD
 	return ret;
-=======
->>>>>>> FETCH_HEAD
 }
 
 static int __devinit platform_pmic_gpio_probe(struct platform_device *pdev)
@@ -301,11 +252,7 @@ static int __devinit platform_pmic_gpio_
 
 	retval = request_irq(pg->irq, pmic_irq_handler, 0, "pmic", pg);
 	if (retval) {
-<<<<<<< HEAD
 		printk(KERN_WARNING "pmic: Interrupt request failed\n");
-=======
-		printk(KERN_WARN "pmic: Interrupt request failed\n");
->>>>>>> FETCH_HEAD
 		goto err;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-platform-x86-intel_pmic_gpioc-fix-big-mess-with-i386-allmodconfig.patch
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
linux-next-git-rejects.patch

