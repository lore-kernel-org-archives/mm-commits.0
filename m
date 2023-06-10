Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B4D5C7EE25
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbjFJAqf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbjFJApw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D8F3A9B
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6959651CF
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CB8C433D2;
        Sat, 10 Jun 2023 00:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357950;
        bh=H2/lOy6r+DNvizA/VnYoASZ7DWyoONTfwtoih/TXyUs=;
        h=Date:To:From:Subject:From;
        b=mK7oktfso9DnCyQulDXqh4TOqbCW2+AJmhuDfKgCX6odnrBCRc11aWUjJRN2qW6qV
         IkWpgrw3PXAqK6A2grMbDn8mDLH57RmxilAsAzR6dNRB/aBWIr58zWs2U2ZhtqYOt6
         DhyXg8aj0WQVEFxUPxHb555L7b2WPlEO1anbqf/E=
Date:   Fri, 09 Jun 2023 17:45:49 -0700
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
Subject: [merged mm-nonmm-stable] watchdog-perf-add-a-weak-function-for-an-arch-to-detect-if-perf-can-use-nmis.patch removed from -mm tree
Message-Id: <20230610004550.21CB8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog/perf: add a weak function for an arch to detect if perf can use NMIs
has been removed from the -mm tree.  Its filename was
     watchdog-perf-add-a-weak-function-for-an-arch-to-detect-if-perf-can-use-nmis.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -208,6 +208,7 @@ static inline bool trigger_single_cpu_ba
 
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

arm64-enable-perf-events-based-hard-lockup-detector.patch

