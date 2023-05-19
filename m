Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C21C77B7A
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 21:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjESVaB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 17:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbjESV3f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 17:29:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9768FE56
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 14:29:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D13C60CA4
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 21:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE16C433D2;
        Fri, 19 May 2023 21:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684531770;
        bh=f3uxfKhN/q3WY5zzEnhQgaRXuqu/lk4YEH0wfF3JvDM=;
        h=Date:To:From:Subject:From;
        b=aBwmkV/0xQDAxEKHHTQJHUfutJ1ZXTwt4YTkox/QtUUE4N2w8fuYS0cqypBP6dCbM
         sNBnY1bwPG83M2Wm57ELr1b/FPdUEebOUUZ/b3LCNq8e7A8nee7Z6VjbMk/IiQpLtC
         LIIo+6X7NHd8BgwCIv3zC+X/4lG/Ds2Nc0vfjeWI=
Date:   Fri, 19 May 2023 14:29:30 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, wens@csie.org,
        tzungbi@chromium.org, swboyd@chromium.org, sumit.garg@linaro.org,
        ricardo.neri@intel.com, rdunlap@infradead.org,
        ravi.v.shankar@intel.com, pmladek@suse.com, npiggin@gmail.com,
        msys.mizuma@gmail.com, mpe@ellerman.id.au, mka@chromium.org,
        maz@kernel.org, mark.rutland@arm.com, kernelfans@gmail.com,
        irogers@google.com, groeck@chromium.org, eranian@google.com,
        dianders@chromium.org, davem@davemloft.net,
        daniel.thompson@linaro.org, christophe.leroy@csgroup.eu,
        ccross@android.com, catalin.marinas@arm.com, ak@linux.intel.com,
        lecopzer.chen@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-add-hw_nmi_get_sample_period-for-preparation-of-lockup-detector.patch added to mm-nonmm-unstable branch
Message-Id: <20230519212930.7EE16C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: add hw_nmi_get_sample_period for preparation of lockup detector
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arm64-add-hw_nmi_get_sample_period-for-preparation-of-lockup-detector.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-add-hw_nmi_get_sample_period-for-preparation-of-lockup-detector.patch

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
From: Lecopzer Chen <lecopzer.chen@mediatek.com>
Subject: arm64: add hw_nmi_get_sample_period for preparation of lockup detector
Date: Fri, 19 May 2023 10:18:41 -0700

Set safe maximum CPU frequency to 5 GHz in case a particular platform
doesn't implement cpufreq driver.  Although, architecture doesn't put any
restrictions on maximum frequency but 5 GHz seems to be safe maximum given
the available Arm CPUs in the market which are clocked much less than 5
GHz.

On the other hand, we can't make it much higher as it would lead to a
large hard-lockup detection timeout on parts which are running slower (eg.
1GHz on Developerbox) and doesn't possess a cpufreq driver.

Link: https://lkml.kernel.org/r/20230519101840.v5.17.Ia9d02578e89c3f44d3cb12eec8b0176603c8ab2f@changeid
Co-developed-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Co-developed-by: Pingfan Liu <kernelfans@gmail.com>
Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
Signed-off-by: Lecopzer Chen <lecopzer.chen@mediatek.com>
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
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: "Ravi V. Shankar" <ravi.v.shankar@intel.com>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@chromium.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/Makefile       |    1 +
 arch/arm64/kernel/watchdog_hld.c |   24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+)

--- a/arch/arm64/kernel/Makefile~arm64-add-hw_nmi_get_sample_period-for-preparation-of-lockup-detector
+++ a/arch/arm64/kernel/Makefile
@@ -45,6 +45,7 @@ obj-$(CONFIG_FUNCTION_TRACER)		+= ftrace
 obj-$(CONFIG_MODULES)			+= module.o
 obj-$(CONFIG_ARM64_MODULE_PLTS)		+= module-plts.o
 obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o perf_callchain.o
+obj-$(CONFIG_HARDLOCKUP_DETECTOR_PERF)	+= watchdog_hld.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT)	+= hw_breakpoint.o
 obj-$(CONFIG_CPU_PM)			+= sleep.o suspend.o
 obj-$(CONFIG_CPU_IDLE)			+= cpuidle.o
--- /dev/null
+++ a/arch/arm64/kernel/watchdog_hld.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/cpufreq.h>
+
+/*
+ * Safe maximum CPU frequency in case a particular platform doesn't implement
+ * cpufreq driver. Although, architecture doesn't put any restrictions on
+ * maximum frequency but 5 GHz seems to be safe maximum given the available
+ * Arm CPUs in the market which are clocked much less than 5 GHz. On the other
+ * hand, we can't make it much higher as it would lead to a large hard-lockup
+ * detection timeout on parts which are running slower (eg. 1GHz on
+ * Developerbox) and doesn't possess a cpufreq driver.
+ */
+#define SAFE_MAX_CPU_FREQ	5000000000UL // 5 GHz
+u64 hw_nmi_get_sample_period(int watchdog_thresh)
+{
+	unsigned int cpu = smp_processor_id();
+	unsigned long max_cpu_freq;
+
+	max_cpu_freq = cpufreq_get_hw_max_freq(cpu) * 1000UL;
+	if (!max_cpu_freq)
+		max_cpu_freq = SAFE_MAX_CPU_FREQ;
+
+	return (u64)max_cpu_freq * watchdog_thresh;
+}
_

Patches currently in -mm which might be from lecopzer.chen@mediatek.com are

watchdog-remove-watchdog_default.patch
watchdog-hardlockup-change-watchdog_nmi_enable-to-void.patch
watchdog-perf-adapt-the-watchdog_perf-interface-for-async-model.patch
arm64-add-hw_nmi_get_sample_period-for-preparation-of-lockup-detector.patch

