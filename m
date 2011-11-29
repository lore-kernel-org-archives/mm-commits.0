From: akpm@linux-foundation.org
Subject: [merged] microblaze-switch-to-generic_pci_iomap.patch removed from -mm tree
Date: Tue, 29 Nov 2011 12:04:17 -0800
Message-ID: <201111292004.pATK4HUa028139@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:52606 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab1K2UET (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2011 15:04:19 -0500
Received: by ghrr18 with SMTP id r18so391765ghr.1
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2011 12:04:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mst@redhat.com, arnd@arndb.de, jbarnes@virtuousgeek.org, monstr@monstr.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: microblaze: switch to GENERIC_PCI_IOMAP
has been removed from the -mm tree.  Its filename was
     microblaze-switch-to-generic_pci_iomap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: microblaze: switch to GENERIC_PCI_IOMAP

microblaze copied pci_iomap from generic code, probably to avoid pulling
the rest of iomap.c in.  Since that's in a separate file now, we can reuse
the common implementation.

The only difference is handling of nocache flag, that turns out to be done
correctly by the generic code since arch/microblaze/include/asm/io.h
defines ioremap_nocache same as ioremap.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/Kconfig     |    1 +
 arch/microblaze/pci/iomap.c |   19 -------------------
 2 files changed, 1 insertion(+), 19 deletions(-)

diff -puN arch/microblaze/Kconfig~microblaze-switch-to-generic_pci_iomap arch/microblaze/Kconfig
--- a/arch/microblaze/Kconfig~microblaze-switch-to-generic_pci_iomap
+++ a/arch/microblaze/Kconfig
@@ -17,6 +17,7 @@ config MICROBLAZE
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
+	select GENERIC_PCI_IOMAP
 
 config SWAP
 	def_bool n
diff -puN arch/microblaze/pci/iomap.c~microblaze-switch-to-generic_pci_iomap arch/microblaze/pci/iomap.c
--- a/arch/microblaze/pci/iomap.c~microblaze-switch-to-generic_pci_iomap
+++ a/arch/microblaze/pci/iomap.c
@@ -10,25 +10,6 @@
 #include <asm/io.h>
 #include <asm/pci-bridge.h>
 
-void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
-{
-	resource_size_t start = pci_resource_start(dev, bar);
-	resource_size_t len = pci_resource_len(dev, bar);
-	unsigned long flags = pci_resource_flags(dev, bar);
-
-	if (!len)
-		return NULL;
-	if (max && len > max)
-		len = max;
-	if (flags & IORESOURCE_IO)
-		return ioport_map(start, len);
-	if (flags & IORESOURCE_MEM)
-		return ioremap(start, len);
-	/* What? */
-	return NULL;
-}
-EXPORT_SYMBOL(pci_iomap);
