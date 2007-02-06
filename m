From: akpm@linux-foundation.org
Subject: - arch-mips-user-array_size-macro-when-appropriate.patch removed from -mm tree
Date: Tue, 06 Feb 2007 11:42:59 -0800
Message-ID: <200702061943.l16Jh0c6026614@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48062 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbXBFTqX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 14:46:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     MIPS: user ARRAY_SIZE macro when appropriate
has been removed from the -mm tree.  Its filename was
     arch-mips-user-array_size-macro-when-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MIPS: user ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Use ARRAY_SIZE macro already defined in linux/kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/arc/identify.c                |    2 +-
 arch/mips/jmr3927/rbhma3100/setup.c     |    2 +-
 arch/mips/mips-boards/atlas/atlas_int.c |    5 +++--
 arch/mips/mips-boards/malta/malta_int.c |    5 +++--
 arch/mips/pci/fixup-vr4133.c            |    3 ++-
 5 files changed, 10 insertions(+), 7 deletions(-)

diff -puN arch/mips/arc/identify.c~arch-mips-user-array_size-macro-when-appropriate arch/mips/arc/identify.c
--- a/arch/mips/arc/identify.c~arch-mips-user-array_size-macro-when-appropriate
+++ a/arch/mips/arc/identify.c
@@ -77,7 +77,7 @@ static struct smatch * __init string_to_
 {
 	int i;
 
-	for (i = 0; i < (sizeof(mach_table) / sizeof (mach_table[0])); i++) {
+	for (i = 0; i < ARRAY_SIZE(mach_table); i++) {
 		if (!strcmp(s, mach_table[i].arcname))
 			return &mach_table[i];
 	}
diff -puN arch/mips/jmr3927/rbhma3100/setup.c~arch-mips-user-array_size-macro-when-appropriate arch/mips/jmr3927/rbhma3100/setup.c
--- a/arch/mips/jmr3927/rbhma3100/setup.c~arch-mips-user-array_size-macro-when-appropriate
+++ a/arch/mips/jmr3927/rbhma3100/setup.c
@@ -434,7 +434,7 @@ void __init tx3927_setup(void)
 
 	/* DMA */
 	tx3927_dmaptr->mcr = 0;
-	for (i = 0; i < sizeof(tx3927_dmaptr->ch) / sizeof(tx3927_dmaptr->ch[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(tx3927_dmaptr->ch); i++) {
 		/* reset channel */
 		tx3927_dmaptr->ch[i].ccr = TX3927_DMA_CCR_CHRST;
 		tx3927_dmaptr->ch[i].ccr = 0;
diff -puN arch/mips/mips-boards/atlas/atlas_int.c~arch-mips-user-array_size-macro-when-appropriate arch/mips/mips-boards/atlas/atlas_int.c
--- a/arch/mips/mips-boards/atlas/atlas_int.c~arch-mips-user-array_size-macro-when-appropriate
+++ a/arch/mips/mips-boards/atlas/atlas_int.c
@@ -32,6 +32,7 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
+#include <linux/kernel.h>
 
 #include <asm/gdb-stub.h>
 #include <asm/io.h>
@@ -220,7 +221,7 @@ msc_irqmap_t __initdata msc_irqmap[] = {
 	{MSC01C_INT_TMR,		MSC01_IRQ_EDGE, 0},
 	{MSC01C_INT_PCI,		MSC01_IRQ_LEVEL, 0},
 };
-int __initdata msc_nr_irqs = sizeof(msc_irqmap) / sizeof(*msc_irqmap);
+int __initdata msc_nr_irqs = ARRAY_SIZE(msc_irqmap);
 
 msc_irqmap_t __initdata msc_eicirqmap[] = {
 	{MSC01E_INT_SW0,		MSC01_IRQ_LEVEL, 0},
@@ -231,7 +232,7 @@ msc_irqmap_t __initdata msc_eicirqmap[] 
 	{MSC01E_INT_PERFCTR,		MSC01_IRQ_LEVEL, 0},
 	{MSC01E_INT_CPUCTR,		MSC01_IRQ_LEVEL, 0}
 };
-int __initdata msc_nr_eicirqs = sizeof(msc_eicirqmap) / sizeof(*msc_eicirqmap);
+int __initdata msc_nr_eicirqs = ARRAY_SIZE(msc_eicirqmap);
 
 void __init arch_init_irq(void)
 {
diff -puN arch/mips/mips-boards/malta/malta_int.c~arch-mips-user-array_size-macro-when-appropriate arch/mips/mips-boards/malta/malta_int.c
--- a/arch/mips/mips-boards/malta/malta_int.c~arch-mips-user-array_size-macro-when-appropriate
+++ a/arch/mips/mips-boards/malta/malta_int.c
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
+#include <linux/kernel.h>
 #include <linux/random.h>
 
 #include <asm/i8259.h>
@@ -289,7 +290,7 @@ msc_irqmap_t __initdata msc_irqmap[] = {
 	{MSC01C_INT_TMR,		MSC01_IRQ_EDGE, 0},
 	{MSC01C_INT_PCI,		MSC01_IRQ_LEVEL, 0},
 };
-int __initdata msc_nr_irqs = sizeof(msc_irqmap)/sizeof(msc_irqmap_t);
+int __initdata msc_nr_irqs = ARRAY_SIZE(msc_irqmap);
 
 msc_irqmap_t __initdata msc_eicirqmap[] = {
 	{MSC01E_INT_SW0,		MSC01_IRQ_LEVEL, 0},
@@ -303,7 +304,7 @@ msc_irqmap_t __initdata msc_eicirqmap[] 
 	{MSC01E_INT_PERFCTR,		MSC01_IRQ_LEVEL, 0},
 	{MSC01E_INT_CPUCTR,		MSC01_IRQ_LEVEL, 0}
 };
-int __initdata msc_nr_eicirqs = sizeof(msc_eicirqmap)/sizeof(msc_irqmap_t);
+int __initdata msc_nr_eicirqs = ARRAY_SIZE(msc_eicirqmap);
 
 void __init arch_init_irq(void)
 {
diff -puN arch/mips/pci/fixup-vr4133.c~arch-mips-user-array_size-macro-when-appropriate arch/mips/pci/fixup-vr4133.c
--- a/arch/mips/pci/fixup-vr4133.c~arch-mips-user-array_size-macro-when-appropriate
+++ a/arch/mips/pci/fixup-vr4133.c
@@ -17,6 +17,7 @@
  */
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <linux/kernel.h>
 
 #include <asm/io.h>
 #include <asm/i8259.h>
@@ -143,7 +144,7 @@ int rockhopper_get_irq(struct pci_dev *d
 	if (bus == NULL)
 		return -1;
 
-	for (i = 0; i < sizeof (int_map) / sizeof (int_map[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(int_map); i++) {
 		if (int_map[i].bus == bus->number && int_map[i].slot == slot) {
 			int line;
 			for (line = 0; line < 4; line++)
_

Patches currently in -mm which might be from darwish.07@gmail.com are

arch-arm-use-array_size-macro-when-appropriate.patch
arch-avr32-use-array_size-macro-when-appropriate.patch
arch-powerpc-user-array_size-macro-when-appropriate.patch
arch-ppc-user-array_size-macro-when-appropriate.patch
git-dvb.patch
arch-mips-user-array_size-macro-when-appropriate.patch
git-netdev-all.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
dac960-kmalloc-kzalloc-casting-cleanups.patch
arch-arm26-use-array_size-macro-when-appropriate.patch
arch-m68knommu-user-array_size-macro-when-appropriate.patch
arch-m68k-user-array_size-macro-when-appropriate.patch
arch-cris-user-array_size-macro-when-appropriate.patch
arch-v850-user-array_size-macro-when-appropriate.patch
isdn-capi-use-array_size-when-appropriate.patch
