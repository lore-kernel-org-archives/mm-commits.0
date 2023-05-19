Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7F51C77B7A
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 21:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjESV2x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 17:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjESV2w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 17:28:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E424BBC
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 14:28:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78D8C65788
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 21:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59A7C433D2;
        Fri, 19 May 2023 21:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684531729;
        bh=fjXadtKBjlX3ydLkNi6Yez+l3CsS5rcFwMGehWRSrVU=;
        h=Date:To:From:Subject:From;
        b=MomXnA0K0pV8P4t7LrS51gT50FxVV9JihylJZq2ISamO9WrPdlsnCDJ/XGlluyYtC
         DHrvANagQ5zrL627ACc2/fkMXq5nHIuvaCku0wFa0TJTdT13+BAx1br7Zc0qLn2QC5
         XffQbep4l6uworbBWpU+S0dLa8ZOxcEs84xlcTeU=
Date:   Fri, 19 May 2023 14:28:49 -0700
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
Subject: + watchdog-perf-define-dummy-watchdog_update_hrtimer_threshold-on-correct-config.patch added to mm-nonmm-unstable branch
Message-Id: <20230519212849.C59A7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog/perf: define dummy watchdog_update_hrtimer_threshold() on correct config
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-perf-define-dummy-watchdog_update_hrtimer_threshold-on-correct-config.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-perf-define-dummy-watchdog_update_hrtimer_threshold-on-correct-config.patch

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
Subject: watchdog/perf: define dummy watchdog_update_hrtimer_threshold() on correct config
Date: Fri, 19 May 2023 10:18:25 -0700

Patch series "watchdog/hardlockup: Add the buddy hardlockup detector", v5.

This patch series adds the "buddy" hardlockup detector.  In brief, the
buddy hardlockup detector can detect hardlockups without arch-level
support by having CPUs checkup on a "buddy" CPU periodically.

Given the new design of this patch series, testing all combinations is
fairly difficult. I've attempted to make sure that all combinations of
CONFIG_ options are good, but it wouldn't surprise me if I missed
something. I apologize in advance and I'll do my best to fix any
problems that are found.


This patch (of 18):

The real watchdog_update_hrtimer_threshold() is defined in
kernel/watchdog_hld.c.  That file is included if
CONFIG_HARDLOCKUP_DETECTOR_PERF and the function is defined in that file
if CONFIG_HARDLOCKUP_CHECK_TIMESTAMP.

The dummy version of the function in "nmi.h" didn't get that quite right. 
While this doesn't appear to be a huge deal, it's nice to make it
consistent.

It doesn't break builds because CHECK_TIMESTAMP is only defined by x86 so
others don't get a double definition, and x86 uses perf lockup detector,
so it gets the out of line version.

Link: https://lkml.kernel.org/r/20230519101840.v5.18.Ia44852044cdcb074f387e80df6b45e892965d4a1@changeid
Link: https://lkml.kernel.org/r/20230519101840.v5.1.I8cbb2f4fa740528fcfade4f5439b6cdcdd059251@changeid
Fixes: 7edaeb6841df ("kernel/watchdog: Prevent false positives with turbo modes")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen-Yu Tsai <wens@csie.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
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
Cc: Pingfan Liu <kernelfans@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: "Ravi V. Shankar" <ravi.v.shankar@intel.com>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: Sumit Garg <sumit.garg@linaro.org>
Cc: Tzung-Bi Shih <tzungbi@chromium.org>
Cc: Will Deacon <will@kernel.org>
Cc: Colin Cross <ccross@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/nmi.h~watchdog-perf-define-dummy-watchdog_update_hrtimer_threshold-on-correct-config
+++ a/include/linux/nmi.h
@@ -197,7 +197,7 @@ u64 hw_nmi_get_sample_period(int watchdo
 #endif
 
 #if defined(CONFIG_HARDLOCKUP_CHECK_TIMESTAMP) && \
-    defined(CONFIG_HARDLOCKUP_DETECTOR)
+    defined(CONFIG_HARDLOCKUP_DETECTOR_PERF)
 void watchdog_update_hrtimer_threshold(u64 period);
 #else
 static inline void watchdog_update_hrtimer_threshold(u64 period) { }
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

