From: akpm@linux-foundation.org
Subject: [merged] lib-add-generic_pci_iomap-v2.patch removed from -mm tree
Date: Thu, 01 Dec 2011 12:32:21 -0800
Message-ID: <201112012032.pB1KWLPM031375@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:49109 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab1LAUcX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2011 15:32:23 -0500
Received: by ggnp2 with SMTP id p2so314726ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Dec 2011 12:32:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mst@redhat.com, arnd@arndb.de, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: [PATCH-RFC 02/10 v2] lib: add GENERIC_PCI_IOMAP
has been removed from the -mm tree.  Its filename was
     lib-add-generic_pci_iomap-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH-RFC 02/10 v2] lib: add GENERIC_PCI_IOMAP

Changes from v1:
	minor tweaks to address comments by Stephen Rothwell

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/io.h        |    1 +
 include/asm-generic/iomap.h     |    2 +-
 include/asm-generic/pci_iomap.h |    3 +--
 lib/pci_iomap.c                 |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/asm-generic/io.h~lib-add-generic_pci_iomap-v2 include/asm-generic/io.h
--- a/include/asm-generic/io.h~lib-add-generic_pci_iomap-v2
+++ a/include/asm-generic/io.h
@@ -285,6 +285,7 @@ static inline void writesb(const void __
 #define __io_virt(x) ((void __force *) (x))
 
 #ifndef CONFIG_GENERIC_IOMAP
+struct pci_dev;
 static inline void pci_iounmap(struct pci_dev *dev, void __iomem *p)
 {
 }
diff -puN include/asm-generic/iomap.h~lib-add-generic_pci_iomap-v2 include/asm-generic/iomap.h
--- a/include/asm-generic/iomap.h~lib-add-generic_pci_iomap-v2
+++ a/include/asm-generic/iomap.h
@@ -67,7 +67,7 @@ extern void ioport_unmap(void __iomem *)
 #endif
 
 #ifdef CONFIG_PCI
-/* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
+/* Destroy a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
 extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
 #else
diff -puN include/asm-generic/pci_iomap.h~lib-add-generic_pci_iomap-v2 include/asm-generic/pci_iomap.h
--- a/include/asm-generic/pci_iomap.h~lib-add-generic_pci_iomap-v2
+++ a/include/asm-generic/pci_iomap.h
@@ -11,12 +11,11 @@
 #ifndef __ASM_GENERIC_PCI_IOMAP_H
 #define __ASM_GENERIC_PCI_IOMAP_H
 
+struct pci_dev;
 #ifdef CONFIG_PCI
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
-struct pci_dev;
 extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
 #else
-struct pci_dev;
 static inline void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
 {
 	return NULL;
diff -puN lib/pci_iomap.c~lib-add-generic_pci_iomap-v2 lib/pci_iomap.c
--- a/lib/pci_iomap.c~lib-add-generic_pci_iomap-v2
+++ a/lib/pci_iomap.c
@@ -6,7 +6,7 @@
 #include <linux/pci.h>
 #include <linux/io.h>
 
-#include <linux/module.h>
+#include <linux/export.h>
 
 #ifdef CONFIG_PCI
 /**
_

Patches currently in -mm which might be from mst@redhat.com are

linux-next.patch

