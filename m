Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9350C7EE26
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 21:29:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbjESV3g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 17:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbjESV3e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 17:29:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB61AE43
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 14:29:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4133965B4D
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 21:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BA5C433EF;
        Fri, 19 May 2023 21:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684531765;
        bh=92ZUtxV7ikkQCdgY43QLnHulMz77CV4DAynUSGjIC/4=;
        h=Date:To:From:Subject:From;
        b=aPJFK09zT6D9TnkqWFLWVekaExyM4E38oFUzYrKi9leXfeO4TPSMFNcCkI1kVAItx
         JcCE9/nuL/CgeCyXdF6FMPDWvo3t/uD7Qu+tx001NN7avzP4baWQSDcMGJheqfBCIn
         7ovVtHV1iy+ewPGBbCf0Ljp4Z2xKAMbz1dOstLjc=
Date:   Fri, 19 May 2023 14:29:25 -0700
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
Subject: + watchdog-perf-add-a-weak-function-for-an-arch-to-detect-if-perf-can-use-nmis.patch added to mm-nonmm-unstable branch
Message-Id: <20230519212925.92BA5C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog/perf: add a weak function for an arch to detect if perf can use NMIs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-perf-add-a-weak-function-for-an-arch-to-detect-if-perf-can-use-nmis.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-perf-add-a-weak-function-for-an-arch-to-detect-if-perf-can-use-nmis.patch

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
Subject: watchdog/perf: add a weak function for an arch to detect if perf can use NMIs
Date: Fri, 19 May 2023 10:18:39 -0700

On arm64, NMI support needs to be detected at runtime.  Add a weak
function to the perf hardlockup detector so that an architecture can
implement it to detect whether NMIs are available.

Link: https://lkml.kernel.org/r/20230519101840.v5.15.Ic55cb6f90ef5967d8aaa2b503a4e67c753f64d3a@changeid
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

 include/linux/nmi.h    |    1 +
 kernel/watchdog_perf.c |   12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

--- a/include/linux/nmi.h~watchdog-perf-add-a-weak-function-for-an-arch-to-detect-if-perf-can-use-nmis
+++ a/include/linux/nmi.h
@@ -210,6 +210,7 @@ static inline bool trigger_single_cpu_ba
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR_PERF
 u64 hw_nmi_get_sample_period(int watchdog_thresh);
+bool arch_perf_nmi_is_available(void);
 #endif
 
 #if defined(CONFIG_HARDLOCKUP_CHECK_TIMESTAMP) && \
--- a/kernel/watchdog_perf.c~watchdog-perf-add-a-weak-function-for-an-arch-to-detect-if-perf-can-use-nmis
+++ a/kernel/watchdog_perf.c
@@ -234,12 +234,22 @@ void __init hardlockup_detector_perf_res
 	}
 }
 
+bool __weak __init arch_perf_nmi_is_available(void)
+{
+	return true;
+}
+
 /**
  * watchdog_hardlockup_probe - Probe whether NMI event is available at all
  */
 int __init watchdog_hardlockup_probe(void)
 {
-	int ret = hardlockup_detector_event_create();
+	int ret;
+
+	if (!arch_perf_nmi_is_available())
+		return -ENODEV;
+
+	ret = hardlockup_detector_event_create();
 
 	if (ret) {
 		pr_info("Perf NMI watchdog permanently disabled\n");
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

