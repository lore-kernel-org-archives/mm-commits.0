Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF873019B2
	for <mm-commits@vger.kernel.org>; Sun,  8 Feb 2026 08:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770538461; cv=none; b=M4ttFKoxwE0NzmNU7AxfzWlQDLLns7/wpWQlgg3C/wMgs5yYBOyFkb7ybI8uDVOdy9g8o44ag2C3e95bxQBfIMsJY53vXybfUZXrk2O8jgo3xoeH3/qVEDCXiL0wMgGQVc0/ehyQs10XTgUf4D1V5oAQWyoj0t+/6Hzm5F0w7os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770538461; c=relaxed/simple;
	bh=+36Hwcg0wFPVeDUw2Ln0UvCyB/LouusOEJgzjkjBfPw=;
	h=Date:To:From:Subject:Message-Id; b=maeH2sxlYM8BByrRojYghKntHRmKg1QPv7hdNrl81LxfkzCE4xjHNCSnLIr8aMR90hUR5JDJzSFDno2TO2nOtj5ibjqJsSsuXkR011THdYI6VjBGHaju77cZEnMKGeH7xiTvHe56q+xio01KbSEmCq0zVAmuNQHDNjw3vR19fbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zmKMdnnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zmKMdnnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAAEC4CEF7;
	Sun,  8 Feb 2026 08:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770538461;
	bh=+36Hwcg0wFPVeDUw2Ln0UvCyB/LouusOEJgzjkjBfPw=;
	h=Date:To:From:Subject:From;
	b=zmKMdnnqosWOkGwQk5qKxMPkiBuvXQbJDsXtTrrQhJXVRC3OXRNuNkvF3j+XncMIb
	 pP5lK7FN7EdDwvRxh71bk6mBzPigGQCxk4PFoJO6vdMAmrqKgbAwdLTyu1nF8qKUkS
	 14p/UowmNZ5Le+Wlp/CfCPKAjk6nrOUFv5LwP8CI=
Date: Sun, 08 Feb 2026 00:14:21 -0800
To: mm-commits@vger.kernel.org,zhangjn11@chinatelecom.cn,yuanql9@chinatelecom.cn,yangyicong@hisilicon.com,wangjinchao600@gmail.com,thorsten.blum@linux.dev,sunshx@chinatelecom.cn,song@kernel.org,mingo@kernel.org,lihuafei1@huawei.com,dianders@chromium.org,realwujing@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-hardlockup-simplify-perf-event-probe-and-remove-per-cpu-dependency.patch removed from -mm tree
Message-Id: <20260208081421.ACAAEC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog/hardlockup: simplify perf event probe and remove per-cpu dependency
has been removed from the -mm tree.  Its filename was
     watchdog-hardlockup-simplify-perf-event-probe-and-remove-per-cpu-dependency.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qiliang Yuan <realwujing@gmail.com>
Subject: watchdog/hardlockup: simplify perf event probe and remove per-cpu dependency
Date: Wed, 28 Jan 2026 21:26:14 -0500

Simplify the hardlockup detector's probe path and remove its implicit
dependency on pinned per-cpu execution.

Refactor hardlockup_detector_event_create() to be stateless.  Return the
created perf_event pointer to the caller instead of directly modifying the
per-cpu 'watchdog_ev' variable.  This allows the probe path to safely
manage a temporary event without the risk of leaving stale pointers should
task migration occur.

Link: https://lkml.kernel.org/r/20260129022629.2201331-1-realwujing@gmail.com
Signed-off-by: Shouxin Sun <sunshx@chinatelecom.cn>
Signed-off-by: Junnan Zhang <zhangjn11@chinatelecom.cn>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: Song Liu <song@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog_perf.c |   50 +++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 22 deletions(-)

--- a/kernel/watchdog_perf.c~watchdog-hardlockup-simplify-perf-event-probe-and-remove-per-cpu-dependency
+++ a/kernel/watchdog_perf.c
@@ -118,18 +118,11 @@ static void watchdog_overflow_callback(s
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
 
@@ -143,14 +136,7 @@ static int hardlockup_detector_event_cre
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
@@ -159,17 +145,26 @@ static int hardlockup_detector_event_cre
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
@@ -263,19 +258,30 @@ bool __weak __init arch_perf_nmi_is_avai
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
+	 * The event is released immediately.
+	 */
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
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from realwujing@gmail.com are


