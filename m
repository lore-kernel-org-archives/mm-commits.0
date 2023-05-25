Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7811BC7EE29
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 21:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240830AbjEYVpA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 17:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242070AbjEYVo6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 17:44:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3281B0
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 14:44:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6626064B50
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 21:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF8AC433D2;
        Thu, 25 May 2023 21:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685051064;
        bh=D//jm7gO9s/WuqgybLTel2wEEe4TqWcPn127uV9i2kk=;
        h=Date:To:From:Subject:From;
        b=d15YFhSlKFFUj/dIpYpnzK5Wj5vp7eL5zoFNANyqGOg8QxDEQviIlPb6UtEsE51/d
         xF0vPzlivFPAIs7QjXneMv7P+AQdDKuFWS+rtk601nSLDaZjFbdAddd7gTmmmePCxw
         LP84b8Lj+PWaARIqRJO9qQe/N8dM/kbEp9LOp3e8=
Date:   Thu, 25 May 2023 14:44:24 -0700
To:     mm-commits@vger.kernel.org, arnd@arndb.de, dianders@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-enable-perf-events-based-hard-lockup-detector-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230525214424.BDF8AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: only HAVE_HARDLOCKUP_DETECTOR_PERF if the PMU config is enabled
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arm64-enable-perf-events-based-hard-lockup-detector-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-enable-perf-events-based-hard-lockup-detector-fix.patch

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

