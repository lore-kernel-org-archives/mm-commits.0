Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23559C77B7A
	for <mm-commits@archiver.kernel.org>; Tue, 30 May 2023 22:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbjE3W01 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 May 2023 18:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbjE3W0X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2023 18:26:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C220993
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 15:26:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F0FE6342C
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 22:26:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5901C433D2;
        Tue, 30 May 2023 22:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685485580;
        bh=N9nDBySz1p3EfNDoi8GBUZZNC+nTKFqz11JQGPMsCmk=;
        h=Date:To:From:Subject:From;
        b=XlqJrszla7eUvNbLsxnPq1uWNHMkW73g93v1jG6jGG/kppujrfjdMFNsAS/KkBONk
         tdC0kONiQrmlCpRj2dgUQD96NT+YotxET6PU0bZf1kQQgVd0+zovaQPv6d7kqQ1x5E
         emWZQ9s7WrfDG/LbzPrYg/HVu69r4ruLf5IpKBgs=
Date:   Tue, 30 May 2023 15:26:20 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com, npiggin@gmail.com,
        mpe@ellerman.id.au, davem@davemloft.net,
        christophe.leroy@csgroup.eu, dianders@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-buddy-cleanup-how-watchdog_buddy_check_hardlockup-is-called.patch added to mm-nonmm-unstable branch
Message-Id: <20230530222620.B5901C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog/buddy: cleanup how watchdog_buddy_check_hardlockup() is called
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-buddy-cleanup-how-watchdog_buddy_check_hardlockup-is-called.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-buddy-cleanup-how-watchdog_buddy_check_hardlockup-is-called.patch

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
Subject: watchdog/buddy: cleanup how watchdog_buddy_check_hardlockup() is called
Date: Fri, 26 May 2023 18:41:36 -0700

In the patch ("watchdog/hardlockup: detect hard lockups using secondary
(buddy) CPUs"), we added a call from the common watchdog.c file into the
buddy.  That call could be done more cleanly.  Specifically:

1. If we move the call into watchdog_hardlockup_kick() then it keeps
   watchdog_timer_fn() simpler.
2. We don't need to pass an "unsigned long" to the buddy for the timer
   count. In the patch ("watchdog/hardlockup: add a "cpu" param to
   watchdog_hardlockup_check()") the count was changed to "atomic_t"
   which is backed by an int, so we should match types.

Link: https://lkml.kernel.org/r/20230526184139.6.I006c7d958a1ea5c4e1e4dc44a25596d9bb5fd3ba@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Suggested-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h     |    4 ++--
 kernel/watchdog.c       |   15 +++++++--------
 kernel/watchdog_buddy.c |    2 +-
 3 files changed, 10 insertions(+), 11 deletions(-)

--- a/include/linux/nmi.h~watchdog-buddy-cleanup-how-watchdog_buddy_check_hardlockup-is-called
+++ a/include/linux/nmi.h
@@ -114,9 +114,9 @@ void watchdog_hardlockup_disable(unsigne
 void lockup_detector_reconfigure(void);
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR_BUDDY
-void watchdog_buddy_check_hardlockup(unsigned long hrtimer_interrupts);
+void watchdog_buddy_check_hardlockup(int hrtimer_interrupts);
 #else
-static inline void watchdog_buddy_check_hardlockup(unsigned long hrtimer_interrupts) {}
+static inline void watchdog_buddy_check_hardlockup(int hrtimer_interrupts) {}
 #endif
 
 /**
--- a/kernel/watchdog_buddy.c~watchdog-buddy-cleanup-how-watchdog_buddy_check_hardlockup-is-called
+++ a/kernel/watchdog_buddy.c
@@ -72,7 +72,7 @@ void watchdog_hardlockup_disable(unsigne
 	cpumask_clear_cpu(cpu, &watchdog_cpus);
 }
 
-void watchdog_buddy_check_hardlockup(unsigned long hrtimer_interrupts)
+void watchdog_buddy_check_hardlockup(int hrtimer_interrupts)
 {
 	unsigned int next_cpu;
 
--- a/kernel/watchdog.c~watchdog-buddy-cleanup-how-watchdog_buddy_check_hardlockup-is-called
+++ a/kernel/watchdog.c
@@ -131,9 +131,12 @@ static bool is_hardlockup(unsigned int c
 	return false;
 }
 
-static unsigned long watchdog_hardlockup_kick(void)
+static void watchdog_hardlockup_kick(void)
 {
-	return atomic_inc_return(this_cpu_ptr(&hrtimer_interrupts));
+	int new_interrupts;
+
+	new_interrupts = atomic_inc_return(this_cpu_ptr(&hrtimer_interrupts));
+	watchdog_buddy_check_hardlockup(new_interrupts);
 }
 
 void watchdog_hardlockup_check(unsigned int cpu, struct pt_regs *regs)
@@ -195,7 +198,7 @@ void watchdog_hardlockup_check(unsigned
 
 #else /* CONFIG_HARDLOCKUP_DETECTOR_COUNTS_HRTIMER */
 
-static inline unsigned long watchdog_hardlockup_kick(void) { return 0; }
+static inline void watchdog_hardlockup_kick(void) { }
 
 #endif /* !CONFIG_HARDLOCKUP_DETECTOR_COUNTS_HRTIMER */
 
@@ -449,15 +452,11 @@ static enum hrtimer_restart watchdog_tim
 	struct pt_regs *regs = get_irq_regs();
 	int duration;
 	int softlockup_all_cpu_backtrace = sysctl_softlockup_all_cpu_backtrace;
-	unsigned long hrtimer_interrupts;
 
 	if (!watchdog_enabled)
 		return HRTIMER_NORESTART;
 
-	hrtimer_interrupts = watchdog_hardlockup_kick();
-
-	/* test for hardlockups */
-	watchdog_buddy_check_hardlockup(hrtimer_interrupts);
+	watchdog_hardlockup_kick();
 
 	/* kick the softlockup detector */
 	if (completion_done(this_cpu_ptr(&softlockup_completion))) {
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

