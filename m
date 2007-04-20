From: akpm@linux-foundation.org
Subject: + char-cyclades-init-card-struct-immediately.patch added to -mm tree
Date: Thu, 19 Apr 2007 21:54:03 -0700
Message-ID: <200704200454.l3K4s3DA007153@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422708AbXDTEyG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 00:54:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, init card struct immediately
has been added to the -mm tree.  Its filename is
     char-cyclades-init-card-struct-immediately.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, init card struct immediately
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-init-card-struct-immediately drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-init-card-struct-immediately
+++ a/drivers/char/cyclades.c
@@ -4834,6 +4834,7 @@ static int __init cy_detect_isa(void)
 		cy_card[j].bus_index = 0;
 		cy_card[j].first_line = cy_next_channel;
 		cy_card[j].num_chips = cy_isa_nchan / 4;
+		cy_init_card(&cy_card[j], j);
 		nboard++;
 
 		/* print message */
@@ -4931,6 +4932,7 @@ static int __devinit cy_init_Ze(unsigned
 	cy_card[j].first_line = cy_next_channel;
 	cy_card[j].num_chips = -1;
 	cy_card[j].pdev = pdev;
+	cy_init_card(&cy_card[j], j);
 	pci_set_drvdata(pdev, &cy_card[j]);
 
 	/* print message */
@@ -5080,6 +5082,7 @@ static int __devinit cy_pci_probe(struct
 		cy_card[j].first_line = cy_next_channel;
 		cy_card[j].num_chips = cy_pci_nchan / 4;
 		cy_card[j].pdev = pdev;
+		cy_init_card(&cy_card[j], j);
 		pci_set_drvdata(pdev, &cy_card[j]);
 
 		/* enable interrupts in the PCI interface */
@@ -5263,6 +5266,7 @@ static int __devinit cy_pci_probe(struct
 		cy_card[j].first_line = cy_next_channel;
 		cy_card[j].num_chips = -1;
 		cy_card[j].pdev = pdev;
+		cy_init_card(&cy_card[j], j);
 		pci_set_drvdata(pdev, &cy_card[j]);
 
 		/* print message */
@@ -5327,6 +5331,7 @@ static void __devexit cy_pci_release(str
 {
 #ifdef CONFIG_PCI
 	struct cyclades_card *cinfo = pci_get_drvdata(pdev);
+	unsigned int i;
 
 	pci_iounmap(pdev, cinfo->base_addr);
 	if (cinfo->ctl_addr)
@@ -5340,6 +5345,10 @@ static void __devexit cy_pci_release(str
 	pci_release_regions(pdev);
 
 	cinfo->base_addr = NULL;
+	for (i = cinfo->first_line; i < cinfo->first_line + cinfo->nports; i++){
+		cy_port[i].line = -1;
+		cy_port[i].magic = -1;
+	}
 #endif
 }
 
@@ -5483,6 +5492,12 @@ static int __init cy_init(void)
 		cy_card[i].base_addr = NULL;
 	}
 
+	/* invalidate remaining cy_port structures */
+	for (i = 0; i < NR_PORTS; i++) {
+		cy_port[i].line = -1;
+		cy_port[i].magic = -1;
+	}
+
 	/* the code below is responsible to find the boards. Each different
 	   type of board has its own detection routine. If a board is found,
 	   the next cy_card structure available is set by the detection
@@ -5498,29 +5513,7 @@ static int __init cy_init(void)
 
 	cy_nboard = cy_isa_nboard + cy_pci_nboard;
 
-	/* invalidate remaining cy_card structures */
-	for (i = 0; i < NR_CARDS; i++) {
-		if (cy_card[i].base_addr == 0) {
-			cy_card[i].first_line = -1;
-			cy_card[i].ctl_addr = NULL;
-			cy_card[i].irq = 0;
-			cy_card[i].bus_index = 0;
-			cy_card[i].first_line = 0;
-			cy_card[i].num_chips = 0;
-		}
-	}
-	/* invalidate remaining cy_port structures */
-	for (i = cy_next_channel; i < NR_PORTS; i++) {
-		cy_port[i].line = -1;
-		cy_port[i].magic = -1;
-	}
-
-	/* initialize per-port data structures for each valid board found */
-	for (i = 0; i < cy_nboard; i++)
-		cy_init_card(&cy_card[i], i);
-
 	return 0;
-
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
