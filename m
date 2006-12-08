From: akpm@osdl.org
Subject: - char-isicom-move-to-tty_register_device.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:08:41 -0800
Message-ID: <200612082008.kB8K8fiZ002629@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58302 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946250AbWLHUIx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:08:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Char: isicom, move to tty_register_device
has been removed from the -mm tree.  Its filename was
     char-isicom-move-to-tty_register_device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: isicom, move to tty_register_device
From: Jiri Slaby <jirislaby@gmail.com>

Instead of registering all devices in register_tty_driver, register devices in
probe function and register only port_count devices.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/isicom.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN drivers/char/isicom.c~char-isicom-move-to-tty_register_device drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-move-to-tty_register_device
+++ a/drivers/char/isicom.c
@@ -195,6 +195,7 @@ struct	isi_board {
 	signed char		count;
 	spinlock_t		card_lock; /* Card wide lock 11/5/00 -sameer */
 	unsigned long		flags;
+	unsigned int		index;
 };
 
 struct	isi_port {
@@ -1781,6 +1782,7 @@ static int __devinit isicom_probe(struct
 			break;
 		}
 
+	board->index = index;
 	board->base = ioaddr;
 	board->irq = pciirq;
 	card++;
@@ -1811,6 +1813,10 @@ static int __devinit isicom_probe(struct
 	if (retval < 0)
 		goto errunri;
 
+	for (index = 0; index < board->port_count; index++)
+		tty_register_device(isicom_normal, board->index * 16 + index,
+				&pdev->dev);
+
 	return 0;
 
 errunri:
@@ -1825,6 +1831,10 @@ err:
 static void __devexit isicom_remove(struct pci_dev *pdev)
 {
 	struct isi_board *board = pci_get_drvdata(pdev);
+	unsigned int i;
+
+	for (i = 0; i < board->port_count; i++)
+		tty_unregister_device(isicom_normal, board->index * 16 + i);
 
 	free_irq(board->irq, board);
 	release_region(board->base, 16);
@@ -1874,7 +1884,8 @@ static int __init isicom_init(void)
 	isicom_normal->init_termios		= tty_std_termios;
 	isicom_normal->init_termios.c_cflag	= B9600 | CS8 | CREAD | HUPCL |
 		CLOCAL;
-	isicom_normal->flags			= TTY_DRIVER_REAL_RAW;
+	isicom_normal->flags			= TTY_DRIVER_REAL_RAW |
+		TTY_DRIVER_DYNAMIC_DEV;
 	tty_set_operations(isicom_normal, &isicom_ops);
 
 	retval = tty_register_driver(isicom_normal);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-isicom-move-to-tty_register_device.patch
char-isicom-use-pci_request_region.patch
char-isicom-check-kmalloc-retval.patch
char-isicom-use-completion.patch
char-isicom-simplify-timer.patch
char-isicom-remove-cvs-stuff.patch
char-isicom-fix-tty-index-check.patch
char-sx-convert-to-pci-probing.patch
char-sx-use-kcalloc.patch
char-sx-mark-functions-as-devinit.patch
char-sx-use-eisa-probing.patch
char-sx-ifdef-isa-code.patch
char-sx-lock-boards-struct.patch
char-sx-remove-duplicite-code.patch
char-sx-whitespace-cleanup.patch
char-sx-simplify-timer-logic.patch
char-sx-fix-return-in-module-init.patch
char-sx-use-pci_iomap.patch
char-sx-request-regions.patch
char-stallion-convert-to-pci-probing.patch
char-stallion-prints-cleanup.patch
char-stallion-implement-fail-paths.patch
char-stallion-correct-__init-macros.patch
char-stallion-functions-cleanup.patch
char-stallion-fix-fail-paths.patch
char-stallion-brd-struct-locking.patch
char-stallion-remove-syntactic-sugar.patch
char-stallion-variables-cleanup.patch
char-stallion-use-dynamic-dev.patch
char-istallion-convert-to-pci-probing.patch
char-istallion-remove-the-mess.patch
char-istallion-eliminate-typedefs.patch
char-istallion-variables-cleanup.patch
char-istallion-ifdef-eisa-code.patch
char-istallion-brdnr-locking.patch
char-istallion-free-only-isa.patch
char-istallion-correct-fail-paths.patch
char-istallion-fix-enabling.patch
char-istallion-move-init-and-exit-code.patch
char-istallion-change-init-sequence.patch
char-istallion-dynamic-tty-device.patch
char-istallion-use-mod_timer.patch
char-cyclades-save-indent-levels.patch
char-cyclades-lindent-the-code.patch
char-cyclades-cleanup.patch
char-cyclades-fix-warnings.patch

