From: akpm@linux-foundation.org
Subject: + arm-switch-to-generic_pci_iomap.patch added to -mm tree
Date: Mon, 28 Nov 2011 16:08:50 -0800
Message-ID: <201111290008.pAT08peo012339@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:40730 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab1K2AIy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 19:08:54 -0500
Received: by eaaa14 with SMTP id a14so132166eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 16:08:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mst@redhat.com, arnd@arndb.de, jbarnes@virtuousgeek.org, linux@arm.linux.org.uk


The patch titled
     Subject: arm: switch to GENERIC_PCI_IOMAP
has been added to the -mm tree.  Its filename is
     arm-switch-to-generic_pci_iomap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: arm: switch to GENERIC_PCI_IOMAP

arm copied pci_iomap from generic code, probably to avoid pulling the rest
of iomap.c in.  Since that's in a separate file now, we can reuse the
common implementation.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig          |    1 +
 arch/arm/include/asm/io.h |    2 +-
 arch/arm/mm/iomap.c       |   21 ---------------------
 3 files changed, 2 insertions(+), 22 deletions(-)

diff -puN arch/arm/Kconfig~arm-switch-to-generic_pci_iomap arch/arm/Kconfig
--- a/arch/arm/Kconfig~arm-switch-to-generic_pci_iomap
+++ a/arch/arm/Kconfig
@@ -30,6 +30,7 @@ config ARM
 	select HAVE_SPARSE_IRQ
 	select GENERIC_IRQ_SHOW
 	select CPU_PM if (SUSPEND || CPU_IDLE)
+	select GENERIC_PCI_IOMAP
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff -puN arch/arm/include/asm/io.h~arm-switch-to-generic_pci_iomap arch/arm/include/asm/io.h
--- a/arch/arm/include/asm/io.h~arm-switch-to-generic_pci_iomap
+++ a/arch/arm/include/asm/io.h
@@ -27,6 +27,7 @@
 #include <asm/byteorder.h>
 #include <asm/memory.h>
 #include <asm/system.h>
+#include <asm-generic/pci_iomap.h>
 
 /*
  * ISA I/O bus memory addresses are 1:1 with the physical address.
@@ -306,7 +307,6 @@ extern void ioport_unmap(void __iomem *a
 
 struct pci_dev;
 
-extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen);
 extern void pci_iounmap(struct pci_dev *dev, void __iomem *addr);
 
 /*
diff -puN arch/arm/mm/iomap.c~arm-switch-to-generic_pci_iomap arch/arm/mm/iomap.c
--- a/arch/arm/mm/iomap.c~arm-switch-to-generic_pci_iomap
+++ a/arch/arm/mm/iomap.c
@@ -35,27 +35,6 @@ EXPORT_SYMBOL(pcibios_min_mem);
 unsigned int pci_flags = PCI_REASSIGN_ALL_RSRC;
 EXPORT_SYMBOL(pci_flags);
 
-void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
-{
-	resource_size_t start = pci_resource_start(dev, bar);
-	resource_size_t len   = pci_resource_len(dev, bar);
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
-	return NULL;
-}
-EXPORT_SYMBOL(pci_iomap);
