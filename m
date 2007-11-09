From: akpm@linux-foundation.org
Subject: + atmel_serial-build-warnings-begone.patch added to -mm tree
Date: Fri, 09 Nov 2007 13:56:07 -0800
Message-ID: <200711092156.lA9Lu7qS001264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49038 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750923AbXKIV4k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 16:56:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, andrew@sanpeople.com, dbrownell@users.sourceforge.net, hskinnemoen@atmel.com


The patch titled
     atmel_serial build warnings begone
has been added to the -mm tree.  Its filename is
     atmel_serial-build-warnings-begone.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atmel_serial build warnings begone
From: David Brownell <david-b@pacbell.net>

Remove annoying build warnings about unused variables in atmel_serial,
which afflict both AT91 and AVR32 builds.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
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

rtc_hctosys-expects-rtcs-in-utc-doc.patch
rtcs-handle-nvram-better.patch
rtc-ds1307-exports-nvram.patch
rtc-tweak-driver-documentation-for-rtc-periodic.patch
spi-fix-double-free-on-spi_unregister_master.patch
spi-fix-error-paths-on-txx9spi_probe.patch
atmel_serial-build-warnings-begone.patch
rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch
git-arm-master.patch
usb-s3c2410_udc-minor-irq-handler-cleanups.patch
rtc-release-correct-region-in-error-path.patch
rtc-fallback-to-requesting-only-the-ports-we-actually-use.patch
tle62x0-driver-stops-ignoring-read-errors.patch
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
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch
