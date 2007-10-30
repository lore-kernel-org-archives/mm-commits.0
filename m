From: akpm@linux-foundation.org
Subject: + optimize-i8259-code-a-bit.patch added to -mm tree
Date: Tue, 30 Oct 2007 13:03:34 -0700
Message-ID: <200710302003.l9UK3YPT025580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32903 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752835AbXJ3UEA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 16:04:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, tglx@linutronix.de


The patch titled
     Optimize i8259 code a bit
has been added to the -mm tree.  Its filename is
     optimize-i8259-code-a-bit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -23,9 +23,7 @@ static DEFINE_SPINLOCK(i8253_lock);
 static void init_pit_timer(enum clock_event_mode mode,
 			   struct clock_event_device *evt)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&i8253_lock, flags);
+	spin_lock(&i8253_lock);
 
 	switch(mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
@@ -54,7 +52,7 @@ static void init_pit_timer(enum clock_ev
 		/* Nothing to do here */
 		break;
 	}
-	spin_unlock_irqrestore(&i8253_lock, flags);
+	spin_unlock(&i8253_lock);
 }
 
 /*
@@ -64,12 +62,10 @@ static void init_pit_timer(enum clock_ev
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
rtc-release-correct-region-in-error-path.patch
rtc-fallback-to-requesting-only-the-ports-we-actually-use.patch
mips-undo-locking-on-error-path-returns.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
maps4-rework-task_size-macros.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-inclusions-of-linux-autoconfh.patch
optimize-i8259-code-a-bit.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
dzc-use-a-helper-to-cast-from-struct-uart_port.patch
dzc-resource-management.patch
