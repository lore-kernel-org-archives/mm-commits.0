From: akpm@linux-foundation.org
Subject: + char-cyclades-use-is_cyc_z-macro.patch added to -mm tree
Date: Thu, 03 May 2007 23:45:17 -0700
Message-ID: <200705040645.l446jHw9030856@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767705AbXEDGpV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 02:45:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, use IS_CYC_Z macro
has been added to the -mm tree.  Its filename is
     char-cyclades-use-is_cyc_z-macro.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, use IS_CYC_Z macro
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-use-is_cyc_z-macro drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-use-is_cyc_z-macro
+++ a/drivers/char/cyclades.c
@@ -3616,11 +3616,6 @@ static int cy_tiocmget(struct tty_struct
 			((status & CyCTS) ? TIOCM_CTS : 0);
 	} else {
 		base_addr = cy_card[card].base_addr;
-
-		if (cy_card[card].num_chips != -1) {
-			return -EINVAL;
-		}
-
 		firm_id = cy_card[card].base_addr + ID_ADDRESS;
 		if (ISZLOADED(cy_card[card])) {
 			zfw_ctrl = cy_card[card].base_addr +
@@ -4513,7 +4508,7 @@ static void __devinit cy_init_card(struc
 	unsigned short chip_number;
 	int index, port;
 
-	if (cinfo->num_chips == -1) {	/* Cyclades-Z */
+	if (IS_CYC_Z(*cinfo)) {	/* Cyclades-Z */
 		mailbox = readl(&((struct RUNTIME_9060 __iomem *)
 				     cinfo->ctl_addr)->mail_box_0);
 		nports = (mailbox == ZE_V1) ? ZE_V1_NPORTS : 8;
@@ -5346,12 +5341,12 @@ static void __devexit cy_pci_release(str
 	unsigned int i;
 
 	/* non-Z with old PLX */
-	if (cinfo->num_chips != -1 && (readb(cinfo->base_addr + CyPLX_VER) &
-				0x0f) == PLX_9050)
+	if (!IS_CYC_Z(*cinfo) && (readb(cinfo->base_addr + CyPLX_VER) & 0x0f) ==
+			PLX_9050)
 		cy_writeb(cinfo->ctl_addr + 0x4c, 0);
 	else
 #ifndef CONFIG_CYZ_INTR
-		if (cinfo->num_chips != -1)
+		if (!IS_CYC_Z(*cinfo))
 #endif
 		cy_writew(cinfo->ctl_addr + 0x68,
 				readw(cinfo->ctl_addr + 0x68) & ~0x0900);
@@ -5361,7 +5356,7 @@ static void __devexit cy_pci_release(str
 		pci_iounmap(pdev, cinfo->ctl_addr);
 	if (cinfo->irq
 #ifndef CONFIG_CYZ_INTR
-		&& cinfo->num_chips != -1 /* not a Z card */
+		&& !IS_CYC_Z(*cinfo)
 #endif /* CONFIG_CYZ_INTR */
 		)
 		free_irq(cinfo->irq, cinfo);
@@ -5582,7 +5577,7 @@ static void __exit cy_cleanup_module(voi
 				iounmap(cy_card[i].ctl_addr);
 			if (cy_card[i].irq
 #ifndef CONFIG_CYZ_INTR
-				&& cy_card[i].num_chips != -1 /* not a Z card */
+				&& !IS_CYC_Z(cy_card[i])
 #endif /* CONFIG_CYZ_INTR */
 				)
 				free_irq(cy_card[i].irq, &cy_card[i]);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

serial-serial_core-use-pr_debug.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
drivers-char-use-__set_current_state.patch
misc-add-sensable-phantom-driver.patch
misc-add-sensable-phantom-driver-v3.patch
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
char-mxser-schedule-for-removal.patch
char-isicom-use-pr_debug.patch
char-cyclades-use-is_cyc_z-macro.patch
char-cyclades-switch-to-pci-probing.patch
char-cyclades-depends-on-pci-or-isa.patch
char-cyclades-unexport-struct-cyclades_card.patch
char-cyclades-remove-useless-fileds-from-cyclades_card.patch
char-cyclades-irq-is-int.patch
char-cyclades-printk-cleanups.patch
char-cyclades-mark-cyy_init_card-as-__devinit-not-__init.patch
char-cyclades-simplify-variables-initialization.patch
char-cyclades-get-rid-of-phys-addresses.patch
char-cyclades-make-info-card-a-pointer.patch
char-cyclades-remove-sleep_on.patch
char-cyclades-fix-blockmove.patch
char-cyclades-timers-cleanup.patch
char-cyclades-remove-unused-timestamps.patch
char-cyclades-remove-locking-macros.patch
char-cyclades-conditions-cleanup.patch
char-cyclades-fix-tty-device-unregister.patch
char-cyclades-dynamic-ports.patch
char-cyclades-probe-cleanup.patch
char-cyclades-copyright-and-version-changes.patch
shrink_slab-handle-bad-shrinkers.patch
