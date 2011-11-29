From: akpm@linux-foundation.org
Subject: + powerpc-switch-to-generic_pci_iomap.patch added to -mm tree
Date: Mon, 28 Nov 2011 16:09:02 -0800
Message-ID: <201111290009.pAT093n6029408@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40051 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab1K2AJG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 19:09:06 -0500
Received: by mail-ee0-f74.google.com with SMTP id u44so50397eeu.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 16:09:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mst@redhat.com, arnd@arndb.de, benh@kernel.crashing.org, jbarnes@virtuousgeek.org, paulus@samba.org


The patch titled
     Subject: powerpc: switch to GENERIC_PCI_IOMAP
has been added to the -mm tree.  Its filename is
     powerpc-switch-to-generic_pci_iomap.patch

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
-
 void pci_iounmap(struct pci_dev *dev, void __iomem *addr)
 {
 	if (isa_vaddr_is_ioport(addr))
@@ -146,6 +128,5 @@ void pci_iounmap(struct pci_dev *dev, vo
 	iounmap(addr);
 }
 
-EXPORT_SYMBOL(pci_iomap);
 EXPORT_SYMBOL(pci_iounmap);
 #endif /* CONFIG_PCI */
_
Subject: Subject: powerpc: switch to GENERIC_PCI_IOMAP

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

