From: akpm@linux-foundation.org
Subject: + blackfin-arch-fix-bug-interrupt-setup-problem-request_irq.patch added to -mm tree
Date: Fri, 30 Mar 2007 14:01:05 -0700
Message-ID: <200703302101.l2UL15Lt005019@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52164 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821AbXC3VBJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Mar 2007 17:01:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com


The patch titled
     blackfin arch fix bug interrupt setup problem request_irq: set_gpio_dir called before gpio_request
has been added to the -mm tree.  Its filename is
     blackfin-arch-fix-bug-interrupt-setup-problem-request_irq.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: blackfin arch fix bug interrupt setup problem request_irq: set_gpio_dir called before gpio_request
From: "Wu, Bryan" <bryan.wu@analog.com>

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/mach-common/ints-priority-dc.c |   36 ++++++++++++----
 arch/blackfin/mach-common/ints-priority-sc.c |   38 +++++++++++++----
 include/asm-blackfin/gpio.h                  |    6 +-
 3 files changed, 63 insertions(+), 17 deletions(-)

diff -puN arch/blackfin/mach-common/ints-priority-dc.c~blackfin-arch-fix-bug-interrupt-setup-problem-request_irq arch/blackfin/mach-common/ints-priority-dc.c
--- a/arch/blackfin/mach-common/ints-priority-dc.c~blackfin-arch-fix-bug-interrupt-setup-problem-request_irq
+++ a/arch/blackfin/mach-common/ints-priority-dc.c
@@ -217,11 +217,18 @@ static void bf561_gpio_unmask_irq(unsign
 static unsigned int bf561_gpio_irq_startup(unsigned int irq)
 {
 	unsigned int ret;
+	u16 gpionr = irq - IRQ_PF0;
+
+	if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
 
-	ret = gpio_request(irq - IRQ_PF0, NULL);
+		ret = gpio_request(gpionr, NULL);
+		if(ret)
+			return ret;
 
-	if (!ret)
-	  bf561_gpio_unmask_irq(irq);
+	}
+
+	gpio_enabled[gpio_bank(gpionr)] |= gpio_bit(gpionr);
+	bf561_gpio_unmask_irq(irq);
 
   return ret;
 
@@ -231,15 +238,15 @@ static void bf561_gpio_irq_shutdown(unsi
 {
 	bf561_gpio_mask_irq(irq);
 	gpio_free(irq - IRQ_PF0);
+	gpio_enabled[gpio_bank(irq - IRQ_PF0)] &= ~gpio_bit(irq - IRQ_PF0);
 }
 
 static int bf561_gpio_irq_type(unsigned int irq, unsigned int type)
 {
 
+	unsigned int ret;
 	u16 gpionr = irq - IRQ_PF0;
 
-		set_gpio_dir(gpionr, 0);
-		set_gpio_inen(gpionr, 1);
 
 		if (type == IRQ_TYPE_PROBE) {
 			/* only probe unenabled GPIO interrupt lines */
@@ -250,11 +257,26 @@ static int bf561_gpio_irq_type(unsigned 
 		}
 
 		if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
-			    IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW))
+			    IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW)) {
+
+		if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
+
+			ret = gpio_request(gpionr, NULL);
+			if(ret)
+				return ret;
+
+		}
 
 			gpio_enabled[gpio_bank(gpionr)] |= gpio_bit(gpionr);
-		else
+		} else {
 			gpio_enabled[gpio_bank(gpionr)] &= ~gpio_bit(gpionr);
+			return 0;
+		}
+
+
+		set_gpio_dir(gpionr, 0);
+		set_gpio_inen(gpionr, 1);
+
 
 		if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING)) {
 			gpio_edge_triggered[gpio_bank(gpionr)] |= gpio_bit(gpionr);
diff -puN arch/blackfin/mach-common/ints-priority-sc.c~blackfin-arch-fix-bug-interrupt-setup-problem-request_irq arch/blackfin/mach-common/ints-priority-sc.c
--- a/arch/blackfin/mach-common/ints-priority-sc.c~blackfin-arch-fix-bug-interrupt-setup-problem-request_irq
+++ a/arch/blackfin/mach-common/ints-priority-sc.c
@@ -326,11 +326,18 @@ static void bfin_gpio_unmask_irq(unsigne
 static unsigned int bfin_gpio_irq_startup(unsigned int irq)
 {
 	unsigned int ret;
+	u16 gpionr = irq - IRQ_PF0;
+
+	if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
+
+		ret = gpio_request(gpionr, NULL);
+		if(ret)
+			return ret;
 
-	ret = gpio_request(irq - IRQ_PF0, NULL);
+	}
 
-	if (!ret)
-		bfin_gpio_unmask_irq(irq);
+	gpio_enabled[gpio_bank(gpionr)] |= gpio_bit(gpionr);
+	bfin_gpio_unmask_irq(irq);
 
 	return ret;
 }
@@ -339,14 +346,15 @@ static void bfin_gpio_irq_shutdown(unsig
 {
 	bfin_gpio_mask_irq(irq);
 	gpio_free(irq - IRQ_PF0);
+	gpio_enabled[gpio_bank(irq - IRQ_PF0)] &= ~gpio_bit(irq - IRQ_PF0);
 }
 
 static int bfin_gpio_irq_type(unsigned int irq, unsigned int type)
 {
+
+	unsigned int ret;
 	u16 gpionr = irq - IRQ_PF0;
 
-		set_gpio_dir(gpionr, 0);
-		set_gpio_inen(gpionr, 1);
 
 		if (type == IRQ_TYPE_PROBE) {
 			/* only probe unenabled GPIO interrupt lines */
@@ -357,10 +365,26 @@ static int bfin_gpio_irq_type(unsigned i
 		}
 
 		if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
-			    IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW))
+			    IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW)) {
+
+		if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
+
+			ret = gpio_request(gpionr, NULL);
+			if(ret)
+				return ret;
+
+		}
+
 			gpio_enabled[gpio_bank(gpionr)] |= gpio_bit(gpionr);
-		else
+		} else {
 			gpio_enabled[gpio_bank(gpionr)] &= ~gpio_bit(gpionr);
+			return 0;
+		}
+
+
+		set_gpio_dir(gpionr, 0);
+		set_gpio_inen(gpionr, 1);
+
 
 		if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING)) {
 			gpio_edge_triggered[gpio_bank(gpionr)] |= gpio_bit(gpionr);
diff -puN include/asm-blackfin/gpio.h~blackfin-arch-fix-bug-interrupt-setup-problem-request_irq include/asm-blackfin/gpio.h
--- a/include/asm-blackfin/gpio.h~blackfin-arch-fix-bug-interrupt-setup-problem-request_irq
+++ a/include/asm-blackfin/gpio.h
@@ -85,9 +85,9 @@
 #ifndef __ARCH_BLACKFIN_GPIO_H__
 #define __ARCH_BLACKFIN_GPIO_H__
 
-#define gpio_bank(x) (x >> 4)
-#define gpio_bit(x)  (1<<(x & 0xF))
-#define gpio_sub_n(x) (x & 0xF)
+#define gpio_bank(x) ((x) >> 4)
+#define gpio_bit(x)  (1<<((x) & 0xF))
+#define gpio_sub_n(x) ((x) & 0xF)
 
 #define GPIO_BANKSIZE 16
 
_

Patches currently in -mm which might be from bryan.wu@analog.com are

blackfin-Documentation.patch
blackfin-arch.patch
blackfin-arch-balance-parenthesis-in-macros.patch
blackfin-arch-2.6.21-rc4-mm1-update.patch
blackfin-arch-fix-struct-dmasg-packing-bug.patch
blackfin-arch-cleanup-cache-header-file.patch
blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
blackfin-arch-fix-compiling-error-in-flat-c-file.patch
blackfin-arch-power-management-replace-firmware-disk-mode.patch
blackfin-arch-add-kdebug-header-file.patch
blackfin-arch-fix-bug-bf561-rev-id-are-8-bit.patch
blackfin-arch-fix-bug-prevent-warning-in-case-bf531-is-target.patch
blackfin-arch-fix-stamp537-isp1716-irq-setting-bug.patch
blackfin-arch-fix-bug-interrupt-setup-problem-request_irq.patch
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
blackfin-blackfin-utrace-patch.patch
utrace-nommu-fixup-support-utrace.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
