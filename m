Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ECAAC7EE25
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbjFJAqu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232563AbjFJAp4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628AF3AAD
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3FC6651CF
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51189C433D2;
        Sat, 10 Jun 2023 00:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357954;
        bh=ZZtHnaE9JVvEDcIwCkwWExTvEw7q+kCeMCcPfmdBaIs=;
        h=Date:To:From:Subject:From;
        b=NXtbFByR0utXT9COy2badkkfW4kFRCWYXEMzU0b1eEtXpp9lMFv/Rlmorx78hjfcn
         LOjB+Zap/739vrRdywQfm1i39W67p0diVQSo/0Nkqn1EHpr5iShcgAE+WHSl4rRBaI
         ILfeBOEcLs/c1+9S0yxj4jr3ZfwtCbMg/7JxxJx0=
Date:   Fri, 09 Jun 2023 17:45:53 -0700
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
Subject: [merged mm-nonmm-stable] arm64-enable-perf-events-based-hard-lockup-detector.patch removed from -mm tree
Message-Id: <20230610004554.51189C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64: enable perf events based hard lockup detector
has been removed from the -mm tree.  Its filename was
     arm64-enable-perf-events-based-hard-lockup-detector.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: arm64: enable perf events based hard lockup detector
Date: Fri, 19 May 2023 10:18:42 -0700

With the recent feature added to enable perf events to use pseudo NMIs as
interrupts on platforms which support GICv3 or later, its now been
possible to enable hard lockup detector (or NMI watchdog) on arm64
platforms.  So enable corresponding support.

One thing to note here is that normally lockup detector is initialized
just after the early initcalls but PMU on arm64 comes up much later as
device_initcall().  To cope with that, override
arch_perf_nmi_is_available() to let the watchdog framework know PMU not
ready, and inform the framework to re-initialize lockup detection once PMU
has been initialized.

[dianders@chromium.org: only HAVE_HARDLOCKUP_DETECTOR_PERF if the PMU config is enabled]
  Link: https://lkml.kernel.org/r/20230523073952.1.I60217a63acc35621e13f10be16c0cd7c363caf8c@changeid
Link: https://lkml.kernel.org/r/20230519101840.v5.18.Ia44852044cdcb074f387e80df6b45e892965d4a1@changeid
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

 arch/arm64/Kconfig               |    3 +++
 arch/arm64/kernel/watchdog_hld.c |   12 ++++++++++++
 drivers/perf/arm_pmu.c           |    5 +++++
 drivers/perf/arm_pmuv3.c         |   12 ++++++++++--
 include/linux/perf/arm_pmu.h     |    2 ++
 5 files changed, 32 insertions(+), 2 deletions(-)

--- a/arch/arm64/Kconfig~arm64-enable-perf-events-based-hard-lockup-detector
+++ a/arch/arm64/Kconfig
@@ -203,12 +203,15 @@ config ARM64
 	select HAVE_FUNCTION_ERROR_INJECTION
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_GCC_PLUGINS
+	select HAVE_HARDLOCKUP_DETECTOR_PERF if PERF_EVENTS && \
+		HW_PERF_EVENTS && HAVE_PERF_EVENTS_NMI
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_IOREMAP_PROT
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select HAVE_KVM
 	select HAVE_NMI
 	select HAVE_PERF_EVENTS
+	select HAVE_PERF_EVENTS_NMI if ARM64_PSEUDO_NMI
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_PREEMPT_DYNAMIC_KEY
--- a/arch/arm64/kernel/watchdog_hld.c~arm64-enable-perf-events-based-hard-lockup-detector
+++ a/arch/arm64/kernel/watchdog_hld.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/nmi.h>
 #include <linux/cpufreq.h>
+#include <linux/perf/arm_pmu.h>
 
 /*
  * Safe maximum CPU frequency in case a particular platform doesn't implement
@@ -22,3 +24,13 @@ u64 hw_nmi_get_sample_period(int watchdo
 
 	return (u64)max_cpu_freq * watchdog_thresh;
 }
+
+bool __init arch_perf_nmi_is_available(void)
+{
+	/*
+	 * hardlockup_detector_perf_init() will success even if Pseudo-NMI turns off,
+	 * however, the pmu interrupts will act like a normal interrupt instead of
+	 * NMI and the hardlockup detector would be broken.
+	 */
+	return arm_pmu_irq_is_nmi();
+}
--- a/drivers/perf/arm_pmu.c~arm64-enable-perf-events-based-hard-lockup-detector
+++ a/drivers/perf/arm_pmu.c
@@ -687,6 +687,11 @@ static int armpmu_get_cpu_irq(struct arm
 	return per_cpu(hw_events->irq, cpu);
 }
 
+bool arm_pmu_irq_is_nmi(void)
+{
+	return has_nmi;
+}
+
 /*
  * PMU hardware loses all context when a CPU goes offline.
  * When a CPU is hotplugged back in, since some hardware registers are
--- a/drivers/perf/arm_pmuv3.c~arm64-enable-perf-events-based-hard-lockup-detector
+++ a/drivers/perf/arm_pmuv3.c
@@ -22,6 +22,7 @@
 #include <linux/platform_device.h>
 #include <linux/sched_clock.h>
 #include <linux/smp.h>
+#include <linux/nmi.h>
 
 #include <asm/arm_pmuv3.h>
 
@@ -1348,10 +1349,17 @@ static struct platform_driver armv8_pmu_
 
 static int __init armv8_pmu_driver_init(void)
 {
+	int ret;
+
 	if (acpi_disabled)
-		return platform_driver_register(&armv8_pmu_driver);
+		ret = platform_driver_register(&armv8_pmu_driver);
 	else
-		return arm_pmu_acpi_probe(armv8_pmuv3_pmu_init);
+		ret = arm_pmu_acpi_probe(armv8_pmuv3_pmu_init);
+
+	if (!ret)
+		lockup_detector_retry_init();
+
+	return ret;
 }
 device_initcall(armv8_pmu_driver_init)
 
--- a/include/linux/perf/arm_pmu.h~arm64-enable-perf-events-based-hard-lockup-detector
+++ a/include/linux/perf/arm_pmu.h
@@ -171,6 +171,8 @@ void kvm_host_pmu_init(struct arm_pmu *p
 #define kvm_host_pmu_init(x)	do { } while(0)
 #endif
 
+bool arm_pmu_irq_is_nmi(void);
+
 /* Internal functions only for core arm_pmu code */
 struct arm_pmu *armpmu_alloc(void);
 void armpmu_free(struct arm_pmu *pmu);
_

Patches currently in -mm which might be from dianders@chromium.org are


