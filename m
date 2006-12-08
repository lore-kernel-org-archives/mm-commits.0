From: akpm@osdl.org
Subject: - char-isicom-expand-function.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:08:33 -0800
Message-ID: <200612082008.kB8K8XMI002614@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58263 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946235AbWLHUIn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:08:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Char: isicom, expand function
has been removed from the -mm tree.  Its filename was
     char-isicom-expand-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: isicom, expand function
From: Jiri Slaby <jirislaby@gmail.com>

Simple functions (those, that calls reuest_irq, request_region et al) may be
expanded directly in code.  It makes probe function more readable and
transparent.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/isicom.c |  151 +++++++++++-----------------------------
 1 file changed, 44 insertions(+), 107 deletions(-)

diff -puN drivers/char/isicom.c~char-isicom-expand-function drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-expand-function
+++ a/drivers/char/isicom.c
@@ -1520,37 +1520,6 @@ static void isicom_flush_buffer(struct t
  * Driver init and deinit functions
  */
 
-static int __devinit isicom_register_ioregion(struct pci_dev *pdev,
-	const unsigned int index)
-{
-	struct isi_board *board = pci_get_drvdata(pdev);
-
-	if (!board->base)
-		return -EINVAL;
-
-	if (!request_region(board->base, 16, ISICOM_NAME)) {
-		dev_dbg(&pdev->dev, "I/O Region 0x%lx-0x%lx is busy. Card%d "
-			"will be disabled.\n", board->base, board->base + 15,
-			index + 1);
-		return -EBUSY;
- 	}
-
-	return 0;
-}
-
-static void isicom_unregister_ioregion(struct pci_dev *pdev)
-{
-	struct isi_board *board = pci_get_drvdata(pdev);
-
-	if (!board->base)
-		return;
-
-	release_region(board->base, 16);
-	dev_dbg(&pdev->dev, "I/O Region 0x%lx-0x%lx released.\n",
-		board->base, board->base + 15);
-	board->base = 0;
-}
-
 static const struct tty_operations isicom_ops = {
 	.open			= isicom_open,
 	.close			= isicom_close,
@@ -1571,70 +1540,6 @@ static const struct tty_operations isico
 	.tiocmset		= isicom_tiocmset,
 };
 
-static int __devinit isicom_register_tty_driver(void)
-{
-	int error = -ENOMEM;
-
-	/* tty driver structure initialization */
-	isicom_normal = alloc_tty_driver(PORT_COUNT);
-	if (!isicom_normal)
-		goto end;
-
-	isicom_normal->owner			= THIS_MODULE;
-	isicom_normal->name 			= "ttyM";
-	isicom_normal->major			= ISICOM_NMAJOR;
-	isicom_normal->minor_start		= 0;
-	isicom_normal->type			= TTY_DRIVER_TYPE_SERIAL;
-	isicom_normal->subtype			= SERIAL_TYPE_NORMAL;
-	isicom_normal->init_termios		= tty_std_termios;
-	isicom_normal->init_termios.c_cflag	= B9600 | CS8 | CREAD | HUPCL |
-		CLOCAL;
-	isicom_normal->flags			= TTY_DRIVER_REAL_RAW;
-	tty_set_operations(isicom_normal, &isicom_ops);
-
-	if ((error = tty_register_driver(isicom_normal))) {
-		pr_dbg("Couldn't register the dialin driver, error=%d\n",
-			error);
-		put_tty_driver(isicom_normal);
-	}
-end:
-	return error;
-}
-
-static void isicom_unregister_tty_driver(void)
-{
-	int error;
-
-	if ((error = tty_unregister_driver(isicom_normal)))
-		pr_dbg("couldn't unregister normal driver, error=%d.\n", error);
-
-	put_tty_driver(isicom_normal);
-}
-
-static int __devinit isicom_register_isr(struct pci_dev *pdev,
-	const unsigned int index)
-{
-	struct isi_board *board = pci_get_drvdata(pdev);
-	unsigned long irqflags = IRQF_DISABLED;
-	int retval = -EINVAL;
-
-	if (!board->base)
-		goto end;
-
-	if (board->isa == NO)
-		irqflags |= IRQF_SHARED;
-
-	retval = request_irq(board->irq, isicom_interrupt, irqflags,
-		ISICOM_NAME, board);
-	if (retval < 0)
-		dev_warn(&pdev->dev, "Could not install handler at Irq %d. "
-			"Card%d will be disabled.\n", board->irq, index + 1);
- 	else
-		retval = 0;
-end:
-	return retval;
-}
-
 static int __devinit reset_card(struct pci_dev *pdev,
 	const unsigned int card, unsigned int *signature)
 {
@@ -1913,13 +1818,21 @@ static int __devinit isicom_probe(struct
 
 	pci_set_drvdata(pdev, board);
 
-	retval = isicom_register_ioregion(pdev, index);
-	if (retval < 0)
+	if (!request_region(board->base, 16, ISICOM_NAME)) {
+		dev_err(&pdev->dev, "I/O Region 0x%lx-0x%lx is busy. Card%d "
+			"will be disabled.\n", board->base, board->base + 15,
+			index + 1);
+		retval = -EBUSY;
 		goto err;
+ 	}
 
-	retval = isicom_register_isr(pdev, index);
-	if (retval < 0)
+	retval = request_irq(board->irq, isicom_interrupt,
+			IRQF_SHARED | IRQF_DISABLED, ISICOM_NAME, board);
+	if (retval < 0) {
+		dev_err(&pdev->dev, "Could not install handler at Irq %d. "
+			"Card%d will be disabled.\n", board->irq, index + 1);
 		goto errunrr;
+	}
 
 	retval = reset_card(pdev, index, &signature);
 	if (retval < 0)
@@ -1934,7 +1847,7 @@ static int __devinit isicom_probe(struct
 errunri:
 	free_irq(board->irq, board);
 errunrr:
-	isicom_unregister_ioregion(pdev);
+	release_region(board->base, 16);
 err:
 	board->base = 0;
 	return retval;
@@ -1945,7 +1858,7 @@ static void __devexit isicom_remove(stru
 	struct isi_board *board = pci_get_drvdata(pdev);
 
 	free_irq(board->irq, board);
-	isicom_unregister_ioregion(pdev);
+	release_region(board->base, 16);
 }
 
 static int __devinit isicom_setup(void)
@@ -1991,14 +1904,35 @@ static int __devinit isicom_setup(void)
 				"Disabling Card%d...\n", irq[idx], idx + 1);
 	}
 
-	retval = isicom_register_tty_driver();
-	if (retval < 0)
+	/* tty driver structure initialization */
+	isicom_normal = alloc_tty_driver(PORT_COUNT);
+	if (!isicom_normal) {
+		retval = -ENOMEM;
 		goto error;
+	}
+
+	isicom_normal->owner			= THIS_MODULE;
+	isicom_normal->name 			= "ttyM";
+	isicom_normal->major			= ISICOM_NMAJOR;
+	isicom_normal->minor_start		= 0;
+	isicom_normal->type			= TTY_DRIVER_TYPE_SERIAL;
+	isicom_normal->subtype			= SERIAL_TYPE_NORMAL;
+	isicom_normal->init_termios		= tty_std_termios;
+	isicom_normal->init_termios.c_cflag	= B9600 | CS8 | CREAD | HUPCL |
+		CLOCAL;
+	isicom_normal->flags			= TTY_DRIVER_REAL_RAW;
+	tty_set_operations(isicom_normal, &isicom_ops);
+
+	retval = tty_register_driver(isicom_normal);
+	if (retval) {
+		pr_dbg("Couldn't register the dialin driver\n");
+		goto err_puttty;
+	}
 
 	retval = pci_register_driver(&isicom_driver);
 	if (retval < 0) {
 		printk(KERN_ERR "ISICOM: Unable to register pci driver.\n");
-		goto errtty;
+		goto err_unrtty;
 	}
 
 	init_timer(&tx);
@@ -2009,8 +1943,10 @@ static int __devinit isicom_setup(void)
 	add_timer(&tx);
 
 	return 0;
-errtty:
-	isicom_unregister_tty_driver();
+err_unrtty:
+	tty_unregister_driver(isicom_normal);
+err_puttty:
+	put_tty_driver(isicom_normal);
 error:
 	return retval;
 }
@@ -2025,7 +1961,8 @@ static void __exit isicom_exit(void)
 		msleep(10);
 
 	pci_unregister_driver(&isicom_driver);
-	isicom_unregister_tty_driver();
+	tty_unregister_driver(isicom_normal);
+	put_tty_driver(isicom_normal);
 }
 
 module_init(isicom_setup);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-isicom-expand-function.patch
char-isicom-rename-init-function.patch
char-isicom-remove-isa-code.patch
char-isicom-remove-unneeded-memset.patch
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

