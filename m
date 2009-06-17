From: akpm@linux-foundation.org
Subject: [merged] time-move-pit_tick_rate-to-linux-timexh.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:32:16 -0700
Message-ID: <200906171832.n5HIWG1g030812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757683AbZFQSe1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:34:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, benh@kernel.crashing.org, dtor@mail.ru, hpa@zytor.com, ink@jurassic.park.msu.ru, johnstul@us.ibm.com, lenb@kernel.org, mingo@elte.hu, ralf@linux-mips.org, rth@twiddle.n


The patch titled
     time: move PIT_TICK_RATE to linux/timex.h
has been removed from the -mm tree.  Its filename was
     time-move-pit_tick_rate-to-linux-timexh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: time: move PIT_TICK_RATE to linux/timex.h
From: Arnd Bergmann <arnd@arndb.de>

PIT_TICK_RATE is currently defined in four architectures, but in three
different places.  While linux/timex.h is not the perfect place for it, it
is still a reasonable replacement for those drivers that traditionally use
asm/timex.h to get CLOCK_TICK_RATE and expect it to be the PIT frequency.

Note that for Alpha, the actual value changed from 1193182UL to 1193180UL.
 This is unlikely to make a difference, and probably can only improve
accuracy.  There was a discussion on the correct value of CLOCK_TICK_RATE
a few years ago, after which every existing instance was getting changed
to 1193182.  According to the specification, it should be
1193181.818181...

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Len Brown <lenb@kernel.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/8253pit.h   |    7 -------
 arch/alpha/kernel/sys_ruffian.c    |    1 +
 arch/mips/include/asm/i8253.h      |    2 --
 arch/powerpc/include/asm/8253pit.h |    7 -------
 arch/x86/include/asm/timex.h       |    4 +---
 arch/x86/kernel/i8253.c            |    1 +
 arch/x86/kernel/tsc.c              |    1 +
 drivers/clocksource/acpi_pm.c      |    1 +
 drivers/input/joystick/analog.c    |    2 +-
 drivers/input/misc/pcspkr.c        |    1 +
 include/linux/timex.h              |    3 +++
 sound/drivers/pcsp/pcsp.h          |    1 +
 sound/oss/pas2_pcm.c               |    2 +-
 13 files changed, 12 insertions(+), 21 deletions(-)

diff -puN arch/alpha/include/asm/8253pit.h~time-move-pit_tick_rate-to-linux-timexh arch/alpha/include/asm/8253pit.h
--- a/arch/alpha/include/asm/8253pit.h~time-move-pit_tick_rate-to-linux-timexh
+++ a/arch/alpha/include/asm/8253pit.h
@@ -1,10 +1,3 @@
 /*
  * 8253/8254 Programmable Interval Timer
  */
-
-#ifndef _8253PIT_H
-#define _8253PIT_H
-
-#define PIT_TICK_RATE 	1193180UL
-
-#endif
diff -puN arch/alpha/kernel/sys_ruffian.c~time-move-pit_tick_rate-to-linux-timexh arch/alpha/kernel/sys_ruffian.c
--- a/arch/alpha/kernel/sys_ruffian.c~time-move-pit_tick_rate-to-linux-timexh
+++ a/arch/alpha/kernel/sys_ruffian.c
@@ -14,6 +14,7 @@
 #include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/ioport.h>
+#include <linux/timex.h>
 #include <linux/init.h>
 
 #include <asm/ptrace.h>
diff -puN arch/mips/include/asm/i8253.h~time-move-pit_tick_rate-to-linux-timexh arch/mips/include/asm/i8253.h
--- a/arch/mips/include/asm/i8253.h~time-move-pit_tick_rate-to-linux-timexh
+++ a/arch/mips/include/asm/i8253.h
@@ -12,8 +12,6 @@
 #define PIT_CH0			0x40
 #define PIT_CH2			0x42
 
-#define PIT_TICK_RATE		1193182UL
-
 extern spinlock_t i8253_lock;
 
 extern void setup_pit_timer(void);
diff -puN arch/powerpc/include/asm/8253pit.h~time-move-pit_tick_rate-to-linux-timexh arch/powerpc/include/asm/8253pit.h
--- a/arch/powerpc/include/asm/8253pit.h~time-move-pit_tick_rate-to-linux-timexh
+++ a/arch/powerpc/include/asm/8253pit.h
@@ -1,10 +1,3 @@
-#ifndef _ASM_POWERPC_8253PIT_H
-#define _ASM_POWERPC_8253PIT_H
-
 /*
  * 8253/8254 Programmable Interval Timer
  */
-
-#define PIT_TICK_RATE	1193182UL
-
-#endif	/* _ASM_POWERPC_8253PIT_H */
diff -puN arch/x86/include/asm/timex.h~time-move-pit_tick_rate-to-linux-timexh arch/x86/include/asm/timex.h
--- a/arch/x86/include/asm/timex.h~time-move-pit_tick_rate-to-linux-timexh
+++ a/arch/x86/include/asm/timex.h
@@ -4,9 +4,7 @@
 #include <asm/processor.h>
 #include <asm/tsc.h>
 
-/* The PIT ticks at this frequency (in HZ): */
-#define PIT_TICK_RATE		1193182
-
+/* Assume we use the PIT time source for the clock tick */
 #define CLOCK_TICK_RATE		PIT_TICK_RATE
 
 #define ARCH_HAS_READ_CURRENT_TIMER
diff -puN arch/x86/kernel/i8253.c~time-move-pit_tick_rate-to-linux-timexh arch/x86/kernel/i8253.c
--- a/arch/x86/kernel/i8253.c~time-move-pit_tick_rate-to-linux-timexh
+++ a/arch/x86/kernel/i8253.c
@@ -7,6 +7,7 @@
 #include <linux/spinlock.h>
 #include <linux/jiffies.h>
 #include <linux/module.h>
+#include <linux/timex.h>
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/io.h>
diff -puN arch/x86/kernel/tsc.c~time-move-pit_tick_rate-to-linux-timexh arch/x86/kernel/tsc.c
--- a/arch/x86/kernel/tsc.c~time-move-pit_tick_rate-to-linux-timexh
+++ a/arch/x86/kernel/tsc.c
@@ -9,6 +9,7 @@
 #include <linux/delay.h>
 #include <linux/clocksource.h>
 #include <linux/percpu.h>
+#include <linux/timex.h>
 
 #include <asm/hpet.h>
 #include <asm/timer.h>
diff -puN drivers/clocksource/acpi_pm.c~time-move-pit_tick_rate-to-linux-timexh drivers/clocksource/acpi_pm.c
--- a/drivers/clocksource/acpi_pm.c~time-move-pit_tick_rate-to-linux-timexh
+++ a/drivers/clocksource/acpi_pm.c
@@ -18,6 +18,7 @@
 
 #include <linux/acpi_pmtmr.h>
 #include <linux/clocksource.h>
+#include <linux/timex.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/pci.h>
diff -puN drivers/input/joystick/analog.c~time-move-pit_tick_rate-to-linux-timexh drivers/input/joystick/analog.c
--- a/drivers/input/joystick/analog.c~time-move-pit_tick_rate-to-linux-timexh
+++ a/drivers/input/joystick/analog.c
@@ -35,7 +35,7 @@
 #include <linux/input.h>
 #include <linux/gameport.h>
 #include <linux/jiffies.h>
-#include <asm/timex.h>
+#include <linux/timex.h>
 
 #define DRIVER_DESC	"Analog joystick and gamepad driver"
 
diff -puN drivers/input/misc/pcspkr.c~time-move-pit_tick_rate-to-linux-timexh drivers/input/misc/pcspkr.c
--- a/drivers/input/misc/pcspkr.c~time-move-pit_tick_rate-to-linux-timexh
+++ a/drivers/input/misc/pcspkr.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/input.h>
 #include <linux/platform_device.h>
+#include <linux/timex.h>
 #include <asm/io.h>
 
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@ucw.cz>");
diff -puN include/linux/timex.h~time-move-pit_tick_rate-to-linux-timexh include/linux/timex.h
--- a/include/linux/timex.h~time-move-pit_tick_rate-to-linux-timexh
+++ a/include/linux/timex.h
@@ -280,6 +280,9 @@ extern int do_adjtimex(struct timex *);
 
 int read_current_timer(unsigned long *timer_val);
 
+/* The clock frequency of the i8253/i8254 PIT */
+#define PIT_TICK_RATE 1193182ul
+
 #endif /* KERNEL */
 
 #endif /* LINUX_TIMEX_H */
diff -puN sound/drivers/pcsp/pcsp.h~time-move-pit_tick_rate-to-linux-timexh sound/drivers/pcsp/pcsp.h
--- a/sound/drivers/pcsp/pcsp.h~time-move-pit_tick_rate-to-linux-timexh
+++ a/sound/drivers/pcsp/pcsp.h
@@ -10,6 +10,7 @@
 #define __PCSP_H__
 
 #include <linux/hrtimer.h>
+#include <linux/timex.h>
 #if defined(CONFIG_MIPS) || defined(CONFIG_X86)
 /* Use the global PIT lock ! */
 #include <asm/i8253.h>
diff -puN sound/oss/pas2_pcm.c~time-move-pit_tick_rate-to-linux-timexh sound/oss/pas2_pcm.c
--- a/sound/oss/pas2_pcm.c~time-move-pit_tick_rate-to-linux-timexh
+++ a/sound/oss/pas2_pcm.c
@@ -17,7 +17,7 @@
 
 #include <linux/init.h>
 #include <linux/spinlock.h>
-#include <asm/timex.h>
+#include <linux/timex.h>
 #include "sound_config.h"
 
 #include "pas2.h"
_

Patches currently in -mm which might be from arnd@arndb.de are

origin.patch
linux-next.patch
ipc-use-__arch_want_ipc_parse_version-in-ipc-utilh.patch
dma-mapping-add-asm-generic-dma-mapping-commonh.patch
dma-mapping-x86-use-asm-generic-dma-mapping-commonh.patch
dma-mapping-ia64-use-asm-generic-dma-mapping-commonh.patch
dma-mapping-ia64-add-config_dma_api_debug-support.patch
dma-mapping-dma-debug-fix-compiler-warnings-on-ia64.patch

