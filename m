From: akpm@linux-foundation.org
Subject: + atmel_serial-use-container_of-instead-of-direct-cast.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:18:11 -0800
Message-ID: <200801270518.m0R5I8ws031174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34061 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961AbYA0FST (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:18:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hskinnemoen@atmel.com, linux@maxim.org.za, marc.pignat@hevs.ch


The patch titled
     atmel_serial: use container_of instead of direct cast
has been added to the -mm tree.  Its filename is
     atmel_serial-use-container_of-instead-of-direct-cast.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_serial: use container_of instead of direct cast
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

As pointed out by David Brownell, we really ought to be using container_of
when converting from "struct uart_port *" to "struct atmel_uart_port *".

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>
Tested-by: Marc Pignat <marc.pignat@hevs.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |   40 ++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-use-container_of-instead-of-direct-cast drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-use-container_of-instead-of-direct-cast
+++ a/drivers/serial/atmel_serial.c
@@ -157,17 +157,23 @@ static struct atmel_uart_port atmel_port
 static struct console atmel_console;
 #endif
 
+static inline struct atmel_uart_port *
+to_atmel_uart_port(struct uart_port *uart)
+{
+	return container_of(uart, struct atmel_uart_port, uart);
+}
+
 #ifdef CONFIG_SERIAL_ATMEL_PDC
 static bool atmel_use_dma_rx(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	return atmel_port->use_dma_rx;
 }
 
 static bool atmel_use_dma_tx(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	return atmel_port->use_dma_tx;
 }
@@ -330,7 +336,7 @@ static void
 atmel_buffer_rx_char(struct uart_port *port, unsigned int status,
 		     unsigned int ch)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	struct circ_buf *ring = &atmel_port->rx_ring;
 	struct atmel_uart_char *c;
 
@@ -374,7 +380,7 @@ static void atmel_pdc_rxerr(struct uart_
  */
 static void atmel_rx_chars(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	unsigned int status, ch;
 
 	status = UART_GET_CSR(port);
@@ -454,7 +460,7 @@ static void atmel_tx_chars(struct uart_p
 static void
 atmel_handle_receive(struct uart_port *port, unsigned int pending)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	if (atmel_use_dma_rx(port)) {
 		/*
@@ -495,7 +501,7 @@ atmel_handle_receive(struct uart_port *p
 static void
 atmel_handle_transmit(struct uart_port *port, unsigned int pending)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	if (atmel_use_dma_tx(port)) {
 		/* PDC transmit */
@@ -519,7 +525,7 @@ static void
 atmel_handle_status(struct uart_port *port, unsigned int pending,
 		    unsigned int status)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	if (pending & (ATMEL_US_RIIC | ATMEL_US_DSRIC | ATMEL_US_DCDIC
 				| ATMEL_US_CTSIC)) {
@@ -555,7 +561,7 @@ static irqreturn_t atmel_interrupt(int i
  */
 static void atmel_tx_dma(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	struct circ_buf *xmit = &port->info->xmit;
 	struct atmel_dma_buffer *pdc = &atmel_port->pdc_tx;
 	int count;
@@ -601,7 +607,7 @@ static void atmel_tx_dma(struct uart_por
 
 static void atmel_rx_from_ring(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	struct circ_buf *ring = &atmel_port->rx_ring;
 	unsigned int flg;
 	unsigned int status;
@@ -669,7 +675,7 @@ static void atmel_rx_from_ring(struct ua
 
 static void atmel_rx_from_dma(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	struct tty_struct *tty = port->info->tty;
 	struct atmel_dma_buffer *pdc;
 	int rx_idx = atmel_port->pdc_rx_idx;
@@ -743,7 +749,7 @@ static void atmel_rx_from_dma(struct uar
 static void atmel_tasklet_func(unsigned long data)
 {
 	struct uart_port *port = (struct uart_port *)data;
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	unsigned int status;
 	unsigned int status_change;
 
@@ -788,7 +794,7 @@ static void atmel_tasklet_func(unsigned 
  */
 static int atmel_startup(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	int retval;
 
 	/*
@@ -898,7 +904,7 @@ static int atmel_startup(struct uart_por
  */
 static void atmel_shutdown(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	/*
 	 * Ensure everything is stopped.
 	 */
@@ -955,7 +961,7 @@ static void atmel_shutdown(struct uart_p
 static void atmel_serial_pm(struct uart_port *port, unsigned int state,
 			    unsigned int oldstate)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	switch (state) {
 	case 0:
@@ -1427,7 +1433,7 @@ static int atmel_serial_suspend(struct p
 				pm_message_t state)
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	if (device_may_wakeup(&pdev->dev)
 	    && !at91_suspend_entering_slow_clock())
@@ -1443,7 +1449,7 @@ static int atmel_serial_suspend(struct p
 static int atmel_serial_resume(struct platform_device *pdev)
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	if (atmel_port->suspended) {
 		uart_resume_port(&atmel_uart, port);
@@ -1502,7 +1508,7 @@ err_alloc_ring:
 static int __devexit atmel_serial_remove(struct platform_device *pdev)
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	int ret = 0;
 
 	device_init_wakeup(&pdev->dev, 0);
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

git-avr32.patch
fix-timerfd-breakage-on-avr32-was-re-fix-variable-use-in-avr32-pte_alloc_one.patch
git-mtd.patch
gpiolib-add-drivers-gpio-directory.patch
gpiolib-add-gpio-provider-infrastructure.patch
gpiolib-update-documentation-gpiotxt.patch
gpiolib-pxa-platform-support.patch
gpiolib-pcf857x-i2c-gpio-expander-support.patch
gpiolib-mcp23s08-spi-gpio-expander-support.patch
gpiolib-pca9539-i2c-gpio-expander-support.patch
gpiolib-deprecate-obsolete-pca9539-driver.patch
gpiolib-avr32-at32ap-platform-support.patch
config_highpte-vs-sub-page-page-tables-avr32-fix.patch
read_current_time-cleanups.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
atmel_spi-throughput-improvement.patch
atmel_spi-chain-dma-transfers.patch
atmel_spi-chain-dma-transfers-update.patch
atmel_spi-fix-dmachain-oops-with-debug-enabled.patch
add-have_oprofile.patch
atmel_lcdfb-validate-display-timings.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-avr32.patch
tty-let-architectures-override-the-user-kernel-macros.patch
maintainers-add-haavard-as-maintainer-of-the-atmel_serial-driver.patch
atmel_serial-clean-up-the-code.patch
atmel_serial-use-cpu_relax-when-busy-waiting.patch
atmel_serial-use-existing-console-options-only-if-brg-is-running.patch
atmel_serial-fix-bugs-in-probe-error-path-and-remove.patch
atmel_serial-split-the-interrupt-handler.patch
atmel_serial-add-dma-support.patch
atmel_serial-use-container_of-instead-of-direct-cast.patch
atmel_serial-show-tty-name-in-proc-interrupts.patch
