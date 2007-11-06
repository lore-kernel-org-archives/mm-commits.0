From: akpm@linux-foundation.org
Subject: - x86-make-i8259_64-more-_32-like.patch removed from -mm tree
Date: Tue, 06 Nov 2007 01:22:34 -0800
Message-ID: <200711060929.lA69TNl8016535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47845 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753751AbXKFJ3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 04:29:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@place.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: Make i8259_64 more _32-like
has been removed from the -mm tree.  Its filename was
     x86-make-i8259_64-more-_32-like.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: x86: Make i8259_64 more _32-like
From: Paul Jimenez <pj@place.org>

This patch mainly hinges around two includes and their ramifications:

#include <i8259.h>	which provides cached_{slave,master}_mask
#include <io_ports.h>	which provides PIC_{MASTER,SLAVE}_{IMR,CMD}

Adding these two includes and using those half dozen or so definitions
removed 140+ lines of diffs between i8259_32.c and i8259_64.c, thus making
it easier for the real substantitive differences between them to show up,
and hopefully therefore making it easier to eventually merge the two.  All
the warnings that checkpatch.pl throws (missing spaces after commas and >80
character lines) exist intentionally to match i8259_32.c.

Signed-off-by: Paul Jimenez <pj@place.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/i8259_64.c |  141 +++++++++++++++++------------------
 1 file changed, 71 insertions(+), 70 deletions(-)

diff -puN arch/x86/kernel/i8259_64.c~x86-make-i8259_64-more-_32-like arch/x86/kernel/i8259_64.c
--- a/arch/x86/kernel/i8259_64.c~x86-make-i8259_64-more-_32-like
+++ a/arch/x86/kernel/i8259_64.c
@@ -21,6 +21,9 @@
 #include <asm/delay.h>
 #include <asm/desc.h>
 #include <asm/apic.h>
+#include <asm/i8259.h>
+
+#include <io_ports.h>
 
 /*
  * Common place to define all x86 IRQ vectors
@@ -116,10 +119,6 @@ static struct irq_chip i8259A_chip = {
  */
 static unsigned int cached_irq_mask = 0xffff;
 
-#define __byte(x,y) 	(((unsigned char *)&(y))[x])
-#define cached_21	(__byte(0,cached_irq_mask))
-#define cached_A1	(__byte(1,cached_irq_mask))
-
 /*
  * Not all IRQs can be routed through the IO-APIC, eg. on certain (older)
  * boards the timer interrupt is not really connected to any IO-APIC pin,
@@ -139,9 +138,9 @@ void disable_8259A_irq(unsigned int irq)
 	spin_lock_irqsave(&i8259A_lock, flags);
 	cached_irq_mask |= mask;
 	if (irq & 8)
-		outb(cached_A1,0xA1);
+		outb(cached_slave_mask, PIC_SLAVE_IMR);
 	else
-		outb(cached_21,0x21);
+		outb(cached_master_mask, PIC_MASTER_IMR);
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
@@ -153,9 +152,9 @@ void enable_8259A_irq(unsigned int irq)
 	spin_lock_irqsave(&i8259A_lock, flags);
 	cached_irq_mask &= mask;
 	if (irq & 8)
-		outb(cached_A1,0xA1);
+		outb(cached_slave_mask, PIC_SLAVE_IMR);
 	else
-		outb(cached_21,0x21);
+		outb(cached_master_mask, PIC_MASTER_IMR);
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
@@ -167,9 +166,9 @@ int i8259A_irq_pending(unsigned int irq)
 
 	spin_lock_irqsave(&i8259A_lock, flags);
 	if (irq < 8)
-		ret = inb(0x20) & mask;
+		ret = inb(PIC_MASTER_CMD) & mask;
 	else
-		ret = inb(0xA0) & (mask >> 8);
+		ret = inb(PIC_SLAVE_CMD) & (mask >> 8);
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 
 	return ret;
@@ -196,14 +195,14 @@ static inline int i8259A_irq_real(unsign
 	int irqmask = 1<<irq;
 
 	if (irq < 8) {
-		outb(0x0B,0x20);		/* ISR register */
-		value = inb(0x20) & irqmask;
-		outb(0x0A,0x20);		/* back to the IRR register */
+		outb(0x0B,PIC_MASTER_CMD);	/* ISR register */
+		value = inb(PIC_MASTER_CMD) & irqmask;
+		outb(0x0A,PIC_MASTER_CMD);	/* back to the IRR register */
 		return value;
 	}
-	outb(0x0B,0xA0);		/* ISR register */
-	value = inb(0xA0) & (irqmask >> 8);
-	outb(0x0A,0xA0);		/* back to the IRR register */
+	outb(0x0B,PIC_SLAVE_CMD);	/* ISR register */
+	value = inb(PIC_SLAVE_CMD) & (irqmask >> 8);
+	outb(0x0A,PIC_SLAVE_CMD);	/* back to the IRR register */
 	return value;
 }
 
@@ -240,14 +239,14 @@ static void mask_and_ack_8259A(unsigned 
 
 handle_real_irq:
 	if (irq & 8) {
-		inb(0xA1);		/* DUMMY - (do we need this?) */
-		outb(cached_A1,0xA1);
-		outb(0x60+(irq&7),0xA0);/* 'Specific EOI' to slave */
-		outb(0x62,0x20);	/* 'Specific EOI' to master-IRQ2 */
+		inb(PIC_SLAVE_IMR);	/* DUMMY - (do we need this?) */
+		outb(cached_slave_mask, PIC_SLAVE_IMR);
+		outb(0x60+(irq&7),PIC_SLAVE_CMD);/* 'Specific EOI' to slave */
+		outb(0x60+PIC_CASCADE_IR,PIC_MASTER_CMD); /* 'Specific EOI' to master-IRQ2 */
 	} else {
-		inb(0x21);		/* DUMMY - (do we need this?) */
-		outb(cached_21,0x21);
-		outb(0x60+irq,0x20);	/* 'Specific EOI' to master */
+		inb(PIC_MASTER_IMR);	/* DUMMY - (do we need this?) */
+		outb(cached_master_mask, PIC_MASTER_IMR);
+		outb(0x60+irq,PIC_MASTER_CMD);	/* 'Specific EOI' to master */
 	}
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 	return;
@@ -283,51 +282,6 @@ spurious_8259A_irq:
 	}
 }
 
-void init_8259A(int auto_eoi)
-{
-	unsigned long flags;
-
-	i8259A_auto_eoi = auto_eoi;
-
-	spin_lock_irqsave(&i8259A_lock, flags);
-
-	outb(0xff, 0x21);	/* mask all of 8259A-1 */
-	outb(0xff, 0xA1);	/* mask all of 8259A-2 */
-
-	/*
-	 * outb_p - this has to work on a wide range of PC hardware.
-	 */
-	outb_p(0x11, 0x20);	/* ICW1: select 8259A-1 init */
-	outb_p(IRQ0_VECTOR, 0x21);	/* ICW2: 8259A-1 IR0-7 mapped to 0x30-0x37 */
-	outb_p(0x04, 0x21);	/* 8259A-1 (the master) has a slave on IR2 */
-	if (auto_eoi)
-		outb_p(0x03, 0x21);	/* master does Auto EOI */
-	else
-		outb_p(0x01, 0x21);	/* master expects normal EOI */
-
-	outb_p(0x11, 0xA0);	/* ICW1: select 8259A-2 init */
-	outb_p(IRQ8_VECTOR, 0xA1);	/* ICW2: 8259A-2 IR0-7 mapped to 0x38-0x3f */
-	outb_p(0x02, 0xA1);	/* 8259A-2 is a slave on master's IR2 */
-	outb_p(0x01, 0xA1);	/* (slave's support for AEOI in flat mode
-				    is to be investigated) */
-
-	if (auto_eoi)
-		/*
-		 * in AEOI mode we just have to mask the interrupt
-		 * when acking.
-		 */
-		i8259A_chip.mask_ack = disable_8259A_irq;
-	else
-		i8259A_chip.mask_ack = mask_and_ack_8259A;
-
-	udelay(100);		/* wait for 8259A to initialize */
-
-	outb(cached_21, 0x21);	/* restore master IRQ mask */
-	outb(cached_A1, 0xA1);	/* restore slave IRQ mask */
-
-	spin_unlock_irqrestore(&i8259A_lock, flags);
-}
-
 static char irq_trigger[2];
 /**
  * ELCR registers (0x4d0, 0x4d1) control edge/level of IRQ
@@ -364,8 +318,8 @@ static int i8259A_shutdown(struct sys_de
 	 * the kernel initialization code can get it
 	 * out of.
 	 */
-	outb(0xff, 0x21);	/* mask all of 8259A-1 */
-	outb(0xff, 0xA1);	/* mask all of 8259A-1 */
+	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
+	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-1 */
 	return 0;
 }
 
@@ -391,6 +345,53 @@ static int __init i8259A_init_sysfs(void
 
 device_initcall(i8259A_init_sysfs);
 
+void init_8259A(int auto_eoi)
+{
+	unsigned long flags;
+
+	i8259A_auto_eoi = auto_eoi;
+
+	spin_lock_irqsave(&i8259A_lock, flags);
+
+	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
+	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
+
+	/*
+	 * outb_p - this has to work on a wide range of PC hardware.
+	 */
+	outb_p(0x11, PIC_MASTER_CMD);	/* ICW1: select 8259A-1 init */
+	outb_p(IRQ0_VECTOR, PIC_MASTER_IMR);	/* ICW2: 8259A-1 IR0-7 mapped to 0x30-0x37 */
+	outb_p(0x04, PIC_MASTER_IMR);	/* 8259A-1 (the master) has a slave on IR2 */
+	if (auto_eoi)	/* master does Auto EOI */
+		outb_p(MASTER_ICW4_DEFAULT | PIC_ICW4_AEOI, PIC_MASTER_IMR);
+	else		/* master expects normal EOI */
+		outb_p(MASTER_ICW4_DEFAULT, PIC_MASTER_IMR);
+
+	outb_p(0x11, PIC_SLAVE_CMD);	/* ICW1: select 8259A-2 init */
+	outb_p(IRQ8_VECTOR, PIC_SLAVE_IMR);	/* ICW2: 8259A-2 IR0-7 mapped to 0x38-0x3f */
+	outb_p(PIC_CASCADE_IR, PIC_SLAVE_IMR);	/* 8259A-2 is a slave on master's IR2 */
+	outb_p(SLAVE_ICW4_DEFAULT, PIC_SLAVE_IMR); /* (slave's support for AEOI in flat mode is to be investigated) */
+
+	if (auto_eoi)
+		/*
+		 * In AEOI mode we just have to mask the interrupt
+		 * when acking.
+		 */
+		i8259A_chip.mask_ack = disable_8259A_irq;
+	else
+		i8259A_chip.mask_ack = mask_and_ack_8259A;
+
+	udelay(100);		/* wait for 8259A to initialize */
+
+	outb(cached_master_mask, PIC_MASTER_IMR); /* restore master IRQ mask */
+	outb(cached_slave_mask, PIC_SLAVE_IMR);	  /* restore slave IRQ mask */
+
+	spin_unlock_irqrestore(&i8259A_lock, flags);
+}
+
+
+
+
 /*
  * IRQ2 is cascade interrupt to second interrupt controller
  */
_

Patches currently in -mm which might be from pj@place.org are

x86-make-i8259_64-more-_32-like.patch
x86-make-i8259_64-more-_32-like-checkpatch-fixes.patch
