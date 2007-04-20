From: akpm@linux-foundation.org
Subject: + char-cyclades-tty_register_device-separately-for-each-device.patch added to -mm tree
Date: Thu, 19 Apr 2007 21:54:07 -0700
Message-ID: <200704200454.l3K4s7GJ007162@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422797AbXDTEyK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 00:54:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, tty_register_device separately for each device
has been added to the -mm tree.  Its filename is
     char-cyclades-tty_register_device-separately-for-each-device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, tty_register_device separately for each device
From: Jiri Slaby <jirislaby@gmail.com>

Do not register all tty devices at the init time, delay it for the time until
some device is found.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff -puN drivers/char/cyclades.c~char-cyclades-tty_register_device-separately-for-each-device drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-tty_register_device-separately-for-each-device
+++ a/drivers/char/cyclades.c
@@ -4841,6 +4841,9 @@ static int __init cy_detect_isa(void)
 			cy_isa_irq);
 		printk("%d channels starting from port %d.\n",
 			cy_isa_nchan, cy_next_channel);
+		for (j = cy_next_channel;
+				j < cy_next_channel + cy_isa_nchan; j++)
+			tty_register_device(cy_serial_driver, j, NULL);
 		cy_next_channel += cy_isa_nchan;
 	}
 	return nboard;
@@ -4948,6 +4951,8 @@ static int __devinit cy_init_Ze(unsigned
 
 	printk("%d channels starting from port %d.\n",
 		cy_pci_nchan, cy_next_channel);
+	for (j = cy_next_channel; j < cy_next_channel + cy_pci_nchan; j++)
+		tty_register_device(cy_serial_driver, j, &pdev->dev);
 	cy_next_channel += cy_pci_nchan;
 
 	return 0;
@@ -5115,6 +5120,9 @@ static int __devinit cy_pci_probe(struct
 			(int)cy_pci_irq);
 		printk("%d channels starting from port %d.\n",
 			cy_pci_nchan, cy_next_channel);
+		for (j = cy_next_channel;
+				j < cy_next_channel + cy_pci_nchan; j++)
+			tty_register_device(cy_serial_driver, j, &pdev->dev);
 
 		cy_next_channel += cy_pci_nchan;
 	} else if (device_id == PCI_DEVICE_ID_CYCLOM_Z_Lo) {
@@ -5282,6 +5290,9 @@ static int __devinit cy_pci_probe(struct
 
 		printk("%d channels starting from port %d.\n",
 				cy_pci_nchan, cy_next_channel);
+		for (j = cy_next_channel;
+				j < cy_next_channel + cy_pci_nchan; j++)
+			tty_register_device(cy_serial_driver, j, &pdev->dev);
 		cy_next_channel += cy_pci_nchan;
 	}
 
@@ -5346,6 +5357,9 @@ static void __devexit cy_pci_release(str
 		cy_port[i].line = -1;
 		cy_port[i].magic = -1;
 	}
+	for (i = cinfo->first_line; i < cinfo->first_line +
+			cinfo->nports; i++)
+		tty_unregister_device(cy_serial_driver, i);
 #endif
 }
 
@@ -5479,7 +5493,7 @@ static int __init cy_init(void)
 	cy_serial_driver->init_termios = tty_std_termios;
 	cy_serial_driver->init_termios.c_cflag =
 	    B9600 | CS8 | CREAD | HUPCL | CLOCAL;
-	cy_serial_driver->flags = TTY_DRIVER_REAL_RAW;
+	cy_serial_driver->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
 	tty_set_operations(cy_serial_driver, &cy_ops);
 
 	retval = tty_register_driver(cy_serial_driver);
@@ -5555,6 +5569,10 @@ static void __exit cy_cleanup_module(voi
 #endif /* CONFIG_CYZ_INTR */
 				)
 				free_irq(cy_card[i].irq, &cy_card[i]);
+			for (e1 = cy_card[i].first_line;
+					e1 < cy_card[i].first_line +
+					cy_card[i].nports; e1++)
+				tty_unregister_device(cy_serial_driver, e1);
 		}
 	}
 } /* cy_cleanup_module */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

acpi-asus_acpi-support-f2je-model.patch
char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
char-cyclades-remove-pause.patch
char-cyclades-cy_readx-writex-cleanup.patch
char-cyclades-timer-cleanup.patch
char-cyclades-remove-volatiles.patch
char-cyclades-remove-useless-casts.patch
char-cyclades-create-cy_init_ze.patch
char-cyclades-use-pci_iomap-unmap.patch
char-cyclades-init-ze-immediately.patch
char-cyclades-create-cy_pci_probe.patch
char-cyclades-move-card-entries-init-into-function.patch
char-cyclades-init-card-struct-immediately.patch
char-cyclades-remove-some-global-vars.patch
char-cyclades-cy_init-error-handling.patch
char-cyclades-tty_register_device-separately-for-each-device.patch
char-cyclades-clear-interrupts-before-releasing.patch
char-cyclades-allow-debug_shirq.patch
shrink_slab-handle-bad-shrinkers.patch
