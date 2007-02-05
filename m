From: akpm@linux-foundation.org
Subject: + arch-v850-user-array_size-macro-when-appropriate.patch added to -mm tree
Date: Mon, 05 Feb 2007 14:09:27 -0800
Message-ID: <200702052209.l15M9Rk4000383@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35943 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964857AbXBEWJe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 17:09:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, uclinux-v850@lsi.nec.co.jp


The patch titled
     V850: user ARRAY_SIZE macro when appropriate
has been added to the -mm tree.  Its filename is
     arch-v850-user-array_size-macro-when-appropriate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: V850: user ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Use ARRAY_SIZE macro already defined in linux/kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: Miles Bader <uclinux-v850@lsi.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/v850/kernel/anna.c         |    2 +-
 arch/v850/kernel/as85ep1.c      |    2 +-
 arch/v850/kernel/fpga85e2c.c    |    2 +-
 arch/v850/kernel/gbus_int.c     |    6 +++---
 arch/v850/kernel/ma.c           |    2 +-
 arch/v850/kernel/me2.c          |    2 +-
 arch/v850/kernel/rte_cb.c       |    4 ++--
 arch/v850/kernel/rte_mb_a_pci.c |    3 +--
 arch/v850/kernel/rte_me2_cb.c   |    3 +--
 arch/v850/kernel/teg.c          |    2 +-
 10 files changed, 13 insertions(+), 15 deletions(-)

diff -puN arch/v850/kernel/anna.c~arch-v850-user-array_size-macro-when-appropriate arch/v850/kernel/anna.c
--- a/arch/v850/kernel/anna.c~arch-v850-user-array_size-macro-when-appropriate
+++ a/arch/v850/kernel/anna.c
@@ -114,7 +114,7 @@ static struct v850e_intc_irq_init irq_in
 	{ "ST",  IRQ_INTST(0), 	IRQ_INTST_NUM, 	3, 5 },
 	{ 0 }
 };
-#define NUM_IRQ_INITS ((sizeof irq_inits / sizeof irq_inits[0]) - 1)
+#define NUM_IRQ_INITS (ARRAY_SIZE(irq_inits) - 1)
 
 static struct hw_interrupt_type hw_itypes[NUM_IRQ_INITS];
 
diff -puN arch/v850/kernel/as85ep1.c~arch-v850-user-array_size-macro-when-appropriate arch/v850/kernel/as85ep1.c
--- a/arch/v850/kernel/as85ep1.c~arch-v850-user-array_size-macro-when-appropriate
+++ a/arch/v850/kernel/as85ep1.c
@@ -142,7 +142,7 @@ static struct v850e_intc_irq_init irq_in
 	{ "ST",  IRQ_INTST(0), 	IRQ_INTST_NUM, 	3, 5 },
 	{ 0 }
 };
-#define NUM_IRQ_INITS ((sizeof irq_inits / sizeof irq_inits[0]) - 1)
+#define NUM_IRQ_INITS (ARRAY_SIZE(irq_inits) - 1)
 
 static struct hw_interrupt_type hw_itypes[NUM_IRQ_INITS];
 
diff -puN arch/v850/kernel/fpga85e2c.c~arch-v850-user-array_size-macro-when-appropriate arch/v850/kernel/fpga85e2c.c
--- a/arch/v850/kernel/fpga85e2c.c~arch-v850-user-array_size-macro-when-appropriate
+++ a/arch/v850/kernel/fpga85e2c.c
@@ -138,7 +138,7 @@ struct v850e_intc_irq_init irq_inits[] =
 	{ "RPU", IRQ_RPU(0),	IRQ_RPU_NUM,	1, 6 },
 	{ 0 }
 };
-#define NUM_IRQ_INITS ((sizeof irq_inits / sizeof irq_inits[0]) - 1)
+#define NUM_IRQ_INITS (ARRAY_SIZE(irq_inits) - 1)
 
 struct hw_interrupt_type hw_itypes[NUM_IRQ_INITS];
 
diff -puN arch/v850/kernel/gbus_int.c~arch-v850-user-array_size-macro-when-appropriate arch/v850/kernel/gbus_int.c
--- a/arch/v850/kernel/gbus_int.c~arch-v850-user-array_size-macro-when-appropriate
+++ a/arch/v850/kernel/gbus_int.c
@@ -16,6 +16,7 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/signal.h>
+#include <linux/kernel.h>
 
 #include <asm/machdep.h>
 
@@ -36,7 +37,7 @@ struct used_gint {
 	{ 1, GBUS_INT_PRIORITY_HIGH },
 	{ 3, GBUS_INT_PRIORITY_LOW }
 };
-#define NUM_USED_GINTS	(sizeof used_gint / sizeof used_gint[0])
+#define NUM_USED_GINTS ARRAY_SIZE(used_gint)
 
 /* A table of which GINT is used by each GBUS interrupts (they are
    assigned based on priority).  */
@@ -231,8 +232,7 @@ struct gbus_int_irq_init gbus_irq_inits[
 	{ "GBUS_INT", IRQ_GBUS_INT(0), IRQ_GBUS_INT_NUM, 1, 6},
 	{ 0 }
 };
-#define NUM_GBUS_IRQ_INITS  \
-   ((sizeof gbus_irq_inits / sizeof gbus_irq_inits[0]) - 1)
+#define NUM_GBUS_IRQ_INITS (ARRAY_SIZE(gbus_irq_inits) - 1)
 
 static struct hw_interrupt_type gbus_hw_itypes[NUM_GBUS_IRQ_INITS];
 
diff -puN arch/v850/kernel/ma.c~arch-v850-user-array_size-macro-when-appropriate arch/v850/kernel/ma.c
--- a/arch/v850/kernel/ma.c~arch-v850-user-array_size-macro-when-appropriate
+++ a/arch/v850/kernel/ma.c
@@ -43,7 +43,7 @@ static struct v850e_intc_irq_init irq_in
 	{ "ST",  IRQ_INTST(0), 	IRQ_INTST_NUM, 	4, 5 },
 	{ 0 }
 };
-#define NUM_IRQ_INITS ((sizeof irq_inits / sizeof irq_inits[0]) - 1)
+#define NUM_IRQ_INITS (ARRAY_SIZE(irq_inits) - 1)
 
 static struct hw_interrupt_type hw_itypes[NUM_IRQ_INITS];
 
diff -puN arch/v850/kernel/me2.c~arch-v850-user-array_size-macro-when-appropriate arch/v850/kernel/me2.c
--- a/arch/v850/kernel/me2.c~arch-v850-user-array_size-macro-when-appropriate
+++ a/arch/v850/kernel/me2.c
@@ -44,7 +44,7 @@ static struct v850e_intc_irq_init irq_in
 	{ "UBTITO", IRQ_INTUBTITO(0), IRQ_INTUBTITO_NUM, 5, 4 },
 	{ 0 }
 };
-#define NUM_IRQ_INITS ((sizeof irq_inits / sizeof irq_inits[0]) - 1)
+#define NUM_IRQ_INITS (ARRAY_SIZE(irq_inits) - 1)
 
 static struct hw_interrupt_type hw_itypes[NUM_IRQ_INITS];
 
diff -puN arch/v850/kernel/rte_cb.c~arch-v850-user-array_size-macro-when-appropriate arch/v850/kernel/rte_cb.c
--- a/arch/v850/kernel/rte_cb.c~arch-v850-user-array_size-macro-when-appropriate
+++ a/arch/v850/kernel/rte_cb.c
@@ -15,6 +15,7 @@
 #include <linux/irq.h>
 #include <linux/fs.h>
 #include <linux/module.h>
+#include <linux/kernel.h>
 
 #include <asm/machdep.h>
 #include <asm/v850e_uart.h>
@@ -176,8 +177,7 @@ static struct gbus_int_irq_init gbus_irq
 #endif
 	{ 0 }
 };
-#define NUM_GBUS_IRQ_INITS  \
-   ((sizeof gbus_irq_inits / sizeof gbus_irq_inits[0]) - 1)
+#define NUM_GBUS_IRQ_INITS (ARRAY_SIZE(gbus_irq_inits) - 1)
 
 static struct hw_interrupt_type gbus_hw_itypes[NUM_GBUS_IRQ_INITS];
 
diff -puN arch/v850/kernel/rte_mb_a_pci.c~arch-v850-user-array_size-macro-when-appropriate arch/v850/kernel/rte_mb_a_pci.c
--- a/arch/v850/kernel/rte_mb_a_pci.c~arch-v850-user-array_size-macro-when-appropriate
+++ a/arch/v850/kernel/rte_mb_a_pci.c
@@ -70,8 +70,7 @@ static struct mb_pci_dev_irq mb_pci_dev_
 	/* PCI slot 2 */
 	{ 9, 	IRQ_MB_A_PCI2(0),	1 }
 };
-#define NUM_MB_PCI_DEV_IRQS \
-  (sizeof mb_pci_dev_irqs / sizeof mb_pci_dev_irqs[0])
+#define NUM_MB_PCI_DEV_IRQS ARRAY_SIZE(mb_pci_dev_irqs)
 
 
 /* PCI configuration primitives.  */
diff -puN arch/v850/kernel/rte_me2_cb.c~arch-v850-user-array_size-macro-when-appropriate arch/v850/kernel/rte_me2_cb.c
--- a/arch/v850/kernel/rte_me2_cb.c~arch-v850-user-array_size-macro-when-appropriate
+++ a/arch/v850/kernel/rte_me2_cb.c
@@ -170,8 +170,7 @@ static struct cb_pic_irq_init cb_pic_irq
 	{ "CB_EXTTM2",       IRQ_CB_EXTTM2,       1, 1, 6 },
 	{ 0 }
 };
-#define NUM_CB_PIC_IRQ_INITS  \
-   ((sizeof cb_pic_irq_inits / sizeof cb_pic_irq_inits[0]) - 1)
+#define NUM_CB_PIC_IRQ_INITS (ARRAY_SIZE(cb_pic_irq_inits) - 1)
 
 static struct hw_interrupt_type cb_pic_hw_itypes[NUM_CB_PIC_IRQ_INITS];
 static unsigned char cb_pic_active_irqs = 0;
diff -puN arch/v850/kernel/teg.c~arch-v850-user-array_size-macro-when-appropriate arch/v850/kernel/teg.c
--- a/arch/v850/kernel/teg.c~arch-v850-user-array_size-macro-when-appropriate
+++ a/arch/v850/kernel/teg.c
@@ -43,7 +43,7 @@ static struct v850e_intc_irq_init irq_in
 	{ "ST",	 IRQ_INTST(0),	IRQ_INTST_NUM,	1, 5 },
 	{ 0 }
 };
-#define NUM_IRQ_INITS ((sizeof irq_inits / sizeof irq_inits[0]) - 1)
+#define NUM_IRQ_INITS (ARRAY_SIZE(irq_inits) - 1)
 
 static struct hw_interrupt_type hw_itypes[NUM_IRQ_INITS];
 
_

Patches currently in -mm which might be from darwish.07@gmail.com are

git-dvb.patch
git-netdev-all.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
dac960-kmalloc-kzalloc-casting-cleanups.patch
isdn-capi-use-array_size-when-appropriate.patch
arch-cris-user-array_size-macro-when-appropriate.patch
arch-avr32-use-array_size-macro-when-appropriate.patch
arch-m68knommu-user-array_size-macro-when-appropriate.patch
arch-v850-user-array_size-macro-when-appropriate.patch
arch-powerpc-user-array_size-macro-when-appropriate.patch
arch-ppc-user-array_size-macro-when-appropriate.patch
arch-mips-user-array_size-macro-when-appropriate.patch
arch-m68k-user-array_size-macro-when-appropriate.patch
arch-arm-use-array_size-macro-when-appropriate.patch
arch-arm26-use-array_size-macro-when-appropriate.patch
