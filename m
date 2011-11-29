From: akpm@linux-foundation.org
Subject: [merged] parisc-switch-to-generic_pci_iomap.patch removed from -mm tree
Date: Tue, 29 Nov 2011 12:04:24 -0800
Message-ID: <201111292004.pATK4OSM002286@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:48335 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab1K2UE0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2011 15:04:26 -0500
Received: by ywb26 with SMTP id 26so663739ywb.1
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2011 12:04:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mst@redhat.com, arnd@arndb.de, deller@gmx.de, jbarnes@virtuousgeek.org, jejb@parisc-linux.org, kyle@mcmartin.ca, mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: switch to GENERIC_PCI_IOMAP
has been removed from the -mm tree.  Its filename was
     parisc-switch-to-generic_pci_iomap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: parisc: switch to GENERIC_PCI_IOMAP

parisc copied pci_iomap from generic code, probably to avoid pulling the
rest of iomap.c in.  Since that's in a separate file now, we can reuse the
common implementation.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/Kconfig     |    1 +
 arch/parisc/lib/iomap.c |   23 -----------------------
 2 files changed, 1 insertion(+), 23 deletions(-)

diff -puN arch/parisc/Kconfig~parisc-switch-to-generic_pci_iomap arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~parisc-switch-to-generic_pci_iomap
+++ a/arch/parisc/Kconfig
@@ -15,6 +15,7 @@ config PARISC
 	select GENERIC_ATOMIC64 if !64BIT
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
+	select GENERIC_PCI_IOMAP
 	select IRQ_PER_CPU
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 
diff -puN arch/parisc/lib/iomap.c~parisc-switch-to-generic_pci_iomap arch/parisc/lib/iomap.c
--- a/arch/parisc/lib/iomap.c~parisc-switch-to-generic_pci_iomap
+++ a/arch/parisc/lib/iomap.c
@@ -436,28 +436,6 @@ void ioport_unmap(void __iomem *addr)
 	}
 }
 
-/* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
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
-		return ioport_map(start, len);
-	if (flags & IORESOURCE_MEM) {
-		if (flags & IORESOURCE_CACHEABLE)
-			return ioremap(start, len);
-		return ioremap_nocache(start, len);
-	}
-	/* What? */
-	return NULL;
-}
