From: akpm@linux-foundation.org
Subject: - powerpc-move-of_irq_to_resource-to-prom_parsec.patch removed from -mm tree
Date: Fri, 16 Feb 2007 17:57:14 -0800
Message-ID: <200702170157.l1H1vE4L016240@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44372 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932623AbXBQB53 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 20:57:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     move of_irq_to_resource to prom_parse.c (powerpc)
has been removed from the -mm tree.  Its filename was
     powerpc-move-of_irq_to_resource-to-prom_parsec.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: move of_irq_to_resource to prom_parse.c (powerpc)
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Here is the patch that follows Benjamin Herrenschmidt's comments to move
of_irq_to_resource from prom.h to prom_parse.c. It solves the following issue :

> include/asm/prom.h: In function `of_irq_to_resource':
> include/asm/prom.h:339: warning: implicit declaration of function `irq_of_parse_and_map'
> include/asm/prom.h:343: error: `NO_IRQ' undeclared (first use in this function)
> include/asm/prom.h:343: error: (Each undeclared identifier is reported only once
> include/asm/prom.h:343: error: for each function it appears in.)
>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/prom_parse.c |   15 +++++++++++++++
 include/asm-powerpc/prom.h       |   17 +++--------------
 2 files changed, 18 insertions(+), 14 deletions(-)

diff -puN arch/powerpc/kernel/prom_parse.c~powerpc-move-of_irq_to_resource-to-prom_parsec arch/powerpc/kernel/prom_parse.c
--- a/arch/powerpc/kernel/prom_parse.c~powerpc-move-of_irq_to_resource-to-prom_parsec
+++ a/arch/powerpc/kernel/prom_parse.c
@@ -1003,3 +1003,18 @@ int of_irq_map_one(struct device_node *d
 	return res;
 }
 EXPORT_SYMBOL_GPL(of_irq_map_one);
+
+int of_irq_to_resource(struct device_node *dev, int index, struct resource *r)
+{
+	int irq = irq_of_parse_and_map(dev, index);
+
+	/* Only dereference the resource if both the
+	 * resource and the irq are valid. */
+	if (r && irq != NO_IRQ) {
+		r->start = r->end = irq;
+		r->flags = IORESOURCE_IRQ;
+	}
+
+	return irq;
+}
+EXPORT_SYMBOL_GPL(of_irq_to_resource);
diff -puN include/asm-powerpc/prom.h~powerpc-move-of_irq_to_resource-to-prom_parsec include/asm-powerpc/prom.h
--- a/include/asm-powerpc/prom.h~powerpc-move-of_irq_to_resource-to-prom_parsec
+++ a/include/asm-powerpc/prom.h
@@ -19,6 +19,7 @@
 #include <linux/proc_fs.h>
 #include <linux/platform_device.h>
 #include <asm/atomic.h>
+#include <asm/irq.h>
 
 /* Definitions used by the flattened device tree */
 #define OF_DT_HEADER		0xd00dfeed	/* marker */
@@ -334,20 +335,8 @@ extern int of_irq_map_one(struct device_
 struct pci_dev;
 extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
 
-static inline int of_irq_to_resource(struct device_node *dev, int index, struct resource *r)
-{
-	int irq = irq_of_parse_and_map(dev, index);
-
-	/* Only dereference the resource if both the
-	 * resource and the irq are valid. */
-	if (r && irq != NO_IRQ) {
-		r->start = r->end = irq;
-		r->flags = IORESOURCE_IRQ;
-	}
-
-	return irq;
-}
-
+extern int of_irq_to_resource(struct device_node *dev, int index,
+			struct resource *r);
 
 #endif /* __KERNEL__ */
 #endif /* _POWERPC_PROM_H */
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-powerpc.patch
powerpc-move-of_irq_to_resource-to-prom_parsec.patch
git-mips.patch
git-s390.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
local_t-architecture-independant-extension.patch
local_t-alpha-extension.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-mips-extension-fix.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-powerpc-extension-fix.patch
local_t-powerpc-extension-shrink-powerpc-localh.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-kconfig-menus-fix.patch
linux-kernel-markers-kconfig-menus-fix-2.patch
linux-kernel-markers-kconfig-menus-fix-3.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-fix.patch
linux-kernel-markers-documentation-update-adds-context.patch
linux-kernel-markers-documentation-update-markerh.patch
