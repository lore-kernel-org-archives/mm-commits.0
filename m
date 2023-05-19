Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E9DC7EE26
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 21:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjESV3P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 17:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbjESV3L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 17:29:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117C01B3
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 14:29:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B74D65788
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 21:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91E2C433D2;
        Fri, 19 May 2023 21:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684531749;
        bh=1CCkpEkFbEp+DFjGuCblIa19LnXtiLV4zkduaMWK8sw=;
        h=Date:To:From:Subject:From;
        b=JMRRlUtCbuj6NRoQHUJJg/wJJIexuPprIAnKhDaC2p5SQDlWQg6Rc4136RWB+HqaP
         EE+YN9v7zdmL/oPVMilJ/tdwn5I8tg8D2ybxFT8156OUVy2ZnZUexXo1EkKL8NxIkL
         xerbUrBDwSowQlrFMWw22ycdnpWgORGdLGZMBt40=
Date:   Fri, 19 May 2023 14:29:08 -0700
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
Subject: + watchdog-hardlockup-style-changes-to-watchdog_hardlockup_check-is_hardlockup.patch added to mm-nonmm-unstable branch
Message-Id: <20230519212908.E91E2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog/hardlockup: style changes to watchdog_hardlockup_check() / is_hardlockup()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-hardlockup-style-changes-to-watchdog_hardlockup_check-is_hardlockup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-hardlockup-style-changes-to-watchdog_hardlockup_check-is_hardlockup.patch

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
Subject: watchdog/hardlockup: style changes to watchdog_hardlockup_check() / is_hardlockup()
Date: Fri, 19 May 2023 10:18:33 -0700

These are tiny style changes:
- Add a blank line before a "return".
- Renames two globals to use the "watchdog_hardlockup" prefix.
- Store processor id in "unsigned int" rather than "int".
- Minor comment rewording.
- Use "else" rather than extra returns since it seemed more symmetric.

Link: https://lkml.kernel.org/r/20230519101840.v5.9.I818492c326b632560b09f20d2608455ecf9d3650@changeid
Reviewed-by: Petr Mladek <pmladek@suse.com>
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

 kernel/watchdog.c |   32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

--- a/kernel/watchdog.c~watchdog-hardlockup-style-changes-to-watchdog_hardlockup_check-is_hardlockup
+++ a/kernel/watchdog.c
@@ -89,8 +89,8 @@ __setup("nmi_watchdog=", hardlockup_pani
 
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
-static DEFINE_PER_CPU(bool, hard_watchdog_warn);
-static unsigned long hardlockup_allcpu_dumped;
+static DEFINE_PER_CPU(bool, watchdog_hardlockup_warned);
+static unsigned long watchdog_hardlockup_all_cpu_dumped;
 
 static bool is_hardlockup(void)
 {
@@ -100,6 +100,7 @@ static bool is_hardlockup(void)
 		return true;
 
 	__this_cpu_write(hrtimer_interrupts_saved, hrint);
+
 	return false;
 }
 
@@ -110,21 +111,20 @@ static void watchdog_hardlockup_kick(voi
 
 void watchdog_hardlockup_check(struct pt_regs *regs)
 {
-	/* check for a hardlockup
-	 * This is done by making sure our timer interrupt
-	 * is incrementing.  The timer interrupt should have
-	 * fired multiple times before we overflow'd.  If it hasn't
+	/*
+	 * Check for a hardlockup by making sure the CPU's timer
+	 * interrupt is incrementing. The timer interrupt should have
+	 * fired multiple times before we overflow'd. If it hasn't
 	 * then this is a good indication the cpu is stuck
 	 */
 	if (is_hardlockup()) {
-		int this_cpu = smp_processor_id();
+		unsigned int this_cpu = smp_processor_id();
 
-		/* only print hardlockups once */
-		if (__this_cpu_read(hard_watchdog_warn) == true)
+		/* Only print hardlockups once. */
+		if (__this_cpu_read(watchdog_hardlockup_warned))
 			return;
 
-		pr_emerg("Watchdog detected hard LOCKUP on cpu %d\n",
-			 this_cpu);
+		pr_emerg("Watchdog detected hard LOCKUP on cpu %d\n", this_cpu);
 		print_modules();
 		print_irqtrace_events(current);
 		if (regs)
@@ -137,18 +137,16 @@ void watchdog_hardlockup_check(struct pt
 		 * generating interleaving traces
 		 */
 		if (sysctl_hardlockup_all_cpu_backtrace &&
-				!test_and_set_bit(0, &hardlockup_allcpu_dumped))
+		    !test_and_set_bit(0, &watchdog_hardlockup_all_cpu_dumped))
 			trigger_allbutself_cpu_backtrace();
 
 		if (hardlockup_panic)
 			nmi_panic(regs, "Hard LOCKUP");
 
-		__this_cpu_write(hard_watchdog_warn, true);
-		return;
+		__this_cpu_write(watchdog_hardlockup_warned, true);
+	} else {
+		__this_cpu_write(watchdog_hardlockup_warned, false);
 	}
-
-	__this_cpu_write(hard_watchdog_warn, false);
-	return;
 }
 
 #else /* CONFIG_HARDLOCKUP_DETECTOR_PERF */
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

