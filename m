From: akpm@linux-foundation.org
Subject: + lguest-the-host-code-handle-dodgy-non-existent-tsc-guest-code.patch added to -mm tree
Date: Thu, 05 Jul 2007 14:03:10 -0700
Message-ID: <200707052103.l65L3AsX019192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48307 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760280AbXGEVEP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 17:04:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, johnstul@us.ibm.com, mpm@selenic.com


The patch titled
     lguest: handle dodgy/non-existent TSC.  Guest code.
has been added to the -mm tree.  Its filename is
     lguest-the-host-code-handle-dodgy-non-existent-tsc-guest-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: handle dodgy/non-existent TSC.  Guest code.
From: Rusty Russell <rusty@rustcorp.com.au>

We create an "lguest_clock" which the guest uses: either TSC or jiffies,
depending on whether the host tells us the TSC frequency.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest.c |   51 +++++++++++++++++++-------------------
 1 files changed, 26 insertions(+), 25 deletions(-)

diff -puN drivers/lguest/lguest.c~lguest-the-host-code-handle-dodgy-non-existent-tsc-guest-code drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-the-host-code-handle-dodgy-non-existent-tsc-guest-code
+++ a/drivers/lguest/lguest.c
@@ -212,8 +212,8 @@ static void lguest_cpuid(unsigned int *e
 	case 1:	/* Basic feature request. */
 		/* We only allow kernel to see SSE3, CMPXCHG16B and SSSE3 */
 		*ecx &= 0x00002201;
-		/* SSE, SSE2, FXSR, MMX, CMOV, CMPXCHG8B, TSC, FPU. */
-		*edx &= 0x07808111;
+		/* SSE, SSE2, FXSR, MMX, CMOV, CMPXCHG8B, FPU. */
+		*edx &= 0x07808101;
 		/* Host wants to know when we flush kernel pages: set PGE. */
 		*edx |= 0x00002000;
 		break;
@@ -348,16 +348,19 @@ static unsigned long lguest_get_wallcloc
 	return hcall(LHCALL_GET_WALLCLOCK, 0, 0, 0);
 }
 
-/* This is what we tell the kernel is our clocksource.  It's the normal "Time
- * Stamp Counter": the Host tells us what speed it's going at. */
+static cycle_t lguest_clock_read(void)
+{
+	if (lguest_data.tsc_khz)
+		return native_read_tsc();
+	else
+		return jiffies;
+}
+
+/* This is what we tell the kernel is our clocksource.  */
 static struct clocksource lguest_clock = {
 	.name		= "lguest",
 	.rating		= 400,
-	.read		= native_read_tsc,
-	.mask		= CLOCKSOURCE_MASK(64),
-	.mult		= 0, /* to be set */
-	.shift		= 22,
-	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.read		= lguest_clock_read,
 };
 
 /* We also need a "struct clock_event_device": Linux asks us to set it to go
@@ -414,14 +417,6 @@ static void lguest_time_irq(unsigned int
 {
 	unsigned long flags;
 
-	/* Check in case host TSC has changed rate. */
-	if (unlikely(tsc_khz != lguest_data.tsc_khz)) {
-		tsc_khz = lguest_data.tsc_khz;
-		lguest_clock.mult = clocksource_khz2mult(tsc_khz, 22);
-		__get_cpu_var(sc_data).cyc2ns_scale
-			= (1000000 << CYC2NS_SCALE_FACTOR) / tsc_khz;
-	}
-
 	/* Don't interrupt us while this is running. */
 	local_irq_save(flags);
 	lguest_clockevent.event_handler(&lguest_clockevent);
@@ -432,7 +427,20 @@ static void lguest_time_init(void)
 {
 	set_irq_handler(0, lguest_time_irq);
 
-	lguest_clock.mult = clocksource_khz2mult(tsc_khz, 22);
+	/* We use the TSC if the Host tells us we can, otherwise a dumb
+	 * jiffies-based clock. */
+	if (lguest_data.tsc_khz) {
+		lguest_clock.shift = 22;
+		lguest_clock.mult = clocksource_khz2mult(lguest_data.tsc_khz,
+							 lguest_clock.shift);
+		lguest_clock.mask = CLOCKSOURCE_MASK(64);
+		lguest_clock.flags = CLOCK_SOURCE_IS_CONTINUOUS;
+	} else {
+		/* To understand this, start at kernel/time/jiffies.c... */
+		lguest_clock.shift = 8;
+		lguest_clock.mult = (((u64)NSEC_PER_SEC<<8)/ACTHZ) << 8;
+		lguest_clock.mask = CLOCKSOURCE_MASK(32);
+	}
 	clocksource_register(&lguest_clock);
 
 	/* We can't set cpumask in the initializer: damn C limitations! */
@@ -442,12 +450,6 @@ static void lguest_time_init(void)
 	enable_lguest_irq(0);
 }
 
-static unsigned long lguest_get_cpu_khz(void)
-{
-	/* The Host tells us the TSC speed */
-	return lguest_data.tsc_khz;
-}
-
 static void lguest_load_esp0(struct tss_struct *tss,
 				     struct thread_struct *thread)
 {
@@ -584,7 +586,6 @@ __init void lguest_init(void *boot)
 	paravirt_ops.time_init = lguest_time_init;
 	paravirt_ops.set_lazy_mode = lguest_lazy_mode;
 	paravirt_ops.wbinvd = lguest_wbinvd;
-	paravirt_ops.get_cpu_khz = lguest_get_cpu_khz;
 
 	hcall(LHCALL_LGUEST_INIT, __pa(&lguest_data), 0, 0);
 
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
paravirt-helper-to-disable-all-io-space-fix.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
mm-clean-up-and-kernelify-shrinker-registration-vs-git-nfs.patch
use-menuconfig-objects-ii-module-menu.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
modules-remove-modlist_lock.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
fix-lguest-w-lockdep.patch
lguest-the-guest-code-lguest-fix-tsc-divide-error-0000-boot-crash.patch
lguest-the-host-code.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
lguest-the-host-code-handle-dodgy-non-existent-tsc-host-code.patch
lguest-the-host-code-handle-dodgy-non-existent-tsc-guest-code.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-fix-guests-1g.patch
readahead-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-min_ra_pages-max_ra_pages-macros.patch
readahead-data-structure-and-routines.patch
readahead-on-demand-readahead-logic.patch
readahead-convert-filemap-invocations.patch
readahead-convert-splice-invocations.patch
readahead-convert-ext3-ext4-invocations.patch
readahead-remove-the-old-algorithm.patch
readahead-move-synchronous-readahead-call-out-of-splice-loop.patch
readahead-pass-real-splice-size.patch
mm-share-pg_readahead-and-pg_reclaim.patch
readahead-split-ondemand-readahead-interface-into-two-functions.patch
readahead-sanify-file_ra_state-names.patch
define-new-percpu-interface-for-shared-data-version-4.patch
use-the-new-percpu-interface-for-shared-data-version-4.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
