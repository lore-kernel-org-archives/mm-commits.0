From: akpm@linux-foundation.org
Subject: + parisc-switch-to-generic_pci_iomap.patch added to -mm tree
Date: Mon, 28 Nov 2011 16:08:59 -0800
Message-ID: <201111290009.pAT08x3c029014@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:48397 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab1K2AJC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 19:09:02 -0500
Received: by mail-gy0-f202.google.com with SMTP id r18so249341ghr.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 16:09:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mst@redhat.com, arnd@arndb.de, deller@gmx.de, jbarnes@virtuousgeek.org, jejb@parisc-linux.org, kyle@mcmartin.ca


The patch titled
     Subject: parisc: switch to GENERIC_PCI_IOMAP
has been added to the -mm tree.  Its filename is
     parisc-switch-to-generic_pci_iomap.patch

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
-
 void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
 {
 	if (!INDIRECT_ADDR(addr)) {
@@ -483,5 +461,4 @@ EXPORT_SYMBOL(iowrite16_rep);
 EXPORT_SYMBOL(iowrite32_rep);
 EXPORT_SYMBOL(ioport_map);
 EXPORT_SYMBOL(ioport_unmap);
-EXPORT_SYMBOL(pci_iomap);
 EXPORT_SYMBOL(pci_iounmap);
_
Subject: Subject: parisc: switch to GENERIC_PCI_IOMAP

Patches currently in -mm which might be from mst@redhat.com are

linux-next.patch
lib-move-generic_iomap-to-lib-kconfig.patch
lib-add-generic_pci_iomap.patch
alpha-switch-to-generic_pci_iomap.patch
arm-switch-to-generic_pci_iomap.patch
microblaze-switch-to-generic_pci_iomap.patch
mips-switch-to-generic_pci_iomap.patch
parisc-switch-to-generic_pci_iomap.patch
powerpc-switch-to-generic_pci_iomap.patch
sh-switch-to-generic_pci_iomap.patch
sparc-switch-to-generic_pci_iomap.patch

