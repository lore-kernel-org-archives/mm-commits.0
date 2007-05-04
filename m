From: akpm@linux-foundation.org
Subject: + char-cyclades-remove-useless-fileds-from-cyclades_card.patch added to -mm tree
Date: Thu, 03 May 2007 23:45:25 -0700
Message-ID: <200705040645.l446jPam030868@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964784AbXEDGpa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 02:45:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, remove useless fileds from cyclades_card
has been added to the -mm tree.  Its filename is
     char-cyclades-remove-useless-fileds-from-cyclades_card.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, remove useless fileds from cyclades_card
From: Jiri Slaby <jirislaby@gmail.com>

pde, ctl_phys and base_phys are useless -- they are never used.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c  |    9 ---------
 include/linux/cyclades.h |    3 ---
 2 files changed, 12 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-remove-useless-fileds-from-cyclades_card drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-remove-useless-fileds-from-cyclades_card
+++ a/drivers/char/cyclades.c
@@ -4914,15 +4914,12 @@ static int __devinit cy_init_Ze(unsigned
 #endif				/* CONFIG_CYZ_INTR */
 
 	/* set cy_card */
-	cy_card[j].base_phys = cy_pci_phys2;
-	cy_card[j].ctl_phys = cy_pci_phys0;
 	cy_card[j].base_addr = cy_pci_addr2;
 	cy_card[j].ctl_addr = cy_pci_addr0;
 	cy_card[j].irq = (int)cy_pci_irq;
 	cy_card[j].bus_index = 1;
 	cy_card[j].first_line = cy_next_channel;
 	cy_card[j].num_chips = -1;
-	cy_card[j].pdev = pdev;
 	cy_init_card(&cy_card[j], j);
 	pci_set_drvdata(pdev, &cy_card[j]);
 
@@ -5066,15 +5063,12 @@ static int __devinit cy_pci_probe(struct
 		}
 
 		/* set cy_card */
-		cy_card[j].base_phys = (ulong) cy_pci_phys2;
-		cy_card[j].ctl_phys = (ulong) cy_pci_phys0;
 		cy_card[j].base_addr = cy_pci_addr2;
 		cy_card[j].ctl_addr = cy_pci_addr0;
 		cy_card[j].irq = (int)cy_pci_irq;
 		cy_card[j].bus_index = 1;
 		cy_card[j].first_line = cy_next_channel;
 		cy_card[j].num_chips = cy_pci_nchan / 4;
-		cy_card[j].pdev = pdev;
 		cy_init_card(&cy_card[j], j);
 		pci_set_drvdata(pdev, &cy_card[j]);
 
@@ -5253,15 +5247,12 @@ static int __devinit cy_pci_probe(struct
 #endif				/* CONFIG_CYZ_INTR */
 
 		/* set cy_card */
-		cy_card[j].base_phys = cy_pci_phys2;
-		cy_card[j].ctl_phys = cy_pci_phys0;
 		cy_card[j].base_addr = cy_pci_addr2;
 		cy_card[j].ctl_addr = cy_pci_addr0;
 		cy_card[j].irq = (int)cy_pci_irq;
 		cy_card[j].bus_index = 1;
 		cy_card[j].first_line = cy_next_channel;
 		cy_card[j].num_chips = -1;
-		cy_card[j].pdev = pdev;
 		cy_init_card(&cy_card[j], j);
 		pci_set_drvdata(pdev, &cy_card[j]);
 
diff -puN include/linux/cyclades.h~char-cyclades-remove-useless-fileds-from-cyclades_card include/linux/cyclades.h
--- a/include/linux/cyclades.h~char-cyclades-remove-useless-fileds-from-cyclades_card
+++ a/include/linux/cyclades.h
@@ -509,8 +509,6 @@ struct ZFW_CTRL {
 
 /* Per card data structure */
 struct cyclades_card {
-    unsigned long base_phys;
-    unsigned long ctl_phys;
     void __iomem *base_addr;
     void __iomem *ctl_addr;
     int irq;
@@ -519,7 +517,6 @@ struct cyclades_card {
     int nports;		/* Number of ports in the card */
     int bus_index;	/* address shift - 0 for ISA, 1 for PCI */
     int	intr_enabled;	/* FW Interrupt flag - 0 disabled, 1 enabled */
-    struct pci_dev *pdev;
     spinlock_t card_lock;
 };
 
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
