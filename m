From: akpm@osdl.org
Subject: - sx-fix-non-pci-build.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:05:57 -0800
Message-ID: <200612140606.kBE65vnD001857@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51867 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbWLNGGT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:06:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sx: fix non-PCI build
has been removed from the -mm tree.  Its filename was
     sx-fix-non-pci-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sx: fix non-PCI build
From: Jiri Slaby <jirislaby@gmail.com>

When CONFIG_PCI is not defined (i.e.  PCI bus is disabled), the sx driver
fails to link, since some pci functions are not available.  Fix this
behaviour to be able to compile this driver on machines with no PCI bus
(but with ISA bus support).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/Kconfig |    2 +-
 drivers/char/sx.c    |    8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff -puN drivers/char/Kconfig~sx-fix-non-pci-build drivers/char/Kconfig
--- a/drivers/char/Kconfig~sx-fix-non-pci-build
+++ a/drivers/char/Kconfig
@@ -312,7 +312,7 @@ config SPECIALIX_RTSCTS
 
 config SX
 	tristate "Specialix SX (and SI) card support"
-	depends on SERIAL_NONSTANDARD
+	depends on SERIAL_NONSTANDARD && (PCI || EISA || ISA)
 	help
 	  This is a driver for the SX and SI multiport serial cards.
 	  Please read the file <file:Documentation/sx.txt> for details.
diff -puN drivers/char/sx.c~sx-fix-non-pci-build drivers/char/sx.c
--- a/drivers/char/sx.c~sx-fix-non-pci-build
+++ a/drivers/char/sx.c
@@ -2498,8 +2498,10 @@ static void __devexit sx_remove_card(str
 		/* It is safe/allowed to del_timer a non-active timer */
 		del_timer(&board->timer);
 		if (pdev) {
+#ifdef CONFIG_PCI
 			pci_iounmap(pdev, board->base);
 			pci_release_region(pdev, IS_CF_BOARD(board) ? 3 : 2);
+#endif
 		} else {
 			iounmap(board->base);
 			release_region(board->hw_base, board->hw_len);
@@ -2601,6 +2603,7 @@ static struct eisa_driver sx_eisadriver 
 
 #endif
 
+#ifdef CONFIG_PCI
  /******************************************************** 
  * Setting bit 17 in the CNTRL register of the PLX 9050  * 
  * chip forces a retry on writes while a read is pending.*
@@ -2632,10 +2635,12 @@ static void __devinit fix_sx_pci(struct 
 	}
 	iounmap(rebase);
 }
+#endif
 
 static int __devinit sx_pci_probe(struct pci_dev *pdev,
 				  const struct pci_device_id *ent)
 {
+#ifdef CONFIG_PCI
 	struct sx_board *board;
 	unsigned int i, reg;
 	int retval = -EIO;
@@ -2700,6 +2705,9 @@ err_flag:
 	board->flags &= ~SX_BOARD_PRESENT;
 err:
 	return retval;
+#else
+	return -ENODEV;
+#endif
 }
 
 static void __devexit sx_pci_remove(struct pci_dev *pdev)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch

