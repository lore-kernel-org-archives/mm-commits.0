From: akpm@linux-foundation.org
Subject: [merged] powerpc-switch-to-generic_pci_iomap.patch removed from -mm tree
Date: Tue, 29 Nov 2011 12:04:28 -0800
Message-ID: <201111292004.pATK4SgB002489@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:52606 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab1K2UEa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2011 15:04:30 -0500
Received: by mail-gy0-f202.google.com with SMTP id r18so391765ghr.1
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2011 12:04:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mst@redhat.com, arnd@arndb.de, benh@kernel.crashing.org, jbarnes@virtuousgeek.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: switch to GENERIC_PCI_IOMAP
has been removed from the -mm tree.  Its filename was
     powerpc-switch-to-generic_pci_iomap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: powerpc: switch to GENERIC_PCI_IOMAP

powerpc copied pci_iomap from generic code, probably to avoid pulling the
rest of iomap.c in.  Since that's in a separate file now, we can reuse the
common implementation.

The only difference is handling of nocache flag, that turns out to be done
correctly by the generic code since arch/powerpc/include/asm/io.h defines
ioremap_nocache same as ioremap.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig        |    1 +
 arch/powerpc/kernel/iomap.c |   19 -------------------
 2 files changed, 1 insertion(+), 19 deletions(-)

diff -puN arch/powerpc/Kconfig~powerpc-switch-to-generic_pci_iomap arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~powerpc-switch-to-generic_pci_iomap
+++ a/arch/powerpc/Kconfig
@@ -711,6 +711,7 @@ config PCI
 	default PCI_PERMEDIA if !4xx && !CPM2 && !8xx
 	default PCI_QSPAN if !4xx && !CPM2 && 8xx
 	select ARCH_SUPPORTS_MSI
+	select GENERIC_PCI_IOMAP
 	help
 	  Find out whether your system includes a PCI bus. PCI is the name of
 	  a bus system, i.e. the way the CPU talks to the other stuff inside
diff -puN arch/powerpc/kernel/iomap.c~powerpc-switch-to-generic_pci_iomap arch/powerpc/kernel/iomap.c
--- a/arch/powerpc/kernel/iomap.c~powerpc-switch-to-generic_pci_iomap
+++ a/arch/powerpc/kernel/iomap.c
@@ -119,24 +119,6 @@ EXPORT_SYMBOL(ioport_map);
 EXPORT_SYMBOL(ioport_unmap);
 
 #ifdef CONFIG_PCI
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
