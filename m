From: akpm@linux-foundation.org
Subject: + sparc-switch-to-generic_pci_iomap.patch added to -mm tree
Date: Mon, 28 Nov 2011 16:09:08 -0800
Message-ID: <201111290009.pAT09EK0029834@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40051 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab1K2AJR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 19:09:17 -0500
Received: by mail-ee0-f74.google.com with SMTP id u44so50397eeu.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 16:09:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mst@redhat.com, arnd@arndb.de, davem@davemloft.net, jbarnes@virtuousgeek.org


The patch titled
     Subject: sparc: switch to GENERIC_PCI_IOMAP
has been added to the -mm tree.  Its filename is
     sparc-switch-to-generic_pci_iomap.patch

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
Subject: sparc: switch to GENERIC_PCI_IOMAP

sparc copied pci_iomap from generic code, probably to avoid pulling the
rest of iomap.c in.  Since that's in a separate file now, we can reuse the
common implementation.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/Kconfig             |    1 +
 arch/sparc/include/asm/io_32.h |    5 ++++-
 arch/sparc/include/asm/io_64.h |    5 ++++-
 arch/sparc/lib/iomap.c         |   23 -----------------------
 4 files changed, 9 insertions(+), 25 deletions(-)

diff -puN arch/sparc/Kconfig~sparc-switch-to-generic_pci_iomap arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~sparc-switch-to-generic_pci_iomap
+++ a/arch/sparc/Kconfig
@@ -28,6 +28,7 @@ config SPARC
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select USE_GENERIC_SMP_HELPERS if SMP
+	select GENERIC_PCI_IOMAP
 
 config SPARC32
 	def_bool !64BIT
diff -puN arch/sparc/include/asm/io_32.h~sparc-switch-to-generic_pci_iomap arch/sparc/include/asm/io_32.h
--- a/arch/sparc/include/asm/io_32.h~sparc-switch-to-generic_pci_iomap
+++ a/arch/sparc/include/asm/io_32.h
@@ -8,6 +8,10 @@
 #include <asm/page.h>      /* IO address mapping routines need this */
 #include <asm/system.h>
 
+#ifdef __KERNEL__
+#include <asm-generic/pci_iomap.h>
+#endif
+
 #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
 
 static inline u32 flip_dword (u32 l)
@@ -324,7 +328,6 @@ extern void ioport_unmap(void __iomem *)
 
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
-extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
 extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
 
 /*
diff -puN arch/sparc/include/asm/io_64.h~sparc-switch-to-generic_pci_iomap arch/sparc/include/asm/io_64.h
--- a/arch/sparc/include/asm/io_64.h~sparc-switch-to-generic_pci_iomap
+++ a/arch/sparc/include/asm/io_64.h
@@ -9,6 +9,10 @@
 #include <asm/system.h>
 #include <asm/asi.h>
 
+#ifdef __KERNEL__
+#include <asm-generic/pci_iomap.h>
+#endif
+
 /* PC crapola... */
 #define __SLOW_DOWN_IO	do { } while (0)
 #define SLOW_DOWN_IO	do { } while (0)
@@ -514,7 +518,6 @@ extern void ioport_unmap(void __iomem *)
 
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
-extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
 extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
 
 static inline int sbus_can_dma_64bit(void)
diff -puN arch/sparc/lib/iomap.c~sparc-switch-to-generic_pci_iomap arch/sparc/lib/iomap.c
--- a/arch/sparc/lib/iomap.c~sparc-switch-to-generic_pci_iomap
+++ a/arch/sparc/lib/iomap.c
@@ -18,31 +18,8 @@ void ioport_unmap(void __iomem *addr)
 EXPORT_SYMBOL(ioport_map);
 EXPORT_SYMBOL(ioport_unmap);
 
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
