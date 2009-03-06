From: akpm@linux-foundation.org
Subject: [merged] input-keyboard-hilkbdc-fix-crash-when-removing-hilkbd-module.patch removed from -mm tree
Date: Fri, 06 Mar 2009 11:28:15 -0800
Message-ID: <200903061928.n26JSFd7022665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754752AbZCFTaH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 14:30:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deller@gmx.de, elendil@planet.nl, geert@linux-m68k.org, grundler@parisc-linux.org, kyle@mcmartin.ca, mm-commits@vger.kernel.org


The patch titled
     input/keyboard/hilkbd.c: fix crash when removing hilkbd module
has been removed from the -mm tree.  Its filename was
     input-keyboard-hilkbdc-fix-crash-when-removing-hilkbd-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input/keyboard/hilkbd.c: fix crash when removing hilkbd module
From: Helge Deller <deller@gmx.de>

On parisc machines, which don't have HIL, removing the hilkbd module
panics the kernel.  Fix this by adding proper implementations for the
probe and remove functions to the parisc_driver structure.

A few functions were renamed to clean up the code and make it easier
readable.

Disable the MODULE_DEVICE_TABLE() macro on parisc since the kernel module
autoloader should instead prefer the hp_sdc driver which takes care of
full HIL support, including HIL mouse and HIL tablets.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Frans Pop <elendil@planet.nl>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/hilkbd.c |   63 ++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 20 deletions(-)

diff -puN drivers/input/keyboard/hilkbd.c~input-keyboard-hilkbdc-fix-crash-when-removing-hilkbd-module drivers/input/keyboard/hilkbd.c
--- a/drivers/input/keyboard/hilkbd.c~input-keyboard-hilkbdc-fix-crash-when-removing-hilkbd-module
+++ a/drivers/input/keyboard/hilkbd.c
@@ -198,9 +198,8 @@ static void hil_do(unsigned char cmd, un
 }
 
 
-/* initialise HIL */
-static int __init
-hil_keyb_init(void)
+/* initialize HIL */
+static int __init hil_keyb_init(void)
 {
 	unsigned char c;
 	unsigned int i, kbid;
@@ -308,13 +307,39 @@ err1:
 	return err;
 }
 
+static void __exit hil_keyb_exit(void)
+{
+	/* exit if there is no HIL keyboard */
+	if (!hil_dev.dev)
+		return;
+
+	if (HIL_IRQ) {
+		disable_irq(HIL_IRQ);
+		free_irq(HIL_IRQ, hil_dev.dev_id);
+	}
+
+	/* Turn off interrupts */
+	hil_do(HIL_INTOFF, NULL, 0);
+
+	input_unregister_device(hil_dev.dev);
+
+	hil_dev.dev = NULL;
+
+#if defined(CONFIG_HP300)
+	release_region(HILBASE+HIL_DATA, 2);
+#endif
+}
 
 #if defined(CONFIG_PARISC)
-static int __init
-hil_init_chip(struct parisc_device *dev)
+static int __init hil_probe_chip(struct parisc_device *dev)
 {
+	/* Only allow one HIL keyboard */
+	if (hil_dev.dev)
+		return -ENODEV;
+
 	if (!dev->irq) {
-		printk(KERN_WARNING "HIL: IRQ not found for HIL bus at 0x%08lx\n", dev->hpa.start);
+		printk(KERN_WARNING "HIL: IRQ not found for HIL bus at 0x%p\n",
+			(void *)dev->hpa.start);
 		return -ENODEV;
 	}
 
@@ -327,17 +352,27 @@ hil_init_chip(struct parisc_device *dev)
 	return hil_keyb_init();
 }
 
+static int __exit hil_remove_chip(struct parisc_device *dev)
+{
+	hil_keyb_exit();
+	return 0;
+}
+
 static struct parisc_device_id hil_tbl[] = {
 	{ HPHW_FIO, HVERSION_REV_ANY_ID, HVERSION_ANY_ID, 0x00073 },
 	{ 0, }
 };
 
+#if 0
+/* Disabled to avoid conflicts with the HP SDC HIL drivers */
 MODULE_DEVICE_TABLE(parisc, hil_tbl);
+#endif
 
 static struct parisc_driver hil_driver = {
 	.name =		"hil",
 	.id_table =	hil_tbl,
-	.probe =	hil_init_chip,
+	.probe =	hil_probe_chip,
+	.remove =	hil_remove_chip,
 };
 #endif /* CONFIG_PARISC */
 
@@ -354,22 +389,10 @@ static int __init hil_init(void)
 
 static void __exit hil_exit(void)
 {
-	if (HIL_IRQ) {
-		disable_irq(HIL_IRQ);
-		free_irq(HIL_IRQ, hil_dev.dev_id);
-	}
-
-	/* Turn off interrupts */
-	hil_do(HIL_INTOFF, NULL, 0);
-
-	input_unregister_device(hil_dev.dev);
-
-	hil_dev.dev = NULL;
