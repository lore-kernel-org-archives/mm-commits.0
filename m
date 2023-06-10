Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF9DC7EE45
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbjFJApu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbjFJApn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782603A9B
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DFAD651DE
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BBDC433EF;
        Sat, 10 Jun 2023 00:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357940;
        bh=zgBRhEZOb/MZwyiLo5TGc7gbqe2VfWCTP653dhZLsco=;
        h=Date:To:From:Subject:From;
        b=PgAtxYgwaHkhl4d6NCa3E++LvrUf+hv/hHbFAsTcfBI82vz6fALz/+zhnQWPbduCf
         QzIQZL0O72IOcopvBiQo44bRUShbU1h0oHLk4YN42PrKj2MXaWts/E5DbaWhuCiSxN
         KueGzu6v0uT1WE+3uYbwn2V7PQJeH9jtXnrcv7v0=
Date:   Fri, 09 Jun 2023 17:45:39 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, wens@csie.org,
        tzungbi@chromium.org, swboyd@chromium.org, sumit.garg@linaro.org,
        ricardo.neri@intel.com, rdunlap@infradead.org,
        ravi.v.shankar@intel.com, pmladek@suse.com, npiggin@gmail.com,
        msys.mizuma@gmail.com, mpe@ellerman.id.au, mka@chromium.org,
        maz@kernel.org, mark.rutland@arm.com, lecopzer.chen@mediatek.com,
        kernelfans@gmail.com, irogers@google.com, groeck@chromium.org,
        eranian@google.com, davem@davemloft.net,
        daniel.thompson@linaro.org, christophe.leroy@csgroup.eu,
        ccross@android.com, catalin.marinas@arm.com, ak@linux.intel.com,
        dianders@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-hardlockup-move-perf-hardlockup-checking-panic-to-common-watchdogc.patch removed from -mm tree
Message-Id: <20230610004540.59BBDC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog/hardlockup: move perf hardlockup checking/panic to common watchdog.c
has been removed from the -mm tree.  Its filename was
     watchdog-hardlockup-move-perf-hardlockup-checking-panic-to-common-watchdogc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: watchdog/hardlockup: move perf hardlockup checking/panic to common watchdog.c
Date: Fri, 19 May 2023 10:18:32 -0700

The perf hardlockup detector works by looking at interrupt counts and
seeing if they change from run to run.  The interrupt counts are managed
by the common watchdog code via its watchdog_timer_fn().

Currently the API between the perf detector and the common code is a
function: is_hardlockup().  When the hard lockup detector sees that
function return true then it handles printing out debug info and inducing
a panic if necessary.

Let's change the API a little bit in preparation for the buddy hardlockup
detector.  The buddy hardlockup detector wants to print nearly the same
debug info and have nearly the same panic behavior.  That means we want to
move all that code to the common file.  For now, the code in the common
file will only be there if the perf hardlockup detector is enabled, but
eventually it will be selected by a common config.

Right now, this _just_ moves the code from the perf detector file to the
common file and changes the names.  It doesn't make the changes that the
buddy hardlockup detector will need and doesn't do any style cleanups.  A
future patch will do cleanup to make it more obvious what changed.

With the above, we no longer have any callers of is_hardlockup() outside
of the "watchdog.c" file, so we can remove it from the header, make it
static, and move it to the same "#ifdef" block as our new
watchdog_hardlockup_check().  While doing this, it can be noted that even
if no hardlockup detectors were configured the existing code used to still
have the code for counting/checking "hrtimer_interrupts" even if the perf
hardlockup detector wasn't configured.  We didn't need to do that, so move
all the "hrtimer_interrupts" counting to only be there if the perf
hardlockup detector is configured as well.

This change is expected to be a no-op.

Link: https://lkml.kernel.org/r/20230519101840.v5.8.Id4133d3183e798122dc3b6205e7852601f289071@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen-Yu Tsai <wens@csie.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Colin Cross <ccross@android.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Pingfan Liu <kernelfans@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: "Ravi V. Shankar" <ravi.v.shankar@intel.com>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: Sumit Garg <sumit.garg@linaro.org>
Cc: Tzung-Bi Shih <tzungbi@chromium.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h    |    5 +-
 kernel/watchdog.c      |   93 ++++++++++++++++++++++++++++++---------
 kernel/watchdog_perf.c |   42 -----------------
 3 files changed, 78 insertions(+), 62 deletions(-)

--- a/include/linux/nmi.h~watchdog-hardlockup-move-perf-hardlockup-checking-panic-to-common-watchdogc
+++ a/include/linux/nmi.h
@@ -15,7 +15,6 @@
 void lockup_detector_init(void);
 void lockup_detector_soft_poweroff(void);
 void lockup_detector_cleanup(void);
-bool is_hardlockup(void);
 
 extern int watchdog_user_enabled;
 extern int nmi_watchdog_user_enabled;
@@ -88,6 +87,10 @@ extern unsigned int hardlockup_panic;
 static inline void hardlockup_detector_disable(void) {}
 #endif
 
+#if defined(CONFIG_HARDLOCKUP_DETECTOR_PERF)
+void watchdog_hardlockup_check(struct pt_regs *regs);
+#endif
+
 #if defined(CONFIG_HAVE_NMI_WATCHDOG) || defined(CONFIG_HARDLOCKUP_DETECTOR)
 # define NMI_WATCHDOG_SYSCTL_PERM	0644
 #else
--- a/kernel/watchdog.c~watchdog-hardlockup-move-perf-hardlockup-checking-panic-to-common-watchdogc
+++ a/kernel/watchdog.c
@@ -85,6 +85,78 @@ __setup("nmi_watchdog=", hardlockup_pani
 
 #endif /* CONFIG_HARDLOCKUP_DETECTOR */
 
+#if defined(CONFIG_HARDLOCKUP_DETECTOR_PERF)
+
+static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
+static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
+static DEFINE_PER_CPU(bool, hard_watchdog_warn);
+static unsigned long hardlockup_allcpu_dumped;
+
+static bool is_hardlockup(void)
+{
+	unsigned long hrint = __this_cpu_read(hrtimer_interrupts);
+
+	if (__this_cpu_read(hrtimer_interrupts_saved) == hrint)
+		return true;
+
+	__this_cpu_write(hrtimer_interrupts_saved, hrint);
+	return false;
+}
+
+static void watchdog_hardlockup_kick(void)
+{
+	__this_cpu_inc(hrtimer_interrupts);
+}
+
+void watchdog_hardlockup_check(struct pt_regs *regs)
+{
+	/* check for a hardlockup
+	 * This is done by making sure our timer interrupt
+	 * is incrementing.  The timer interrupt should have
+	 * fired multiple times before we overflow'd.  If it hasn't
+	 * then this is a good indication the cpu is stuck
+	 */
+	if (is_hardlockup()) {
+		int this_cpu = smp_processor_id();
+
+		/* only print hardlockups once */
+		if (__this_cpu_read(hard_watchdog_warn) == true)
+			return;
+
+		pr_emerg("Watchdog detected hard LOCKUP on cpu %d\n",
+			 this_cpu);
+		print_modules();
+		print_irqtrace_events(current);
+		if (regs)
+			show_regs(regs);
+		else
+			dump_stack();
+
+		/*
+		 * Perform all-CPU dump only once to avoid multiple hardlockups
+		 * generating interleaving traces
+		 */
+		if (sysctl_hardlockup_all_cpu_backtrace &&
+				!test_and_set_bit(0, &hardlockup_allcpu_dumped))
+			trigger_allbutself_cpu_backtrace();
+
+		if (hardlockup_panic)
+			nmi_panic(regs, "Hard LOCKUP");
+
+		__this_cpu_write(hard_watchdog_warn, true);
+		return;
+	}
+
+	__this_cpu_write(hard_watchdog_warn, false);
+	return;
+}
+
+#else /* CONFIG_HARDLOCKUP_DETECTOR_PERF */
+
+static inline void watchdog_hardlockup_kick(void) { }
+
+#endif /* !CONFIG_HARDLOCKUP_DETECTOR_PERF */
+
 /*
  * These functions can be overridden if an architecture implements its
  * own hardlockup detector.
@@ -176,8 +248,6 @@ static DEFINE_PER_CPU(unsigned long, wat
 static DEFINE_PER_CPU(unsigned long, watchdog_report_ts);
 static DEFINE_PER_CPU(struct hrtimer, watchdog_hrtimer);
 static DEFINE_PER_CPU(bool, softlockup_touch_sync);
-static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
-static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
 static unsigned long soft_lockup_nmi_warn;
 
 static int __init nowatchdog_setup(char *str)
@@ -312,22 +382,6 @@ static int is_softlockup(unsigned long t
 }
 
 /* watchdog detector functions */
-bool is_hardlockup(void)
-{
-	unsigned long hrint = __this_cpu_read(hrtimer_interrupts);
-
-	if (__this_cpu_read(hrtimer_interrupts_saved) == hrint)
-		return true;
-
-	__this_cpu_write(hrtimer_interrupts_saved, hrint);
-	return false;
-}
-
-static void watchdog_interrupt_count(void)
-{
-	__this_cpu_inc(hrtimer_interrupts);
-}
-
 static DEFINE_PER_CPU(struct completion, softlockup_completion);
 static DEFINE_PER_CPU(struct cpu_stop_work, softlockup_stop_work);
 
@@ -358,8 +412,7 @@ static enum hrtimer_restart watchdog_tim
 	if (!watchdog_enabled)
 		return HRTIMER_NORESTART;
 
-	/* kick the hardlockup detector */
-	watchdog_interrupt_count();
+	watchdog_hardlockup_kick();
 
 	/* kick the softlockup detector */
 	if (completion_done(this_cpu_ptr(&softlockup_completion))) {
--- a/kernel/watchdog_perf.c~watchdog-hardlockup-move-perf-hardlockup-checking-panic-to-common-watchdogc
+++ a/kernel/watchdog_perf.c
@@ -20,13 +20,11 @@
 #include <asm/irq_regs.h>
 #include <linux/perf_event.h>
 
-static DEFINE_PER_CPU(bool, hard_watchdog_warn);
 static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
 static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
 static DEFINE_PER_CPU(struct perf_event *, dead_event);
 static struct cpumask dead_events_mask;
 
-static unsigned long hardlockup_allcpu_dumped;
 static atomic_t watchdog_cpus = ATOMIC_INIT(0);
 
 notrace void arch_touch_nmi_watchdog(void)
@@ -122,45 +120,7 @@ static void watchdog_overflow_callback(s
 		return;
 	}
 
-	/* check for a hardlockup
-	 * This is done by making sure our timer interrupt
-	 * is incrementing.  The timer interrupt should have
-	 * fired multiple times before we overflow'd.  If it hasn't
-	 * then this is a good indication the cpu is stuck
-	 */
-	if (is_hardlockup()) {
-		int this_cpu = smp_processor_id();
-
-		/* only print hardlockups once */
-		if (__this_cpu_read(hard_watchdog_warn) == true)
-			return;
-
-		pr_emerg("Watchdog detected hard LOCKUP on cpu %d\n",
-			 this_cpu);
-		print_modules();
-		print_irqtrace_events(current);
-		if (regs)
-			show_regs(regs);
-		else
-			dump_stack();
-
-		/*
-		 * Perform all-CPU dump only once to avoid multiple hardlockups
-		 * generating interleaving traces
-		 */
-		if (sysctl_hardlockup_all_cpu_backtrace &&
-				!test_and_set_bit(0, &hardlockup_allcpu_dumped))
-			trigger_allbutself_cpu_backtrace();
-
-		if (hardlockup_panic)
-			nmi_panic(regs, "Hard LOCKUP");
-
-		__this_cpu_write(hard_watchdog_warn, true);
-		return;
-	}
-
-	__this_cpu_write(hard_watchdog_warn, false);
-	return;
+	watchdog_hardlockup_check(regs);
 }
 
 static int hardlockup_detector_event_create(void)
_

Patches currently in -mm which might be from dianders@chromium.org are

watchdog-hardlockup-style-changes-to-watchdog_hardlockup_check-is_hardlockup.patch
watchdog-hardlockup-add-a-cpu-param-to-watchdog_hardlockup_check.patch
watchdog-hardlockup-move-perf-hardlockup-watchdog-petting-to-watchdogc.patch
watchdog-hardlockup-rename-some-nmi-watchdog-constants-function.patch
watchdog-hardlockup-have-the-perf-hardlockup-use-__weak-functions-more-cleanly.patch
watchdog-hardlockup-detect-hard-lockups-using-secondary-buddy-cpus.patch
watchdog-perf-add-a-weak-function-for-an-arch-to-detect-if-perf-can-use-nmis.patch
arm64-enable-perf-events-based-hard-lockup-detector.patch

