From: akpm@linux-foundation.org
Subject: - optimize-i8259-code-a-bit.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:24:26 -0800
Message-ID: <200712010024.lB10OQxf032071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40155 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757317AbXLAA1c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:27:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Optimize i8259 code a bit
has been removed from the -mm tree.  Its filename was
     optimize-i8259-code-a-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Optimize i8259 code a bit
From: Ralf Baechle <ralf@linux-mips.org>

The timer code always calls the clock_event_device set_net_event and
set_mode methods with interrupts disabled, so no need to use
spin_lock_irqsave / spin_unlock_irqrestore for those.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by:Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/i8253.c |   12 ++++--------
 arch/x86/kernel/i8253.c  |   12 ++++--------
 2 files changed, 8 insertions(+), 16 deletions(-)

diff -puN arch/mips/kernel/i8253.c~optimize-i8259-code-a-bit arch/mips/kernel/i8253.c
--- a/arch/mips/kernel/i8253.c~optimize-i8259-code-a-bit
+++ a/arch/mips/kernel/i8253.c
@@ -24,9 +24,7 @@ DEFINE_SPINLOCK(i8253_lock);
 static void init_pit_timer(enum clock_event_mode mode,
 			   struct clock_event_device *evt)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&i8253_lock, flags);
+	spin_lock(&i8253_lock);
 
 	switch(mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
@@ -55,7 +53,7 @@ static void init_pit_timer(enum clock_ev
 		/* Nothing to do here */
 		break;
 	}
-	spin_unlock_irqrestore(&i8253_lock, flags);
+	spin_unlock(&i8253_lock);
 }
 
 /*
@@ -65,12 +63,10 @@ static void init_pit_timer(enum clock_ev
  */
 static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&i8253_lock, flags);
+	spin_lock(&i8253_lock);
 	outb_p(delta & 0xff , PIT_CH0);	/* LSB */
 	outb(delta >> 8 , PIT_CH0);	/* MSB */
-	spin_unlock_irqrestore(&i8253_lock, flags);
+	spin_unlock(&i8253_lock);
 
 	return 0;
 }
diff -puN arch/x86/kernel/i8253.c~optimize-i8259-code-a-bit arch/x86/kernel/i8253.c
--- a/arch/x86/kernel/i8253.c~optimize-i8259-code-a-bit
+++ a/arch/x86/kernel/i8253.c
@@ -31,9 +31,7 @@ struct clock_event_device *global_clock_
 static void init_pit_timer(enum clock_event_mode mode,
 			   struct clock_event_device *evt)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&i8253_lock, flags);
+	spin_lock(&i8253_lock);
 
 	switch(mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
@@ -62,7 +60,7 @@ static void init_pit_timer(enum clock_ev
 		/* Nothing to do here */
 		break;
 	}
-	spin_unlock_irqrestore(&i8253_lock, flags);
+	spin_unlock(&i8253_lock);
 }
 
 /*
@@ -72,12 +70,10 @@ static void init_pit_timer(enum clock_ev
  */
 static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&i8253_lock, flags);
+	spin_lock(&i8253_lock);
 	outb_p(delta & 0xff , PIT_CH0);	/* LSB */
 	outb(delta >> 8 , PIT_CH0);	/* MSB */
-	spin_unlock_irqrestore(&i8253_lock, flags);
+	spin_unlock(&i8253_lock);
 
 	return 0;
 }
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
git-mips.patch
mips-remove-dead-config-symbols-from-mips-code.patch
txx9-watchdog-driver.patch
git-x86.patch
maps4-rework-task_size-macros.patch
maps4-rework-task_size-macros-mips-fix.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-inclusions-of-linux-autoconfh.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
dzc-use-a-helper-to-cast-from-struct-uart_port.patch
dzc-resource-management.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg64-and-cmpxchg64_local-to-mips.patch
