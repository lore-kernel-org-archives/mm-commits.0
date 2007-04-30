From: akpm@linux-foundation.org
Subject: - blackfin-arch-fix-bug-asserting-gpio-requested-doesnt-make-sense-with-gpio-whole-port-accesses.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:11:04 -0700
Message-ID: <200704301911.l3UJB5Qc012474@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946662AbXD3TLI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:11:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     blackfin arch: fix bug asserting gpio requested doesnt make sense with GPIO whole PORT accesses
has been removed from the -mm tree.  Its filename was
     blackfin-arch-fix-bug-asserting-gpio-requested-doesnt-make-sense-with-gpio-whole-port-accesses.patch

This patch was dropped because it was folded into blackfin-arch.patch

------------------------------------------------------
Subject: blackfin arch: fix bug asserting gpio requested doesnt make sense with GPIO whole PORT accesses
From: "Wu, Bryan" <bryan.wu@analog.com>

A BUG_ON will fire in the STAMP533 board when enable ethernet support.  This
BUG_ON asserting is useless in the whole PORT accesses.  So remove it.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/bfin_gpio.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN arch/blackfin/kernel/bfin_gpio.c~blackfin-arch-fix-bug-asserting-gpio-requested-doesnt-make-sense-with-gpio-whole-port-accesses arch/blackfin/kernel/bfin_gpio.c
--- a/arch/blackfin/kernel/bfin_gpio.c~blackfin-arch-fix-bug-asserting-gpio-requested-doesnt-make-sense-with-gpio-whole-port-accesses
+++ a/arch/blackfin/kernel/bfin_gpio.c
@@ -316,7 +316,6 @@ SET_GPIO_P(maskb)
 void set_gpiop_data(unsigned short gpio, unsigned short arg)
 {
 	unsigned long flags;
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	local_irq_save(flags);
 	gpio_bankb[gpio_bank(gpio)]->data = arg;
 	bfin_read_CHIPID();
@@ -386,7 +385,6 @@ unsigned short get_gpiop_data(unsigned s
 {
 	unsigned long flags;
 	unsigned short ret;
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	local_irq_save(flags);
 	ret = gpio_bankb[gpio_bank(gpio)]->data;
 	bfin_read_CHIPID();
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
blackfin-Documentation.patch
blackfin-arch.patch
blackfin-arch-fix-bug-asserting-gpio-requested-doesnt-make-sense-with-gpio-whole-port-accesses.patch
blackfin-arch-04-and-05-silicon-doesnt-exist-for-bf534-bf536-adn-bf537-so-dont-let-people-select-the-option.patch
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
