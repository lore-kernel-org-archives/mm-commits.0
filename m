From: akpm@linux-foundation.org
Subject: + char-cyclades-cy_init-error-handling.patch added to -mm tree
Date: Thu, 19 Apr 2007 21:54:05 -0700
Message-ID: <200704200454.l3K4s5O3007159@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422813AbXDTEyI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 00:54:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, cy_init error handling
has been added to the -mm tree.  Its filename is
     char-cyclades-cy_init-error-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, cy_init error handling
From: Jiri Slaby <jirislaby@gmail.com>

- do not panic if tty_register_driver fails
- handle fail paths properly

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-cy_init-error-handling drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-cy_init-error-handling
+++ a/drivers/char/cyclades.c
@@ -5460,10 +5460,11 @@ static const struct tty_operations cy_op
 static int __init cy_init(void)
 {
 	unsigned int i, nboards;
+	int retval = -ENOMEM;
 
 	cy_serial_driver = alloc_tty_driver(NR_PORTS);
 	if (!cy_serial_driver)
-		return -ENOMEM;
+		goto err;
 	show_version();
 
 	/* Initialize the tty_driver structure */
@@ -5481,8 +5482,11 @@ static int __init cy_init(void)
 	cy_serial_driver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(cy_serial_driver, &cy_ops);
 
-	if (tty_register_driver(cy_serial_driver))
-		panic("Couldn't register Cyclades serial driver\n");
+	retval = tty_register_driver(cy_serial_driver);
+	if (retval) {
+		printk(KERN_ERR "Couldn't register Cyclades serial driver\n");
+		goto err_frtty;
+	}
 
 	for (i = 0; i < NR_CARDS; i++) {
 		/* base_addr=0 indicates board not found */
@@ -5508,7 +5512,18 @@ static int __init cy_init(void)
 	/* look for pci boards */
 	nboards += cy_detect_pci();
 
-	return nboards ? 0 : -ENODEV;
+	if (nboards == 0) {
+		retval = -ENODEV;
+		goto err_unr;
+	}
+
+	return 0;
+err_unr:
+	tty_unregister_driver(cy_serial_driver);
+err_frtty:
+	put_tty_driver(cy_serial_driver);
+err:
+	return retval;
 }				/* cy_init */
 
 static void __exit cy_cleanup_module(void)
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
