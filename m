From: akpm@linux-foundation.org
Subject: + iomap-fix-64-bits-resources-on-32-bits.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:33:42 -0800
Message-ID: <200802230734.m1N7YVfu018295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270AbYBWHyJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, linux-arch@vger.kernel.org


The patch titled
     iomap: fix 64 bits resources on 32 bits
has been added to the -mm tree.  Its filename is
     iomap-fix-64-bits-resources-on-32-bits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 lib/iomap.c                           |    4 ++--
 12 files changed, 24 insertions(+), 24 deletions(-)

diff -puN arch/alpha/kernel/pci.c~iomap-fix-64-bits-resources-on-32-bits arch/alpha/kernel/pci.c
--- a/arch/alpha/kernel/pci.c~iomap-fix-64-bits-resources-on-32-bits
+++ a/arch/alpha/kernel/pci.c
@@ -547,8 +547,8 @@ sys_pciconfig_iobase(long which, unsigne
 
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
@@ -1176,8 +1176,8 @@ void __init pci_init_resource(struct res
 
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
@@ -256,8 +256,8 @@ EXPORT_SYMBOL(ioport_unmap);
  * */
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-md-accel.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
drivers-block-viodasdc-use-field_sizeof.patch
percpu-fix-debug_preempt-per_cpu-checking.patch
iomap-fix-64-bits-resources-on-32-bits.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
fb-add-support-for-foreign-endianness.patch
fb-add-support-for-foreign-endianness-add-support-for-choice-foreign-endianness.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
powerpc-offb-add-support-for-foreign-endianness.patch
asm-futexh-should-include-linux-uaccessh.patch
