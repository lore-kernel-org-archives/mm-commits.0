From: akpm@linux-foundation.org
Subject: - blackfin-remove-__function__-in-new-serial-driver.patch removed from -mm tree
Date: Sat, 06 Dec 2008 16:05:28 -0800
Message-ID: <200812070005.mB705S8L021401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753542AbYLGAFt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 19:05:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, alan@redhat.com, bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     blackfin: remove __FUNCTION__ in new serial driver
has been removed from the -mm tree.  Its filename was
     blackfin-remove-__function__-in-new-serial-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin: remove __FUNCTION__ in new serial driver
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Bryan Wu <bryan.wu@analog.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/bfin_sport_uart.c |   60 ++++++++++++++---------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff -puN drivers/serial/bfin_sport_uart.c~blackfin-remove-__function__-in-new-serial-driver drivers/serial/bfin_sport_uart.c
--- a/drivers/serial/bfin_sport_uart.c~blackfin-remove-__function__-in-new-serial-driver
+++ a/drivers/serial/bfin_sport_uart.c
@@ -99,7 +99,7 @@ static void sport_stop_tx(struct uart_po
 
 static inline void tx_one_byte(struct sport_uart_port *up, unsigned int value)
 {
-	pr_debug("%s value:%x\n", __FUNCTION__, value);
+	pr_debug("%s value:%x\n", __func__, value);
 	/* Place a Start and Stop bit */
 	__asm__ volatile (
 		"R2 = b#01111111100;\n\t"
@@ -110,7 +110,7 @@ static inline void tx_one_byte(struct sp
 		:"=r"(value)
 		:"0"(value)
 		:"R2", "R3");
-	pr_debug("%s value:%x\n", __FUNCTION__, value);
+	pr_debug("%s value:%x\n", __func__, value);
 
 	SPORT_PUT_TX(up, value);
 }
@@ -120,7 +120,7 @@ static inline unsigned int rx_one_byte(s
 	unsigned int value, extract;
 
 	value = SPORT_GET_RX32(up);
-	pr_debug("%s value:%x\n", __FUNCTION__, value);
+	pr_debug("%s value:%x\n", __func__, value);
 
 	/* Extract 8 bits data */
 	__asm__ volatile (
@@ -151,12 +151,12 @@ static int sport_uart_setup(struct sport
 	/* Set TCR1 and TCR2 */
 	SPORT_PUT_TCR1(up, (LTFS | ITFS | TFSR | TLSBIT | ITCLK));
 	SPORT_PUT_TCR2(up, 10);
-	pr_debug("%s TCR1:%x, TCR2:%x\n", __FUNCTION__, SPORT_GET_TCR1(up), SPORT_GET_TCR2(up));
+	pr_debug("%s TCR1:%x, TCR2:%x\n", __func__, SPORT_GET_TCR1(up), SPORT_GET_TCR2(up));
 
 	/* Set RCR1 and RCR2 */
 	SPORT_PUT_RCR1(up, (RCKFE | LARFS | LRFS | RFSR | IRCLK));
 	SPORT_PUT_RCR2(up, 28);
-	pr_debug("%s RCR1:%x, RCR2:%x\n", __FUNCTION__, SPORT_GET_RCR1(up), SPORT_GET_RCR2(up));
+	pr_debug("%s RCR1:%x, RCR2:%x\n", __func__, SPORT_GET_RCR1(up), SPORT_GET_RCR2(up));
 
 	tclkdiv = sclk/(2 * baud_rate) - 1;
 	tfsdiv = 12;
@@ -166,7 +166,7 @@ static int sport_uart_setup(struct sport
 	SPORT_PUT_RCLKDIV(up, rclkdiv);
 	SSYNC();
 	pr_debug("%s sclk:%d, baud_rate:%d, tclkdiv:%d, tfsdiv:%d, rclkdiv:%d\n",
-			__FUNCTION__, sclk, baud_rate, tclkdiv, tfsdiv, rclkdiv);
+			__func__, sclk, baud_rate, tclkdiv, tfsdiv, rclkdiv);
 
 	return 0;
 }
@@ -231,7 +231,7 @@ static int sport_startup(struct uart_por
 	char buffer[20];
 	int retval;
 
-	pr_debug("%s enter\n", __FUNCTION__);
+	pr_debug("%s enter\n", __func__);
 	memset(buffer, 20, '\0');
 	snprintf(buffer, 20, "%s rx", up->name);
 	retval = request_irq(up->rx_irq, sport_uart_rx_irq, IRQF_SAMPLE_RANDOM, buffer, up);
@@ -320,7 +320,7 @@ static unsigned int sport_tx_empty(struc
 	unsigned int stat;
 
 	stat = SPORT_GET_STAT(up);
-	pr_debug("%s stat:%04x\n", __FUNCTION__, stat);
+	pr_debug("%s stat:%04x\n", __func__, stat);
 	if (stat & TXHRE) {
 		return TIOCSER_TEMT;
 	} else
@@ -329,13 +329,13 @@ static unsigned int sport_tx_empty(struc
 
 static unsigned int sport_get_mctrl(struct uart_port *port)
 {
-	pr_debug("%s enter\n", __FUNCTION__);
+	pr_debug("%s enter\n", __func__);
 	return (TIOCM_CTS | TIOCM_CD | TIOCM_DSR);
 }
 
 static void sport_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
-	pr_debug("%s enter\n", __FUNCTION__);
+	pr_debug("%s enter\n", __func__);
 }
 
 static void sport_stop_tx(struct uart_port *port)
@@ -343,7 +343,7 @@ static void sport_stop_tx(struct uart_po
 	struct sport_uart_port *up = (struct sport_uart_port *)port;
 	unsigned int stat;
 
-	pr_debug("%s enter\n", __FUNCTION__);
+	pr_debug("%s enter\n", __func__);
 
 	stat = SPORT_GET_STAT(up);
 	while(!(stat & TXHRE)) {
@@ -366,21 +366,21 @@ static void sport_start_tx(struct uart_p
 {
 	struct sport_uart_port *up = (struct sport_uart_port *)port;
 
-	pr_debug("%s enter\n", __FUNCTION__);
+	pr_debug("%s enter\n", __func__);
 	/* Write data into SPORT FIFO before enable SPROT to transmit */
 	sport_uart_tx_chars(up);
 
 	/* Enable transmit, then an interrupt will generated */
 	SPORT_PUT_TCR1(up, (SPORT_GET_TCR1(up) | TSPEN));
 	SSYNC();
-	pr_debug("%s exit\n", __FUNCTION__);
+	pr_debug("%s exit\n", __func__);
 }
 
 static void sport_stop_rx(struct uart_port *port)
 {
 	struct sport_uart_port *up = (struct sport_uart_port *)port;
 
-	pr_debug("%s enter\n", __FUNCTION__);
+	pr_debug("%s enter\n", __func__);
 	/* Disable sport to stop rx */
 	SPORT_PUT_RCR1(up, (SPORT_GET_RCR1(up) & ~RSPEN));
 	SSYNC();
@@ -388,19 +388,19 @@ static void sport_stop_rx(struct uart_po
 
 static void sport_enable_ms(struct uart_port *port)
 {
-	pr_debug("%s enter\n", __FUNCTION__);
+	pr_debug("%s enter\n", __func__);
 }
 
 static void sport_break_ctl(struct uart_port *port, int break_state)
 {
-	pr_debug("%s enter\n", __FUNCTION__);
+	pr_debug("%s enter\n", __func__);
 }
 
 static void sport_shutdown(struct uart_port *port)
 {
 	struct sport_uart_port *up = (struct sport_uart_port *)port;
 
-	pr_debug("%s enter\n", __FUNCTION__);
+	pr_debug("%s enter\n", __func__);
 
 	/* Disable sport */
 	SPORT_PUT_TCR1(up, (SPORT_GET_TCR1(up) & ~TSPEN));
@@ -421,7 +421,7 @@ static void sport_shutdown(struct uart_p
 static void sport_set_termios(struct uart_port *port,
 		struct termios *termios, struct termios *old)
 {
-	pr_debug("%s enter, c_cflag:%08x\n", __FUNCTION__, termios->c_cflag);
+	pr_debug("%s enter, c_cflag:%08x\n", __func__, termios->c_cflag);
 	uart_update_timeout(port, CS8 ,port->uartclk);
 }
 
@@ -429,18 +429,18 @@ static const char *sport_type(struct uar
 {
 	struct sport_uart_port *up = (struct sport_uart_port *)port;
 
-	pr_debug("%s enter\n", __FUNCTION__);
+	pr_debug("%s enter\n", __func__);
 	return up->name;
 }
 
 static void sport_release_port(struct uart_port *port)
 {
-	pr_debug("%s enter\n", __FUNCTION__);
+	pr_debug("%s enter\n", __func__);
 }
 
 static int sport_request_port(struct uart_port *port)
 {
-	pr_debug("%s enter\n", __FUNCTION__);
+	pr_debug("%s enter\n", __func__);
 	return 0;
 }
 
@@ -448,13 +448,13 @@ static void sport_config_port(struct uar
 {
 	struct sport_uart_port *up = (struct sport_uart_port *)port;
 
-	pr_debug("%s enter\n", __FUNCTION__);
+	pr_debug("%s enter\n", __func__);
 	up->port.type = PORT_BFIN_SPORT;
 }
 
 static int sport_verify_port(struct uart_port *port, struct serial_struct *ser)
 {
-	pr_debug("%s enter\n", __FUNCTION__);
+	pr_debug("%s enter\n", __func__);
 	return 0;
 }
 
@@ -527,7 +527,7 @@ static int sport_uart_suspend(struct pla
 {
 	struct sport_uart_port *sport = platform_get_drvdata(dev);
 
-	pr_debug("%s enter\n", __FUNCTION__);
+	pr_debug("%s enter\n", __func__);
 	if (sport)
 		uart_suspend_port(&sport_uart_reg, &sport->port);
 
@@ -538,7 +538,7 @@ static int sport_uart_resume(struct plat
 {
 	struct sport_uart_port *sport = platform_get_drvdata(dev);
 
-	pr_debug("%s enter\n", __FUNCTION__);
+	pr_debug("%s enter\n", __func__);
 	if (sport)
 		uart_resume_port(&sport_uart_reg, &sport->port);
 
@@ -547,7 +547,7 @@ static int sport_uart_resume(struct plat
 
 static int sport_uart_probe(struct platform_device *dev)
 {
-	pr_debug("%s enter\n", __FUNCTION__);
+	pr_debug("%s enter\n", __func__);
 	sport_uart_ports[dev->id].port.dev = &dev->dev;
 	uart_add_one_port(&sport_uart_reg, &sport_uart_ports[dev->id].port);
 	platform_set_drvdata(dev, &sport_uart_ports[dev->id]);
@@ -559,7 +559,7 @@ static int sport_uart_remove(struct plat
 {
 	struct sport_uart_port *sport = platform_get_drvdata(dev);
 
-	pr_debug("%s enter\n", __FUNCTION__);
+	pr_debug("%s enter\n", __func__);
 	platform_set_drvdata(dev, NULL);
 
 	if (sport)
@@ -582,7 +582,7 @@ static int __init sport_uart_init(void)
 {
 	int ret;
 
-	pr_debug("%s enter\n", __FUNCTION__);
+	pr_debug("%s enter\n", __func__);
 	ret = uart_register_driver(&sport_uart_reg);
 	if (ret != 0) {
 		printk(KERN_ERR "Failed to register %s:%d\n",
@@ -597,13 +597,13 @@ static int __init sport_uart_init(void)
 	}
 
 
-	pr_debug("%s exit\n", __FUNCTION__);
+	pr_debug("%s exit\n", __func__);
 	return ret;
 }
 
 static void __exit sport_uart_exit(void)
 {
-	pr_debug("%s enter\n", __FUNCTION__);
+	pr_debug("%s enter\n", __func__);
 	platform_driver_unregister(&sport_uart_driver);
 	uart_unregister_driver(&sport_uart_reg);
 }
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
arm-use-the-new-byteorder-headers.patch
i2c-misannotation-in-i2c-pmcmspc.patch
i2c-trivial-endian-casting-fixes-in-i2c-highlanderc.patch
ia64-use-the-new-byteorder-headers.patch
input-ads7846c-sparse-lock-annotation.patch
input-strict_strtoul-takes-unsigned-long.patch
m32r-use-the-new-byteorder-headers.patch
blackfin-use-the-new-byteorder-headers.patch
parisc-use-the-new-byteorder-headers.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
frv-use-the-new-byteorder-headers.patch
m68knommu-use-the-new-byteorder-headers.patch
h8300-use-the-new-byteorder-headers.patch
alpha-use-the-new-byteorder-headers.patch
lib-fix-sparse-shadowed-variable-warning.patch
lib-radix_treec-make-percpu-variable-static.patch
lib-proportionsc-trivial-sparse-lock-annotation.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch
blackfin-remove-__function__-in-video-driver.patch
fb-carminefb-trivial-annotation-packing-color-register.patch
memstick-annotate-endianness-of-attribute-structs.patch
byteorder-add-load_-store_endian-api.patch
unaligned-consolidate-unaligned-headers-add-load_-store_endian_noalign.patch
unaligned-wire-up-trivial-arches-for-new-common-unaligned-header.patch
sh-wire-up-arch-overrides-for-unaligned-access-on-the-sh4a.patch
unaligned-wire-up-h8300-and-m32r-arches.patch
unaligned-wire-up-arm-arch-overrides-for-unaligned-access.patch
unaligned-remove-the-old-implementation.patch

