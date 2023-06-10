Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB8C4C87FDD
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbjFJApp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbjFJAph (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540723AAD
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AC6F651DE
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F1AC433EF;
        Sat, 10 Jun 2023 00:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357930;
        bh=iLAtWVO4qawtEyA+uK7tQUg3VsCu+jhyTB2eptEQSv8=;
        h=Date:To:From:Subject:From;
        b=sEtPh7ilBJ+UvCsPk+R9ZZU3ijEyL/wfVobjL2Gqm+ckk+bK+Y4Qn6uR0ubEcreWc
         1Er6YD2f64guVwci4frP39ba5HW7CXLTjGRcWNMaERr07k4iGcOt52RfrYvKe1tvu5
         EZTuAtfHV8Up6cIhriXSr5KU55/+CtYAMZvaA9Lw=
Date:   Fri, 09 Jun 2023 17:45:30 -0700
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
Subject: [merged mm-nonmm-stable] watchdog-perf-define-dummy-watchdog_update_hrtimer_threshold-on-correct-config.patch removed from -mm tree
Message-Id: <20230610004530.99F1AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog/perf: define dummy watchdog_update_hrtimer_threshold() on correct config
has been removed from the -mm tree.  Its filename was
     watchdog-perf-define-dummy-watchdog_update_hrtimer_threshold-on-correct-config.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

