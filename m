From: akpm@osdl.org
Subject: + serial-serial_txx9-driver-update.patch added to -mm tree
Date: Thu, 21 Dec 2006 12:53:13 -0800
Message-ID: <200612212053.kBLKrDM0004566@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:39463 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423089AbWLUUxS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 15:53:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp


The patch titled
     serial: serial_txx9 driver update
has been added to the -mm tree.  Its filename is
     serial-serial_txx9-driver-update.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: serial_txx9 driver update
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Update the serial_txx9 driver.

 * Configurable manumum port number. (SERIAL_TXX9_NR_UARTS)
 * Remove some code which is unneeded if CONFIG_PM=n.
 * Use PCI_DEVICE() for pci device id table and make it const.
 * Do not include <asm/irq.h>

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/serial/Kconfig       |    5 +++++
 drivers/serial/serial_txx9.c |   23 +++++++++++------------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff -puN drivers/serial/Kconfig~serial-serial_txx9-driver-update drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~serial-serial_txx9-driver-update
+++ a/drivers/serial/Kconfig
@@ -916,6 +916,11 @@ config SERIAL_TXX9
 config HAS_TXX9_SERIAL
 	bool
 
+config SERIAL_TXX9_NR_UARTS
+	int "Maximum number of TMPTX39XX/49XX SIO ports"
+	depends on SERIAL_TXX9
+	default "6"
+
 config SERIAL_TXX9_CONSOLE
 	bool "TMPTX39XX/49XX SIO Console support"
 	depends on SERIAL_TXX9=y
diff -puN drivers/serial/serial_txx9.c~serial-serial_txx9-driver-update drivers/serial/serial_txx9.c
--- a/drivers/serial/serial_txx9.c~serial-serial_txx9-driver-update
+++ a/drivers/serial/serial_txx9.c
@@ -37,6 +37,7 @@
  *	1.06	Do not insert a char caused previous overrun.
  *		Fix some spin_locks.
  *		Do not call uart_add_one_port for absent ports.
+ *	1.07	Use CONFIG_SERIAL_TXX9_NR_UARTS.  Cleanup.
  */
 
 #if defined(CONFIG_SERIAL_TXX9_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
@@ -58,9 +59,8 @@
 #include <linux/mutex.h>
 
 #include <asm/io.h>
-#include <asm/irq.h>
 
-static char *serial_version = "1.06";
+static char *serial_version = "1.07";
 static char *serial_name = "TX39/49 Serial driver";
 
 #define PASS_LIMIT	256
@@ -88,12 +88,7 @@ static char *serial_name = "TX39/49 Seri
 /*
  * Number of serial ports
  */
-#ifdef ENABLE_SERIAL_TXX9_PCI
-#define NR_PCI_BOARDS	4
-#define UART_NR  (4 + NR_PCI_BOARDS)
-#else
-#define UART_NR  4
-#endif
+#define UART_NR  CONFIG_SERIAL_TXX9_NR_UARTS
 
 #define HIGH_BITS_OFFSET	((sizeof(long)-sizeof(int))*8)
 
@@ -987,6 +982,7 @@ int __init early_serial_txx9_setup(struc
 }
 
 #ifdef ENABLE_SERIAL_TXX9_PCI
+#ifdef CONFIG_PM
 /**
  *	serial_txx9_suspend_port - suspend one serial port
  *	@line:  serial line number
@@ -1008,6 +1004,7 @@ static void serial_txx9_resume_port(int 
 {
 	uart_resume_port(&serial_txx9_reg, &serial_txx9_ports[line].port);
 }
+#endif
 
 static DEFINE_MUTEX(serial_txx9_mutex);
 
@@ -1118,6 +1115,7 @@ static void __devexit pciserial_txx9_rem
 	}
 }
 
+#ifdef CONFIG_PM
 static int pciserial_txx9_suspend_one(struct pci_dev *dev, pm_message_t state)
 {
 	int line = (int)(long)pci_get_drvdata(dev);
@@ -1142,11 +1140,10 @@ static int pciserial_txx9_resume_one(str
 	}
 	return 0;
 }
+#endif
 
-static struct pci_device_id serial_txx9_pci_tbl[] = {
-	{	PCI_VENDOR_ID_TOSHIBA_2, PCI_DEVICE_ID_TOSHIBA_TC86C001_MISC,
-		PCI_ANY_ID, PCI_ANY_ID,
-		0, 0, 0 },
+static const struct pci_device_id serial_txx9_pci_tbl[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA_2, PCI_DEVICE_ID_TOSHIBA_TC86C001_MISC) },
 	{ 0, }
 };
 
@@ -1154,8 +1151,10 @@ static struct pci_driver serial_txx9_pci
 	.name		= "serial_txx9",
 	.probe		= pciserial_txx9_init_one,
 	.remove		= __devexit_p(pciserial_txx9_remove_one),
+#ifdef CONFIG_PM
 	.suspend	= pciserial_txx9_suspend_one,
 	.resume		= pciserial_txx9_resume_one,
+#endif
 	.id_table	= serial_txx9_pci_tbl,
 };
 
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

serial-serial_txx9-driver-update.patch

