Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 176AAC77B7A
	for <mm-commits@archiver.kernel.org>; Tue, 30 May 2023 22:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbjE3W0U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 May 2023 18:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjE3W0R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2023 18:26:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631A093
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 15:26:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAE9462CB1
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 22:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504F2C433D2;
        Tue, 30 May 2023 22:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685485575;
        bh=jIwdc1u8mef7le5rE27zvy6Ixp79EKrUibDAuTvO9Fg=;
        h=Date:To:From:Subject:From;
        b=qTLS7nRB6RTW54ctPYuPZd4l8w9MsZwZEUi35RVFWip4xBqgrTURRnuRPXHZzuxwG
         +b25wZTfq702g5TZ1WGX7C/nm2twyvbm3Ulo69un639y4ZLxKXmL+UEw16rHw2Q1lW
         BT7KhiwGXBsMjaEMRHfEoJ+5dXTMQ06egaMxmCc0=
Date:   Tue, 30 May 2023 15:26:14 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com, npiggin@gmail.com,
        mpe@ellerman.id.au, davem@davemloft.net,
        christophe.leroy@csgroup.eu, dianders@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-hardlockup-dont-use-raw_cpu_ptr-in-watchdog_hardlockup_kick.patch added to mm-nonmm-unstable branch
Message-Id: <20230530222615.504F2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog/hardlockup: don't use raw_cpu_ptr() in watchdog_hardlockup_kick()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-hardlockup-dont-use-raw_cpu_ptr-in-watchdog_hardlockup_kick.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-hardlockup-dont-use-raw_cpu_ptr-in-watchdog_hardlockup_kick.patch

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
Subject: watchdog/hardlockup: don't use raw_cpu_ptr() in watchdog_hardlockup_kick()
Date: Fri, 26 May 2023 18:41:33 -0700

In the patch ("watchdog/hardlockup: add a "cpu" param to
watchdog_hardlockup_check()") there was no reason to use raw_cpu_ptr(). 
Using this_cpu_ptr() works fine.

Link: https://lkml.kernel.org/r/20230526184139.3.I660e103077dcc23bb29aaf2be09cb234e0495b2d@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Suggested-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/watchdog.c~watchdog-hardlockup-dont-use-raw_cpu_ptr-in-watchdog_hardlockup_kick
+++ a/kernel/watchdog.c
@@ -133,7 +133,7 @@ static bool is_hardlockup(unsigned int c
 
 static unsigned long watchdog_hardlockup_kick(void)
 {
-	return atomic_inc_return(raw_cpu_ptr(&hrtimer_interrupts));
+	return atomic_inc_return(this_cpu_ptr(&hrtimer_interrupts));
 }
 
 void watchdog_hardlockup_check(unsigned int cpu, struct pt_regs *regs)
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

