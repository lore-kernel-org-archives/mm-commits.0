From: akpm@linux-foundation.org
Subject: [merged] mips-switch-to-generic_pci_iomap.patch removed from -mm tree
Date: Tue, 29 Nov 2011 12:04:20 -0800
Message-ID: <201111292004.pATK4KPe028179@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:45334 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289Ab1K2UEW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2011 15:04:22 -0500
Received: by yenl2 with SMTP id l2so154774yen.1
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2011 12:04:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mst@redhat.com, arnd@arndb.de, jbarnes@virtuousgeek.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mips: switch to GENERIC_PCI_IOMAP
has been removed from the -mm tree.  Its filename was
     mips-switch-to-generic_pci_iomap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: mips: switch to GENERIC_PCI_IOMAP

mips copied pci_iomap from generic code, probably to avoid pulling the
rest of iomap.c in.  Since that's in a separate file now, we can reuse the
common implementation.

Signed-off-by: Michael S.  Tsirkin <mst@redhat.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig         |    1 +
 arch/mips/lib/iomap-pci.c |   26 --------------------------
 2 files changed, 1 insertion(+), 26 deletions(-)

diff -puN arch/mips/Kconfig~mips-switch-to-generic_pci_iomap arch/mips/Kconfig
--- a/arch/mips/Kconfig~mips-switch-to-generic_pci_iomap
+++ a/arch/mips/Kconfig
@@ -2354,6 +2354,7 @@ config PCI
 	bool "Support for PCI controller"
 	depends on HW_HAS_PCI
 	select PCI_DOMAINS
+	select GENERIC_PCI_IOMAP
 	help
 	  Find out whether you have a PCI motherboard. PCI is the name of a
 	  bus system, i.e. the way the CPU talks to the other stuff inside
diff -puN arch/mips/lib/iomap-pci.c~mips-switch-to-generic_pci_iomap arch/mips/lib/iomap-pci.c
--- a/arch/mips/lib/iomap-pci.c~mips-switch-to-generic_pci_iomap
+++ a/arch/mips/lib/iomap-pci.c
@@ -40,32 +40,6 @@ static void __iomem *ioport_map_pci(stru
 	return (void __iomem *) (ctrl->io_map_base + port);
 }
 
-/*
- * Create a virtual mapping cookie for a PCI BAR (memory or IO)
- */
-void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
-{
-	resource_size_t start = pci_resource_start(dev, bar);
-	resource_size_t len = pci_resource_len(dev, bar);
-	unsigned long flags = pci_resource_flags(dev, bar);
-
-	if (!len || !start)
-		return NULL;
-	if (maxlen && len > maxlen)
-		len = maxlen;
-	if (flags & IORESOURCE_IO)
-		return ioport_map_pci(dev, start, len);
-	if (flags & IORESOURCE_MEM) {
-		if (flags & IORESOURCE_CACHEABLE)
-			return ioremap(start, len);
-		return ioremap_nocache(start, len);
-	}
-	/* What? */
-	return NULL;
-}
-
-EXPORT_SYMBOL(pci_iomap);
