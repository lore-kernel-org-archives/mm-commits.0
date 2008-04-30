From: akpm@linux-foundation.org
Subject: - iomap-fix-64-bits-resources-on-32-bits.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:04 -0700
Message-ID: <200804300540.m3U5e4xM028929__16144.5988379002$1209534085$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754255AbYD3FkH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:40:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, linux-arch@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     iomap: fix 64 bits resources on 32 bits
has been removed from the -mm tree.  Its filename was
     iomap-fix-64-bits-resources-on-32-bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iomap: fix 64 bits resources on 32 bits
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Almost all implementations of pci_iomap() in the kernel, including the generic
lib/iomap.c one, copies the content of a struct resource into unsigned long's
which will break on 32 bits platforms with 64 bits resources.

This fixes all definitions of pci_iomap() to use resource_size_t.  I also
"fixed" the 64bits arch for consistency.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/pci.c               |    4 ++--
 arch/arm/mm/iomap.c                   |    4 ++--
 arch/frv/mb93090-mb00/pci-iomap.c     |    4 ++--
 arch/mips/lib/iomap-pci.c             |    4 ++--
 arch/mn10300/unit-asb2305/pci-iomap.c |    4 ++--
 arch/parisc/lib/iomap.c               |    4 ++--
 arch/ppc/kernel/pci.c                 |    4 ++--
 arch/sh/drivers/pci/pci.c             |    4 ++--
 arch/sparc/lib/iomap.c                |    4 ++--
 arch/sparc64/lib/iomap.c              |    4 ++--
 arch/v850/kernel/rte_mb_a_pci.c       |    4 ++--
 lib/iomap.c                           |    2 +-
 12 files changed, 23 insertions(+), 23 deletions(-)

diff -puN arch/alpha/kernel/pci.c~iomap-fix-64-bits-resources-on-32-bits arch/alpha/kernel/pci.c
--- a/arch/alpha/kernel/pci.c~iomap-fix-64-bits-resources-on-32-bits
+++ a/arch/alpha/kernel/pci.c
@@ -514,8 +514,8 @@ sys_pciconfig_iobase(long which, unsigne
 
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
diff -puN arch/arm/mm/iomap.c~iomap-fix-64-bits-resources-on-32-bits arch/arm/mm/iomap.c
--- a/arch/arm/mm/iomap.c~iomap-fix-64-bits-resources-on-32-bits
+++ a/arch/arm/mm/iomap.c
@@ -26,8 +26,8 @@ EXPORT_SYMBOL(ioport_unmap);
 #ifdef CONFIG_PCI
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len   = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len   = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
diff -puN arch/frv/mb93090-mb00/pci-iomap.c~iomap-fix-64-bits-resources-on-32-bits arch/frv/mb93090-mb00/pci-iomap.c
--- a/arch/frv/mb93090-mb00/pci-iomap.c~iomap-fix-64-bits-resources-on-32-bits
+++ a/arch/frv/mb93090-mb00/pci-iomap.c
@@ -13,8 +13,8 @@
 
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
diff -puN arch/mips/lib/iomap-pci.c~iomap-fix-64-bits-resources-on-32-bits arch/mips/lib/iomap-pci.c
--- a/arch/mips/lib/iomap-pci.c~iomap-fix-64-bits-resources-on-32-bits
+++ a/arch/mips/lib/iomap-pci.c
@@ -45,8 +45,8 @@ static void __iomem *ioport_map_pci(stru
  */
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
diff -puN arch/mn10300/unit-asb2305/pci-iomap.c~iomap-fix-64-bits-resources-on-32-bits arch/mn10300/unit-asb2305/pci-iomap.c
--- a/arch/mn10300/unit-asb2305/pci-iomap.c~iomap-fix-64-bits-resources-on-32-bits
+++ a/arch/mn10300/unit-asb2305/pci-iomap.c
@@ -16,8 +16,8 @@
  */
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
diff -puN arch/parisc/lib/iomap.c~iomap-fix-64-bits-resources-on-32-bits arch/parisc/lib/iomap.c
--- a/arch/parisc/lib/iomap.c~iomap-fix-64-bits-resources-on-32-bits
+++ a/arch/parisc/lib/iomap.c
@@ -438,8 +438,8 @@ void ioport_unmap(void __iomem *addr)
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
diff -puN arch/ppc/kernel/pci.c~iomap-fix-64-bits-resources-on-32-bits arch/ppc/kernel/pci.c
--- a/arch/ppc/kernel/pci.c~iomap-fix-64-bits-resources-on-32-bits
+++ a/arch/ppc/kernel/pci.c
@@ -1121,8 +1121,8 @@ void __init pci_init_resource(struct res
 
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len)
diff -puN arch/sh/drivers/pci/pci.c~iomap-fix-64-bits-resources-on-32-bits arch/sh/drivers/pci/pci.c
--- a/arch/sh/drivers/pci/pci.c~iomap-fix-64-bits-resources-on-32-bits
+++ a/arch/sh/drivers/pci/pci.c
@@ -191,8 +191,8 @@ void __init pcibios_update_irq(struct pc
 
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (unlikely(!len || !start))
diff -puN arch/sparc/lib/iomap.c~iomap-fix-64-bits-resources-on-32-bits arch/sparc/lib/iomap.c
--- a/arch/sparc/lib/iomap.c~iomap-fix-64-bits-resources-on-32-bits
+++ a/arch/sparc/lib/iomap.c
@@ -21,8 +21,8 @@ EXPORT_SYMBOL(ioport_unmap);
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
diff -puN arch/sparc64/lib/iomap.c~iomap-fix-64-bits-resources-on-32-bits arch/sparc64/lib/iomap.c
--- a/arch/sparc64/lib/iomap.c~iomap-fix-64-bits-resources-on-32-bits
+++ a/arch/sparc64/lib/iomap.c
@@ -21,8 +21,8 @@ EXPORT_SYMBOL(ioport_unmap);
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
diff -puN arch/v850/kernel/rte_mb_a_pci.c~iomap-fix-64-bits-resources-on-32-bits arch/v850/kernel/rte_mb_a_pci.c
--- a/arch/v850/kernel/rte_mb_a_pci.c~iomap-fix-64-bits-resources-on-32-bits
+++ a/arch/v850/kernel/rte_mb_a_pci.c
@@ -790,8 +790,8 @@ pci_free_consistent (struct pci_dev *pde
 
 void __iomem *pci_iomap (struct pci_dev *dev, int bar, unsigned long max)
 {
-	unsigned long start = pci_resource_start (dev, bar);
-	unsigned long len = pci_resource_len (dev, bar);
+	resource_size_t start = pci_resource_start (dev, bar);
+	resource_size_t len = pci_resource_len (dev, bar);
 
 	if (!start || len == 0)
 		return 0;
diff -puN lib/iomap.c~iomap-fix-64-bits-resources-on-32-bits lib/iomap.c
--- a/lib/iomap.c~iomap-fix-64-bits-resources-on-32-bits
+++ a/lib/iomap.c
@@ -257,7 +257,7 @@ EXPORT_SYMBOL(ioport_unmap);
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
 	resource_size_t start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
macintosh-therm_pm72-driver_lock-semaphore-to-mutex.patch
macintosh-qindfarm_smu_sat-semaphore-to-mutex.patch
machintosh-adb-driver-adb_handler_sem-semaphore-to-mutex.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
rtc-class-driver-for-ppc_md-rtc-functions.patch
rtc-class-driver-for-ppc_md-rtc-functions-fix.patch
powerpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch
asm-futexh-should-include-linux-uaccessh.patch
basic-braille-screen-reader-support-ppc-fix.patch

