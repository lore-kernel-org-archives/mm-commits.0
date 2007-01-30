From: akpm@osdl.org
Subject: - ia64-add-pci_get_legacy_ide_irq.patch removed from -mm tree
Date: Tue, 30 Jan 2007 13:47:01 -0800
Message-ID: <200701302147.l0ULl1xd030149@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52197 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbXA3VuR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 16:50:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk, bunk@stusta.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: add pci_get_legacy_ide_irq()
has been removed from the -mm tree.  Its filename was
     ia64-add-pci_get_legacy_ide_irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ia64: add pci_get_legacy_ide_irq()
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Add pci_get_legacy_ide_irq() identical to the one used by i386/x86_64. 
Fixes amd74xx driver build on ia64 (bugzilla bug #6644).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-ia64/pci.h |    6 ++++++
 1 files changed, 6 insertions(+)

diff -puN include/asm-ia64/pci.h~ia64-add-pci_get_legacy_ide_irq include/asm-ia64/pci.h
--- a/include/asm-ia64/pci.h~ia64-add-pci_get_legacy_ide_irq
+++ a/include/asm-ia64/pci.h
@@ -167,4 +167,10 @@ pcibios_select_root(struct pci_dev *pdev
 
 #define pcibios_scan_all_fns(a, b)	0
 
+#define HAVE_ARCH_PCI_GET_LEGACY_IDE_IRQ
+static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
+{
+	return channel ? 15 : 14;
+}
+
 #endif /* _ASM_IA64_PCI_H */
_

Patches currently in -mm which might be from bzolnier@gmail.com are

origin.patch
jmicron-40-80pin-primary-detection.patch
mm-ide-ide-acpi-support-warning-fix.patch
