From: akpm@linux-foundation.org
Subject: - blackfin-arch-fix-coding-style-in-ints-priority-sc-c-file.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:11:11 -0700
Message-ID: <200704301911.l3UJBBOO012485@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946654AbXD3TLO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:11:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     blackfin arch: fix coding style in ints-priority-sc C file
has been removed from the -mm tree.  Its filename was
     blackfin-arch-fix-coding-style-in-ints-priority-sc-c-file.patch

This patch was dropped because it was folded into blackfin-arch.patch

------------------------------------------------------
Subject: blackfin arch: fix coding style in ints-priority-sc C file
From: Bryan Wu <bryan.wu@analog.com>

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/mach-common/ints-priority-sc.c |   77 +++++++----------
 1 file changed, 34 insertions(+), 43 deletions(-)

diff -puN arch/blackfin/mach-common/ints-priority-sc.c~blackfin-arch-fix-coding-style-in-ints-priority-sc-c-file arch/blackfin/mach-common/ints-priority-sc.c
--- a/arch/blackfin/mach-common/ints-priority-sc.c~blackfin-arch-fix-coding-style-in-ints-priority-sc-c-file
+++ a/arch/blackfin/mach-common/ints-priority-sc.c
@@ -329,11 +329,9 @@ static unsigned int bfin_gpio_irq_startu
 	u16 gpionr = irq - IRQ_PF0;
 
 	if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
-
 		ret = gpio_request(gpionr, NULL);
-		if(ret)
+		if (ret)
 			return ret;
-
 	}
 
 	gpio_enabled[gpio_bank(gpionr)] |= gpio_bit(gpionr);
@@ -355,55 +353,49 @@ static int bfin_gpio_irq_type(unsigned i
 	unsigned int ret;
 	u16 gpionr = irq - IRQ_PF0;
 
+	if (type == IRQ_TYPE_PROBE) {
+		/* only probe unenabled GPIO interrupt lines */
+		if (gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))
+			return 0;
+		type = IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING;
+	}
 
-		if (type == IRQ_TYPE_PROBE) {
-			/* only probe unenabled GPIO interrupt lines */
-			if (gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))
-				return 0;
-			type = IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING;
-
-		}
-
-		if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
-			    IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW)) {
-
+	if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
+	            IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW))
+	{
 		if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
-
 			ret = gpio_request(gpionr, NULL);
-			if(ret)
+			if (ret)
 				return ret;
-
-		}
-
-			gpio_enabled[gpio_bank(gpionr)] |= gpio_bit(gpionr);
-		} else {
-			gpio_enabled[gpio_bank(gpionr)] &= ~gpio_bit(gpionr);
-			return 0;
 		}
 
+		gpio_enabled[gpio_bank(gpionr)] |= gpio_bit(gpionr);
+	} else {
+		gpio_enabled[gpio_bank(gpionr)] &= ~gpio_bit(gpionr);
+		return 0;
+	}
 
-		set_gpio_dir(gpionr, 0);
-		set_gpio_inen(gpionr, 1);
-
+	set_gpio_dir(gpionr, 0);
+	set_gpio_inen(gpionr, 1);
 
-		if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING)) {
-			gpio_edge_triggered[gpio_bank(gpionr)] |= gpio_bit(gpionr);
-			set_gpio_edge(gpionr, 1);
-		} else {
-			set_gpio_edge(gpionr, 0);
-			gpio_edge_triggered[gpio_bank(gpionr)] &= ~gpio_bit(gpionr);
-		}
+	if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING)) {
+		gpio_edge_triggered[gpio_bank(gpionr)] |= gpio_bit(gpionr);
+		set_gpio_edge(gpionr, 1);
+	} else {
+		set_gpio_edge(gpionr, 0);
+		gpio_edge_triggered[gpio_bank(gpionr)] &= ~gpio_bit(gpionr);
+	}
 
-		if ((type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING))
-		    == (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING))
-			set_gpio_both(gpionr, 1);
-		else
-			set_gpio_both(gpionr, 0);
+	if ((type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING))
+	    == (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING))
+		set_gpio_both(gpionr, 1);
+	else
+		set_gpio_both(gpionr, 0);
 
-		if ((type & (IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_LEVEL_LOW)))
-			set_gpio_polar(gpionr, 1);	/* low or falling edge denoted by one */
-		else
-			set_gpio_polar(gpionr, 0);	/* high or rising edge denoted by zero */
+	if ((type & (IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_LEVEL_LOW)))
+		set_gpio_polar(gpionr, 1);	/* low or falling edge denoted by one */
+	else
+		set_gpio_polar(gpionr, 0);	/* high or rising edge denoted by zero */
 
 	SSYNC();
 
@@ -416,7 +408,6 @@ static int bfin_gpio_irq_type(unsigned i
 }
 
 
-
 static struct irq_chip bfin_gpio_irqchip = {
 	.ack = bfin_gpio_ack_irq,
 	.mask = bfin_gpio_mask_irq,
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
blackfin-Documentation.patch
blackfin-arch.patch
blackfin-arch-fix-coding-style-in-ints-priority-sc-c-file.patch
blackfin-arch-fix-bug-refuse-to-boot-if-rootfs-image-is-not-attached-when-mtd_uclinux-is-selected.patch
blackfin-arch-move-revid-function-into-global-headers-as-inline-functions.patch
blackfin-arch-need-linux-ttyh-header-for-console_init-prototype.patch
blackfin-arch-convert-most-blackfin-specific-spi-register-settings-to-common-spi-framework-settings.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-on-chip-ethernet-mac-controller-driver-update.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-on-chip-rtc-controller-driver-fix-rtc_update_irq-augument.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver-cleanup-and-coding-style-fixing.patch
blackfin-blackfin-on-chip-spi-controller-driver-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
blackfin-spi-controller-driver-update-according-to-david-brownells-review.patch
blackfin-serial-core-driver-uart1-should-depend-on-bf534-bf536-bf537-remove-experimental-marking-from-on-chip-serial-core-driver-and-make-options-less-wordy.patch
move-die-notifier-handling-to-common-code-fix.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
