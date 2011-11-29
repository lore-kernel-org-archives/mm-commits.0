From: akpm@linux-foundation.org
Subject: [merged] alpha-switch-to-generic_pci_iomap.patch removed from -mm tree
Date: Tue, 29 Nov 2011 12:04:10 -0800
Message-ID: <201111292004.pATK4AmJ028043@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:36565 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab1K2UEO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2011 15:04:14 -0500
Received: by eaaa14 with SMTP id a14so161746eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2011 12:04:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mst@redhat.com, arnd@arndb.de, ink@jurassic.park.msu.ru, jbarnes@virtuousgeek.org, mattst88@gmail.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: switch to GENERIC_PCI_IOMAP
has been removed from the -mm tree.  Its filename was
     alpha-switch-to-generic_pci_iomap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: alpha: switch to GENERIC_PCI_IOMAP

alpha copied pci_iomap from generic code to avoid pulling the rest of
iomap.c in.  Since that's in a separate file now, we can reuse the common
implementation.

The only difference is handling of nocache flag, that turns out to be done
correctly by the generic code since arch/alpha/include/asm/io.h defines
ioremap_nocache same as ioremap.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig      |    1 +
 arch/alpha/kernel/pci.c |   26 +-------------------------
 2 files changed, 2 insertions(+), 25 deletions(-)

diff -puN arch/alpha/Kconfig~alpha-switch-to-generic_pci_iomap arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~alpha-switch-to-generic_pci_iomap
+++ a/arch/alpha/Kconfig
@@ -315,6 +315,7 @@ config ISA_DMA_API
 config PCI
 	bool
 	depends on !ALPHA_JENSEN
+	select GENERIC_PCI_IOMAP
 	default y
 	help
 	  Find out whether you have a PCI motherboard. PCI is the name of a
diff -puN arch/alpha/kernel/pci.c~alpha-switch-to-generic_pci_iomap arch/alpha/kernel/pci.c
--- a/arch/alpha/kernel/pci.c~alpha-switch-to-generic_pci_iomap
+++ a/arch/alpha/kernel/pci.c
@@ -508,30 +508,7 @@ sys_pciconfig_iobase(long which, unsigne
 	return -EOPNOTSUPP;
 }
 
-/* Create an __iomem token from a PCI BAR.  Copied from lib/iomap.c with
-   no changes, since we don't want the other things in that object file.  */
-
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
-		/* Not checking IORESOURCE_CACHEABLE because alpha does
-		   not distinguish between ioremap and ioremap_nocache.  */
-		return ioremap(start, len);
-	}
-	return NULL;
-}
