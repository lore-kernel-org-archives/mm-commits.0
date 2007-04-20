From: akpm@linux-foundation.org
Subject: + char-cyclades-remove-some-global-vars.patch added to -mm tree
Date: Thu, 19 Apr 2007 21:54:04 -0700
Message-ID: <200704200454.l3K4s4LH007156@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422692AbXDTEyH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 00:54:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, remove some global vars
has been added to the -mm tree.  Its filename is
     char-cyclades-remove-some-global-vars.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, remove some global vars
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-remove-some-global-vars drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-remove-some-global-vars
+++ a/drivers/char/cyclades.c
@@ -818,9 +818,6 @@ static int cy_chip_offset[] = { 0x0000,
 
 /* PCI related definitions */
 
-static unsigned short cy_pci_nboard;
-static unsigned short cy_isa_nboard;
-static unsigned short cy_nboard;
 #ifdef CONFIG_PCI
 static struct pci_device_id cy_pci_dev_id[] __devinitdata = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_Y_Lo) },	/* PCI < 1Mb */
@@ -5462,7 +5459,7 @@ static const struct tty_operations cy_op
 
 static int __init cy_init(void)
 {
-	unsigned int i;
+	unsigned int i, nboards;
 
 	cy_serial_driver = alloc_tty_driver(NR_PORTS);
 	if (!cy_serial_driver)
@@ -5506,14 +5503,12 @@ static int __init cy_init(void)
 	   the cy_next_channel. */
 
 	/* look for isa boards */
-	cy_isa_nboard = cy_detect_isa();
+	nboards = cy_detect_isa();
 
 	/* look for pci boards */
-	cy_pci_nboard = cy_detect_pci();
-
-	cy_nboard = cy_isa_nboard + cy_pci_nboard;
+	nboards += cy_detect_pci();
 
-	return 0;
+	return nboards ? 0 : -ENODEV;
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
