From: akpm@linux-foundation.org
Subject: + fix-modpost-warning-in-serial-driver.patch added to -mm tree
Date: Thu, 23 Aug 2007 14:23:08 -0700
Message-ID: <200708232123.l7NLN8ie027537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60452 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759388AbXHWVXR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 17:23:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org


The patch titled
     Fix modpost warning in serial driver
has been added to the -mm tree.  Its filename is
     fix-modpost-warning-in-serial-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 1 deletion(-)

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

serial_txx9-fix-modem-control-line-handling.patch
newport_con-warning-fix.patch
au1100fb-move-au1100fb_fb_blank-beforce.patch
fix-font-dependency-for-sgi-newport-console-driver.patch
add-maintainers-entry-for-ioc3-serial-driver.patch
fix-modpost-warning-in-serial-driver.patch
git-mips.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
mips-qemu-network-work-again.patch
mips-detect-bcm947xx-cpus.patch
mips-bcm947xx-support.patch
rfc-add-bcm947xx-to-kconfig.patch
mips-add-bcm947xx-to-makefile.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
mips-move-platform-independent-cfe-code-into-arch-mips-cfe.patch
mips-add-cfe-support-to-bcm947xx-code.patch
mips-irix_getcontext-will-always-fail-efault.patch
git-mtd.patch
git-netdev-all.patch
dont-use-gfp_dma-for-zone-allocation.patch
sgiseeq-fix-return-type-of-sgiseeq_remove.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
serial_txx9-cleanup-includes.patch
serio-fix-modpost-warning.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
define-global-bit-macro.patch
