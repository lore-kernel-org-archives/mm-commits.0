Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A04223E356
	for <mm-commits@vger.kernel.org>; Thu, 29 Jan 2026 02:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769653601; cv=none; b=nuk8RAeNxkne+GZZzy7OuLtUZqcKLywqZlc2ibGJFleUY052SmgHuLi8Qy1K1XQKr9bqOcK6+3FaGFf96xkKrHnGEX+DDf8D826zShvQ1b02R1o01ll3Ry+fm9o6OHCID7/5KvWOoz/f3ahScSfzba7f1hEUMe9L+DJF0dpgmZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769653601; c=relaxed/simple;
	bh=CAf2Etf/SR10lea8VN5fkUmacasr/02Ph7H3nfRTwjY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aLVm9RWyXZMmF+g1l2ynMvi3/1vSgWq6RBNPI0X3/kDU0osOQQMNLqQXcMjEXuuP2b/jyCuASKTCZ0tYMaVPm3GlKqhjKNU3fR51I8c7c72w/2NOkzqni6tb/TJaa8sU9HVZ2JhM23DIbJsw0C4Mf2MMCcQ03hX9No39hlf8qsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kJoahQGH; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kJoahQGH"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2b72e49776eso1004322eec.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 18:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769653599; x=1770258399; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vcq7aD3lYlVWIhmj7yegBQ/oAWD8jMRiUwoR40ggFyM=;
        b=kJoahQGH6TA33DiLoGqDe6QeC3jKjEhCv6RkyHN0j8fb8cm1fGtymAf+v0ZyedhZkc
         gsXytRmd+T3Z/Oakd8U4hEjPm8F1iyBaAdZjYQ8gd4Bvyg3w3XX51tfqasYikBUgA1wS
         1QeC6da8F9hsLw9ZrcZqj6NULR+dEEi9a+BLnrmuUITYwH6j1jAJu1Mt5F0QS386H0HC
         voEcciL/NCwEX12yRbVpkyZjOK04i7yuc0+D99cvgUGuauElTF8Q3QqLj2ULxrvSC14Q
         PC57yHympGJLdeH4SPfHjLtWOEHU1RSuBG/Bekw7r/xj4JFlFHp9ZA53RYJ9nNmS7rBf
         iAGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769653599; x=1770258399;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vcq7aD3lYlVWIhmj7yegBQ/oAWD8jMRiUwoR40ggFyM=;
        b=fcLDaXsX15UTwSKEpilU+UBRS5JWoxWh87qE+tKDPKEY4vYF+gMBo+SaiKuc68GPqH
         56y/ZvHVbTA8aKfmLWtSCwt+U0i+/tZufDwRb92HicIAzIMHf2DHTHcWoOXwpMxps6n/
         +3BR69iU2q1Cd2j+OwFnQQZxY24d96IFZ62nePt7nhXsTWQ5BYf0c/Av86AfrJPXXkcE
         fSKC4GM8AI6BXDzusP9em7ttZobpo+yJ2wzKnr3uZKDcCNT9HDcY3FTImlySExXygaIt
         eioVaZAt7viLxVG6Mj1U8/X/tpzjI4rsIW2cKeAWtdMYRRiCq3Ic1zNz27RDk2HfywYB
         kXtQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9Tma5K302wsw5wwxEAEW+9tP4CrVJ+8xX3yvrHN7kVsAc6Ooh2BU4WXJUM1CHwISy2m/KM4G0O4b+@vger.kernel.org
X-Gm-Message-State: AOJu0YydSv23BnpSyAVVpFNC+i4MnzPUMW/evZPSquYjbk2yO0iYzKza
	PmYJKn6twZopIVQ7rnuUZXsc+NUYxG9tMMFaMjk02TaX6lCx7veZPvEf
X-Gm-Gg: AZuq6aKm25VSM10GNXPq4qj9DstIgJhd4LMpoAibWey0n8jxnv84EgJxKfRB9WPW+R5
	XeJ62QGLMLHm5UUF6mAhvcs/plkst2Z1kuGzVubFsUTdRvhaGsMA/A845Shh44m//9u/N1VbIVd
	amjVXnFZ53dzH4jttOoWbAGZiyzAZxaZDkitRKif41O9s/CREzz8907j6F2bcQGLLh+EHNJLnCR
	z51NwmKcr1dUzpLkN3YRnom+4qsxqY6tcuMIYkU5CddDJFFvA5NqDVBgBTzSSrNLNvpD4gs+NKJ
	2DIFzDduug4vQ7Gk38kYQ7wvnmeWcD5s+FcqA2bKfu3+gyOfmUXKUFNF3Pv4NjH5gj/ZhfL84G7
	5uNeOyCl0RUJrGSHOp6SlIUh5K48bbj2z19G0G3oWDE4PHHU1rbWL0LLZNnZNYHGVDhZ88MyI1N
	y25XA=
X-Received: by 2002:a05:7301:9f03:b0:2b7:3955:f50a with SMTP id 5a478bee46e88-2b78da4a0b4mr4654448eec.41.1769653597804;
        Wed, 28 Jan 2026 18:26:37 -0800 (PST)
Received: from debian ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a1adef97sm5088827eec.29.2026.01.28.18.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 18:26:37 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
To: Ingo Molnar <mingo@kernel.org>,
	Li Huafei <lihuafei1@huawei.com>,
	Qiliang Yuan <realwujing@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jinchao Wang <wangjinchao600@gmail.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Thorsten Blum <thorsten.blum@linux.dev>
Cc: linux-watchdog@vger.kernel.org,
	mm-commits@vger.kernel.org,
	Shouxin Sun <sunshx@chinatelecom.cn>,
	Junnan Zhang <zhangjn11@chinatelecom.cn>,
	Qiliang Yuan <yuanql9@chinatelecom.cn>,
	Douglas Anderson <dianders@chromium.org>,
	Song Liu <song@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v9] watchdog/hardlockup: simplify perf event probe and remove per-cpu dependency
Date: Wed, 28 Jan 2026 21:26:14 -0500
Message-ID: <20260129022629.2201331-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simplify the hardlockup detector's probe path and remove its implicit
dependency on pinned per-cpu execution.

Refactor hardlockup_detector_event_create() to be stateless. Return
the created perf_event pointer to the caller instead of directly
modifying the per-cpu 'watchdog_ev' variable. This allows the probe
path to safely manage a temporary event without the risk of leaving
stale pointers should task migration occur.

Signed-off-by: Shouxin Sun <sunshx@chinatelecom.cn>
Signed-off-by: Junnan Zhang <zhangjn11@chinatelecom.cn>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Song Liu <song@kernel.org>
Cc: Jinchao Wang <wangjinchao600@gmail.com>
---
v9:
- remove unused `#include <linux/cpu.h>`
v8:
- Add Signed-off-by with work email.
v7:
- Update Signed-off-by to match author email.
- Remove redundant cpu_hotplug_disable() in probe path.
v6:
- Change title to "simplify/cleanup" and remove "Fixes" tag since the issue
  is not reproducible on mainline.
- Rewrite commit message in imperative mood.
- Clarify that mainline is safe while this improves robustness.
v5:
- Refine description: clarify that the retry path uses worker threads
  without PF_PERCPU_THREAD (though mainline is safe due to system_percpu_wq).
v4:
- Add cpu_hotplug_disable() in watchdog_hardlockup_probe() to stabilize
  the probe CPU.
- Update description to explain the relevance of 4.19 logs.
v3:
- Refactor hardlockup_detector_event_create() to be stateless by returning
  the event pointer instead of directly assigning to per-cpu variables.
- Restore PMU cycle fallback and unify the enable/probe paths.
v2:
- Add Cc: stable@vger.kernel.org.
v1:
- Avoid 'watchdog_ev' in probe path by manually creating and releasing a
  local perf event.

 kernel/watchdog_perf.c | 50 +++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 22 deletions(-)

diff --git a/kernel/watchdog_perf.c b/kernel/watchdog_perf.c
index d3ca70e3c256..cf05775a96d3 100644
--- a/kernel/watchdog_perf.c
+++ b/kernel/watchdog_perf.c
@@ -118,18 +118,11 @@ static void watchdog_overflow_callback(struct perf_event *event,
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
 
@@ -143,14 +136,7 @@ static int hardlockup_detector_event_create(void)
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
@@ -159,17 +145,26 @@ static int hardlockup_detector_event_create(void)
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
@@ -263,19 +258,30 @@ bool __weak __init arch_perf_nmi_is_available(void)
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
 
-- 
2.51.0

