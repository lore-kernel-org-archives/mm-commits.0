From: akpm@linux-foundation.org
Subject: + blackfin-arch-pnav-and-bluetechnix-cm-bf537-use-the-mac.patch added to -mm tree
Date: Fri, 30 Mar 2007 14:01:31 -0700
Message-ID: <200703302101.l2UL1VcK005032@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52185 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825AbXC3VBd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Mar 2007 17:01:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com


The patch titled
     blackfin arch PNAV and Bluetechnix CM-BF537 use the MAC address programmed by u-boot and Warn if no valid MAC address found
has been added to the -mm tree.  Its filename is
     blackfin-arch-pnav-and-bluetechnix-cm-bf537-use-the-mac.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
blackfin-arch-pnav-and-bluetechnix-cm-bf537-use-the-mac.patch
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
