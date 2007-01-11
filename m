From: akpm@osdl.org
Subject: + ia64-add-pci_get_legacy_ide_irq.patch added to -mm tree
Date: Thu, 11 Jan 2007 13:41:34 -0800
Message-ID: <200701112141.l0BLfYYM003862@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37235 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094AbXAKVpX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 16:45:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk, bunk@stusta.de, tony.luck@intel.com


The patch titled
     ia64: add pci_get_legacy_ide_irq()
has been added to the -mm tree.  Its filename is
     ia64-add-pci_get_legacy_ide_irq.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ia64-add-pci_get_legacy_ide_irq.patch
pdc202xx_new-remove-useless-code.patch
pdc202xx_-remove-check_in_drive_lists-abomination.patch
piix-tuneproc-fixes-cleanups.patch
slc90e66-carry-over-fixes-from-piix-driver.patch
hpt36x-pci-clock-detection-fix.patch
atiixpc-remove-unused-code.patch
atiixpc-sb600-ide-only-has-one-channel.patch
atiixpc-add-cable-detection-support-for-ati-ide.patch
ide-generic-jmicron-has-its-own-drivers-now.patch
