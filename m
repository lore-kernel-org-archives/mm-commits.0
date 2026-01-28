Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE517229B2A
	for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 13:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769608088; cv=none; b=mpcI2dJZ/Z/EiPvgdpke2DpdKNTGOMexMjD2Lxc7DTBWiFYkYCfB5eE3N6ar0AnrIm5vpC26+o+E9vvSOBNnRSYzwMDXI/jvj/IV/qVB2fFT6fJR0k2KzVPtR6wvKSdHFH+AW9UF1+w2D6IJrYtQrAeBRhnUdjVGSduacfi2Erw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769608088; c=relaxed/simple;
	bh=e4Y0gnq911FKNdWWWGAQnFXylREVdGWOawghZntWz9g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y8TxOjxqO70zUIjr+E2XSNhj7IA2mA2DBD1AqsvDyvcEILZ6K/2yoe/icfo2fzGw5j1Dny7tKbJHpSb8gaHfSbPMTXnFA73yvi6MdwMIXIB1PWBK573yBKLEuUZI/Fw+KammIb35kTCfqBhDzYhF688f+SQpP9qgwqwq8f64coo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cvVQ8yw1; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cvVQ8yw1"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2b70abe3417so15116644eec.0
        for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 05:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769608086; x=1770212886; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NvwAkydsJHGg+bpnKIjXBjgXWCnzFDla2aq6C1Z3aaY=;
        b=cvVQ8yw1BkfXjwh/13drzkIlXURMIYCjDQyJrYKDYT8+Z9gltcNXpqxYT9tKiY9nsd
         5o1Zpcxk5T5yOIvfa8V7AI3HjgVGWmMHRrlxigzcvQdqwXp6O95Abv1MO3swlTiy7a3B
         +aZOYQInEQ/dBKHuRY0ob2oXAczkNZpi2IkKDeHvdQwAAgovlidyj1RZF1dS05ydUayR
         lqvHIgMOZMDB/a8F2DacLj0ZHBXcC2JsBUHMkjXxXIFzSRFciVsxgSJ/jMoqbQ7IsRAZ
         yncGAg1LODckBfF0DCC5L09+61Mqo67KQLaF6mAmC/dfQ9s4T6VvE9EiHpYUm9sF8UUk
         hDSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769608086; x=1770212886;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NvwAkydsJHGg+bpnKIjXBjgXWCnzFDla2aq6C1Z3aaY=;
        b=w6NJ2ibdnAUOiDx4jT/dtzHMdV+WUZbvUzUGvzCTrhX//JaXS8yRZ0WvKTjPWbdjT3
         xUsCdilCV8iEn2sopyCcOsARH4APptqOyc7K/VUWZjODewha/Nc9pxYWWbud8Nosv/TW
         5I+o2GfmDvjFIw09gL1y6Yw9VmyrI0oZ2V0e8n99YuyNKZ0HHzewg9FVMmEZlwdnHuPa
         48M2EPQGLywvSZFR3aJPgUvWGTkx5s3r5bxWcY7v6tykAxG1HtIsQBtPWKejc5FGLexH
         rIElyvrqVS8chJHeqZrBJ3KqYhLV+f1935XNAUKGgABPdl15vJsIK7yoFyeQYQzEoOEE
         MSnA==
X-Forwarded-Encrypted: i=1; AJvYcCVUCuxMe9ic1NjxQSvkDlzdKwTCcQW9Cox8laPibTuaVE2Lym9Y2/Bb3rTp7ql2rn/PQXIfdv0qvSdm@vger.kernel.org
X-Gm-Message-State: AOJu0YwOyc6gmg5fBMkVmETMJwd7BIAYbLssWylG9+0Z4jkWWJ0Hj+gT
	cCgm8fHKWOwmqv3BJfqd8E2OqdAnLBK6bASNBbKNjn6DK1Jr+RaKxMKC8mXHDheB
X-Gm-Gg: AZuq6aLekYrtc4xgO/3LJf9woudb8RjoAVb91Z+mSNqEAxdpqw1MqEZzC6EApqwzErF
	vd8oXcJf2y6UPA3R/elfU0DNWc/A+Xg6TnsVeDDD1U7Z5OVGXdIgt73i4U3g2lI+ouCUUnjXIU3
	2rnCG77Y/uF5wl1IZJhdQl+EjhUHgdAOWPJNUuKj5R9QNKc1xYRNJ+833tzhK4/wdK+LxAIAfBC
	HG6qY+bap5+dR1iy/+hZIgLf4DB+YQxWkVTriWm9sUnwnGqeozgPwTUe3sTOTy2eMl0gxrBeXED
	z/9ydaZuntxjMb+BYTgxQQNM0R4VWSVkOiFQrRWjLuUcWn6weG69RWGByzrftlkRMElIxfrxKOK
	W7VHacXgY1xbwZrbi7aoQ0VQpklvE6yGjNg2dZq5k4MymuhbmWvfC8wAZ8cVJHoTj6Eu05hmXtz
	QyrCc=
X-Received: by 2002:a05:7022:e0e:b0:11e:70d8:5dbb with SMTP id a92af1059eb24-124a005f9damr2907058c88.7.1769601247809;
        Wed, 28 Jan 2026 03:54:07 -0800 (PST)
Received: from debian ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-124a9debe5dsm2173511c88.11.2026.01.28.03.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 03:54:07 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
To: Ingo Molnar <mingo@kernel.org>,
	Qiliang Yuan <realwujing@gmail.com>,
	Li Huafei <lihuafei1@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jinchao Wang <wangjinchao600@gmail.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Yicong Yang <yangyicong@hisilicon.com>
Cc: linux-watchdog@vger.kernel.org,
	mm-commits@vger.kernel.org,
	Shouxin Sun <sunshx@chinatelecom.cn>,
	Junnan Zhang <zhangjn11@chinatelecom.cn>,
	Qiliang Yuan <yuanql9@chinatelecom.cn>,
	Douglas Anderson <dianders@chromium.org>,
	Song Liu <song@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8] watchdog/hardlockup: simplify perf event probe and remove per-cpu dependency
Date: Wed, 28 Jan 2026 06:53:44 -0500
Message-ID: <20260128115358.1757147-1-realwujing@gmail.com>
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
v8:
- Add Signed-off-by with work email.
- v7 link: https://lore.kernel.org/all/20260128060833.1715622-1-realwujing@gmail.com/
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

