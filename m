From: akpm@linux-foundation.org
Subject: - atmel_serial-use-container_of-instead-of-direct-cast.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:18:45 -0800
Message-ID: <200802082018.m18KIQs0010924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49360 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753855AbYBHVCU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:02:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, linux@maxim.org.za, marc.pignat@hevs.ch, mm-commits@vger.kernel.org


The patch titled
     atmel_serial: use container_of instead of direct cast
has been removed from the -mm tree.  Its filename was
     atmel_serial-use-container_of-instead-of-direct-cast.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -153,17 +153,23 @@ static struct atmel_uart_port atmel_port
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
@@ -326,7 +332,7 @@ static void
 atmel_buffer_rx_char(struct uart_port *port, unsigned int status,
 		     unsigned int ch)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	struct circ_buf *ring = &atmel_port->rx_ring;
 	struct atmel_uart_char *c;
 
@@ -370,7 +376,7 @@ static void atmel_pdc_rxerr(struct uart_
  */
 static void atmel_rx_chars(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	unsigned int status, ch;
 
 	status = UART_GET_CSR(port);
@@ -450,7 +456,7 @@ static void atmel_tx_chars(struct uart_p
 static void
 atmel_handle_receive(struct uart_port *port, unsigned int pending)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	if (atmel_use_dma_rx(port)) {
 		/*
@@ -491,7 +497,7 @@ atmel_handle_receive(struct uart_port *p
 static void
 atmel_handle_transmit(struct uart_port *port, unsigned int pending)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	if (atmel_use_dma_tx(port)) {
 		/* PDC transmit */
@@ -515,7 +521,7 @@ static void
 atmel_handle_status(struct uart_port *port, unsigned int pending,
 		    unsigned int status)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	if (pending & (ATMEL_US_RIIC | ATMEL_US_DSRIC | ATMEL_US_DCDIC
 				| ATMEL_US_CTSIC)) {
@@ -551,7 +557,7 @@ static irqreturn_t atmel_interrupt(int i
  */
 static void atmel_tx_dma(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	struct circ_buf *xmit = &port->info->xmit;
 	struct atmel_dma_buffer *pdc = &atmel_port->pdc_tx;
 	int count;
@@ -593,7 +599,7 @@ static void atmel_tx_dma(struct uart_por
 
 static void atmel_rx_from_ring(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	struct circ_buf *ring = &atmel_port->rx_ring;
 	unsigned int flg;
 	unsigned int status;
@@ -661,7 +667,7 @@ static void atmel_rx_from_ring(struct ua
 
 static void atmel_rx_from_dma(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	struct tty_struct *tty = port->info->tty;
 	struct atmel_dma_buffer *pdc;
 	int rx_idx = atmel_port->pdc_rx_idx;
@@ -741,7 +747,7 @@ static void atmel_rx_from_dma(struct uar
 static void atmel_tasklet_func(unsigned long data)
 {
 	struct uart_port *port = (struct uart_port *)data;
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	unsigned int status;
 	unsigned int status_change;
 
@@ -786,7 +792,7 @@ static void atmel_tasklet_func(unsigned 
  */
 static int atmel_startup(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	int retval;
 
 	/*
@@ -896,7 +902,7 @@ static int atmel_startup(struct uart_por
  */
 static void atmel_shutdown(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	/*
 	 * Ensure everything is stopped.
 	 */
@@ -953,7 +959,7 @@ static void atmel_shutdown(struct uart_p
 static void atmel_serial_pm(struct uart_port *port, unsigned int state,
 			    unsigned int oldstate)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	switch (state) {
 	case 0:
@@ -1425,7 +1431,7 @@ static int atmel_serial_suspend(struct p
 				pm_message_t state)
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	if (device_may_wakeup(&pdev->dev)
 	    && !at91_suspend_entering_slow_clock())
@@ -1441,7 +1447,7 @@ static int atmel_serial_suspend(struct p
 static int atmel_serial_resume(struct platform_device *pdev)
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	if (atmel_port->suspended) {
 		uart_resume_port(&atmel_uart, port);
@@ -1501,7 +1507,7 @@ err_alloc_ring:
 static int __devexit atmel_serial_remove(struct platform_device *pdev)
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	int ret = 0;
 
 	device_init_wakeup(&pdev->dev, 0);
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
git-avr32.patch
