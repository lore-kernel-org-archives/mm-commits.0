From: akpm@linux-foundation.org
Subject: + synclink_gt-use-dynamic-tty-device-registration.patch added to -mm tree
Date: Thu, 03 May 2007 00:05:34 -0700
Message-ID: <200705030705.l4375YLk006884@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755218AbXECHGH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 03:06:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulkf@microgate.com


The patch titled
     synclink_gt use dynamic tty device registration
has been added to the -mm tree.  Its filename is
     synclink_gt-use-dynamic-tty-device-registration.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: synclink_gt use dynamic tty device registration
From: Paul Fulghum <paulkf@microgate.com>

Change synclink_gt driver to use dynamic tty device registration.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink_gt.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff -puN drivers/char/synclink_gt.c~synclink_gt-use-dynamic-tty-device-registration drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink_gt-use-dynamic-tty-device-registration
+++ a/drivers/char/synclink_gt.c
@@ -3415,6 +3415,9 @@ static void device_init(int adapter_num,
 			}
 		}
 	}
+
+	for (i=0; i < port_count; ++i)
+		tty_register_device(serial_driver, port_array[i]->line, &(port_array[i]->pdev->dev));
 }
 
 static int __devinit init_one(struct pci_dev *dev,
@@ -3466,6 +3469,8 @@ static void slgt_cleanup(void)
 	printk("unload %s %s\n", driver_name, driver_version);
 
 	if (serial_driver) {
+		for (info=slgt_device_list ; info != NULL ; info=info->next_device)
+			tty_unregister_device(serial_driver, info->line);
 		if ((rc = tty_unregister_driver(serial_driver)))
 			DBGERR(("tty_unregister_driver error=%d\n", rc));
 		put_tty_driver(serial_driver);
@@ -3506,23 +3511,10 @@ static int __init slgt_init(void)
 
  	printk("%s %s\n", driver_name, driver_version);
 
-	slgt_device_count = 0;
-	if ((rc = pci_register_driver(&pci_driver)) < 0) {
-		printk("%s pci_register_driver error=%d\n", driver_name, rc);
-		return rc;
-	}
-	pci_registered = 1;
-
-	if (!slgt_device_list) {
-		printk("%s no devices found\n",driver_name);
-		pci_unregister_driver(&pci_driver);
-		return -ENODEV;
-	}
-
 	serial_driver = alloc_tty_driver(MAX_DEVICES);
 	if (!serial_driver) {
-		rc = -ENOMEM;
-		goto error;
+		printk("%s can't allocate tty driver\n", driver_name);
+		return -ENOMEM;
 	}
 
 	/* Initialize the tty_driver structure */
@@ -3539,7 +3531,7 @@ static int __init slgt_init(void)
 		B9600 | CS8 | CREAD | HUPCL | CLOCAL;
 	serial_driver->init_termios.c_ispeed = 9600;
 	serial_driver->init_termios.c_ospeed = 9600;
-	serial_driver->flags = TTY_DRIVER_REAL_RAW;
+	serial_driver->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
 	tty_set_operations(serial_driver, &ops);
 	if ((rc = tty_register_driver(serial_driver)) < 0) {
 		DBGERR(("%s can't register serial driver\n", driver_name));
@@ -3552,6 +3544,16 @@ static int __init slgt_init(void)
 		driver_name, driver_version,
 		serial_driver->major);
 
+	slgt_device_count = 0;
+	if ((rc = pci_register_driver(&pci_driver)) < 0) {
+		printk("%s pci_register_driver error=%d\n", driver_name, rc);
+		goto error;
+	}
+	pci_registered = 1;
+
+	if (!slgt_device_list)
+		printk("%s no devices found\n",driver_name);
+
 	return 0;
 
 error:
_

Patches currently in -mm which might be from paulkf@microgate.com are

drivers-char-synclinkc-check-kmalloc-return-value.patch
synclink_gt-use-dynamic-tty-device-registration.patch
