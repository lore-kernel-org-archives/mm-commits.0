From: akpm@linux-foundation.org
Subject: + char-cyclades-get-rid-of-phys-addresses.patch added to -mm tree
Date: Thu, 03 May 2007 23:45:35 -0700
Message-ID: <200705040645.l446jZSh030883@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965737AbXEDGpj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 02:45:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, get rid of phys addresses
has been added to the -mm tree.  Its filename is
     char-cyclades-get-rid-of-phys-addresses.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, get rid of phys addresses
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-get-rid-of-phys-addresses drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-get-rid-of-phys-addresses
+++ a/drivers/char/cyclades.c
@@ -4797,9 +4797,7 @@ static void __devinit plx_init(void __io
 	cy_writel(addr + initctl, readl(addr + initctl) & ~0x20000000);
 }
 
-static int __devinit cy_init_Ze(unsigned long cy_pci_phys0,
-		unsigned long cy_pci_phys2,
-		struct RUNTIME_9060 __iomem *cy_pci_addr0,
+static int __devinit cy_init_Ze(struct RUNTIME_9060 __iomem *cy_pci_addr0,
 		int cy_pci_irq, struct pci_dev *pdev)
 {
 	void __iomem *cy_pci_addr2;
@@ -4869,7 +4867,7 @@ static int __devinit cy_pci_probe(struct
 {
 	unsigned char cyy_rev_id;
 	int cy_pci_irq;
-	__u32 cy_pci_phys0, cy_pci_phys2, mailbox;
+	__u32 mailbox;
 	void __iomem *cy_pci_addr0, *cy_pci_addr2;
 	unsigned int device_id;
 	unsigned short j, cy_pci_nchan, plx_ver;
@@ -4883,8 +4881,6 @@ static int __devinit cy_pci_probe(struct
 
 	/* read PCI configuration area */
 	cy_pci_irq = pdev->irq;
-	cy_pci_phys0 = pci_resource_start(pdev, 0);
-	cy_pci_phys2 = pci_resource_start(pdev, 2);
 	pci_read_config_byte(pdev, PCI_REVISION_ID, &cyy_rev_id);
 
 	device_id = pdev->device & ~PCI_DEVICE_ID_MASK;
@@ -5038,8 +5034,7 @@ static int __devinit cy_pci_probe(struct
 		}
 
 		if (mailbox == ZE_V1) {
-			retval = cy_init_Ze(cy_pci_phys0, cy_pci_phys2,
-					cy_pci_addr0, cy_pci_irq, pdev);
+			retval = cy_init_Ze(cy_pci_addr0, cy_pci_irq, pdev);
 			return retval;
 		} else {
 			cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Zwin);
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
