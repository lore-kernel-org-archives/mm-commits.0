Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E198C7EE25
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjFJAf2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjFJAf1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:35:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A7430D2
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:35:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9053964BD5
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3CB7C433EF;
        Sat, 10 Jun 2023 00:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357326;
        bh=ZZxI09UvrZA6pmrvHW+fmez3UXxnQdHWwtaAV5KQopI=;
        h=Date:To:From:Subject:From;
        b=S6l5h1kG8NVsEbXYdxXV95WaT0tLseBB9R5zr8JFkw5bTyrTSEFtvMbJGfhv9xbSF
         TQjwPiKEUOSwB1rEIuCFB8X4ZPI4K71HZVn/nPbH1cZNUdwHtKFpuZR5tDcYu/arUY
         e67Mn11DxIjdG0zx/ANfXXUfR6SofQQVaEaUqnbg=
Date:   Fri, 09 Jun 2023 17:35:25 -0700
To:     mm-commits@vger.kernel.org, arnd@arndb.de, dianders@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] arm64-enable-perf-events-based-hard-lockup-detector-fix.patch removed from -mm tree
Message-Id: <20230610003525.E3CB7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64: only HAVE_HARDLOCKUP_DETECTOR_PERF if the PMU config is enabled
has been removed from the -mm tree.  Its filename was
     arm64-enable-perf-events-based-hard-lockup-detector-fix.patch

This patch was dropped because it was folded into arm64-enable-perf-events-based-hard-lockup-detector.patch

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: arm64: only HAVE_HARDLOCKUP_DETECTOR_PERF if the PMU config is enabled
Date: Tue, 23 May 2023 07:39:53 -0700

If you try to enable the arm64 perf-based hardlockup detector but you
don't enable CONFIG_ARM_PMU then you'll get an error:

arch/arm64/kernel/watchdog_hld.c: In function 'arch_perf_nmi_is_available':
arch/arm64/kernel/watchdog_hld.c:35:16: error: implicit declaration of function 'arm_pmu_irq_is_nmi' [-Werror=implicit-function-declaration]
   35 |         return arm_pmu_irq_is_nmi();

It doesn't make sense to enable HAVE_HARDLOCKUP_DETECTOR_PERF if the
PMU isn't enabled. Let's add a dependency. HW_PERF_EVENTS is a synonum
for ARM_PMU and makes the most logical sense here, so add the
dependency on that.

Link: https://lkml.kernel.org/r/20230523073952.1.I60217a63acc35621e13f10be16c0cd7c363caf8c@changeid
Fixes: 02ea35ee19d9 ("arm64: enable perf events based hard lockup detector")
Closes: https://lore.kernel.org/r/20230522114922.1052421-1-arnd@kernel.org
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/Kconfig~arm64-enable-perf-events-based-hard-lockup-detector-fix
+++ a/arch/arm64/Kconfig
@@ -203,7 +203,8 @@ config ARM64
 	select HAVE_FUNCTION_ERROR_INJECTION
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_GCC_PLUGINS
-	select HAVE_HARDLOCKUP_DETECTOR_PERF if PERF_EVENTS && HAVE_PERF_EVENTS_NMI
+	select HAVE_HARDLOCKUP_DETECTOR_PERF if PERF_EVENTS && \
+		HW_PERF_EVENTS && HAVE_PERF_EVENTS_NMI
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_IOREMAP_PROT
 	select HAVE_IRQ_TIME_ACCOUNTING
_

Patches currently in -mm which might be from dianders@chromium.org are

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

