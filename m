Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F286C77B7A
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 21:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjESV3W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 17:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbjESV3Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 17:29:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFF7BC
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 14:29:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63BE865788
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 21:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FE6C433D2;
        Fri, 19 May 2023 21:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684531753;
        bh=ddx5WxJZZyQnCQ+GAPLuro/fQV99EutcN31ajXdscFI=;
        h=Date:To:From:Subject:From;
        b=hU+L8Qmhw4pxZpbZHzONKWnciXUetw0n4WjayMNjiyU6qTyaAX2WSYD+PoJ8/RLgy
         WhZeOh9O+7FWtrNi6a+66e3DnU5bgQZJkRFxKzoJAdqG/J9eY3XWTISWdC2NKX1JPV
         aNDTBpGZS1Xq6bvj5S6H1KSieADYVRWhu+XKLWt4=
Date:   Fri, 19 May 2023 14:29:13 -0700
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
Subject: + watchdog-hardlockup-move-perf-hardlockup-watchdog-petting-to-watchdogc.patch added to mm-nonmm-unstable branch
Message-Id: <20230519212913.B8FE6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog/hardlockup: move perf hardlockup watchdog petting to watchdog.c
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-hardlockup-move-perf-hardlockup-watchdog-petting-to-watchdogc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-hardlockup-move-perf-hardlockup-watchdog-petting-to-watchdogc.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: watchdog/hardlockup: move perf hardlockup watchdog petting to watchdog.c
Date: Fri, 19 May 2023 10:18:35 -0700

In preparation for the buddy hardlockup detector, which wants the same
petting logic as the current perf hardlockup detector, move the code to
watchdog.c.  While doing this, rename the global variable to match others
nearby.  As part of this change we have to change the code to account for
the fact that the CPU we're running on might be different than the one
we're checking.

Currently the code in watchdog.c is guarded by
CONFIG_HARDLOCKUP_DETECTOR_PERF, which makes this change seem silly. 
However, a future patch will change this.

Link: https://lkml.kernel.org/r/20230519101840.v5.11.I00dfd6386ee00da25bf26d140559a41339b53e57@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
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
Cc: Petr Mladek <pmladek@suse.com>
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

 include/linux/nmi.h    |    5 +++--
 kernel/watchdog.c      |   19 +++++++++++++++++++
 kernel/watchdog_perf.c |   19 -------------------
 3 files changed, 22 insertions(+), 21 deletions(-)

--- a/include/linux/nmi.h~watchdog-hardlockup-move-perf-hardlockup-watchdog-petting-to-watchdogc
+++ a/include/linux/nmi.h
@@ -88,7 +88,10 @@ static inline void hardlockup_detector_d
 #endif
 
 #if defined(CONFIG_HARDLOCKUP_DETECTOR_PERF)
+void arch_touch_nmi_watchdog(void);
 void watchdog_hardlockup_check(unsigned int cpu, struct pt_regs *regs);
+#elif !defined(CONFIG_HAVE_NMI_WATCHDOG)
+static inline void arch_touch_nmi_watchdog(void) { }
 #endif
 
 #if defined(CONFIG_HAVE_NMI_WATCHDOG) || defined(CONFIG_HARDLOCKUP_DETECTOR)
@@ -98,7 +101,6 @@ void watchdog_hardlockup_check(unsigned
 #endif
 
 #if defined(CONFIG_HARDLOCKUP_DETECTOR_PERF)
-extern void arch_touch_nmi_watchdog(void);
 extern void hardlockup_detector_perf_stop(void);
 extern void hardlockup_detector_perf_restart(void);
 extern void hardlockup_detector_perf_disable(void);
@@ -113,7 +115,6 @@ static inline void hardlockup_detector_p
 static inline void hardlockup_detector_perf_cleanup(void) { }
 # if !defined(CONFIG_HAVE_NMI_WATCHDOG)
 static inline int hardlockup_detector_perf_init(void) { return -ENODEV; }
-static inline void arch_touch_nmi_watchdog(void) {}
 # else
 static inline int hardlockup_detector_perf_init(void) { return 0; }
 # endif
--- a/kernel/watchdog.c~watchdog-hardlockup-move-perf-hardlockup-watchdog-petting-to-watchdogc
+++ a/kernel/watchdog.c
@@ -90,8 +90,22 @@ __setup("nmi_watchdog=", hardlockup_pani
 static DEFINE_PER_CPU(atomic_t, hrtimer_interrupts);
 static DEFINE_PER_CPU(int, hrtimer_interrupts_saved);
 static DEFINE_PER_CPU(bool, watchdog_hardlockup_warned);
+static DEFINE_PER_CPU(bool, watchdog_hardlockup_touched);
 static unsigned long watchdog_hardlockup_all_cpu_dumped;
 
+notrace void arch_touch_nmi_watchdog(void)
+{
+	/*
+	 * Using __raw here because some code paths have
+	 * preemption enabled.  If preemption is enabled
+	 * then interrupts should be enabled too, in which
+	 * case we shouldn't have to worry about the watchdog
+	 * going off.
+	 */
+	raw_cpu_write(watchdog_hardlockup_touched, true);
+}
+EXPORT_SYMBOL(arch_touch_nmi_watchdog);
+
 static bool is_hardlockup(unsigned int cpu)
 {
 	int hrint = atomic_read(&per_cpu(hrtimer_interrupts, cpu));
@@ -116,6 +130,11 @@ static void watchdog_hardlockup_kick(voi
 
 void watchdog_hardlockup_check(unsigned int cpu, struct pt_regs *regs)
 {
+	if (per_cpu(watchdog_hardlockup_touched, cpu)) {
+		per_cpu(watchdog_hardlockup_touched, cpu) = false;
+		return;
+	}
+
 	/*
 	 * Check for a hardlockup by making sure the CPU's timer
 	 * interrupt is incrementing. The timer interrupt should have
--- a/kernel/watchdog_perf.c~watchdog-hardlockup-move-perf-hardlockup-watchdog-petting-to-watchdogc
+++ a/kernel/watchdog_perf.c
@@ -20,26 +20,12 @@
 #include <asm/irq_regs.h>
 #include <linux/perf_event.h>
 
-static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
 static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
 static DEFINE_PER_CPU(struct perf_event *, dead_event);
 static struct cpumask dead_events_mask;
 
 static atomic_t watchdog_cpus = ATOMIC_INIT(0);
 
-notrace void arch_touch_nmi_watchdog(void)
-{
-	/*
-	 * Using __raw here because some code paths have
-	 * preemption enabled.  If preemption is enabled
-	 * then interrupts should be enabled too, in which
-	 * case we shouldn't have to worry about the watchdog
-	 * going off.
-	 */
-	raw_cpu_write(watchdog_nmi_touch, true);
-}
-EXPORT_SYMBOL(arch_touch_nmi_watchdog);
-
 #ifdef CONFIG_HARDLOCKUP_CHECK_TIMESTAMP
 static DEFINE_PER_CPU(ktime_t, last_timestamp);
 static DEFINE_PER_CPU(unsigned int, nmi_rearmed);
@@ -115,11 +101,6 @@ static void watchdog_overflow_callback(s
 	if (!watchdog_check_timestamp())
 		return;
 
-	if (__this_cpu_read(watchdog_nmi_touch) == true) {
-		__this_cpu_write(watchdog_nmi_touch, false);
-		return;
-	}
-
 	watchdog_hardlockup_check(smp_processor_id(), regs);
 }
 
_

Patches currently in -mm which might be from dianders@chromium.org are

migrate_pages-avoid-blocking-for-io-in-migrate_sync_light.patch
watchdog-perf-define-dummy-watchdog_update_hrtimer_threshold-on-correct-config.patch
watchdog-perf-more-properly-prevent-false-positives-with-turbo-modes.patch
watchdog-hardlockup-add-comments-to-touch_nmi_watchdog.patch
watchdog-perf-rename-watchdog_hldc-to-watchdog_perfc.patch
watchdog-hardlockup-move-perf-hardlockup-checking-panic-to-common-watchdogc.patch
watchdog-hardlockup-style-changes-to-watchdog_hardlockup_check-is_hardlockup.patch
watchdog-hardlockup-add-a-cpu-param-to-watchdog_hardlockup_check.patch
watchdog-hardlockup-move-perf-hardlockup-watchdog-petting-to-watchdogc.patch
watchdog-hardlockup-rename-some-nmi-watchdog-constants-function.patch
watchdog-hardlockup-have-the-perf-hardlockup-use-__weak-functions-more-cleanly.patch
watchdog-hardlockup-detect-hard-lockups-using-secondary-buddy-cpus.patch
watchdog-perf-add-a-weak-function-for-an-arch-to-detect-if-perf-can-use-nmis.patch
arm64-enable-perf-events-based-hard-lockup-detector.patch

