From: akpm@linux-foundation.org
Subject: - 8250_hp300-coding-style.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:12:56 -0800
Message-ID: <200802082012.m18KCbEQ010218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51906 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752459AbYBHUwL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:52:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     8250_hp300: coding style
has been removed from the -mm tree.  Its filename was
     8250_hp300-coding-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 8250_hp300: coding style
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_hp300.c |   35 ++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff -puN drivers/serial/8250_hp300.c~8250_hp300-coding-style drivers/serial/8250_hp300.c
--- a/drivers/serial/8250_hp300.c~8250_hp300-coding-style
+++ a/drivers/serial/8250_hp300.c
@@ -36,7 +36,7 @@ static struct hp300_port *hp300_ports;
 #ifdef CONFIG_HPDCA
 
 static int __devinit hpdca_init_one(struct dio_dev *d,
-                                const struct dio_device_id *ent);
+					const struct dio_device_id *ent);
 static void __devexit hpdca_remove_one(struct dio_dev *d);
 
 static struct dio_device_id hpdca_dio_tbl[] = {
@@ -85,7 +85,7 @@ extern int hp300_uart_scode;
 
 #ifdef CONFIG_SERIAL_8250_CONSOLE
 /*
- * Parse the bootinfo to find descriptions for headless console and 
+ * Parse the bootinfo to find descriptions for headless console and
  * debug serial ports and register them with the 8250 driver.
  * This function should be called before serial_console_init() is called
  * to make sure the serial console will be available for use. IA-64 kernel
@@ -126,13 +126,11 @@ int __init hp300_setup_serial_console(vo
 		printk(KERN_WARNING "Serial console is APCI but support is disabled (CONFIG_HPAPCI)!\n");
 		return 0;
 #endif
-	}
-	else {
+	} else {
 #ifdef CONFIG_HPDCA
 		unsigned long pa = dio_scodetophysaddr(scode);
-		if (!pa) {
+		if (!pa)
 			return 0;
-		}
 
 		printk(KERN_INFO "Serial console is HP DCA at select code %d\n", scode);
 
@@ -145,26 +143,23 @@ int __init hp300_setup_serial_console(vo
 		/* Enable board-interrupts */
 		out_8(pa + DIO_VIRADDRBASE + DCA_IC, DCA_IC_IE);
 
-		if (DIO_ID(pa + DIO_VIRADDRBASE) & 0x80) {
+		if (DIO_ID(pa + DIO_VIRADDRBASE) & 0x80)
 			add_preferred_console("ttyS", port.line, "9600n8");
-		}
 #else
 		printk(KERN_WARNING "Serial console is DCA but support is disabled (CONFIG_HPDCA)!\n");
 		return 0;
 #endif
 	}
 
-	if (early_serial_setup(&port) < 0) {
+	if (early_serial_setup(&port) < 0)
 		printk(KERN_WARNING "hp300_setup_serial_console(): early_serial_setup() failed.\n");
-	}
-
 	return 0;
 }
 #endif /* CONFIG_SERIAL_8250_CONSOLE */
 
 #ifdef CONFIG_HPDCA
 static int __devinit hpdca_init_one(struct dio_dev *d,
-                                const struct dio_device_id *ent)
+				const struct dio_device_id *ent)
 {
 	struct uart_port port;
 	int line;
@@ -210,7 +205,7 @@ static int __devinit hpdca_init_one(stru
 
 static int __init hp300_8250_init(void)
 {
-	static int called = 0;
+	static int called;
 #ifdef CONFIG_HPAPCI
 	int line;
 	unsigned long base;
@@ -239,13 +234,12 @@ static int __init hp300_8250_init(void)
 	 * Port 1 is either the console or the DCA.
 	 */
 	for (i = 1; i < 4; i++) {
-		/* Port 1 is the console on a 425e, on other machines it's mapped to
-		 * DCA.
+		/* Port 1 is the console on a 425e, on other machines it's
+		 * mapped to DCA.
 		 */
 #ifdef CONFIG_SERIAL_8250_CONSOLE
-		if (i == 1) {
+		if (i == 1)
 			continue;
-		}
 #endif
 
 		/* Create new serial device */
@@ -259,7 +253,8 @@ static int __init hp300_8250_init(void)
 
 		/* Memory mapped I/O */
 		uport.iotype = UPIO_MEM;
-		uport.flags = UPF_SKIP_TEST | UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF;
+		uport.flags = UPF_SKIP_TEST | UPF_SHARE_IRQ \
+			      | UPF_BOOT_AUTOCONF;
 		/* XXX - no interrupt support yet */
 		uport.irq = 0;
 		uport.uartclk = HPAPCI_BAUD_BASE * 16;
@@ -270,8 +265,8 @@ static int __init hp300_8250_init(void)
 		line = serial8250_register_port(&uport);
 
 		if (line < 0) {
-			printk(KERN_NOTICE "8250_hp300: register_serial() APCI %d"
-			       " irq %d failed\n", i, uport.irq);
+			printk(KERN_NOTICE "8250_hp300: register_serial() APCI"
+			       " %d irq %d failed\n", i, uport.irq);
 			kfree(port);
 			continue;
 		}
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
hci_ldisc-fix-null-pointer-deref.patch
parisc-new-termios-definitions.patch
git-sh.patch
git-watchdog.patch
