From: akpm@linux-foundation.org
Subject: - pcspkr-use-the-global-pit-lock.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:10:33 -0700
Message-ID: <200707192010.l6JKAXMU020683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60288 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760984AbXGSUR2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:17:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, dtor@mail.ru, mingo@elte.hu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     pcspkr: use the global PIT lock
has been removed from the -mm tree.  Its filename was
     pcspkr-use-the-global-pit-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pcspkr: use the global PIT lock
From: Thomas Gleixner <tglx@linutronix.de>

Replace the pcspkr private PIT lock by the global PIT lock to serialize the
PIT access all over the place.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/time.c   |    2 ++
 drivers/input/misc/pcspkr.c |   11 ++++++++---
 include/asm-x86_64/i8253.h  |    6 ++++++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff -puN arch/x86_64/kernel/time.c~pcspkr-use-the-global-pit-lock arch/x86_64/kernel/time.c
--- a/arch/x86_64/kernel/time.c~pcspkr-use-the-global-pit-lock
+++ a/arch/x86_64/kernel/time.c
@@ -33,6 +33,7 @@
 #include <acpi/acpi_bus.h>
 #endif
 #include <asm/8253pit.h>
+#include <asm/i8253.h>
 #include <asm/pgtable.h>
 #include <asm/vsyscall.h>
 #include <asm/timex.h>
@@ -51,6 +52,7 @@ static char *timename = NULL;
 DEFINE_SPINLOCK(rtc_lock);
 EXPORT_SYMBOL(rtc_lock);
 DEFINE_SPINLOCK(i8253_lock);
+EXPORT_SYMBOL(i8253_lock);
 
 volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
 
diff -puN drivers/input/misc/pcspkr.c~pcspkr-use-the-global-pit-lock drivers/input/misc/pcspkr.c
--- a/drivers/input/misc/pcspkr.c~pcspkr-use-the-global-pit-lock
+++ a/drivers/input/misc/pcspkr.c
@@ -24,7 +24,12 @@ MODULE_AUTHOR("Vojtech Pavlik <vojtech@u
 MODULE_DESCRIPTION("PC Speaker beeper driver");
 MODULE_LICENSE("GPL");
 
-static DEFINE_SPINLOCK(i8253_beep_lock);
+#ifdef CONFIG_X86
+/* Use the global PIT lock ! */
+#include <asm/i8253.h>
+#else
+static DEFINE_SPINLOCK(i8253_lock);
+#endif
 
 static int pcspkr_event(struct input_dev *dev, unsigned int type, unsigned int code, int value)
 {
@@ -43,7 +48,7 @@ static int pcspkr_event(struct input_dev
 	if (value > 20 && value < 32767)
 		count = PIT_TICK_RATE / value;
 
-	spin_lock_irqsave(&i8253_beep_lock, flags);
+	spin_lock_irqsave(&i8253_lock, flags);
 
 	if (count) {
 		/* enable counter 2 */
@@ -58,7 +63,7 @@ static int pcspkr_event(struct input_dev
 		outb(inb_p(0x61) & 0xFC, 0x61);
 	}
 
-	spin_unlock_irqrestore(&i8253_beep_lock, flags);
+	spin_unlock_irqrestore(&i8253_lock, flags);
 
 	return 0;
 }
diff -puN /dev/null include/asm-x86_64/i8253.h
--- /dev/null
+++ a/include/asm-x86_64/i8253.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_I8253_H__
+#define __ASM_I8253_H__
+
+extern spinlock_t i8253_lock;
+
+#endif	/* __ASM_I8253_H__ */
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
clockevents-remove-prototypes-of-removed-functions.patch
clockevents-fix-resume-logic.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
clockevents-fix-device-replacement.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
hrtimer-speedup-hrtimer_enqueue.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
