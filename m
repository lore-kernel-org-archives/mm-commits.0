From: akpm@linux-foundation.org
Subject: + pci-remove-__devinit-from-pcibios_get_irq_routing_table.patch added to -mm tree
Date: Thu, 23 Aug 2007 14:30:48 -0700
Message-ID: <200708232130.l7NLUmio027836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52253 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760255AbXHWVbE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 17:31:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, ak@suse.de, greg@kroah.com


The patch titled
     i386: PCI: remove __devinit from pcibios_get_irq_routing_table
has been added to the -mm tree.  Its filename is
     pci-remove-__devinit-from-pcibios_get_irq_routing_table.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: PCI: remove __devinit from pcibios_get_irq_routing_table
From: Ralf Baechle <ralf@linux-mips.org>

pcibios_get_irq_routing_table is an exported symbol.  This results in a
modpost warning:

WARNING: vmlinux.o(.text+0xdca51): Section mismatch: reference to .init.text:pcibios_fixup_bus (between 'pci_scan_child_bus' and 'pci_scan_bus_parented')

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Greg KH <greg@kroah.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/pcbios.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/pci/pcbios.c~pci-remove-__devinit-from-pcibios_get_irq_routing_table arch/i386/pci/pcbios.c
--- a/arch/i386/pci/pcbios.c~pci-remove-__devinit-from-pcibios_get_irq_routing_table
+++ a/arch/i386/pci/pcbios.c
@@ -412,7 +412,7 @@ struct irq_routing_options {
 	u16 segment;
 } __attribute__((packed));
 
-struct irq_routing_table * __devinit pcibios_get_irq_routing_table(void)
+struct irq_routing_table * pcibios_get_irq_routing_table(void)
 {
 	struct irq_routing_options opt;
 	struct irq_routing_table *rt = NULL;
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
pci-remove-__devinit-from-pcibios_get_irq_routing_table.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
define-global-bit-macro.patch
