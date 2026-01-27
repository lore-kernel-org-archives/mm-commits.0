Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D55829A30E
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 02:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769480591; cv=none; b=Tu5H/+mDFqBBwoPN+0lW+MOlICZZJckuCQnMqX2tewrpIa5yspJkzlqQmyxSyS5EbcGaT/isTxKzuC10n4Zp8J6ky+9YFvbZwx9eXTqmTPFP7yJ2KYZuRJr+KlyAwCSf9VSYqYZJUI7H9Mi3YhsKonzQ+ioW33lD9bv0LMFpYaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769480591; c=relaxed/simple;
	bh=N64M/JIJLJwol49yhjrUkcj2FnRP1GWKH932vmf5iHg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MNRSYWUweAEKjV2q/s7aWc/t4j25gtIKF80TLztBlWdZupDAcw8HioshT8WVxK239m2AYKmPv3BBXZbLL3jYIDlTDCP570KKdOZ0Bh7KMfhYv4g1PH76iiwZvGN5RciesgK64q1jzFjy2NFIkT+IO4RgTOuD4An5tgITpyB1Tz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dlcal7hw; arc=none smtp.client-ip=74.125.82.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dlcal7hw"
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-12339e2e2c1so3339008c88.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 18:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769480588; x=1770085388; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C/BKwe8/Yc0esAHXSWFatM1ucuc0hnp+X30KfdTTAPY=;
        b=Dlcal7hwWTDZxQTCOfnwtmBy8iOvHqQIJvt/bhR9jpoyNep7Rzy7GxNkhmxJEQKiQy
         yYbwJRA7THKCc62/Oe3LpKzIQLxIhYdawEv3GACkuWacW2saOFh5qwxg+ghI3gDDlq/+
         zYPK3zG9q6qrP4+UrIUPinfQI9nTB7T/7MelW+2SJgfIDF2JoXjokE0L+fHpYYhpjoI9
         XrxZFXbu60IM2lNwJKeH+dzEWgwjUyUWS9VvRS1ISFYdIP0dBsd2ehNY7maJApDM+pgj
         GxoSfdAarSs5FxsD3pr4dZldhTssR+MFqx+6aQawuiMl+T2nneWZASvc6zDA1jV1Y0b4
         Y10A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769480588; x=1770085388;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C/BKwe8/Yc0esAHXSWFatM1ucuc0hnp+X30KfdTTAPY=;
        b=AEziZ3Uonw0KkUI6ttWU47ll1/h/LX2gaAlUvCswinRZskQsqOvn7DcEBxpeP1hVUw
         CnS3Mm0kmvLEyhrjZ1Ydnds27d7DuSzIInuQN1CgQwGIMFbUNklyO2EH1kQJTFnvnuFb
         9Pa99pt0KQt7z3vGfZhlvndkFIIfOUndLonswif+iA0uNBv50OIGG5tKFpzih5ORRGcd
         6LWFazI6lT/fISHEY526yNUrWrPpzcEGQs0x7s3gaQgiz0cm8L9WSO9OayRgyXQjiVRM
         1vWCnKh2lfcw/anQ4QhonYa3XCdnYgdCpEIeChf6XkqYde5wT25t4j6zr34D3t98ThF6
         4LGg==
X-Forwarded-Encrypted: i=1; AJvYcCUs6V5LfPNORDD57r5oA4QEiUA/4j+fn/BW5pKCnfeBZPOPHNa0sgz96i3N8b6ORshENGpQJqXluRAO@vger.kernel.org
X-Gm-Message-State: AOJu0YyIKQd3iU0VZQikWrtnwTRIqHSzd1RvHmiob022kBq9v6eSqNpj
	8OqpuwXMGq/JymhhU3TFssxG8DggLAoFPvDzc/3hUJfHHVHhqJ8Ij6Cv
X-Gm-Gg: AZuq6aK1nOVB96WR0PBxCD6XxiKOIZ+X0jzjhlGHXk3hhxhtN2+MmeeGlRS4tTqXu0j
	v8AEJKMsH/ZC5Ds2i5QOWR64jqZ12mEZddIfYfF5jm/5XzwH0WbP+EpX4a7UBvTLOWp3jcVXyDu
	iocuphHEj1pTRPbD47dhIR9K2OAeZIwbZuKge2p/wBKeNbNUFFborWbnRpJRqKDnjaalPOHjw8S
	MzPKP8dVOP+Z4m6aeMCgiJU2OVSbKlmkhGqhSU0MK9HdsineF4AqGYeSrECRx/ld4IrEvIW5z77
	UUNi/qvxqYRDw1l+yTn2VKyz6b7xUrELtVZevr30ViV62nL8RROh4HuCW+6orB/pmh5qB9dvYyU
	44vFT1CdSdUAFXdRa7QbOXON0qJKPLJ2bNrHwi19PoYBUJKaOgV6DpmtG1LAp4mRPf3GsPMms1L
	g9YSY=
X-Received: by 2002:a05:7022:6725:b0:11b:9386:a383 with SMTP id a92af1059eb24-124a0e8a130mr52799c88.22.1769480588356;
        Mon, 26 Jan 2026 18:23:08 -0800 (PST)
Received: from debian ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1247d90cda6sm20111224c88.1.2026.01.26.18.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 18:23:08 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
To: Ingo Molnar <mingo@kernel.org>,
	Qiliang Yuan <realwujing@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Li Huafei <lihuafei1@huawei.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Jinchao Wang <wangjinchao600@gmail.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Petr Mladek <pmladek@suse.com>,
	Pingfan Liu <kernelfans@gmail.com>,
	Lecopzer Chen <lecopzer.chen@mediatek.com>,
	Douglas Anderson <dianders@chromium.org>
Cc: linux-watchdog@vger.kernel.org,
	mm-commits@vger.kernel.org,
	Shouxin Sun <sunshx@chinatelecom.cn>,
	Junnan Zhang <zhangjn11@chinatelecom.cn>,
	Qiliang Yuan <yuanql9@chinatelecom.cn>,
	Song Liu <song@kernel.org>,
	stable@vger.kernel.org,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5] watchdog/hardlockup: Fix UAF in perf event cleanup due to migration race
Date: Mon, 26 Jan 2026 21:22:24 -0500
Message-ID: <20260127022238.1182079-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

Fixes: 930d8f8dbab9 ("watchdog/perf: adapt the watchdog_perf interface for async model")
Signed-off-by: Shouxin Sun <sunshx@chinatelecom.cn>
Signed-off-by: Junnan Zhang <zhangjn11@chinatelecom.cn>
Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
Cc: Song Liu <song@kernel.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Jinchao Wang <wangjinchao600@gmail.com>
Cc: <stable@vger.kernel.org>
---
v5:
- Refine description: clarify it identifies a latent bug in the mainline
  asynchronous retry path where worker threads lack PF_PERCPU_THREAD.
v4:
- Add cpu_hotplug_disable() in watchdog_hardlockup_probe() to stabilize
  the probe CPU.
- Update description to explain the relevance of 4.19 logs.
v3:
- Refactor hardlockup_detector_event_create() to be stateless.
v2:
- Add Cc stable.

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

