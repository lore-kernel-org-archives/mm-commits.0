Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243FC28D82F
	for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 02:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769567525; cv=none; b=tBJqod7W/yJdLYZJP/UZcXUIqlvCeuQWYfNxfL7ZZJ0ewjfGOPAY6T7nwfkk9wD12wK8DvjPd8p895XZvbrQM4et6BNR2Zg/yrIVXhkIGT6dynSfsob4zw2pzSw0BlyB+VjnDtCINv1sqMdm/L8BzFd1MPit6/ciqSApwAsIBlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769567525; c=relaxed/simple;
	bh=3zyzKCSekqq7FHMYW7I4Xhmf24lrfieQrozQP0dABJg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dt8y+oYIiJ5Gym0Bdrdb57qv2GB5P/pSBxkCwxJBf3Hc8mYDI4W+pBeF7Bj8aRpM2zRIffpA2Lwcz5HFTpzoaMNKI/nll91LkdDg19ntDnsjLfhfEf7FwKQMcayJvUKl/mOkzTr+O4R6+rQIyCqEXPzCJpK/FDHpfIm3CuSPfRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D3FpUrpA; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D3FpUrpA"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2b73112ab62so5455953eec.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 18:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769567522; x=1770172322; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=egAN9VsiBBmLS+EOoK2lXqZdjZw63twFvoDba+Q9+sA=;
        b=D3FpUrpAPSkq7c5MzDpfnDRX1BXrInzAxy5VejW8UEwXDOqHIk+aricbX3hVMVBZqI
         sHY/58vamS2jVQIV4OGRmXNXqMmWGjdc6XNn7oRuyOCMWxjF/mhJTRAfqOR7U2wYlV4u
         EErl6jV0zCVvYqQ7iGRIrFN9agSrm7Mw/594UYDO+mrYfvJFMKQPsmtXBNn117Agmf2v
         H3LbAnMXzeSBkRzrE8uy/LjsFuy8YWCNQJlb80SwFahxnelv371Ekwkw9TKGL6yfHzHs
         pAxLDd0X2fLdvO+3jtMdWjcERLj5Sj1J2cyNwQ9OTfQpOczSFIMXjRVRhkNnzhq4okZC
         xAXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769567522; x=1770172322;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=egAN9VsiBBmLS+EOoK2lXqZdjZw63twFvoDba+Q9+sA=;
        b=GjNvq3hc1h2nUTFB+dVHtAeJdUOxi/x2uY+Wh1WuZR7AlTO2/u2fxTgwqSVhaOlbi3
         C6QME6U1jIfnP5VccDtPc6D/v+oy6CX3E7rR9EZUPAkSGd824kQaeCxN1OXcgxKky/lE
         tSqIqfZsTCsYmWXbrNfwkOF6qkD2l6z0F4PDn8/FZe4y7xh9eXTEo+4Z2MJXul7PeXwB
         vBzq2ffCgF1SNthJ2C/nnh8Oy9nA0MVITqxxUStkwrBCnvNHOQ3wjIgQ0S+blXXpmpYP
         ld/bQzI5pH+2mFLFIYbH8mcMizmGHt4cNAJ4TPlnemMD+3YZJ+cYRk/Ekzfw6FqcQDLQ
         3Vuw==
X-Forwarded-Encrypted: i=1; AJvYcCXmXC6Nm57vvLo7u7VvDyJyEsohfsisbJ/6DEAg6mofvoeWfjCojgDHnSu1yXjIeCORfhWemZBJAIv3@vger.kernel.org
X-Gm-Message-State: AOJu0YzpbPex4uhsPR19WtSZkt5c6ZhzYv9fMczbP4TaGxlhd1Ddit+X
	CmsfX7hNabvva3eNbIZNHOJfGjemEwWMcJIKWkV/7Pa7n23B7IfFa3gu
X-Gm-Gg: AZuq6aIXJEIJvCIZQD/fJ8r5YSyIM6NiGQJXLiSfw14mL3vLwgQ/gjZ/uIBn900138f
	qrH4HZ8i5qFPjwq1Lklo8GqAzXei0p7a6qMdjkGeaSFPMOpAynkdzIw3rCvYOfg9gx2MhJouSjG
	ZHQjg6lZjpRk8Br7QOgaaV7YdyCRtCPYJJv9Z5Qsu25haVqhkj9fpDkOL0R5C0AUVB2x3oO1BBv
	ZDc3jfkCNGRLp3/xbDJcG4NEr0CS9ToGwK23wF1agBf7lBQjekW7wCfA2wSNZHUSL16payIpx4I
	ewbwiACiEnxmzA8cqR9OjBb/JVAzGQcVvcTkRjiKY8tJOJM+8QxWH7AYRJOr56B8bLox+Sl+DyW
	GrZzN2xfY3MZHsNzGsGUS+KkZhBf6SQdNQa+ljzxhE2iNhBtUInGQlXk/96R3QYAomWcnzdFb8M
	6Cm0ArsWCpOtw7kQ==
X-Received: by 2002:a05:693c:60cd:b0:2b7:97b0:82b9 with SMTP id 5a478bee46e88-2b797b09200mr1234573eec.9.1769567522217;
        Tue, 27 Jan 2026 18:32:02 -0800 (PST)
Received: from debian ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a17083dasm930663eec.14.2026.01.27.18.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 18:32:01 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
To: Qiliang Yuan <realwujing@gmail.com>,
	Li Huafei <lihuafei1@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	Jinchao Wang <wangjinchao600@gmail.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Thorsten Blum <thorsten.blum@linux.dev>
Cc: linux-watchdog@vger.kernel.org,
	mm-commits@vger.kernel.org,
	Shouxin Sun <sunshx@chinatelecom.cn>,
	Junnan Zhang <zhangjn11@chinatelecom.cn>,
	Qiliang Yuan <yuanql9@chinatelecom.cn>,
	Song Liu <song@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6] watchdog/hardlockup: simplify perf event probe and remove per-cpu dependency
Date: Tue, 27 Jan 2026 21:31:22 -0500
Message-ID: <20260128023136.1691973-1-realwujing@gmail.com>
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

Use cpu_hotplug_disable() during the probe to ensure the target CPU
remains stable throughout the availability check.

Signed-off-by: Shouxin Sun <sunshx@chinatelecom.cn>
Signed-off-by: Junnan Zhang <zhangjn11@chinatelecom.cn>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
Cc: Song Liu <song@kernel.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Jinchao Wang <wangjinchao600@gmail.com>
---
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

