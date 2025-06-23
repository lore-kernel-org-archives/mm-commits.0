Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B14E221268
	for <mm-commits@vger.kernel.org>; Mon, 23 Jun 2025 23:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750721455; cv=none; b=MHEsProtki6zvjo2ckHRfEYKReaN0wg+GdJnvaJdv8NBpJ5qH2wmi4JMkpg7yz6YZCQcDubslOUHhAXBSMxL/W/OpuPNHsMGVhyksakq5zcYYx/G0X70DgQnRAWVDLTmC3XmBl2dCjPrMqAqsll5p83Tk0f5OMW3q3wx0UAw+UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750721455; c=relaxed/simple;
	bh=8h0CNaMznRIpeQOBndTfjTKHZbkKePcIDSd+ZXoB7+Y=;
	h=Date:To:From:Subject:Message-Id; b=FqnJxo+dx2dyBvDtcx4ebAsTA1PF0iUn9m3xkGDhq52TSLbHUOGxZyanSDHXKEksjDBRdk6qswfTdLSll/dMToEYUowKxPkeaYQE7kBoUMXIpl3jZt1Xcn+3qBRmhlkvbfxhx3LBsGPNoV95xcx9JePK0tSU8aqwN2CPVhAzjfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jZXeCbCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jZXeCbCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B95C4CEED;
	Mon, 23 Jun 2025 23:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750721454;
	bh=8h0CNaMznRIpeQOBndTfjTKHZbkKePcIDSd+ZXoB7+Y=;
	h=Date:To:From:Subject:From;
	b=jZXeCbCqSrUQQ7wm1QnQGqz+XovrD/3a+PceHtEh5F0TTAgCgLmJ9u8y3zQWgmPGZ
	 NhzEQthiE/Xf/TUaT1QjCdtcQeAzalKa90nNAGTnf2oyPH5M5xIKskYWRe1hjusn/d
	 RGlNcoJXYHqLrNC1KaT+0AGuonS4dWvPtI9AGZgg=
Date: Mon, 23 Jun 2025 16:30:54 -0700
To: mm-commits@vger.kernel.org,zhanjie9@hisilicon.com,will@kernel.org,viresh.kumar@linaro.org,tglx@linutronix.de,sumit.garg@linaro.org,song@kernel.org,rafael@kernel.org,prime.zeng@hisilicon.com,lecopzer.chen@mediatek.com,kernelfans@gmail.com,Jonathan.Cameron@huawei.com,dianders@chromium.org,catalin.marinas@arm.com,yangyicong@hisilicon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-watchdog_hld-add-a-cpufreq-notifier-for-update-watchdog-thresh.patch added to mm-nonmm-unstable branch
Message-Id: <20250623233054.D3B95C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64/watchdog_hld: add a cpufreq notifier for update watchdog thresh
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arm64-watchdog_hld-add-a-cpufreq-notifier-for-update-watchdog-thresh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-watchdog_hld-add-a-cpufreq-notifier-for-update-watchdog-thresh.patch

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
From: Yicong Yang <yangyicong@hisilicon.com>
Subject: arm64/watchdog_hld: add a cpufreq notifier for update watchdog thresh
Date: Thu, 19 Jun 2025 19:48:05 +0800

arm64 depends on the cpufreq driver to gain the maximum cpu frequency to
convert the watchdog_thresh to perf event period.  cpufreq drivers like
cppc_cpufreq will be initialized lately after the initializing of the hard
lockup detector so just use a safe cpufreq which will be inaccurency.  Use
a cpufreq notifier to adjust the event's period to a more accurate one.

Link: https://lkml.kernel.org/r/20250619114805.16968-3-yangyicong@huawei.com
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Jie Zhan <zhanjie9@hisilicon.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Liu Pingfan <kernelfans@gmail.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Sumit Garg <sumit.garg@linaro.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zeng Tao <prime.zeng@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/watchdog_hld.c |   58 +++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

--- a/arch/arm64/kernel/watchdog_hld.c~arm64-watchdog_hld-add-a-cpufreq-notifier-for-update-watchdog-thresh
+++ a/arch/arm64/kernel/watchdog_hld.c
@@ -34,3 +34,61 @@ bool __init arch_perf_nmi_is_available(v
 	 */
 	return arm_pmu_irq_is_nmi();
 }
+
+static int watchdog_perf_update_period(void *data)
+{
+	int cpu = raw_smp_processor_id();
+	u64 max_cpu_freq, new_period;
+
+	max_cpu_freq = cpufreq_get_hw_max_freq(cpu) * 1000UL;
+	if (!max_cpu_freq)
+		return 0;
+
+	new_period = watchdog_thresh * max_cpu_freq;
+	hardlockup_detector_perf_adjust_period(cpu, new_period);
+
+	return 0;
+}
+
+static int watchdog_freq_notifier_callback(struct notifier_block *nb,
+					   unsigned long val, void *data)
+{
+	struct cpufreq_policy *policy = data;
+	int cpu;
+
+	if (val != CPUFREQ_CREATE_POLICY)
+		return NOTIFY_DONE;
+
+	/*
+	 * Let each online CPU related to the policy update the period by their
+	 * own. This will serialize with the framework on start/stop the lockup
+	 * detector (softlockup_{start,stop}_all) and avoid potential race
+	 * condition. Otherwise we may have below theoretical race condition:
+	 * (core 0/1 share the same policy)
+	 * [core 0]                      [core 1]
+	 *                               hardlockup_detector_event_create()
+	 *                                 hw_nmi_get_sample_period()
+	 * (cpufreq registered, notifier callback invoked)
+	 * watchdog_freq_notifier_callback()
+	 *   watchdog_perf_update_period()
+	 *   (since core 1's event's not yet created,
+	 *    the period is not set)
+	 *                                 perf_event_create_kernel_counter()
+	 *                                 (event's period is SAFE_MAX_CPU_FREQ)
+	 */
+	for_each_cpu(cpu, policy->cpus)
+		smp_call_on_cpu(cpu, watchdog_perf_update_period, NULL, false);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block watchdog_freq_notifier = {
+	.notifier_call = watchdog_freq_notifier_callback,
+};
+
+static int __init init_watchdog_freq_notifier(void)
+{
+	return cpufreq_register_notifier(&watchdog_freq_notifier,
+					 CPUFREQ_POLICY_NOTIFIER);
+}
+core_initcall(init_watchdog_freq_notifier);
_

Patches currently in -mm which might be from yangyicong@hisilicon.com are

watchdog-perf-provide-function-for-adjusting-the-event-period.patch
arm64-watchdog_hld-add-a-cpufreq-notifier-for-update-watchdog-thresh.patch

