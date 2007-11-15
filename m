From: akpm@linux-foundation.org
Subject: - atmel_serial-build-warnings-begone.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:09:27 -0800
Message-ID: <200711152109.lAFL9RRO015445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46529 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752409AbXKOVUQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:20:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, andrew@sanpeople.com, dbrownell@users.sourceforge.net, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_serial build warnings begone
has been removed from the -mm tree.  Its filename was
     atmel_serial-build-warnings-begone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atmel_serial build warnings begone
From: David Brownell <david-b@pacbell.net>

Remove annoying build warnings about unused variables in atmel_serial,
which afflict both AT91 and AVR32 builds.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Victor <andrew@sanpeople.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-build-warnings-begone drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-build-warnings-begone
+++ a/drivers/serial/atmel_serial.c
@@ -204,8 +204,6 @@ static u_int atmel_get_mctrl(struct uart
  */
 static void atmel_stop_tx(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
-
 	UART_PUT_IDR(port, ATMEL_US_TXRDY);
 }
 
@@ -214,8 +212,6 @@ static void atmel_stop_tx(struct uart_po
  */
 static void atmel_start_tx(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
-
 	UART_PUT_IER(port, ATMEL_US_TXRDY);
 }
 
@@ -224,8 +220,6 @@ static void atmel_start_tx(struct uart_p
  */
 static void atmel_stop_rx(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
-
 	UART_PUT_IDR(port, ATMEL_US_RXRDY);
 }
 
@@ -409,7 +403,6 @@ static irqreturn_t atmel_interrupt(int i
  */
 static int atmel_startup(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
 	int retval;
 
 	/*
@@ -456,8 +449,6 @@ static int atmel_startup(struct uart_por
  */
 static void atmel_shutdown(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
-
 	/*
 	 * Disable all interrupts, port and break condition.
 	 */
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch
git-mmc.patch
usb-s3c2410_udc-minor-irq-handler-cleanups.patch
usb-device-dma-support-on-omap2.patch
rtc-convert-mutex-to-bitfield.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-pointless-casts-from-void-pointers.patch
spi-at25-driver-is-for-eeprom-not-flash.patch
spi-use-mutex-not-semaphore.patch
blackfin-spi-driver-use-cpu_relax-to-replace-continue-in-while-busywait.patch
blackfin-spi-driver-use-void-__iomem-for-regs_base.patch
blackfin-spi-driver-move-hard-coded-pin_req-to-board-file.patch
blackfin-spi-driver-reconfigure-speed_hz-and-bits_per_word-in-each-spi-transfer.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
rtc-cmos-exports-nvram-in-sysfs.patch
generic-gpio-gpio_chip-support.patch
generic-gpio-gpio_chip-support-fix.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch
