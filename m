From: akpm@linux-foundation.org
Subject: + panic-keep-blinking-in-spite-of-long-spin-timer-mode.patch added to -mm tree
Date: Thu, 03 Jun 2010 15:30:30 -0700
Message-ID: <201006032230.o53MUUNZ019173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755743Ab0FCWbc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jun 2010 18:31:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tamuki@linet.gr.jp, ben-linux@fluff.org, dtor@mail.ru, linux@arm.linux.org.uk


The patch titled
     panic: keep blinking in spite of long spin timer mode
has been added to the -mm tree.  Its filename is
     panic-keep-blinking-in-spite-of-long-spin-timer-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: panic: keep blinking in spite of long spin timer mode
From: TAMUKI Shoichi <tamuki@linet.gr.jp>

To keep panic_timeout accuracy when running under a hypervisor, the
current implementation spins for a long time (1 second) in calls to
mdelay.  This brings a good effect, but the problem is that the keyboard
LEDs don't blink at all in this situation.

This patch changes things so we call panic_blink_enter() between every
mdelay() and keeps blinking even when in the long spin timer mode.

The default time spent in mdelay() is 1ms.  If the speed of blinking is
slow enough, the mdelay() delay time will be automatically switched to
something longer.  This is suitable for running under a hypervisor.

Signed-off-by: TAMUKI Shoichi <tamuki@linet.gr.jp>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    8 +-
 arch/arm/mach-s3c2440/mach-gta02.c  |   17 +----
 drivers/input/serio/i8042.c         |   25 +-------
 include/linux/kernel.h              |    2 
 kernel/panic.c                      |   77 +++++++++++++++++---------
 5 files changed, 67 insertions(+), 62 deletions(-)

diff -puN Documentation/kernel-parameters.txt~panic-keep-blinking-in-spite-of-long-spin-timer-mode Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~panic-keep-blinking-in-spite-of-long-spin-timer-mode
+++ a/Documentation/kernel-parameters.txt
@@ -917,9 +917,6 @@ and is between 256 and 4096 characters. 
 			     controller
 	i8042.nopnp	[HW] Don't use ACPIPnP / PnPBIOS to discover KBD/AUX
 			     controllers
-	i8042.panicblink=
-			[HW] Frequency with which keyboard LEDs should blink
-			     when kernel panics (default is 0.5 sec)
 	i8042.reset	[HW] Reset the controller during init and cleanup
 	i8042.unlock	[HW] Unlock (ignore) the keylock
 
@@ -1871,6 +1868,11 @@ and is between 256 and 4096 characters. 
 
 	panic=		[KNL] Kernel behaviour on panic
 			Format: <timeout>
+	panicblink=	[KNL] The speed of panic blink (default is 12 wpm)
+			The period of panic blink can be computed by the
+			formula T = 7200 / W, where T is the period in milli-
+			seconds, W is the speed in wpm (words per minute).
+			Should be 5 or less when running under a hypervisor
 
 	parkbd.port=	[HW] Parallel port number the keyboard adapter is
 			connected to, default is 0.
diff -puN arch/arm/mach-s3c2440/mach-gta02.c~panic-keep-blinking-in-spite-of-long-spin-timer-mode arch/arm/mach-s3c2440/mach-gta02.c
--- a/arch/arm/mach-s3c2440/mach-gta02.c~panic-keep-blinking-in-spite-of-long-spin-timer-mode
+++ a/arch/arm/mach-s3c2440/mach-gta02.c
@@ -90,24 +90,17 @@
 static struct pcf50633 *gta02_pcf;
 
 /*
- * This gets called every 1ms when we paniced.
+ * This gets called frequently when we paniced.
  */
 
-static long gta02_panic_blink(long count)
+static long gta02_panic_blink(int state)
 {
 	long delay = 0;
-	static long last_blink;
-	static char led;
+	char led;
 
-	/* Fast blink: 200ms period. */
-	if (count - last_blink < 100)
-		return 0;
-
-	led ^= 1;
+	led = (state) ? 1 : 0;
 	gpio_direction_output(GTA02_GPIO_AUX_LED, led);
 
-	last_blink = count;
-
 	return delay;
 }
 
@@ -556,7 +549,7 @@ static void gta02_poweroff(void)
 
 static void __init gta02_machine_init(void)
 {
-	/* Set the panic callback to make AUX LED blink at ~5Hz. */
+	/* Set the panic callback to turn AUX LED on or off. */
 	panic_blink = gta02_panic_blink;
 
 	s3c_pm_init();
diff -puN drivers/input/serio/i8042.c~panic-keep-blinking-in-spite-of-long-spin-timer-mode drivers/input/serio/i8042.c
--- a/drivers/input/serio/i8042.c~panic-keep-blinking-in-spite-of-long-spin-timer-mode
+++ a/drivers/input/serio/i8042.c
@@ -61,10 +61,6 @@ static bool i8042_noloop;
 module_param_named(noloop, i8042_noloop, bool, 0);
 MODULE_PARM_DESC(noloop, "Disable the AUX Loopback command while probing for the AUX port");
 
-static unsigned int i8042_blink_frequency = 500;
-module_param_named(panicblink, i8042_blink_frequency, uint, 0600);
-MODULE_PARM_DESC(panicblink, "Frequency with which keyboard LEDs should blink when kernel panics");
-
 #ifdef CONFIG_X86
 static bool i8042_dritek;
 module_param_named(dritek, i8042_dritek, bool, 0);
@@ -1032,8 +1028,8 @@ static void i8042_controller_reset(void)
 
 
 /*
- * i8042_panic_blink() will flash the keyboard LEDs and is called when
- * kernel panics. Flashing LEDs is useful for users running X who may
+ * i8042_panic_blink() will turn the keyboard LEDs on or off and is called
+ * when kernel panics. Flashing LEDs is useful for users running X who may
  * not see the console and will help distingushing panics from "real"
  * lockups.
  *
@@ -1043,22 +1039,12 @@ static void i8042_controller_reset(void)
 
 #define DELAY do { mdelay(1); if (++delay > 10) return delay; } while(0)
 
-static long i8042_panic_blink(long count)
+static long i8042_panic_blink(int state)
 {
 	long delay = 0;
-	static long last_blink;
-	static char led;
-
-	/*
-	 * We expect frequency to be about 1/2s. KDB uses about 1s.
-	 * Make sure they are different.
-	 */
-	if (!i8042_blink_frequency)
-		return 0;
-	if (count - last_blink < i8042_blink_frequency)
-		return 0;
+	char led;
 
-	led ^= 0x01 | 0x04;
+	led = (state) ? 0x01 | 0x04 : 0;
 	while (i8042_read_status() & I8042_STR_IBF)
 		DELAY;
 	dbg("%02x -> i8042 (panic blink)", 0xed);
@@ -1071,7 +1057,6 @@ static long i8042_panic_blink(long count
 	dbg("%02x -> i8042 (panic blink)", led);
 	i8042_write_data(led);
 	DELAY;
-	last_blink = count;
 	return delay;
 }
 
diff -puN include/linux/kernel.h~panic-keep-blinking-in-spite-of-long-spin-timer-mode include/linux/kernel.h
--- a/include/linux/kernel.h~panic-keep-blinking-in-spite-of-long-spin-timer-mode
+++ a/include/linux/kernel.h
@@ -172,7 +172,7 @@ static inline void might_fault(void)
 #endif
 
 extern struct atomic_notifier_head panic_notifier_list;
-extern long (*panic_blink)(long time);
+extern long (*panic_blink)(int state);
 NORET_TYPE void panic(const char * fmt, ...)
 	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
 extern void oops_enter(void);
diff -puN kernel/panic.c~panic-keep-blinking-in-spite-of-long-spin-timer-mode kernel/panic.c
--- a/kernel/panic.c~panic-keep-blinking-in-spite-of-long-spin-timer-mode
+++ a/kernel/panic.c
@@ -31,39 +31,43 @@ static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
 
 int panic_timeout;
+static int panic_blink_wpm = 12;
 
 ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
 
 EXPORT_SYMBOL(panic_notifier_list);
 
+static long no_blink(int state)
+{
+	return 0;
+}
+
 /* Returns how long it waited in ms */
-long (*panic_blink)(long time);
+long (*panic_blink)(int state);
 EXPORT_SYMBOL(panic_blink);
 
-static void panic_blink_one_second(void)
+static long panic_blink_enter(long count)
 {
-	static long i = 0, end;
-
-	if (panic_blink) {
-		end = i + MSEC_PER_SEC;
-
-		while (i < end) {
-			i += panic_blink(i);
-			mdelay(1);
-			i++;
-		}
+	int len;
+	long delay = 0;
+	static int state = 1;
+	static int first = 1;
+	static long next_count;
+
+	len = 3600 / panic_blink_wpm;
+	if (!first && count - next_count < 0)
+		return 0;
+	if (state) {
+		delay += panic_blink(0);
+		state = 0;
+		if (first)
+			first = 0;
 	} else {
-		/*
-		 * When running under a hypervisor a small mdelay may get
-		 * rounded up to the hypervisor timeslice. For example, with
-		 * a 1ms in 10ms hypervisor timeslice we might inflate a
-		 * mdelay(1) loop by 10x.
-		 *
-		 * If we have nothing to blink, spin on 1 second calls to
-		 * mdelay to avoid this.
-		 */
-		mdelay(MSEC_PER_SEC);
+		delay += panic_blink(1);
+		state = 1;
 	}
+	next_count = count + len;
+	return delay;
 }
 
 /**
@@ -79,6 +83,7 @@ NORET_TYPE void panic(const char * fmt, 
 	static char buf[1024];
 	va_list args;
 	long i;
+	int step;
 
 	/*
 	 * It's possible to come here directly from a panic-assertion and
@@ -117,6 +122,23 @@ NORET_TYPE void panic(const char * fmt, 
 
 	bust_spinlocks(0);
 
+	if (panic_blink_wpm <= 0 || panic_blink_wpm > 100)
+		panic_blink_wpm = 12;
+
+	if (!panic_blink)
+		panic_blink = no_blink;
+
+	/*
+	 * When running under a hypervisor a small mdelay may get
+	 * rounded up to the hypervisor timeslice. For example, with
+	 * a 1ms in 10ms hypervisor timeslice we might inflate a
+	 * mdelay(1) loop by 10x.
+	 *
+	 * If panic_blink_wpm is 5 or less, spin on 240 millisecond
+	 * calls to mdelay to avoid this.
+	 */
+	step = (panic_blink_wpm <= 5) ? 240 : 1;
+
 	if (panic_timeout > 0) {
 		/*
 		 * Delay timeout seconds before rebooting the machine.
@@ -124,9 +146,10 @@ NORET_TYPE void panic(const char * fmt, 
 		 */
 		printk(KERN_EMERG "Rebooting in %d seconds..", panic_timeout);
 
-		for (i = 0; i < panic_timeout; i++) {
+		for (i = 0; i < panic_timeout * 1000; i += step) {
 			touch_nmi_watchdog();
-			panic_blink_one_second();
+			i += panic_blink_enter(i);
+			mdelay(step);
 		}
 		/*
 		 * This will not be a clean reboot, with everything
@@ -152,9 +175,10 @@ NORET_TYPE void panic(const char * fmt, 
 	}
 #endif
 	local_irq_enable();
-	while (1) {
+	for (i = 0; ; i += step) {
 		touch_softlockup_watchdog();
-		panic_blink_one_second();
+		i += panic_blink_enter(i);
+		mdelay(step);
 	}
 }
 
@@ -437,4 +461,5 @@ EXPORT_SYMBOL(__stack_chk_fail);
 #endif
 
 core_param(panic, panic_timeout, int, 0644);
+core_param(panicblink, panic_blink_wpm, int, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);
_

Patches currently in -mm which might be from tamuki@linet.gr.jp are

panic-keep-blinking-in-spite-of-long-spin-timer-mode.patch

