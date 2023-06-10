Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 791B3C7EE45
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbjFJAqA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbjFJApt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3393AA5
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEE27651D5
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4A9C433EF;
        Sat, 10 Jun 2023 00:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357947;
        bh=6L3SEAU9i5/r+yt7qTsa2ixHvvQmyIFOoxfuG6O81sI=;
        h=Date:To:From:Subject:From;
        b=aLEIF4VD5dLxg5JuiKwF2olaCZoRp3mH/9A3ca9XAVGiibgf8xGb5M7IqzEdrWIso
         EK6qwBMxTgSC1Tt1NNXewFMlntI/GI922OR8n4TzxQIEelo3cmXjdhC/KK46nB4DDf
         MQBLnpzVZFLiRexvlF4U65HOGqEGfNfvv66dlaBM=
Date:   Fri, 09 Jun 2023 17:45:46 -0700
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
Subject: [merged mm-nonmm-stable] watchdog-hardlockup-have-the-perf-hardlockup-use-__weak-functions-more-cleanly.patch removed from -mm tree
Message-Id: <20230610004547.3C4A9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog/hardlockup: have the perf hardlockup use __weak functions more cleanly
has been removed from the -mm tree.  Its filename was
     watchdog-hardlockup-have-the-perf-hardlockup-use-__weak-functions-more-cleanly.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: watchdog/hardlockup: have the perf hardlockup use __weak functions more cleanly
Date: Fri, 19 May 2023 10:18:37 -0700

The fact that there watchdog_hardlockup_enable(),
watchdog_hardlockup_disable(), and watchdog_hardlockup_probe() are
declared __weak means that the configured hardlockup detector can define
non-weak versions of those functions if it needs to.  Instead of doing
this, the perf hardlockup detector hooked itself into the default __weak
implementation, which was a bit awkward.  Clean this up.

From comments, it looks as if the original design was done because the
__weak function were expected to implemented by the architecture and not
by the configured hardlockup detector.  This got awkward when we tried to
add the buddy lockup detector which was not arch-specific but wanted to
hook into those same functions.

This is not expected to have any functional impact.

Link: https://lkml.kernel.org/r/20230519101840.v5.13.I847d9ec852449350997ba00401d2462a9cb4302b@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
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

 include/linux/nmi.h    |   10 ----------
 kernel/watchdog.c      |   30 ++++++++++++++++++------------
 kernel/watchdog_perf.c |   20 ++++++++++++++------
 3 files changed, 32 insertions(+), 28 deletions(-)

--- a/include/linux/nmi.h~watchdog-hardlockup-have-the-perf-hardlockup-use-__weak-functions-more-cleanly
+++ a/include/linux/nmi.h
@@ -101,21 +101,11 @@ static inline void arch_touch_nmi_watchd
 #if defined(CONFIG_HARDLOCKUP_DETECTOR_PERF)
 extern void hardlockup_detector_perf_stop(void);
 extern void hardlockup_detector_perf_restart(void);
-extern void hardlockup_detector_perf_disable(void);
-extern void hardlockup_detector_perf_enable(void);
 extern void hardlockup_detector_perf_cleanup(void);
-extern int hardlockup_detector_perf_init(void);
 #else
 static inline void hardlockup_detector_perf_stop(void) { }
 static inline void hardlockup_detector_perf_restart(void) { }
-static inline void hardlockup_detector_perf_disable(void) { }
-static inline void hardlockup_detector_perf_enable(void) { }
 static inline void hardlockup_detector_perf_cleanup(void) { }
-# if !defined(CONFIG_HAVE_NMI_WATCHDOG)
-static inline int hardlockup_detector_perf_init(void) { return -ENODEV; }
-# else
-static inline int hardlockup_detector_perf_init(void) { return 0; }
-# endif
 #endif
 
 void watchdog_hardlockup_stop(void);
--- a/kernel/watchdog.c~watchdog-hardlockup-have-the-perf-hardlockup-use-__weak-functions-more-cleanly
+++ a/kernel/watchdog.c
@@ -187,27 +187,33 @@ static inline void watchdog_hardlockup_k
 #endif /* !CONFIG_HARDLOCKUP_DETECTOR_PERF */
 
 /*
- * These functions can be overridden if an architecture implements its
- * own hardlockup detector.
+ * These functions can be overridden based on the configured hardlockdup detector.
  *
  * watchdog_hardlockup_enable/disable can be implemented to start and stop when
- * softlockup watchdog start and stop. The arch must select the
+ * softlockup watchdog start and stop. The detector must select the
  * SOFTLOCKUP_DETECTOR Kconfig.
  */
-void __weak watchdog_hardlockup_enable(unsigned int cpu)
-{
-	hardlockup_detector_perf_enable();
-}
+void __weak watchdog_hardlockup_enable(unsigned int cpu) { }
 
-void __weak watchdog_hardlockup_disable(unsigned int cpu)
-{
-	hardlockup_detector_perf_disable();
-}
+void __weak watchdog_hardlockup_disable(unsigned int cpu) { }
 
 /* Return 0, if a hardlockup watchdog is available. Error code otherwise */
 int __weak __init watchdog_hardlockup_probe(void)
 {
-	return hardlockup_detector_perf_init();
+	/*
+	 * If CONFIG_HAVE_NMI_WATCHDOG is defined then an architecture
+	 * is assumed to have the hard watchdog available and we return 0.
+	 */
+	if (IS_ENABLED(CONFIG_HAVE_NMI_WATCHDOG))
+		return 0;
+
+	/*
+	 * Hardlockup detectors other than those using CONFIG_HAVE_NMI_WATCHDOG
+	 * are required to implement a non-weak version of this probe function
+	 * to tell whether they are available. If they don't override then
+	 * we'll return -ENODEV.
+	 */
+	return -ENODEV;
 }
 
 /**
--- a/kernel/watchdog_perf.c~watchdog-hardlockup-have-the-perf-hardlockup-use-__weak-functions-more-cleanly
+++ a/kernel/watchdog_perf.c
@@ -132,10 +132,14 @@ static int hardlockup_detector_event_cre
 }
 
 /**
- * hardlockup_detector_perf_enable - Enable the local event
+ * watchdog_hardlockup_enable - Enable the local event
+ *
+ * @cpu: The CPU to enable hard lockup on.
  */
-void hardlockup_detector_perf_enable(void)
+void watchdog_hardlockup_enable(unsigned int cpu)
 {
+	WARN_ON_ONCE(cpu != smp_processor_id());
+
 	if (hardlockup_detector_event_create())
 		return;
 
@@ -147,12 +151,16 @@ void hardlockup_detector_perf_enable(voi
 }
 
 /**
- * hardlockup_detector_perf_disable - Disable the local event
+ * watchdog_hardlockup_disable - Disable the local event
+ *
+ * @cpu: The CPU to enable hard lockup on.
  */
-void hardlockup_detector_perf_disable(void)
+void watchdog_hardlockup_disable(unsigned int cpu)
 {
 	struct perf_event *event = this_cpu_read(watchdog_ev);
 
+	WARN_ON_ONCE(cpu != smp_processor_id());
+
 	if (event) {
 		perf_event_disable(event);
 		this_cpu_write(watchdog_ev, NULL);
@@ -227,9 +235,9 @@ void __init hardlockup_detector_perf_res
 }
 
 /**
- * hardlockup_detector_perf_init - Probe whether NMI event is available at all
+ * watchdog_hardlockup_probe - Probe whether NMI event is available at all
  */
-int __init hardlockup_detector_perf_init(void)
+int __init watchdog_hardlockup_probe(void)
 {
 	int ret = hardlockup_detector_event_create();
 
_

Patches currently in -mm which might be from dianders@chromium.org are

watchdog-hardlockup-detect-hard-lockups-using-secondary-buddy-cpus.patch
watchdog-perf-add-a-weak-function-for-an-arch-to-detect-if-perf-can-use-nmis.patch
arm64-enable-perf-events-based-hard-lockup-detector.patch

