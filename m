Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D865309EE4
	for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 06:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769580391; cv=none; b=S1A6SiLMP+F07wmP7v3Y9HfjuV9EFL3gH17bbUksU/EWKUVGY90z4q22dtD3hHr09Bvf7u80ewDpI2B0wfFKCDKxMma3JRoxyaIiPGhuHFI6wIc48IBc7RJ4Yn1p39SQkzfVndoByqHZYJCZUNHm7V2lQvwtPbgdEeUG1ATpMbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769580391; c=relaxed/simple;
	bh=fD/kgZvAJFHYzXjUwTyBXUwZSjmzmlfRjg/zztY3NpI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BOBej3w8vFRD6M3NcB6mElUmMwE0Fc7TZpH4apL98VR5h6QH4UGljwo6panmuz3gqdwfWrk+C6gdzHefru1Sj2WgZjzJ+/uz7DSRUN/LmlVzVXXuyVbiiru5Pp9iFd9GemHBpcRwceEsKC3AaP1cDTYKKrVcQC+M2SSPcC0n8WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b2BLG0eA; arc=none smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b2BLG0eA"
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1233bb90317so518549c88.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 22:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769580389; x=1770185189; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ylSEp4a0zfiE/n3fKLMKe4thGKMdljP/4PNULWhpuIc=;
        b=b2BLG0eAbFraMpVUSm2yzawP1t1+u3Q/b3njS7jDr5in4sq5gv8K7G+incDL0jLatf
         5O8SWeLqKGL/aW6D200w7ANj5aHLroKaG9s0Roo4iCH2amAZpQ4OE6YL/K1asLJqburc
         Fd96I1zaYEFJDj++K2XZp++Y+YIeagQ/Hn4xkn6e8alzBAPoOVW4Rawrb6Uc/+Af6yxf
         elckJZL0MNAdfjIS5RK07STdp+ba/lquAzT4XDkeGj4hyjiul3z6mvspfPNzjyomAksP
         bW3AchyQqENm60cpB1e1Ie3yK99ybITmFQnCPMe7npxfNVPB50hZbvFYJMWIRBGDfAZ6
         yvqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769580389; x=1770185189;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ylSEp4a0zfiE/n3fKLMKe4thGKMdljP/4PNULWhpuIc=;
        b=kIztQI9tasR9kuD9TzZfTuA7hXdqEE9Rpp575U6g8Rhc1YBbjjnlv6FyX6k4OdAETD
         vnupK9MVpfFfIlhcgK1+uzIzqAXHxNpB4FPqYQ9XBvzp3YQInkb6rhKn+dpX2AFuT+df
         et+wKQBLSKFLxMn97F7glICk0vPczK1s5acqUDA9KJdEK6cxyz2FoABLmWgX14I9BnQq
         yKLjYgLvVQ3TFaP3uaXm7Nl19Hi1ZA5QRQGM+B1YLeavRNeOi/TBeGjRJb04OID/etQN
         owwFkzDGUzc117LzLdRR889Srwkj+FdKTS2ohMcow/HLeQUjWs2zsnhDcZL0s/qzVGbL
         zxWA==
X-Forwarded-Encrypted: i=1; AJvYcCWEWWOCMRVyQf6zMjzjfJvt6ZeEffJbHv2N1ILkBpCYjiOCBVOJI6h7vxF6yl/nOnSCaTrRLupME+fp@vger.kernel.org
X-Gm-Message-State: AOJu0YyN5zdnmCJRgH8oEjT9XRVcmyHfEJKhRnxRDTmJFRm1qkmxc38w
	GSJgPzsueT9MGZLLf7skIXkWbI7FggAv2QXwnZVgKJi8RaCuyqRFaMn1
X-Gm-Gg: AZuq6aLVJgaXfdIH/e5uXFzwUPGTWtmD9q3E63QS5Q4Cm6ixZIGlPh9kjq6bxa3d2gf
	n7e96lNTk+6PKUQORsQNq1KFMqVfpdlMHqKqChYMoYHDzZ3z+ESB/hCh1n95Leza5nrNY8SbmDz
	U8Lh1ILcvcVWDBRus+OqFGJiii47PNX0/h3XSzvWyTmSYxe4xgZEL3klM5381rQLC0KopZRarN1
	Ee1opt4hOuH8c4V1Gt4LRt5ZUdG1QPUTwxBz3KPLkbaP493YrXX/6S+JnNr3g7c5YyisCntIumI
	CjDhVkOciCxK5rasx6w2Krl1M/N+K4H1OG87Z0J2doquq2TnEuPidaGnBudY1Pg9bpFhjtz3VeB
	5aYjUd5bIRWtFb7f7pZvv1HJBR3SarT8JwmHb9xmZbBSS/22TNNLX5njir85zcPffRsPspgWqwR
	aQVyU=
X-Received: by 2002:a05:693c:61d2:b0:2a4:3593:cca7 with SMTP id 5a478bee46e88-2b78e6beedbmr2168496eec.4.1769580388693;
        Tue, 27 Jan 2026 22:06:28 -0800 (PST)
Received: from debian ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a17083dasm1548275eec.14.2026.01.27.22.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 22:06:28 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
To: Li Huafei <lihuafei1@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	Jinchao Wang <wangjinchao600@gmail.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Qiliang Yuan <realwujing@gmail.com>,
	Thorsten Blum <thorsten.blum@linux.dev>
Cc: linux-watchdog@vger.kernel.org,
	mm-commits@vger.kernel.org,
	Shouxin Sun <sunshx@chinatelecom.cn>,
	Junnan Zhang <zhangjn11@chinatelecom.cn>,
	Song Liu <song@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7] watchdog/hardlockup: simplify perf event probe and remove per-cpu dependency
Date: Wed, 28 Jan 2026 01:05:29 -0500
Message-ID: <20260128060544.1714875-1-realwujing@gmail.com>
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
Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
Cc: Song Liu <song@kernel.org>
Cc: Jinchao Wang <wangjinchao600@gmail.com>
---
v7:
- Update Signed-off-by to match author email.
- Remove redundant cpu_hotplug_disable() in probe path.
- v6 link: https://lore.kernel.org/all/20260128023136.1691973-1-realwujing@gmail.com/
v6:
- Change title to "simplify/cleanup" and remove "Fixes" tag since the issue
  is not reproducible on mainline.
- Rewrite commit message in imperative mood.
- Clarify that mainline is safe while this improves robustness.
- v5 link: https://lore.kernel.org/all/20260127022238.1182079-1-realwujing@gmail.com/
v5:
- Refine description: clarify that the retry path uses worker threads
  without PF_PERCPU_THREAD (though mainline is safe due to system_percpu_wq).
- v4 link: https://lore.kernel.org/all/20260124070814.806828-1-realwujing@gmail.com/
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

 kernel/watchdog_perf.c | 51 ++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff --git a/kernel/watchdog_perf.c b/kernel/watchdog_perf.c
index d3ca70e3c256..4a798443033b 100644
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
@@ -263,19 +259,30 @@ bool __weak __init arch_perf_nmi_is_available(void)
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

