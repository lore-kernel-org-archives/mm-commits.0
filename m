From: akpm@linux-foundation.org
Subject: [merged] sh-switch-to-generic_pci_iomap.patch removed from -mm tree
Date: Tue, 29 Nov 2011 12:04:32 -0800
Message-ID: <201111292004.pATK4Wgq028251@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:54121 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab1K2UEf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2011 15:04:35 -0500
Received: by mail-fx0-f74.google.com with SMTP id q16so1737faa.1
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2011 12:04:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mst@redhat.com, arnd@arndb.de, jbarnes@virtuousgeek.org, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: switch to GENERIC_PCI_IOMAP
has been removed from the -mm tree.  Its filename was
     sh-switch-to-generic_pci_iomap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: sh: switch to GENERIC_PCI_IOMAP

sh copied pci_iomap from generic code, probably to avoid pulling the rest
of iomap.c in.  Since that's in a separate file now, we can reuse the
common implementation.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/Kconfig           |    1 +
 arch/sh/drivers/pci/pci.c |   23 -----------------------
 2 files changed, 1 insertion(+), 23 deletions(-)

diff -puN arch/sh/Kconfig~sh-switch-to-generic_pci_iomap arch/sh/Kconfig
--- a/arch/sh/Kconfig~sh-switch-to-generic_pci_iomap
+++ a/arch/sh/Kconfig
@@ -857,6 +857,7 @@ config PCI
 	bool "PCI support"
 	depends on SYS_SUPPORTS_PCI
 	select PCI_DOMAINS
+	select GENERIC_PCI_IOMAP
 	help
 	  Find out whether you have a PCI motherboard. PCI is the name of a
 	  bus system, i.e. the way the CPU talks to the other stuff inside
diff -puN arch/sh/drivers/pci/pci.c~sh-switch-to-generic_pci_iomap arch/sh/drivers/pci/pci.c
--- a/arch/sh/drivers/pci/pci.c~sh-switch-to-generic_pci_iomap
+++ a/arch/sh/drivers/pci/pci.c
@@ -393,29 +393,6 @@ static void __iomem *ioport_map_pci(stru
 	return (void __iomem *)(chan->io_map_base + port);
 }
 
-void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
-{
-	resource_size_t start = pci_resource_start(dev, bar);
-	resource_size_t len = pci_resource_len(dev, bar);
-	unsigned long flags = pci_resource_flags(dev, bar);
-
-	if (unlikely(!len || !start))
-		return NULL;
-	if (maxlen && len > maxlen)
-		len = maxlen;
-
-	if (flags & IORESOURCE_IO)
-		return ioport_map_pci(dev, start, len);
-	if (flags & IORESOURCE_MEM) {
-		if (flags & IORESOURCE_CACHEABLE)
-			return ioremap(start, len);
-		return ioremap_nocache(start, len);
-	}
-
-	return NULL;
-}
-EXPORT_SYMBOL(pci_iomap);
