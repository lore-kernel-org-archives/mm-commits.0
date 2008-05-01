From: akpm@linux-foundation.org
Subject: - powerpc-devres-add-devm_ioremap_prot.patch removed from -mm tree
Date: Thu, 01 May 2008 15:54:14 -0700
Message-ID: <200805012254.m41MsExk029728@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758483AbYEAWyt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 18:54:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Emilian.Medve@Freescale.com, benh@kernel.crashing.org, galak@kernel.crashing.org, htejun@gmail.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: devres: add devm_ioremap_prot()
has been removed from the -mm tree.  Its filename was
     powerpc-devres-add-devm_ioremap_prot.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: devres: add devm_ioremap_prot()
From: Emil Medve <Emilian.Medve@Freescale.com>

We provide an ioremap_flags so provide a corresponding devm_ioremap_prot. 
The slight name difference is at Ben Herrenschmidt request as he plans on
changing ioremap_flags to ioremap_prot in the future.

Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/lib/Makefile |    1 +
 arch/powerpc/lib/devres.c |   33 +++++++++++++++++++++++++++++++++
 include/asm-powerpc/io.h  |    8 +++++++-
 include/linux/io.h        |    1 +
 lib/devres.c              |    2 +-
 5 files changed, 43 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/lib/Makefile~powerpc-devres-add-devm_ioremap_prot arch/powerpc/lib/Makefile
--- a/arch/powerpc/lib/Makefile~powerpc-devres-add-devm_ioremap_prot
+++ a/arch/powerpc/lib/Makefile
@@ -23,3 +23,4 @@ obj-$(CONFIG_SMP)	+= locks.o
 endif
 
 obj-$(CONFIG_PPC_LIB_RHEAP) += rheap.o
+obj-$(CONFIG_HAS_IOMEM)	+= devres.o
diff -puN /dev/null arch/powerpc/lib/devres.c
--- /dev/null
+++ a/arch/powerpc/lib/devres.c
@@ -0,0 +1,33 @@
+#include <linux/device.h>	/* devres_*(), devm_ioremap_release() */
+#include <linux/io.h>		/* ioremap_flags() */
+#include <linux/module.h>	/* EXPORT_SYMBOL() */
+
+/**
+ * devm_ioremap_prot - Managed ioremap_flags()
+ * @dev: Generic device to remap IO address for
+ * @offset: BUS offset to map
+ * @size: Size of map
+ * @flags: Page flags
+ *
+ * Managed ioremap_prot().  Map is automatically unmapped on driver
+ * detach.
+ */
+void __iomem *devm_ioremap_prot(struct device *dev, resource_size_t offset,
+				 size_t size, unsigned long flags)
+{
+	void __iomem **ptr, *addr;
+
+	ptr = devres_alloc(devm_ioremap_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return NULL;
+
+	addr = ioremap_flags(offset, size, flags);
+	if (addr) {
+		*ptr = addr;
+		devres_add(dev, ptr);
+	} else
+		devres_free(ptr);
+
+	return addr;
+}
+EXPORT_SYMBOL(devm_ioremap_prot);
diff -puN include/asm-powerpc/io.h~powerpc-devres-add-devm_ioremap_prot include/asm-powerpc/io.h
--- a/include/asm-powerpc/io.h~powerpc-devres-add-devm_ioremap_prot
+++ a/include/asm-powerpc/io.h
@@ -2,7 +2,7 @@
 #define _ASM_POWERPC_IO_H
 #ifdef __KERNEL__
 
-/* 
+/*
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * as published by the Free Software Foundation; either version
@@ -18,6 +18,9 @@ extern int check_legacy_ioport(unsigned 
 #define _PNPWRP		0xa79
 #define PNPBIOS_BASE	0xf000
 
+#include <linux/device.h>
+#include <linux/io.h>
+
 #include <linux/compiler.h>
 #include <asm/page.h>
 #include <asm/byteorder.h>
@@ -744,6 +747,9 @@ static inline void * bus_to_virt(unsigne
 
 #define clrsetbits_8(addr, clear, set) clrsetbits(8, addr, clear, set)
 
+void __iomem *devm_ioremap_prot(struct device *dev, resource_size_t offset,
+				size_t size, unsigned long flags);
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_POWERPC_IO_H */
diff -puN include/linux/io.h~powerpc-devres-add-devm_ioremap_prot include/linux/io.h
--- a/include/linux/io.h~powerpc-devres-add-devm_ioremap_prot
+++ a/include/linux/io.h
@@ -65,5 +65,6 @@ void __iomem * devm_ioremap_nocache(stru
 void devm_iounmap(struct device *dev, void __iomem *addr);
 int check_signature(const volatile void __iomem *io_addr,
 			const unsigned char *signature, int length);
+void devm_ioremap_release(struct device *dev, void *res);
 
 #endif /* _LINUX_IO_H */
diff -puN lib/devres.c~powerpc-devres-add-devm_ioremap_prot lib/devres.c
--- a/lib/devres.c~powerpc-devres-add-devm_ioremap_prot
+++ a/lib/devres.c
@@ -2,7 +2,7 @@
 #include <linux/io.h>
 #include <linux/module.h>
 
-static void devm_ioremap_release(struct device *dev, void *res)
+void devm_ioremap_release(struct device *dev, void *res)
 {
 	iounmap(*(void __iomem **)res);
 }
_

Patches currently in -mm which might be from Emilian.Medve@Freescale.com are

powerpc-devres-add-devm_ioremap_prot.patch

