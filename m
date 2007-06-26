From: akpm@linux-foundation.org
Subject: + pcspkr-use-the-global-pit-lock.patch added to -mm tree
Date: Mon, 25 Jun 2007 17:07:42 -0700
Message-ID: <200706260007.l5Q07gGw014430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33749 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752545AbXFZAI2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 20:08:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, dtor@mail.ru, mingo@elte.hu


The patch titled
     pcspkr: use the global PIT lock
has been added to the -mm tree.  Its filename is
     pcspkr-use-the-global-pit-lock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-acpi-add-exports.patch
git-arm.patch
i386-hpet-check-if-the-counter-works.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
timekeeping-fixup-shadow-variable-argument.patch
timerc-cleanup-recently-introduced-whitespace-damage.patch
clockevents-remove-prototypes-of-removed-functions.patch
clockevents-fix-resume-logic.patch
clockevents-fix-device-replacement.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
hrtimer-speedup-hrtimer_enqueue.patch
pcspkr-use-the-global-pit-lock.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
i386-remove-volatile-in-apicc.patch
i386-hpet-assumes-boot-cpu-is-0.patch
i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch
x86_64-untangle-asm-hpeth-from-asm-timexh.patch
x86_64-use-generic-cmos-update.patch
x86_64-remove-dead-code-and-other-janitor-work-in-tscc.patch
x86_64-fix-apic-typo.patch
x86_64-convert-to-cleckevents.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
remove-clockevents_releaserequest_device.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
improve-behaviour-of-spurious-irq-detect.patch
improve-behaviour-of-spurious-irq-detect-fix.patch
sys_time-speedup.patch
lguest-the-host-code.patch
