From: akpm@linux-foundation.org
Subject: [merged] asm-generic-iomaph-add-stubs-for-pci-iomap-iounmap.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:55:05 -0700
Message-ID: <201107260754.p6Q7s87l003325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412Ab1GZHzF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:55:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, arnd@arndb.de, jonas@southpole.se, mm-commits@vger.kernel.org


The patch titled
     asm-generic/iomap.h: add stubs for pci iomap/iounmap
has been removed from the -mm tree.  Its filename was
     asm-generic-iomaph-add-stubs-for-pci-iomap-iounmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm-generic/iomap.h: add stubs for pci iomap/iounmap
From: Randy Dunlap <rdunlap@xenotime.net>

When CONFIG_PCI is not enabled, CONFIG_EISA=y, and CONFIG_GENERIC_IOMAP=y,
drivers/net/3c59x.c build fails due to a recent small change to
<asm-generic/iomap.h> that surrounds pci_iomap() and pci_iounmap() with
#ifdef CONFIG_PCI/#endif.  Since that patch to iomap.h looks correct, add
stubs for pci_iomap() and pci_iounmap() with CONFIG_PCI is not enabled to
fix the build errors.

drivers/net/3c59x.c:1026: error: implicit declaration of function 'pci_iomap'
drivers/net/3c59x.c:1038: error: implicit declaration of function 'pci_iounmap'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/iomap.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN include/asm-generic/iomap.h~asm-generic-iomaph-add-stubs-for-pci-iomap-iounmap include/asm-generic/iomap.h
--- a/include/asm-generic/iomap.h~asm-generic-iomaph-add-stubs-for-pci-iomap-iounmap
+++ a/include/asm-generic/iomap.h
@@ -71,6 +71,14 @@ extern void ioport_unmap(void __iomem *)
 struct pci_dev;
 extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
 extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
+#else
+struct pci_dev;
+static inline void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
+{
+	return NULL;
+}
+static inline void pci_iounmap(struct pci_dev *dev, void __iomem *addr)
+{ }
 #endif
 
 #endif
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
ipc-introduce-shm_rmid_forced-sysctl.patch
ipc-introduce-shm_rmid_forced-sysctl-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
init-add-root=partuuid=uuid-partnroff=%d-support.patch
documentation-add-pointer-to-name_to_dev_t-for-root=-values.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

