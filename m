From: akpm@osdl.org
Subject: + mxser_new-fix-non-pci-build.patch added to -mm tree
Date: Tue, 12 Dec 2006 16:46:45 -0800
Message-ID: <200612130046.kBD0kjq3022940@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34226 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964850AbWLMAqr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 19:46:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     mxser_new: fix non-PCI build
has been added to the -mm tree.  Its filename is
     mxser_new-fix-non-pci-build.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mxser_new: fix non-PCI build
From: Jiri Slaby <jirislaby@gmail.com>

When CONFIG_PCI is not defined (i.e.  PCI bus is disabled), the mxser_new
driver fails to link, since some pci functions are not available.  Fix this
behaviour to be able to compile this driver on machines with no PCI bus
(but with ISA bus support).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/Kconfig     |    2 +-
 drivers/char/mxser_new.c |    8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff -puN drivers/char/Kconfig~mxser_new-fix-non-pci-build drivers/char/Kconfig
--- a/drivers/char/Kconfig~mxser_new-fix-non-pci-build
+++ a/drivers/char/Kconfig
@@ -203,7 +203,7 @@ config MOXA_SMARTIO
 
 config MOXA_SMARTIO_NEW
 	tristate "Moxa SmartIO support v. 2.0 (EXPERIMENTAL)"
-	depends on SERIAL_NONSTANDARD
+	depends on SERIAL_NONSTANDARD && (PCI || EISA || ISA)
 	help
 	  Say Y here if you have a Moxa SmartIO multiport serial card and/or
 	  want to help develop a new version of this driver.
diff -puN drivers/char/mxser_new.c~mxser_new-fix-non-pci-build drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~mxser_new-fix-non-pci-build
+++ a/drivers/char/mxser_new.c
@@ -315,6 +315,7 @@ static struct mxser_mon_ext mon_data_ext
 static int mxser_set_baud_method[MXSER_PORTS + 1];
 static spinlock_t gm_lock;
 
+#ifdef CONFIG_PCI
 static int CheckIsMoxaMust(int io)
 {
 	u8 oldmcr, hwid;
@@ -337,6 +338,7 @@ static int CheckIsMoxaMust(int io)
 	}
 	return MOXA_OTHER_UART;
 }
+#endif
 
 static void process_txrx_fifo(struct mxser_port *info)
 {
@@ -2380,9 +2382,11 @@ static void mxser_release_res(struct mxs
 	if (irq)
 		free_irq(brd->irq, brd);
 	if (pdev != NULL) {	/* PCI */
+#ifdef CONFIG_PCI
 		pci_release_region(pdev, 2);
 		pci_release_region(pdev, 3);
 		pci_dev_put(pdev);
+#endif
 	} else {
 		release_region(brd->ports[0].ioaddr, 8 * brd->info->nports);
 		release_region(brd->vector, 1);
@@ -2546,6 +2550,7 @@ static int __init mxser_get_ISA_conf(int
 static int __devinit mxser_probe(struct pci_dev *pdev,
 		const struct pci_device_id *ent)
 {
+#ifdef CONFIG_PCI
 	struct mxser_board *brd;
 	unsigned int i, j;
 	unsigned long ioaddress;
@@ -2644,6 +2649,9 @@ err_relio:
 	brd->info = NULL;
 err:
 	return retval;
+#else
+	return -ENODEV;
+#endif
 }
 
 static void __devexit mxser_remove(struct pci_dev *pdev)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
isicom-fix-build-with-pci-disabled.patch
mxser_new-fix-non-pci-build.patch

