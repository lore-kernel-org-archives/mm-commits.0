Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AEE36C0C0;
	Thu, 29 Jan 2026 23:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769727952; cv=none; b=mPNBx4XKhSGqZDQEWRHQED0/UhT3xiiMnJN1Pd75svwpYQm27O5reFsiqrhZTp/9BGjzll90pg5WHoH3p5AzxHHLtX30cC5Nb9WlmYQ0vSFreQKVtANqyQx6UxfCHDBko2UlzqekIwRj1jRB9Y3Kyx8AuNIuI8RTEfjV3/EYoOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769727952; c=relaxed/simple;
	bh=ysjJi/nb+60fgbhXCkEHjf8sWvgjPa8SWFX7P8AiPH0=;
	h=Date:To:From:Subject:Message-Id; b=n6QXmMAzqHuZ9tPl2s0OYkAaya2OsJSX5WsbFi7WSCnErc4b/j/KVHzSFlubZqEjzZ3qNhrHjBJqbKGsAZmKILRLVWAEreNNIXkMbcSkhfM8DUn3/Yh/FjvMYyy841XgB25SnsdHpReSXFKJ+39Ujvu1TObgBP9cMlaCTvf7+kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lbyl/S1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lbyl/S1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D760DC4CEF7;
	Thu, 29 Jan 2026 23:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769727951;
	bh=ysjJi/nb+60fgbhXCkEHjf8sWvgjPa8SWFX7P8AiPH0=;
	h=Date:To:From:Subject:From;
	b=lbyl/S1K4mRh32KL80YgU/q3uDIFEu4PhbRQ3GI4TtsjdClmJMbM7h1YggaVVBoS/
	 tpX0wzcXJmzwWPaZXbxDsIsJDpJRL80y1qvX4b94aK5nBU0PsysUl26/Op2KgJYgxe
	 0Mbw3iEEGixJyGccL/Q7i40c9te3MMkwNGqaeI8M=
Date: Thu, 29 Jan 2026 15:05:51 -0800
To: mm-commits@vger.kernel.org,zhangjn11@chinatelecom.cn,yuanql9@chinatelecom.cn,yangyicong@hisilicon.com,wangjinchao600@gmail.com,thorsten.blum@linux.dev,sunshx@chinatelecom.cn,stable@vger.kernel.org,song@kernel.org,mingo@kernel.org,lihuafei1@huawei.com,dianders@chromium.org,realwujing@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] watchdog-hardlockup-fix-uaf-in-perf-event-cleanup-due-to-migration-race.patch removed from -mm tree
Message-Id: <20260129230551.D760DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog/hardlockup: fix UAF in perf event cleanup due to migration race
has been removed from the -mm tree.  Its filename was
     watchdog-hardlockup-fix-uaf-in-perf-event-cleanup-due-to-migration-race.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Qiliang Yuan <realwujing@gmail.com>
Subject: watchdog/hardlockup: fix UAF in perf event cleanup due to migration race
Date: Sat, 24 Jan 2026 02:08:14 -0500

The hardlockup detector's probe path (watchdog_hardlockup_probe()) can
be executed in a non-pinned context, such as during the asynchronous
retry mechanism (lockup_detector_delay_init) which runs in a standard
unbound workqueue.

In this context, the existing implementation of
hardlockup_detector_event_create() suffers from a race condition due to
potential task migration. It relies on is_percpu_thread() to ensure
CPU-locality, but worker threads in a global workqueue do not carry the
PF_PERCPU_THREAD flag, causing the WARN_ON() to trigger and violating
the assumption of stable per-cpu access.

If the task migrates during the probe:
1. It might set 'watchdog_ev' on one CPU but fail to clear it if the
   subsequent migration causes the cleanup logic to run on a different CPU.
2. This leaves a stale pointer to a freed perf_event in the original
   CPU's 'watchdog_ev' variable, leading to a use-after-free (UAF) when
   the watchdog is later enabled or reconfigured.

While this issue was prominently observed in downstream kernels (like
openEuler 4.19) where initialization timings are shifted to a post-SMP
phase, it represents a latent bug in the mainline asynchronous
initialization path.

Refactor hardlockup_detector_event_create() to be stateless by returning
the created perf_event pointer instead of directly modifying the per-cpu
'watchdog_ev' variable. This allows the probe logic to safely manage
the temporary event. Use cpu_hotplug_disable() during the probe to ensure
the target CPU remains valid throughout the check.

Link: https://lkml.kernel.org/r/20260124070814.806828-1-realwujing@gmail.com
Fixes: 930d8f8dbab9 ("watchdog/perf: adapt the watchdog_perf interface for async model")
Signed-off-by: Shouxin Sun <sunshx@chinatelecom.cn>
Signed-off-by: Junnan Zhang <zhangjn11@chinatelecom.cn>
Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
Cc: Song Liu <song@kernel.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog_perf.c |   56 +++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 22 deletions(-)

--- a/kernel/watchdog_perf.c~watchdog-hardlockup-fix-uaf-in-perf-event-cleanup-due-to-migration-race
+++ a/kernel/watchdog_perf.c
@@ -17,6 +17,7 @@
 #include <linux/atomic.h>
 #include <linux/module.h>
 #include <linux/sched/debug.h>
+#include <linux/cpu.h>
 
 #include <asm/irq_regs.h>
 #include <linux/perf_event.h>
@@ -118,18 +119,11 @@ static void watchdog_overflow_callback(s
 	watchdog_hardlockup_check(smp_processor_id(), regs);
 }
 
-static int hardlockup_detector_event_create(void)
+static struct perf_event *hardlockup_detector_event_create(unsigned int cpu)
 {
-	unsigned int cpu;
 	struct perf_event_attr *wd_attr;
 	struct perf_event *evt;
 
-	/*
-	 * Preemption is not disabled because memory will be allocated.
-	 * Ensure CPU-locality by calling this in per-CPU kthread.
-	 */
-	WARN_ON(!is_percpu_thread());
-	cpu = raw_smp_processor_id();
 	wd_attr = &wd_hw_attr;
 	wd_attr->sample_period = hw_nmi_get_sample_period(watchdog_thresh);
 
@@ -143,14 +137,7 @@ static int hardlockup_detector_event_cre
 						       watchdog_overflow_callback, NULL);
 	}
 
-	if (IS_ERR(evt)) {
-		pr_debug("Perf event create on CPU %d failed with %ld\n", cpu,
-			 PTR_ERR(evt));
-		return PTR_ERR(evt);
-	}
-	WARN_ONCE(this_cpu_read(watchdog_ev), "unexpected watchdog_ev leak");
-	this_cpu_write(watchdog_ev, evt);
-	return 0;
+	return evt;
 }
 
 /**
@@ -159,17 +146,26 @@ static int hardlockup_detector_event_cre
  */
 void watchdog_hardlockup_enable(unsigned int cpu)
 {
+	struct perf_event *evt;
+
 	WARN_ON_ONCE(cpu != smp_processor_id());
 
-	if (hardlockup_detector_event_create())
+	evt = hardlockup_detector_event_create(cpu);
+	if (IS_ERR(evt)) {
+		pr_debug("Perf event create on CPU %d failed with %ld\n", cpu,
+			 PTR_ERR(evt));
 		return;
+	}
 
 	/* use original value for check */
 	if (!atomic_fetch_inc(&watchdog_cpus))
 		pr_info("Enabled. Permanently consumes one hw-PMU counter.\n");
 
+	WARN_ONCE(this_cpu_read(watchdog_ev), "unexpected watchdog_ev leak");
+	this_cpu_write(watchdog_ev, evt);
+
 	watchdog_init_timestamp();
-	perf_event_enable(this_cpu_read(watchdog_ev));
+	perf_event_enable(evt);
 }
 
 /**
@@ -263,19 +259,35 @@ bool __weak __init arch_perf_nmi_is_avai
  */
 int __init watchdog_hardlockup_probe(void)
 {
+	struct perf_event *evt;
+	unsigned int cpu;
 	int ret;
 
 	if (!arch_perf_nmi_is_available())
 		return -ENODEV;
 
-	ret = hardlockup_detector_event_create();
+	if (!hw_nmi_get_sample_period(watchdog_thresh))
+		return -EINVAL;
 
-	if (ret) {
+	/*
+	 * Test hardware PMU availability by creating a temporary perf event.
+	 * The requested CPU is arbitrary; preemption is not disabled, so
+	 * raw_smp_processor_id() is used. Surround with cpu_hotplug_disable()
+	 * to ensure the arbitrarily chosen CPU remains online during the check.
+	 * The event is released immediately.
+	 */
+	cpu_hotplug_disable();
+	cpu = raw_smp_processor_id();
+	evt = hardlockup_detector_event_create(cpu);
+	if (IS_ERR(evt)) {
 		pr_info("Perf NMI watchdog permanently disabled\n");
+		ret = PTR_ERR(evt);
 	} else {
-		perf_event_release_kernel(this_cpu_read(watchdog_ev));
-		this_cpu_write(watchdog_ev, NULL);
+		perf_event_release_kernel(evt);
+		ret = 0;
 	}
+	cpu_hotplug_enable();
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from realwujing@gmail.com are

watchdog-hardlockup-simplify-perf-event-probe-and-remove-per-cpu-dependency.patch

