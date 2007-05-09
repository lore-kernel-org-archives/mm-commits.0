From: akpm@linux-foundation.org
Subject: - char-cyclades-tty_register_device-separately-for-each-device.patch removed from -mm tree
Date: Tue, 08 May 2007 19:57:13 -0700
Message-ID: <200705090257.l492vDja010156@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032710AbXEIC5R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:57:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, tty_register_device separately for each device
has been removed from the -mm tree.  Its filename was
     char-cyclades-tty_register_device-separately-for-each-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
