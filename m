From: akpm@linux-foundation.org
Subject: - lguest-the-host-code-use-tsc.patch removed from -mm tree
Date: Thu, 07 Jun 2007 23:14:59 -0700
Message-ID: <200706080614.l586Exux020999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39604 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755264AbXFHGPK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 02:15:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     lguest: use TSC
has been removed from the -mm tree.  Its filename was
     lguest-the-host-code-use-tsc.patch

This patch was dropped because it was folded into lguest-the-host-code.patch

------------------------------------------------------
Subject: lguest: use TSC
From: Rusty Russell <rusty@rustcorp.com.au>

James: Add rudimentary TSC-based clocksource support (based on Rusty's
original patch).

Rusty: Add rudimentary code to handle TSC changing.  We can use the native
sched_clock again, we just have to tell it the TSC speed (get_cpu_khz).

(Note on benchmarks: Linux only sets the clock to the nearest second, so
expect it to be up to up to 1000000000 ns out.  But the narrowness of the max
- min range indicates consistency.)

Before:
Approximate accuracy of clock: 827460500 (819802000 - 834640500)

After:
Approximate accuracy of clock: 326354500 (326257000 - 327937500)

Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/tsc.c  |    1 +
 drivers/lguest/core.c   |    8 ++++++++
 drivers/lguest/lg.h     |    1 +
 drivers/lguest/lguest.c |   38 +++++++++++++++++++++++++++++++-------
 include/linux/lguest.h  |    2 ++
 5 files changed, 43 insertions(+), 7 deletions(-)

diff -puN arch/i386/kernel/tsc.c~lguest-the-host-code-use-tsc arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~lguest-the-host-code-use-tsc
+++ a/arch/i386/kernel/tsc.c
@@ -26,6 +26,7 @@ static int tsc_enabled;
  * an extra value to store the TSC freq
  */
 unsigned int tsc_khz;
+EXPORT_SYMBOL_GPL(tsc_khz);
 
 int tsc_disable;
 
diff -puN drivers/lguest/core.c~lguest-the-host-code-use-tsc drivers/lguest/core.c
--- a/drivers/lguest/core.c~lguest-the-host-code-use-tsc
+++ a/drivers/lguest/core.c
@@ -332,6 +332,14 @@ int run_guest(struct lguest *lg, unsigne
 			continue;
 		}
 
+		/* If the Guest hasn't been told the clock multiplier to use or
+		 * it's changed, we update it here. */
+		if (unlikely(lg->tsc_khz != tsc_khz) && lg->lguest_data) {
+			lg->tsc_khz = tsc_khz;
+			if (put_user(lg->tsc_khz, &lg->lguest_data->tsc_khz))
+				return -EFAULT;
+		}
+
 		local_irq_disable();
 
 		/* Even if *we* don't want FPU trap, guest might... */
diff -puN drivers/lguest/lg.h~lguest-the-host-code-use-tsc drivers/lguest/lg.h
--- a/drivers/lguest/lg.h~lguest-the-host-code-use-tsc
+++ a/drivers/lguest/lg.h
@@ -160,6 +160,7 @@ struct lguest
 	unsigned long pending_key; /* address they're sending to */
 
 	unsigned int stack_pages;
+	u32 tsc_khz;
 
 	struct lguest_dma_info dma[LGUEST_MAX_DMA];
 
diff -puN drivers/lguest/lguest.c~lguest-the-host-code-use-tsc drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-the-host-code-use-tsc
+++ a/drivers/lguest/lguest.c
@@ -25,6 +25,7 @@
 #include <linux/screen_info.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
+#include <linux/clocksource.h>
 #include <linux/lguest.h>
 #include <linux/lguest_launcher.h>
 #include <linux/lguest_bus.h>
@@ -37,6 +38,7 @@
 #include <asm/e820.h>
 #include <asm/mce.h>
 #include <asm/io.h>
+#include <asm/sched-clock.h>
 
 /* Declarations for definitions in lguest_guest.S */
 extern char lguest_noirq_start[], lguest_noirq_end[];
@@ -209,8 +211,8 @@ static void lguest_cpuid(unsigned int *e
 	case 1:	/* Basic feature request. */
 		/* We only allow kernel to see SSE3, CMPXCHG16B and SSSE3 */
 		*ecx &= 0x00002201;
-		/* Similarly: SSE, SSE2, FXSR, MMX, CMOV, CMPXCHG8B, FPU. */
-		*edx &= 0x07808101;
+		/* SSE, SSE2, FXSR, MMX, CMOV, CMPXCHG8B, TSC, FPU. */
+		*edx &= 0x07808111;
 		/* Host wants to know when we flush kernel pages: set PGE. */
 		*edx |= 0x00002000;
 		break;
@@ -345,24 +347,46 @@ static unsigned long lguest_get_wallcloc
 	return hcall(LHCALL_GET_WALLCLOCK, 0, 0, 0);
 }
 
+/* This is what we tell the kernel is our clocksource.  It's the normal "Time
+ * Stamp Counter": the Host tells us what speed it's going at. */
+static struct clocksource lguest_clock = {
+	.name		= "lguest",
+	.rating		= 400,
+	.read		= native_read_tsc,
+	.mask		= CLOCKSOURCE_MASK(64),
+	.mult		= 0, /* to be set */
+	.shift		= 22,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
 static void lguest_time_irq(unsigned int irq, struct irq_desc *desc)
 {
+	/* Check in case host TSC has changed rate. */
+	if (unlikely(tsc_khz != lguest_data.tsc_khz)) {
+		tsc_khz = lguest_data.tsc_khz;
+		lguest_clock.mult = clocksource_khz2mult(tsc_khz, 22);
+		__get_cpu_var(sc_data).cyc2ns_scale
+			= (1000000 << CYC2NS_SCALE_FACTOR) / tsc_khz;
+	}
 	do_timer(hcall(LHCALL_TIMER_READ, 0, 0, 0));
 	update_process_times(user_mode_vm(get_irq_regs()));
 }
 
-static u64 sched_clock_base;
 static void lguest_time_init(void)
 {
 	set_irq_handler(0, lguest_time_irq);
+
+	lguest_clock.mult = clocksource_khz2mult(tsc_khz, 22);
+	clocksource_register(&lguest_clock);
+
 	hcall(LHCALL_TIMER_READ, 0, 0, 0);
-	sched_clock_base = jiffies_64;
 	enable_lguest_irq(0);
 }
 
-static unsigned long long lguest_sched_clock(void)
+static unsigned long lguest_get_cpu_khz(void)
 {
-	return (jiffies_64 - sched_clock_base) * (1000000000 / HZ);
+	/* The Host tells us the TSC speed */
+	return lguest_data.tsc_khz;
 }
 
 static void lguest_load_esp0(struct tss_struct *tss,
@@ -502,7 +526,7 @@ __init void lguest_init(void *boot)
 	paravirt_ops.time_init = lguest_time_init;
 	paravirt_ops.set_lazy_mode = lguest_lazy_mode;
 	paravirt_ops.wbinvd = lguest_wbinvd;
-	paravirt_ops.sched_clock = lguest_sched_clock;
+	paravirt_ops.get_cpu_khz = lguest_get_cpu_khz;
 
 	hcall(LHCALL_LGUEST_INIT, __pa(&lguest_data), 0, 0);
 
diff -puN include/linux/lguest.h~lguest-the-host-code-use-tsc include/linux/lguest.h
--- a/include/linux/lguest.h~lguest-the-host-code-use-tsc
+++ a/include/linux/lguest.h
@@ -70,6 +70,8 @@ struct lguest_data
 	unsigned long reserve_mem;
 	/* ID of this guest (used by network driver to set ethernet address) */
 	u16 guestid;
+	/* KHz for the TSC clock. */
+	u32 tsc_khz;
 
 /* Fields initialized by the guest at boot: */
 	/* Instruction range to suppress interrupts even if enabled */
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
paravirt-helper-to-disable-all-io-space.patch
paravirt-helper-to-disable-all-io-space-fix.patch
xen-disable-all-non-virtual-devices.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
use-menuconfig-objects-ii-module-menu.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-host-code-use-tsc.patch
lguest-the-host-code-use-hrtimers.patch
lguest-the-host-code-update-for-mm-simplify-boot_params.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-makefile-and-kconfig-tidyups.patch
lguest-the-console-driver.patch
lguest-the-console-driver-tidyups.patch
lguest-the-net-driver.patch
lguest-the-net-driver-tidyups.patch
lguest-the-net-driver-tidyups-update.patch
lguest-the-net-driver-include-fix.patch
lguest-the-block-driver.patch
lguest-the-block-driver-tidyups.patch
lguest-the-block-driver-tidyups-update.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-example-launcher-fix.patch
lguest-dont-signal-like-crazy-use-lhreq_break-command-doc.patch
lguest-documentation-infrastructure-and-chapter-i.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
