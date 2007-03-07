From: akpm@linux-foundation.org
Subject: + x86_64-irq-keep-consistent-for-changing-irq0_vector-from-0x20-to-0x30.patch added to -mm tree
Date: Tue, 06 Mar 2007 17:10:29 -0800
Message-ID: <200703070110.l271AT05015091@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41498 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932610AbXCGBKf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 20:10:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai.lu@amd.com, ak@suse.de, ebiederm@xmission.com


The patch titled
     x86_64 irq: keep consistent for changing IRQ0_VECTOR from 0x20 to 0x30
has been added to the -mm tree.  Its filename is
     x86_64-irq-keep-consistent-for-changing-irq0_vector-from-0x20-to-0x30.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64 irq: keep consistent for changing IRQ0_VECTOR from 0x20 to 0x30
From: "Yinghai Lu" <yinghai.lu@amd.com>

FIRST_EXTERNAL_VECTOR is used for IRQ_MOVE_CLEANUP_VECTOR, and IRQ0 starting
from FIRST_EXTERNAL_VECTOR + 0x10.  So reduce interrupt array for IRQ.

Signed-off-by: Yinghai Lu <yinghai.lu@amd.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/i8259.c   |   16 ++++++++--------
 arch/x86_64/kernel/io_apic.c |    2 +-
 include/asm-x86_64/hw_irq.h  |    2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff -puN arch/x86_64/kernel/i8259.c~x86_64-irq-keep-consistent-for-changing-irq0_vector-from-0x20-to-0x30 arch/x86_64/kernel/i8259.c
--- a/arch/x86_64/kernel/i8259.c~x86_64-irq-keep-consistent-for-changing-irq0_vector-from-0x20-to-0x30
+++ a/arch/x86_64/kernel/i8259.c
@@ -45,7 +45,7 @@
 
 /*
  * ISA PIC or low IO-APIC triggered (INTA-cycle or APIC) interrupts:
- * (these are usually mapped to vectors 0x20-0x2f)
+ * (these are usually mapped to vectors 0x30-0x3f)
  */
 
 /*
@@ -58,7 +58,7 @@
  *
  * (these are usually mapped into the 0x30-0xff vector range)
  */
-				      BUILD_16_IRQS(0x2) BUILD_16_IRQS(0x3)
+							 BUILD_16_IRQS(0x3)
 BUILD_16_IRQS(0x4) BUILD_16_IRQS(0x5) BUILD_16_IRQS(0x6) BUILD_16_IRQS(0x7)
 BUILD_16_IRQS(0x8) BUILD_16_IRQS(0x9) BUILD_16_IRQS(0xa) BUILD_16_IRQS(0xb)
 BUILD_16_IRQS(0xc) BUILD_16_IRQS(0xd) BUILD_16_IRQS(0xe) BUILD_16_IRQS(0xf)
@@ -77,8 +77,8 @@ BUILD_16_IRQS(0xc) BUILD_16_IRQS(0xd) BU
 	IRQ(x,c), IRQ(x,d), IRQ(x,e), IRQ(x,f)
 
 /* for the irq vectors */
-static void (*interrupt[NR_VECTORS - FIRST_EXTERNAL_VECTOR])(void) = {
-					  IRQLIST_16(0x2), IRQLIST_16(0x3),
+static void (*interrupt[NR_VECTORS - IRQ0_VECTOR])(void) = {
+					  		   IRQLIST_16(0x3),
 	IRQLIST_16(0x4), IRQLIST_16(0x5), IRQLIST_16(0x6), IRQLIST_16(0x7),
 	IRQLIST_16(0x8), IRQLIST_16(0x9), IRQLIST_16(0xa), IRQLIST_16(0xb),
 	IRQLIST_16(0xc), IRQLIST_16(0xd), IRQLIST_16(0xe), IRQLIST_16(0xf)
@@ -299,7 +299,7 @@ void init_8259A(int auto_eoi)
 	 * outb_p - this has to work on a wide range of PC hardware.
 	 */
 	outb_p(0x11, 0x20);	/* ICW1: select 8259A-1 init */
-	outb_p(IRQ0_VECTOR, 0x21);	/* ICW2: 8259A-1 IR0-7 mapped to 0x20-0x27 */
+	outb_p(IRQ0_VECTOR, 0x21);	/* ICW2: 8259A-1 IR0-7 mapped to 0x30-0x37 */
 	outb_p(0x04, 0x21);	/* 8259A-1 (the master) has a slave on IR2 */
 	if (auto_eoi)
 		outb_p(0x03, 0x21);	/* master does Auto EOI */
@@ -307,7 +307,7 @@ void init_8259A(int auto_eoi)
 		outb_p(0x01, 0x21);	/* master expects normal EOI */
 
 	outb_p(0x11, 0xA0);	/* ICW1: select 8259A-2 init */
-	outb_p(IRQ8_VECTOR, 0xA1);	/* ICW2: 8259A-2 IR0-7 mapped to 0x28-0x2f */
+	outb_p(IRQ8_VECTOR, 0xA1);	/* ICW2: 8259A-2 IR0-7 mapped to 0x38-0x3f */
 	outb_p(0x02, 0xA1);	/* 8259A-2 is a slave on master's IR2 */
 	outb_p(0x01, 0xA1);	/* (slave's support for AEOI in flat mode
 				    is to be investigated) */
@@ -513,8 +513,8 @@ void __init init_IRQ(void)
 	 * us. (some of these will be overridden and become
 	 * 'special' SMP interrupts)
 	 */
-	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
-		int vector = FIRST_EXTERNAL_VECTOR + i;
+	for (i = 0; i < (NR_VECTORS - IRQ0_VECTOR); i++) {
+		int vector = IRQ0_VECTOR + i;
 		if (vector != IA32_SYSCALL_VECTOR)
 			set_intr_gate(vector, interrupt[i]);
 	}
diff -puN arch/x86_64/kernel/io_apic.c~x86_64-irq-keep-consistent-for-changing-irq0_vector-from-0x20-to-0x30 arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~x86_64-irq-keep-consistent-for-changing-irq0_vector-from-0x20-to-0x30
+++ a/arch/x86_64/kernel/io_apic.c
@@ -1398,7 +1398,7 @@ asmlinkage void smp_irq_move_cleanup_int
 	irq_enter();
 
 	me = smp_processor_id();
-	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
+	for (vector = IRQ0_VECTOR; vector < NR_VECTORS; vector++) {
 		unsigned int irq;
 		struct irq_desc *desc;
 		struct irq_cfg *cfg;
diff -puN include/asm-x86_64/hw_irq.h~x86_64-irq-keep-consistent-for-changing-irq0_vector-from-0x20-to-0x30 include/asm-x86_64/hw_irq.h
--- a/include/asm-x86_64/hw_irq.h~x86_64-irq-keep-consistent-for-changing-irq0_vector-from-0x20-to-0x30
+++ a/include/asm-x86_64/hw_irq.h
@@ -38,7 +38,7 @@
 #define IRQ_MOVE_CLEANUP_VECTOR	FIRST_EXTERNAL_VECTOR
  
 /*
- * Vectors 0x20-0x2f are used for ISA interrupts.
+ * Vectors 0x30-0x3f are used for ISA interrupts.
  */
 #define IRQ0_VECTOR		FIRST_EXTERNAL_VECTOR + 0x10
 #define IRQ1_VECTOR		IRQ0_VECTOR + 1
_

Patches currently in -mm which might be from yinghai.lu@amd.com are

x86_64-irq-remove-extra-smp_processor_id-calling.patch
x86_64-irq-make-affinity-works-for-genapic_flat-mode.patch
x86_64-irq-keep-consistent-for-changing-irq0_vector-from-0x20-to-0x30.patch
