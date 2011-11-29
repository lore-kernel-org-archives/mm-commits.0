From: akpm@linux-foundation.org
Subject: + alpha-switch-to-generic_pci_iomap.patch added to -mm tree
Date: Mon, 28 Nov 2011 16:08:46 -0800
Message-ID: <201111290008.pAT08lRH029337@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:62731 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab1K2AIt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 19:08:49 -0500
Received: by ywb26 with SMTP id 26so519362ywb.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 16:08:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mst@redhat.com, arnd@arndb.de, ink@jurassic.park.msu.ru, jbarnes@virtuousgeek.org, mattst88@gmail.com, rth@twiddle.net


The patch titled
     Subject: alpha: switch to GENERIC_PCI_IOMAP
has been added to the -mm tree.  Its filename is
     alpha-switch-to-generic_pci_iomap.patch

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
-
-/* Destroy that token.  Not copied from lib/iomap.c.  */
+/* Destroy an __iomem token.  Not copied from lib/iomap.c.  */
 
 void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
 {
@@ -539,7 +516,6 @@ void pci_iounmap(struct pci_dev *dev, vo
 		iounmap(addr);
 }
 
-EXPORT_SYMBOL(pci_iomap);
 EXPORT_SYMBOL(pci_iounmap);
 
 /* FIXME: Some boxes have multiple ISA bridges! */
_
Subject: Subject: alpha: switch to GENERIC_PCI_IOMAP

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

