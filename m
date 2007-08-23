From: akpm@linux-foundation.org
Subject: + pci-section-warning-fix.patch added to -mm tree
Date: Thu, 23 Aug 2007 14:28:39 -0700
Message-ID: <200708232128.l7NLSd8q027726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42963 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761777AbXHWV2s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 17:28:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, greg@kroah.com


The patch titled
     pci: section warning fix
has been added to the -mm tree.  Its filename is
     pci-section-warning-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pci: section warning fix
From: Ralf Baechle <ralf@linux-mips.org>

On MIPS with PCI && !HOTPLUG, I'm currently getting the following modpost
warning:

  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x1ce128): Section mismatch: reference to .init.text:pci_read_bridge_bases (between 'pcibios_fixup_bus' and 'pcibios_enable_device')

On MIPS I have the call chains pci_scan_child_bus -> pcibios_fixup_bus ->
pci_read_bridge_bases.  pci_scan_child_bus can't be __devinit because it
it is an exported symbol, thus pcibios_fixup_bus and pci_read_bridge_bases
can't be either.

For some reason I don't see this issue on x86; I blame compiler differences.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/probe.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/probe.c~pci-section-warning-fix drivers/pci/probe.c
--- a/drivers/pci/probe.c~pci-section-warning-fix
+++ a/drivers/pci/probe.c
@@ -332,7 +332,7 @@ static void pci_read_bases(struct pci_de
 	}
 }
 
-void __devinit pci_read_bridge_bases(struct pci_bus *child)
+void pci_read_bridge_bases(struct pci_bus *child)
 {
 	struct pci_dev *dev = child->self;
 	u8 io_base_lo, io_limit_lo;
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
pci-section-warning-fix.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
define-global-bit-macro.patch
