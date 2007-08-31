From: akpm@linux-foundation.org
Subject: - fix-modpost-warning-in-serial-driver.patch removed from -mm tree
Date: Fri, 31 Aug 2007 09:56:10 -0700
Message-ID: <200708311656.l7VGuAaS017466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33194 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760489AbXHaQ4X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 12:56:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Fix modpost warning in serial driver
has been removed from the -mm tree.  Its filename was
     fix-modpost-warning-in-serial-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix modpost warning in serial driver
From: Ralf Baechle <ralf@linux-mips.org>

This is triggered if PCI && !HOTPLUG.

  MODPOST vmlinux.o
WARNING: vmlinux.o(.data+0xc910): Section mismatch: reference to .init.text:pci_ite887x_init (between 'pci_serial_quirks' and 'serial_pci_tbl')

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/8250_pci.c~fix-modpost-warning-in-serial-driver drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~fix-modpost-warning-in-serial-driver
+++ a/drivers/serial/8250_pci.c
@@ -610,7 +610,7 @@ static int pci_netmos_init(struct pci_de
 /* enable IO_Space bit */
 #define ITE_887x_POSIO_ENABLE		(1 << 31)
 
-static int __devinit pci_ite887x_init(struct pci_dev *dev)
+static int pci_ite887x_init(struct pci_dev *dev)
 {
 	/* inta_addr are the configuration addresses of the ITE */
 	static const short inta_addr[] = { 0x2a0, 0x2c0, 0x220, 0x240, 0x1e0,
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
git-mips.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
mips-qemu-network-work-again.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
mips-move-platform-independent-cfe-code-into-arch-mips-cfe.patch
mips-add-cfe-support-to-bcm947xx-code.patch
mips-replace-config_usb_ohci-with-config_usb_ohci_hcd-in-a-few-overlooked-files.patch
git-mtd.patch
git-netdev-all.patch
ioc3-program-uart-predividers.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
serial_txx9-cleanup-includes.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
serio-fix-modpost-warning.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers.patch
vt-fix-warnings-in-selectionh.patch
define-global-bit-macro.patch
