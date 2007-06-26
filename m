From: akpm@linux-foundation.org
Subject: + i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch added to -mm tree
Date: Mon, 25 Jun 2007 17:07:52 -0700
Message-ID: <200706260007.l5Q07qv3014450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49883 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753011AbXFZAIl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 20:08:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu


The patch titled
     i386: move PIT function declarations and constants to correct header file
has been added to the -mm tree.  Its filename is
     i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: move PIT function declarations and constants to correct header file
From: Thomas Gleixner <tglx@linutronix.de>

setup_pit_timer is declared in asm-i386/timer.h.  Move it to the pit header
file, so it can be used by x86_64 as well.

Move also the PIT constants.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/i8253.c                 |    2 --
 arch/i386/kernel/vmiclock.c              |    1 +
 include/asm-i386/i8253.h                 |    7 +++++++
 include/asm-i386/mach-default/io_ports.h |    5 -----
 include/asm-i386/timer.h                 |    1 -
 5 files changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/i386/kernel/i8253.c~i386-move-pit-function-declarations-and-constants-to-correct-header-file arch/i386/kernel/i8253.c
--- a/arch/i386/kernel/i8253.c~i386-move-pit-function-declarations-and-constants-to-correct-header-file
+++ a/arch/i386/kernel/i8253.c
@@ -15,8 +15,6 @@
 #include <asm/io.h>
 #include <asm/timer.h>
 
-#include "io_ports.h"
-
 DEFINE_SPINLOCK(i8253_lock);
 EXPORT_SYMBOL(i8253_lock);
 
diff -puN arch/i386/kernel/vmiclock.c~i386-move-pit-function-declarations-and-constants-to-correct-header-file arch/i386/kernel/vmiclock.c
--- a/arch/i386/kernel/vmiclock.c~i386-move-pit-function-declarations-and-constants-to-correct-header-file
+++ a/arch/i386/kernel/vmiclock.c
@@ -32,6 +32,7 @@
 #include <asm/apicdef.h>
 #include <asm/apic.h>
 #include <asm/timer.h>
+#include <asm/i8253.h>
 
 #include <irq_vectors.h>
 #include "io_ports.h"
diff -puN include/asm-i386/i8253.h~i386-move-pit-function-declarations-and-constants-to-correct-header-file include/asm-i386/i8253.h
--- a/include/asm-i386/i8253.h~i386-move-pit-function-declarations-and-constants-to-correct-header-file
+++ a/include/asm-i386/i8253.h
@@ -3,6 +3,11 @@
 
 #include <linux/clockchips.h>
 
+/* i8253A PIT registers */
+#define PIT_MODE		0x43
+#define PIT_CH0			0x40
+#define PIT_CH2			0x42
+
 extern spinlock_t i8253_lock;
 
 extern struct clock_event_device *global_clock_event;
@@ -18,4 +23,6 @@ static inline void pit_interrupt_hook(vo
 	global_clock_event->event_handler(global_clock_event);
 }
 
+extern void setup_pit_timer(void);
+
 #endif	/* __ASM_I8253_H__ */
diff -puN include/asm-i386/mach-default/io_ports.h~i386-move-pit-function-declarations-and-constants-to-correct-header-file include/asm-i386/mach-default/io_ports.h
--- a/include/asm-i386/mach-default/io_ports.h~i386-move-pit-function-declarations-and-constants-to-correct-header-file
+++ a/include/asm-i386/mach-default/io_ports.h
@@ -7,11 +7,6 @@
 #ifndef _MACH_IO_PORTS_H
 #define _MACH_IO_PORTS_H
 
-/* i8253A PIT registers */
-#define PIT_MODE		0x43
-#define PIT_CH0			0x40
-#define PIT_CH2			0x42
-
 /* i8259A PIC registers */
 #define PIC_MASTER_CMD		0x20
 #define PIC_MASTER_IMR		0x21
diff -puN include/asm-i386/timer.h~i386-move-pit-function-declarations-and-constants-to-correct-header-file include/asm-i386/timer.h
--- a/include/asm-i386/timer.h~i386-move-pit-function-declarations-and-constants-to-correct-header-file
+++ a/include/asm-i386/timer.h
@@ -6,7 +6,6 @@
 
 #define TICK_SIZE (tick_nsec / 1000)
 
-void setup_pit_timer(void);
 unsigned long long native_sched_clock(void);
 unsigned long native_calculate_cpu_khz(void);
 
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
