Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C707C7EE24
	for <mm-commits@archiver.kernel.org>; Tue, 30 May 2023 22:26:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjE3W0U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 May 2023 18:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbjE3W0T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2023 18:26:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EEF897
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 15:26:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADAC963446
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 22:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E919C433EF;
        Tue, 30 May 2023 22:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685485577;
        bh=qxsTsv1ODeJdYDArBTH5iewB4QXq+VAHR5wceuY7bMI=;
        h=Date:To:From:Subject:From;
        b=D5UINUB3gq5FNR6wGzd1pybG1TdXBTejTtIUuO90T1sPrbJnr2dGoXdH70S7jlhBw
         6Fk3327qJedvOiXIe/R5w/ytGtAgvFVY1goUs2lWNUjYtXt85RFEA7dMI0w4ThF9jB
         w+LYbGtV76OuqJ0Cdb0d7meKFiYtWdgCHblKlKV0=
Date:   Tue, 30 May 2023 15:26:16 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com, npiggin@gmail.com,
        mpe@ellerman.id.au, davem@davemloft.net,
        christophe.leroy@csgroup.eu, dianders@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-hardlockup-in-watchdog_hardlockup_check-use-cpumask_copy.patch added to mm-nonmm-unstable branch
Message-Id: <20230530222617.0E919C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog/hardlockup: in watchdog_hardlockup_check() use cpumask_copy()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-hardlockup-in-watchdog_hardlockup_check-use-cpumask_copy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-hardlockup-in-watchdog_hardlockup_check-use-cpumask_copy.patch

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
Subject: watchdog/hardlockup: in watchdog_hardlockup_check() use cpumask_copy()
Date: Fri, 26 May 2023 18:41:34 -0700

In the patch ("watchdog/hardlockup: add a "cpu" param to
watchdog_hardlockup_check()") we started using a cpumask to keep track of
which CPUs to backtrace.  When setting up this cpumask, it's better to use
cpumask_copy() than to just copy the structure directly.  Fix this.

Link: https://lkml.kernel.org/r/20230526184139.4.Iccee2d1ea19114dafb6553a854ea4d8ab2a3f25b@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Suggested-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/watchdog.c~watchdog-hardlockup-in-watchdog_hardlockup_check-use-cpumask_copy
+++ a/kernel/watchdog.c
@@ -154,7 +154,9 @@ void watchdog_hardlockup_check(unsigned
 	 */
 	if (is_hardlockup(cpu)) {
 		unsigned int this_cpu = smp_processor_id();
-		struct cpumask backtrace_mask = *cpu_online_mask;
+		struct cpumask backtrace_mask;
+
+		cpumask_copy(&backtrace_mask, cpu_online_mask);
 
 		/* Only print hardlockups once. */
 		if (per_cpu(watchdog_hardlockup_warned, cpu))
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

