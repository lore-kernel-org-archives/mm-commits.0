Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58790C7EE25
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjFJAp5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbjFJApp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF63230F6
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0EDF651DE
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D29C433D2;
        Sat, 10 Jun 2023 00:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357943;
        bh=e7gkpEPTtwEtyp4VAibMRCDQufGaPRGsMlvnP8GtQTs=;
        h=Date:To:From:Subject:From;
        b=Shu+6n4jdfYmAdJDN642z/XkiZKKxqlL5QUq9l1TFDiroEf6iv4ETwxl4OzAEXAOR
         wL47DGh9wSvs5OYuLP75st2BfpqnsT7Y2zH7qJuby8RiPDyX1GPai7Vc6aUjqousTM
         cW1s0L7MOUDVA65a8dRJZPSsv4hITAima/aiPV3E=
Date:   Fri, 09 Jun 2023 17:45:42 -0700
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
Subject: [merged mm-nonmm-stable] watchdog-hardlockup-add-a-cpu-param-to-watchdog_hardlockup_check.patch removed from -mm tree
Message-Id: <20230610004543.23D29C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog/hardlockup: add a "cpu" param to watchdog_hardlockup_check()
has been removed from the -mm tree.  Its filename was
     watchdog-hardlockup-add-a-cpu-param-to-watchdog_hardlockup_check.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: watchdog/hardlockup: add a "cpu" param to watchdog_hardlockup_check()
Date: Fri, 19 May 2023 10:18:34 -0700

In preparation for the buddy hardlockup detector where the CPU checking
for lockup might not be the currently running CPU, add a "cpu" parameter
to watchdog_hardlockup_check().

As part of this change, make hrtimer_interrupts an atomic_t since now the
CPU incrementing the value and the CPU reading the value might be
different.  Technially this could also be done with just READ_ONCE and
WRITE_ONCE, but atomic_t feels a little cleaner in this case.

While hrtimer_interrupts is made atomic_t, we change
hrtimer_interrupts_saved from "unsigned long" to "int".  The "int" is
needed to match the data type backing atomic_t for hrtimer_interrupts. 
Even if this changes us from 64-bits to 32-bits (which I don't think is
true for most compilers), it doesn't really matter.  All we ever do is
increment it every few seconds and compare it to an old value so 32-bits
is fine (even 16-bits would be).  The "signed" vs "unsigned" also doesn't
matter for simple equality comparisons.

hrtimer_interrupts_saved is _not_ switched to atomic_t nor even accessed
with READ_ONCE / WRITE_ONCE.  The hrtimer_interrupts_saved is always
consistently accessed with the same CPU.  NOTE: with the upcoming "buddy"
detector there is one special case.  When a CPU goes offline/online then
we can change which CPU is the one to consistently access a given instance
of hrtimer_interrupts_saved.  We still can't end up with a partially
updated hrtimer_interrupts_saved, however, because we end up petting all
affected CPUs to make sure the new and old CPU can't end up somehow
read/write hrtimer_interrupts_saved at the same time.

Link: https://lkml.kernel.org/r/20230519101840.v5.10.I3a7d4dd8c23ac30ee0b607d77feb6646b64825c0@changeid
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

 include/linux/nmi.h    |    2 -
 kernel/watchdog.c      |   52 ++++++++++++++++++++++++---------------
 kernel/watchdog_perf.c |    2 -
 3 files changed, 34 insertions(+), 22 deletions(-)

--- a/include/linux/nmi.h~watchdog-hardlockup-add-a-cpu-param-to-watchdog_hardlockup_check
+++ a/include/linux/nmi.h
@@ -88,7 +88,7 @@ static inline void hardlockup_detector_d
 #endif
 
 #if defined(CONFIG_HARDLOCKUP_DETECTOR_PERF)
-void watchdog_hardlockup_check(struct pt_regs *regs);
+void watchdog_hardlockup_check(unsigned int cpu, struct pt_regs *regs);
 #endif
 
 #if defined(CONFIG_HAVE_NMI_WATCHDOG) || defined(CONFIG_HARDLOCKUP_DETECTOR)
--- a/kernel/watchdog.c~watchdog-hardlockup-add-a-cpu-param-to-watchdog_hardlockup_check
+++ a/kernel/watchdog.c
@@ -87,29 +87,34 @@ __setup("nmi_watchdog=", hardlockup_pani
 
 #if defined(CONFIG_HARDLOCKUP_DETECTOR_PERF)
 
-static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
-static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
+static DEFINE_PER_CPU(atomic_t, hrtimer_interrupts);
+static DEFINE_PER_CPU(int, hrtimer_interrupts_saved);
 static DEFINE_PER_CPU(bool, watchdog_hardlockup_warned);
 static unsigned long watchdog_hardlockup_all_cpu_dumped;
 
-static bool is_hardlockup(void)
+static bool is_hardlockup(unsigned int cpu)
 {
-	unsigned long hrint = __this_cpu_read(hrtimer_interrupts);
+	int hrint = atomic_read(&per_cpu(hrtimer_interrupts, cpu));
 
-	if (__this_cpu_read(hrtimer_interrupts_saved) == hrint)
+	if (per_cpu(hrtimer_interrupts_saved, cpu) == hrint)
 		return true;
 
-	__this_cpu_write(hrtimer_interrupts_saved, hrint);
+	/*
+	 * NOTE: we don't need any fancy atomic_t or READ_ONCE/WRITE_ONCE
+	 * for hrtimer_interrupts_saved. hrtimer_interrupts_saved is
+	 * written/read by a single CPU.
+	 */
+	per_cpu(hrtimer_interrupts_saved, cpu) = hrint;
 
 	return false;
 }
 
 static void watchdog_hardlockup_kick(void)
 {
-	__this_cpu_inc(hrtimer_interrupts);
+	atomic_inc(raw_cpu_ptr(&hrtimer_interrupts));
 }
 
-void watchdog_hardlockup_check(struct pt_regs *regs)
+void watchdog_hardlockup_check(unsigned int cpu, struct pt_regs *regs)
 {
 	/*
 	 * Check for a hardlockup by making sure the CPU's timer
@@ -117,35 +122,42 @@ void watchdog_hardlockup_check(struct pt
 	 * fired multiple times before we overflow'd. If it hasn't
 	 * then this is a good indication the cpu is stuck
 	 */
-	if (is_hardlockup()) {
+	if (is_hardlockup(cpu)) {
 		unsigned int this_cpu = smp_processor_id();
+		struct cpumask backtrace_mask = *cpu_online_mask;
 
 		/* Only print hardlockups once. */
-		if (__this_cpu_read(watchdog_hardlockup_warned))
+		if (per_cpu(watchdog_hardlockup_warned, cpu))
 			return;
 
-		pr_emerg("Watchdog detected hard LOCKUP on cpu %d\n", this_cpu);
+		pr_emerg("Watchdog detected hard LOCKUP on cpu %d\n", cpu);
 		print_modules();
 		print_irqtrace_events(current);
-		if (regs)
-			show_regs(regs);
-		else
-			dump_stack();
+		if (cpu == this_cpu) {
+			if (regs)
+				show_regs(regs);
+			else
+				dump_stack();
+			cpumask_clear_cpu(cpu, &backtrace_mask);
+		} else {
+			if (trigger_single_cpu_backtrace(cpu))
+				cpumask_clear_cpu(cpu, &backtrace_mask);
+		}
 
 		/*
-		 * Perform all-CPU dump only once to avoid multiple hardlockups
-		 * generating interleaving traces
+		 * Perform multi-CPU dump only once to avoid multiple
+		 * hardlockups generating interleaving traces
 		 */
 		if (sysctl_hardlockup_all_cpu_backtrace &&
 		    !test_and_set_bit(0, &watchdog_hardlockup_all_cpu_dumped))
-			trigger_allbutself_cpu_backtrace();
+			trigger_cpumask_backtrace(&backtrace_mask);
 
 		if (hardlockup_panic)
 			nmi_panic(regs, "Hard LOCKUP");
 
-		__this_cpu_write(watchdog_hardlockup_warned, true);
+		per_cpu(watchdog_hardlockup_warned, cpu) = true;
 	} else {
-		__this_cpu_write(watchdog_hardlockup_warned, false);
+		per_cpu(watchdog_hardlockup_warned, cpu) = false;
 	}
 }
 
--- a/kernel/watchdog_perf.c~watchdog-hardlockup-add-a-cpu-param-to-watchdog_hardlockup_check
+++ a/kernel/watchdog_perf.c
@@ -120,7 +120,7 @@ static void watchdog_overflow_callback(s
 		return;
 	}
 
-	watchdog_hardlockup_check(regs);
+	watchdog_hardlockup_check(smp_processor_id(), regs);
 }
 
 static int hardlockup_detector_event_create(void)
_

Patches currently in -mm which might be from dianders@chromium.org are

watchdog-hardlockup-move-perf-hardlockup-watchdog-petting-to-watchdogc.patch
watchdog-hardlockup-rename-some-nmi-watchdog-constants-function.patch
watchdog-hardlockup-have-the-perf-hardlockup-use-__weak-functions-more-cleanly.patch
watchdog-hardlockup-detect-hard-lockups-using-secondary-buddy-cpus.patch
watchdog-perf-add-a-weak-function-for-an-arch-to-detect-if-perf-can-use-nmis.patch
arm64-enable-perf-events-based-hard-lockup-detector.patch

