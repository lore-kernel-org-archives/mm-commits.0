From: akpm@linux-foundation.org
Subject: - blackfin-serial-core-driver-uart1-should-depend-on-bf534-bf536-bf537-remove-experimental-marking-from-on-chip-serial-core-driver-and-make-options-less-wordy.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:16:17 -0700
Message-ID: <200704301916.l3UJGIhu012620@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946710AbXD3TQV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:16:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     blackfin serial core driver: UART1 should depend on BF534/BF536/BF537, remove experimental marking from on-chip serial core driver and make options less wordy.
has been removed from the -mm tree.  Its filename was
     blackfin-serial-core-driver-uart1-should-depend-on-bf534-bf536-bf537-remove-experimental-marking-from-on-chip-serial-core-driver-and-make-options-less-wordy.patch

This patch was dropped because it was folded into driver_bfin_serial_core.patch

------------------------------------------------------
Subject: blackfin serial core driver: UART1 should depend on BF534/BF536/BF537, remove experimental marking from on-chip serial core driver and make options less wordy.
From: Bryan Wu <bryan.wu@analog.com>

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Kconfig |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/serial/Kconfig~blackfin-serial-core-driver-uart1-should-depend-on-bf534-bf536-bf537-remove-experimental-marking-from-on-chip-serial-core-driver-and-make-options-less-wordy drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~blackfin-serial-core-driver-uart1-should-depend-on-bf534-bf536-bf537-remove-experimental-marking-from-on-chip-serial-core-driver-and-make-options-less-wordy
+++ a/drivers/serial/Kconfig
@@ -509,8 +509,8 @@ config SERIAL_SA1100_CONSOLE
 	  kernel at boot time.)
 
 config SERIAL_BFIN
-	tristate "Blackfin serial port support (EXPERIMENTAL)"
-	depends on BFIN && EXPERIMENTAL
+	tristate "Blackfin serial port support"
+	depends on BFIN
 	select SERIAL_CORE
 	select SERIAL_BFIN_UART0 if (BF531 || BF532 || BF533 || BF561)
 	help
@@ -525,7 +525,7 @@ config SERIAL_BFIN_CONSOLE
 	select SERIAL_CORE_CONSOLE
 
 choice
-	prompt  "Blackfin UART Mode"
+	prompt "UART Mode"
 	depends on SERIAL_BFIN
 	default SERIAL_BFIN_DMA
 	help
@@ -533,14 +533,14 @@ choice
 	  of CPUs
 
 config SERIAL_BFIN_DMA
-	bool "Blackfin UART DMA mode"
+	bool "DMA mode"
 	depends on DMA_UNCACHED_1M
 	help
 	  This driver works under DMA mode. If this option is selected, the
 	  blackfin simple dma driver is also enabled.
 
 config SERIAL_BFIN_PIO
-	bool "Blackfin UART PIO mode"
+	bool "PIO mode"
 	help
 	  This driver works under PIO mode.
 
@@ -577,7 +577,7 @@ config UART0_RTS_PIN
 
 config SERIAL_BFIN_UART1
 	bool "Enable UART1"
-	depends on SERIAL_BFIN && BF537
+	depends on SERIAL_BFIN && (BF534 || BF536 || BF537)
 	help
 	  Enable UART1
 
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
blackfin-arch.patch
driver_bfin_serial_core.patch
blackfin-serial-core-driver-uart1-should-depend-on-bf534-bf536-bf537-remove-experimental-marking-from-on-chip-serial-core-driver-and-make-options-less-wordy.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
move-die-notifier-handling-to-common-code-fix.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
