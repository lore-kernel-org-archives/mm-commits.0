Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32774C7EE23
	for <mm-commits@archiver.kernel.org>; Tue, 30 May 2023 22:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbjE3W0O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 May 2023 18:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjE3W0N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2023 18:26:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D13993
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 15:26:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70CF7615F5
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 22:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB677C433EF;
        Tue, 30 May 2023 22:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685485570;
        bh=i/WXwhZpKOC6CgNdBU1wuEjLOfGfJnDF2kDVMNvI03Y=;
        h=Date:To:From:Subject:From;
        b=UjOsHsVGbEh83RbsFAGzLQsz68jT56P7GlDfYhMh/P3JoT9Do5GF7DTL9pUi/kM60
         sfbk3VcQQNrzAuFMLS1f9rRfz97Hj71VzO5FIKsZndtj3E5WFse8SFk+bdb6UA/3nx
         Dxj6YcMPhSTuo3H8RXNdVxPTSVz9enqdBhbWufA0=
Date:   Tue, 30 May 2023 15:26:10 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com, npiggin@gmail.com,
        mpe@ellerman.id.au, davem@davemloft.net,
        christophe.leroy@csgroup.eu, dianders@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-hardlockup-keep-kernelnmi_watchdog-sysctl-as-0444-if-probe-fails.patch added to mm-nonmm-unstable branch
Message-Id: <20230530222610.CB677C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog/hardlockup: keep kernel.nmi_watchdog sysctl as 0444 if probe fails
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-hardlockup-keep-kernelnmi_watchdog-sysctl-as-0444-if-probe-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-hardlockup-keep-kernelnmi_watchdog-sysctl-as-0444-if-probe-fails.patch

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
Subject: watchdog/hardlockup: keep kernel.nmi_watchdog sysctl as 0444 if probe fails
Date: Fri, 26 May 2023 18:41:31 -0700

Patch series "watchdog: Cleanup / fixes after buddy series v5 reviews".

This patch series attempts to finish resolving the feedback received
from Petr Mladek on the v5 series I posted.

Probably the only thing that wasn't fully as clean as Petr requested was
the Kconfig stuff.  I couldn't find a better way to express it without a
more major overhaul.  In the very least, I renamed "NON_ARCH" to
"PERF_OR_BUDDY" in the hopes that will make it marginally better.

Nothing in this series is terribly critical and even the bugfixes are
small.  However, it does cleanup a few things that were pointed out in
review.


This patch (of 10):

The permissions for the kernel.nmi_watchdog sysctl have always been set at
compile time despite the fact that a watchdog can fail to probe.  Let's
fix this and set the permissions based on whether the hardlockup detector
actually probed.

Link: https://lkml.kernel.org/r/20230527014153.2793931-1-dianders@chromium.org
Link: https://lkml.kernel.org/r/20230526184139.1.I0d75971cc52a7283f495aac0bd5c3041aadc734e@changeid
Fixes: a994a3147e4c ("watchdog/hardlockup/perf: Implement init time detection of perf")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reported-by: Petr Mladek <pmladek@suse.com>
Closes: https://lore.kernel.org/r/ZHCn4hNxFpY5-9Ki@alley
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |    6 ------
 kernel/watchdog.c   |   30 ++++++++++++++++++++----------
 2 files changed, 20 insertions(+), 16 deletions(-)

--- a/include/linux/nmi.h~watchdog-hardlockup-keep-kernelnmi_watchdog-sysctl-as-0444-if-probe-fails
+++ a/include/linux/nmi.h
@@ -95,12 +95,6 @@ void watchdog_hardlockup_check(unsigned
 static inline void arch_touch_nmi_watchdog(void) { }
 #endif
 
-#if defined(CONFIG_HAVE_NMI_WATCHDOG) || defined(CONFIG_HARDLOCKUP_DETECTOR)
-# define NMI_WATCHDOG_SYSCTL_PERM	0644
-#else
-# define NMI_WATCHDOG_SYSCTL_PERM	0444
-#endif
-
 #if defined(CONFIG_HARDLOCKUP_DETECTOR_PERF)
 extern void hardlockup_detector_perf_stop(void);
 extern void hardlockup_detector_perf_restart(void);
--- a/kernel/watchdog.c~watchdog-hardlockup-keep-kernelnmi_watchdog-sysctl-as-0444-if-probe-fails
+++ a/kernel/watchdog.c
@@ -881,15 +881,6 @@ static struct ctl_table watchdog_sysctls
 		.extra2		= (void *)&sixty,
 	},
 	{
-		.procname       = "nmi_watchdog",
-		.data		= &watchdog_hardlockup_user_enabled,
-		.maxlen		= sizeof(int),
-		.mode		= NMI_WATCHDOG_SYSCTL_PERM,
-		.proc_handler   = proc_nmi_watchdog,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-	{
 		.procname	= "watchdog_cpumask",
 		.data		= &watchdog_cpumask_bits,
 		.maxlen		= NR_CPUS,
@@ -952,10 +943,28 @@ static struct ctl_table watchdog_sysctls
 	{}
 };
 
+static struct ctl_table watchdog_hardlockup_sysctl[] = {
+	{
+		.procname       = "nmi_watchdog",
+		.data		= &watchdog_hardlockup_user_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler   = proc_nmi_watchdog,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{}
+};
+
 static void __init watchdog_sysctl_init(void)
 {
 	register_sysctl_init("kernel", watchdog_sysctls);
+
+	if (watchdog_hardlockup_available)
+		watchdog_hardlockup_sysctl[0].mode = 0644;
+	register_sysctl_init("kernel", watchdog_hardlockup_sysctl);
 }
+
 #else
 #define watchdog_sysctl_init() do { } while (0)
 #endif /* CONFIG_SYSCTL */
@@ -1011,6 +1020,8 @@ static int __init lockup_detector_check(
 	/* Make sure no work is pending. */
 	flush_work(&detector_work);
 
+	watchdog_sysctl_init();
+
 	return 0;
 
 }
@@ -1030,5 +1041,4 @@ void __init lockup_detector_init(void)
 		allow_lockup_detector_init_retry = true;
 
 	lockup_detector_setup();
-	watchdog_sysctl_init();
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
arm64-enable-perf-events-based-hard-lockup-detector-fix.patch
watchdog-hardlockup-keep-kernelnmi_watchdog-sysctl-as-0444-if-probe-fails.patch
watchdog-hardlockup-have_nmi_watchdog-must-implement-watchdog_hardlockup_probe.patch
watchdog-hardlockup-dont-use-raw_cpu_ptr-in-watchdog_hardlockup_kick.patch
watchdog-hardlockup-in-watchdog_hardlockup_check-use-cpumask_copy.patch
watchdog-hardlockup-remove-softlockup-comment-in-touch_nmi_watchdog.patch
watchdog-buddy-cleanup-how-watchdog_buddy_check_hardlockup-is-called.patch
watchdog-buddy-dont-copy-the-cpumask-in-watchdog_next_cpu.patch
watchdog-buddy-simplify-the-dependency-for-hardlockup_detector_prefer_buddy.patch
watchdog-hardlockup-move-smp-barriers-from-common-code-to-buddy-code.patch
watchdog-hardlockup-rename-have_hardlockup_detector_non_arch-to-_perf_or_buddy.patch

