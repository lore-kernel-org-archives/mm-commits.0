Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5414D1A9FAB
	for <mm-commits@vger.kernel.org>; Sat, 24 Jan 2026 07:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769238511; cv=none; b=ejcKNjRpFI8WFQ4KHsspCqrm2PACZyh2n4RK9DKw/kMZpWkHou2ho3lZOWSw3AQ/0HzqqiGePnEhmR62bunlMpsofRBrTN3pFtsZ22JsoaydcenZ8eWNq5XWpUdyFdHZ6leM8QQ7UIMg/UBVSaWxZeg4tGRHS6y+SmyHGmjVrgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769238511; c=relaxed/simple;
	bh=f0WroCkTqRKE2T125f7PZut/lKVaRERWCDmHSoTNRxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iA6vPNaJYwtNMVJRef2hEqS9jK4ew35ptmCpqAjB/Pm3aKXnhU3k7CR2eskEb/W+kjDClSj4uQylpsmX91s48Ox9nblj0XYzzXBNxG6CLnD9np1Q1lKBt0iyQvYPfRgJM/oEIajod0/9iG7PHTZ5vPXkBNy7zoKNYWQmU+Dtayc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xl7/qPlD; arc=none smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xl7/qPlD"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2b4520f6b32so4694476eec.0
        for <mm-commits@vger.kernel.org>; Fri, 23 Jan 2026 23:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769238508; x=1769843308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iAlcDf31qBBwSv93L3Z4uMSzJzYFnwNA3ebbhkgX8oI=;
        b=Xl7/qPlD1uUQQYMO1kMG0uZs/0fn0BwIUVHH03domQk+oe2StTfDKMDPfor37Gk1O3
         0pA6H7k/2xNdYTeRnyLG1V1WM50SZtyBvHuCedGtp5Uu7bnVge0a2BsfL7Zbv+aIaJ/n
         xyGgMcyGmbr/o+0O/q6iUStJ0fxI4okjDmttv28vCrtzmhN13LS4b0sFlna0vVppvaQc
         MTwI+KRvPFrkSRM5ycPydQ470eCpWjHX5VgHJ23ajXc4xHr3U1kSavcOYgZTu4H1yujq
         QmK8a/+ncbi2xMrfQkzqVedOzyX8xGHtSs1hfZmrFejIgTfnRLSQsE8xZ//Dh8gMo5UP
         sDbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769238508; x=1769843308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iAlcDf31qBBwSv93L3Z4uMSzJzYFnwNA3ebbhkgX8oI=;
        b=wshGB1CqmQjm6e/drLQEm+7bUSqVJg0nENsHTnRP5wSPAJGfWRXz9Mp8AcPjh/0Blh
         Ttc5oWbG7UQRXik1HHfq5HC/zDxtlI1HikI8S6UzMI0JD4GwRsIrsJ0oxfI4rNL3ojoz
         iHPqlIya44G/l5q2SacDfA4eCygtm4BWAjR1n5mtFQrkp3SR5c9/AF/d+3pACwxqwoCQ
         VtSFNoOk+XyXC8D3x6IE58gC12kJPmUCLd/p1aUIxtG85aKD2vjyfEODZE1gbk4VO39z
         J9uLT8yP8W4QxxOmyiaajo7qieHBpWQhdMhG8JxwqTB9/TNI5ItOsvmgx5OE8+6Xw30d
         mj3A==
X-Forwarded-Encrypted: i=1; AJvYcCVeERChICIOPjLnRX4dik47v9uUKOUCBFxAvnEMU66yrswbNydIOPcsYG2xqI09RVQMPfARLhNqQQ0o@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+T6bLJf9UbIOGY8paTf/B/K+k4AtrDCQ8lqHR01A0c+ySMZHQ
	DfKQFeH9kdBYJUGpRI8acPebBuexaqwxP+tm5qHVVIuIhNm/epXyWnU4
X-Gm-Gg: AZuq6aLzS//b1MLBH3pc6rWgBb16AQSOjpXdfo3GVXMz4lzhkfsm1DR3dLBnbLzqr5Z
	MhlU8jCpScE6W1R7Mum2Finzr8pR9jf8rwJI/CR0yvredlsT9a3vca57ayJMmfRl/F3nQUqTbia
	swf8Wya47hmg31iOhpIXJhLdiplGtP5yNUWFJpYy33LTYc93rIV3DIk92R8JmkC0TYTR2GzHpow
	Pp+20VBF4ccyd2cncXzgj4TbTk2PNMs9B3wlGK1UNd/m9ADLaIi6Exd6sDzl8X6nyCtjhScRhA1
	wPgoYdRMQvmQuS3nz8NbEU0qh00FzxrJGSQGlmcu1zA6hs6IK0Z1RwpP6aM+u9njRXMJ9IUV0h/
	6kd7w/veHUXBOn8FJxEnhDv9ZXOusuqWWDFIofsynHki4wMhLpL4OE50A5ZXv0+AbDW2o5sJj2B
	TyCJk=
X-Received: by 2002:a05:7300:bc0e:b0:2b7:3780:810f with SMTP id 5a478bee46e88-2b739b73be3mr3051286eec.23.1769238508267;
        Fri, 23 Jan 2026 23:08:28 -0800 (PST)
Received: from debian ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b749e301f0sm3798342eec.35.2026.01.23.23.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 23:08:27 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
To: dianders@chromium.org
Cc: akpm@linux-foundation.org,
	lihuafei1@huawei.com,
	linux-kernel@vger.kernel.org,
	mingo@kernel.org,
	mm-commits@vger.kernel.org,
	realwujing@gmail.com,
	song@kernel.org,
	stable@vger.kernel.org,
	sunshx@chinatelecom.cn,
	thorsten.blum@linux.dev,
	wangjinchao600@gmail.com,
	yangyicong@hisilicon.com,
	yuanql9@chinatelecom.cn,
	zhangjn11@chinatelecom.cn,
	linux-watchdog@vger.kernel.org
Subject: [PATCH v4] watchdog/hardlockup: Fix UAF in perf event cleanup due to migration race
Date: Sat, 24 Jan 2026 02:08:14 -0500
Message-ID: <20260124070814.806828-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <CAD=FV=WHWrKS_LVjod6nhnPdEk9_ZqeubGpft3PJOUJNMbBxfg@mail.gmail.com>
References: <CAD=FV=WHWrKS_LVjod6nhnPdEk9_ZqeubGpft3PJOUJNMbBxfg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Original analysis on Linux 4.19 showed a race condition in the hardlockup
detector's initialization phase. Specifically, during the early probe
phase, hardlockup_detector_perf_init() (renamed to
watchdog_hardlockup_probe() in newer kernels via commit d9b3629ade8e)
interacted with the per-cpu 'watchdog_ev' variable.

If the initializing task migrates to another CPU during this probe phase,
two issues arise:
1. The 'watchdog_ev' pointer on the original CPU is set but not cleared,
   leaving a stale pointer to a freed perf event.
2. The 'watchdog_ev' pointer on the new CPU might be incorrectly cleared.

Note: Although the logs below reference hardlockup_detector_perf_init(),
the same logic persists in the current watchdog_hardlockup_probe()
implementation.

This race condition was observed in console logs:
[23.038376] hardlockup_detector_perf_init 313 cur_cpu=2
...
[23.076385] hardlockup_detector_event_create 203 cpu(cur)=2 set watchdog_ev
...
[23.095788] perf_event_release_kernel 4623 cur_cpu=2
...
[23.116963] lockup_detector_reconfigure 577 cur_cpu=3

The log shows the task started on CPU 2, set watchdog_ev on CPU 2,
released the event on CPU 2, but then migrated to CPU 3 before the
cleanup logic could run. This left watchdog_ev on CPU 2 pointing to a
freed event, resulting in a UAF when later accessed:

[26.540732] BUG: KASAN: use-after-free in perf_event_ctx_lock_nested.isra.72+0x6b/0x140
[26.542442] Read of size 8 at addr ff110006b360d718 by task kworker/2:1/94

Fix this by refactoring hardlockup_detector_event_create() to return the
created perf event instead of directly assigning it to the per-cpu variable.
In the probe function, use an arbitrary CPU but ensure it remains
online via cpu_hotplug_disable() during the check.

Fixes: 930d8f8dbab9 ("watchdog/perf: adapt the watchdog_perf interface for async model")
Signed-off-by: Shouxin Sun <sunshx@chinatelecom.cn>
Signed-off-by: Junnan Zhang <zhangjn11@chinatelecom.cn>
Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
Cc: Song Liu <song@kernel.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: <stable@vger.kernel.org>
---
v4:
- Add cpu_hotplug_disable() in watchdog_hardlockup_probe() to ensure the
  sampled CPU remains online during probing. 
- Update commit message to explain the relevance of 4.19 logs even
  though functions were renamed in modern kernels. 
v3:
- Refactor hardlockup_detector_event_create() to return the event pointer
  instead of directly assigning to per-cpu variables to fix the UAF.
- Restore PMU cycle fallback and unify the enable/probe paths.
v2:
- Add Cc: <stable@vger.kernel.org>.
v1:
- Avoid 'watchdog_ev' in probe path by manually creating and releasing a
  local perf event.
 kernel/watchdog_perf.c | 56 +++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff --git a/kernel/watchdog_perf.c b/kernel/watchdog_perf.c
index d3ca70e3c256..887b61c65c1b 100644
--- a/kernel/watchdog_perf.c
+++ b/kernel/watchdog_perf.c
@@ -17,6 +17,7 @@
 #include <linux/atomic.h>
 #include <linux/module.h>
 #include <linux/sched/debug.h>
+#include <linux/cpu.h>
 
 #include <asm/irq_regs.h>
 #include <linux/perf_event.h>
@@ -118,18 +119,11 @@ static void watchdog_overflow_callback(struct perf_event *event,
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
 
@@ -143,14 +137,7 @@ static int hardlockup_detector_event_create(void)
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
@@ -159,17 +146,26 @@ static int hardlockup_detector_event_create(void)
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
@@ -263,19 +259,35 @@ bool __weak __init arch_perf_nmi_is_available(void)
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
 
-- 
2.51.0

