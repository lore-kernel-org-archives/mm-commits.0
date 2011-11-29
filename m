From: akpm@linux-foundation.org
Subject: + microblaze-switch-to-generic_pci_iomap.patch added to -mm tree
Date: Mon, 28 Nov 2011 16:08:53 -0800
Message-ID: <201111290008.pAT08rTx029394@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:55934 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab1K2AIz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 19:08:55 -0500
Received: by qyk15 with SMTP id 15so369477qyk.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 16:08:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mst@redhat.com, arnd@arndb.de, jbarnes@virtuousgeek.org, monstr@monstr.eu


The patch titled
     Subject: microblaze: switch to GENERIC_PCI_IOMAP
has been added to the -mm tree.  Its filename is
     microblaze-switch-to-generic_pci_iomap.patch

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
