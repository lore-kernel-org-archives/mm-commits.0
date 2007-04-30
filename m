From: akpm@linux-foundation.org
Subject: - blackfin-arch-pnav-and-bluetechnix-cm-bf537-use-the-mac.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:10:24 -0700
Message-ID: <200704301910.l3UJAOEO012420@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946669AbXD3TK2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:10:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     blackfin arch PNAV and Bluetechnix CM-BF537 use the MAC address programmed by u-boot and Warn if no valid MAC address found
has been removed from the -mm tree.  Its filename was
     blackfin-arch-pnav-and-bluetechnix-cm-bf537-use-the-mac.patch

This patch was dropped because it was folded into blackfin-arch.patch

------------------------------------------------------
Subject: blackfin arch PNAV and Bluetechnix CM-BF537 use the MAC address programmed by u-boot and Warn if no valid MAC address found
From: "Wu, Bryan" <bryan.wu@analog.com>

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/mach-bf537/boards/eth_mac.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/blackfin/mach-bf537/boards/eth_mac.c~blackfin-arch-pnav-and-bluetechnix-cm-bf537-use-the-mac arch/blackfin/mach-bf537/boards/eth_mac.c
--- a/arch/blackfin/mach-bf537/boards/eth_mac.c~blackfin-arch-pnav-and-bluetechnix-cm-bf537-use-the-mac
+++ a/arch/blackfin/mach-bf537/boards/eth_mac.c
@@ -21,9 +21,7 @@
 #include <asm/blackfin.h>
 
 #if	defined(CONFIG_GENERIC_BOARD) \
-	|| defined(CONFIG_BFIN537_STAMP) \
-	|| defined(CONFIG_BFIN537_BLUETECHNIX_CM) \
-	|| defined(CONFIG_PNAV10)
+	|| defined(CONFIG_BFIN537_STAMP)
 
 /*
  * Currently the MAC address is saved in Flash by U-Boot
@@ -45,6 +43,7 @@ void get_bf537_ether_addr(char *addr)
  */
 void get_bf537_ether_addr(char *addr)
 {
+	printk(KERN_WARNING "%s: No valid Ethernet MAC address found\n",__FILE__);
 }
 
 #endif
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
blackfin-Documentation.patch
blackfin-arch.patch
blackfin-arch-pnav-and-bluetechnix-cm-bf537-use-the-mac.patch
blackfin-arch-always-include-linux-kallsysms-header-file.patch
blackfin-arch-sync-with-uclibc-no-functional-changes.patch
blackfin-arch-using-asm-generic-pgtable-header-file-by.patch
blackfin-arch-add-missing-__clear_user-function-to.patch
blackfin-arch-use-boot_command_line-instead-of.patch
blackfin-arch-fix-some-coding-style-in-include.patch
blackfin-arch-add-scm_timestampns-and-siocgstampns-to.patch
blackfin-arch-add-missing-blackfin-support-in-lib.patch
blackfin-arch-fix-bug-data-cannot-be-put-into-l1-data.patch
blackfin-arch-source-kernel-preemption-option.patch
blackfin-arch-workaround-bf561-anomaly-05000266.patch
blackfin-arch-define-a-new-cacheline_aligned-attribute-to-put-it-in-l1-data-memory-with-linkscript-update.patch
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
