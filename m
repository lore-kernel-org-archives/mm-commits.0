From: akpm@linux-foundation.org
Subject: + lib-add-generic_pci_iomap.patch added to -mm tree
Date: Mon, 28 Nov 2011 16:08:38 -0800
Message-ID: <201111290008.pAT08c6M029126@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:58034 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab1K2AIw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 19:08:52 -0500
Received: by faaq16 with SMTP id q16so8569faa.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 16:08:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mst@redhat.com, arend@broadcom.com, arnd@arndb.de, benh@kernel.crashing.org, davem@davemloft.net, deller@gmx.de, fabio.baltieri@gmail.com, fenghua.yu@intel.com, frankyl@broadcom.com, galak@kernel.crashing.org, geert@linux-m68k.org, gxt@mprc.pku.edu.cn, hpa@zytor.com, ink@jurassic.park.msu.ru, jbarnes@virtuousgeek.org, jejb@parisc-linux.org, jesper.nilsson@axis.com, jonas@southpole.se, kyle@mcmartin.ca, lasse.collin@tukaani.org, lennox.wu@gmail.com, lethal@linux-sh.org, linux@arm.linux.org.uk, linville@tuxdriver.com, liqin.chen@sunplusct.com, lucas.demarchi@profusion.mobi, mattst88@gmail.com, michael@ellerman.id.au, mingo@redhat.com, monstr@monstr.eu, nicolas.pitre@linaro.org, olof@lixom.net, paul.gortmaker@windriver.com, paulus@samba.org, pebolle@tiscali.nl, ralf@linux-mips.org, rkuo@codeaurora.org, rob.herring@calxeda.com, rth@twiddle.net, sfr@canb.auug.org.au, starvi


The patch titled
     Subject: lib: add GENERIC_PCI_IOMAP
has been added to the -mm tree.  Its filename is
     lib-add-generic_pci_iomap.patch

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
Subject: lib: add GENERIC_PCI_IOMAP

Many architectures want a generic pci_iomap but not the rest of iomap.c. 
Split that to a separate .c file and add a new config symbol.  select
automatically by GENERIC_IOMAP.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: Olof Johansson <olof@lixom.net>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Lasse Collin <lasse.collin@tukaani.org>
Cc: Arend van Spriel <arend@broadcom.com>
Cc: Franky Lin <frankyl@broadcom.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/io.h        |    5 +--
 include/asm-generic/iomap.h     |    7 +---
 include/asm-generic/pci_iomap.h |   26 ++++++++++++++++
 lib/Kconfig                     |    4 ++
 lib/Makefile                    |    1 
 lib/iomap.c                     |   38 +----------------------
 lib/pci_iomap.c                 |   48 ++++++++++++++++++++++++++++++
 7 files changed, 85 insertions(+), 44 deletions(-)

diff -puN include/asm-generic/io.h~lib-add-generic_pci_iomap include/asm-generic/io.h
--- a/include/asm-generic/io.h~lib-add-generic_pci_iomap
+++ a/include/asm-generic/io.h
@@ -19,6 +19,8 @@
 #include <asm-generic/iomap.h>
 #endif
 
+#include <asm-generic/pci_iomap.h>
+
 #ifndef mmiowb
 #define mmiowb() do {} while (0)
 #endif
@@ -283,9 +285,6 @@ static inline void writesb(const void __
 #define __io_virt(x) ((void __force *) (x))
 
 #ifndef CONFIG_GENERIC_IOMAP
-/* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
-struct pci_dev;
-extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
 static inline void pci_iounmap(struct pci_dev *dev, void __iomem *p)
 {
 }
diff -puN include/asm-generic/iomap.h~lib-add-generic_pci_iomap include/asm-generic/iomap.h
--- a/include/asm-generic/iomap.h~lib-add-generic_pci_iomap
+++ a/include/asm-generic/iomap.h
@@ -69,16 +69,13 @@ extern void ioport_unmap(void __iomem *)
 #ifdef CONFIG_PCI
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
-extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
 extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
 #else
 struct pci_dev;
-static inline void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
-{
-	return NULL;
-}
 static inline void pci_iounmap(struct pci_dev *dev, void __iomem *addr)
 { }
 #endif
 
+#include <asm-generic/pci_iomap.h>
+
 #endif
diff -puN /dev/null include/asm-generic/pci_iomap.h
--- /dev/null
+++ a/include/asm-generic/pci_iomap.h
@@ -0,0 +1,26 @@
+/* Generic I/O port emulation, based on MN10300 code
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef __ASM_GENERIC_PCI_IOMAP_H
+#define __ASM_GENERIC_PCI_IOMAP_H
+
+#ifdef CONFIG_PCI
+/* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
+struct pci_dev;
+extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+#else
+struct pci_dev;
+static inline void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
+{
+	return NULL;
+}
+#endif
+
+#endif /* __ASM_GENERIC_IO_H */
diff -puN lib/Kconfig~lib-add-generic_pci_iomap lib/Kconfig
--- a/lib/Kconfig~lib-add-generic_pci_iomap
+++ a/lib/Kconfig
@@ -19,8 +19,12 @@ config RATIONAL
 config GENERIC_FIND_FIRST_BIT
 	bool
 
+config GENERIC_PCI_IOMAP
+	bool
+
 config GENERIC_IOMAP
 	bool
+	select GENERIC_PCI_IOMAP
 
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
diff -puN lib/Makefile~lib-add-generic_pci_iomap lib/Makefile
--- a/lib/Makefile~lib-add-generic_pci_iomap
+++ a/lib/Makefile
@@ -34,6 +34,7 @@ endif
 
 lib-$(CONFIG_HOTPLUG) += kobject_uevent.o
 obj-$(CONFIG_GENERIC_IOMAP) += iomap.o
+obj-$(CONFIG_GENERIC_PCI_IOMAP) += pci_iomap.o
 obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
 obj-$(CONFIG_CHECK_SIGNATURE) += check_signature.o
 obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
diff -puN lib/iomap.c~lib-add-generic_pci_iomap lib/iomap.c
--- a/lib/iomap.c~lib-add-generic_pci_iomap
+++ a/lib/iomap.c
@@ -242,45 +242,11 @@ EXPORT_SYMBOL(ioport_unmap);
 #endif /* CONFIG_HAS_IOPORT */
 
 #ifdef CONFIG_PCI
-/**
- * pci_iomap - create a virtual mapping cookie for a PCI BAR
- * @dev: PCI device that owns the BAR
- * @bar: BAR number
- * @maxlen: length of the memory to map
- *
- * Using this function you will get a __iomem address to your device BAR.
- * You can access it using ioread*() and iowrite*(). These functions hide
- * the details if this is a MMIO or PIO address space and will just do what
- * you expect from them in the correct way.
- *
- * @maxlen specifies the maximum length to map. If you want to get access to
- * the complete BAR without checking for its length first, pass %0 here.
- * */
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
+/* Hide the details if this is a MMIO or PIO address space and just do what
+ * you expect in the correct way. */
 void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
 {
 	IO_COND(addr, /* nothing */, iounmap(addr));
 }
-EXPORT_SYMBOL(pci_iomap);
 EXPORT_SYMBOL(pci_iounmap);
 #endif /* CONFIG_PCI */
diff -puN /dev/null lib/pci_iomap.c
--- /dev/null
+++ a/lib/pci_iomap.c
@@ -0,0 +1,48 @@
+/*
+ * Implement the default iomap interfaces
+ *
+ * (C) Copyright 2004 Linus Torvalds
+ */
+#include <linux/pci.h>
+#include <linux/io.h>
+
+#include <linux/module.h>
+
+#ifdef CONFIG_PCI
+/**
+ * pci_iomap - create a virtual mapping cookie for a PCI BAR
+ * @dev: PCI device that owns the BAR
+ * @bar: BAR number
+ * @maxlen: length of the memory to map
+ *
+ * Using this function you will get a __iomem address to your device BAR.
+ * You can access it using ioread*() and iowrite*(). These functions hide
+ * the details if this is a MMIO or PIO address space and will just do what
+ * you expect from them in the correct way.
+ *
+ * @maxlen specifies the maximum length to map. If you want to get access to
+ * the complete BAR without checking for its length first, pass %0 here.
+ * */
+void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
+{
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
+	unsigned long flags = pci_resource_flags(dev, bar);
+
+	if (!len || !start)
+		return NULL;
+	if (maxlen && len > maxlen)
+		len = maxlen;
+	if (flags & IORESOURCE_IO)
+		return ioport_map(start, len);
+	if (flags & IORESOURCE_MEM) {
+		if (flags & IORESOURCE_CACHEABLE)
+			return ioremap(start, len);
+		return ioremap_nocache(start, len);
+	}
+	/* What? */
+	return NULL;
+}
+
+EXPORT_SYMBOL(pci_iomap);
+#endif /* CONFIG_PCI */
_
Subject: Subject: lib: add GENERIC_PCI_IOMAP

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

