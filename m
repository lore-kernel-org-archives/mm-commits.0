From: akpm@linux-foundation.org
Subject: + char-cyclades-clear-interrupts-before-releasing.patch added to -mm tree
Date: Thu, 19 Apr 2007 21:54:09 -0700
Message-ID: <200704200454.l3K4s9w5007170@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422808AbXDTEyM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 00:54:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, clear interrupts before releasing
has been added to the -mm tree.  Its filename is
     char-cyclades-clear-interrupts-before-releasing.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, clear interrupts before releasing
From: Jiri Slaby <jirislaby@gmail.com>

Without this patch, the driver sometimes causes "IRQXX: Nobody cares".  Fix it
by turning off irqs when releasing.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN drivers/char/cyclades.c~char-cyclades-clear-interrupts-before-releasing drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-clear-interrupts-before-releasing
+++ a/drivers/char/cyclades.c
@@ -5341,6 +5341,17 @@ static void __devexit cy_pci_release(str
 	struct cyclades_card *cinfo = pci_get_drvdata(pdev);
 	unsigned int i;
 
+	/* non-Z with old PLX */
+	if (cinfo->num_chips != -1 && (readb(cinfo->base_addr + CyPLX_VER) &
+				0x0f) == PLX_9050)
+		cy_writeb(cinfo->ctl_addr + 0x4c, 0);
+	else
+#ifndef CONFIG_CYZ_INTR
+		if (cinfo->num_chips != -1)
+#endif
+		cy_writew(cinfo->ctl_addr + 0x68,
+				readw(cinfo->ctl_addr + 0x68) & ~0x0900);
+
 	pci_iounmap(pdev, cinfo->base_addr);
 	if (cinfo->ctl_addr)
 		pci_iounmap(pdev, cinfo->ctl_addr);
@@ -5560,6 +5571,8 @@ static void __exit cy_cleanup_module(voi
 				cy_pci_release(cy_card[i].pdev);
 				continue;
 			}
+			/* clear interrupt */
+			cy_writeb(cy_card[i].base_addr + Cy_ClrIntr, 0);
 			iounmap(cy_card[i].base_addr);
 			if (cy_card[i].ctl_addr)
 				iounmap(cy_card[i].ctl_addr);
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
