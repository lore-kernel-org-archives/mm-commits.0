Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6C22F5A0D
	for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 14:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769610585; cv=none; b=nMuSEYjM8k3IZEw2l1FOdhRWHV+QmXhZE8oJLrSLnXlYCJbew512Fqlu3I1dRYKtqbQLFynw/QT5tX7Sep6I7kjYaPXVMYhH6X59CdPJtI+TDQuFg/8MowDA15GaqnyWyzQ/pGiLMLw4JDVp1fPJU/MBJzb4pYFdVDLBqWIKjXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769610585; c=relaxed/simple;
	bh=e4Y0gnq911FKNdWWWGAQnFXylREVdGWOawghZntWz9g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EMoDucxMkNmDqWoX7nmO3FlykxnaX88nNknddgHyxn2iK+VDsNHV1FaVDVo6dNYnyasy8HuKzkslENNfK1WBA9vt7pGzaMFkWipFLVGcHdLhv/Jaz8jJacZSKecGWCR74PbtB28ZAaa7JCvlOPFYx23pSiRkUYuOKa4CoAQ1wD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i3HgqtkT; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i3HgqtkT"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ffbea7fdf1so66343551cf.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 06:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769610583; x=1770215383; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NvwAkydsJHGg+bpnKIjXBjgXWCnzFDla2aq6C1Z3aaY=;
        b=i3HgqtkTn227tyBuaiP9mYQ0P+AS+51LmiycjOA7u6OKXeXvD7+014meI01fiEHgfH
         HU5QRCmxFpExJRsC3bu11gNwbdf6CK7hKYbFixnYtrkbuA+lsX2Re4D6nqadYzg6GkZJ
         EYbQZKn6aIF6sklm+sIaymNFV3JKHLt2/jhZ5tITMO3IAPOv+yZaDD5LzCY01RlgyPlR
         NmIkCfqEBI/F1KC7uIHvl8kjg9c3C7uR0jACe1fYpyiZswsBGvnXDYterVKe5u3AyRqg
         skoiJ/KRY0aHIgviMr7X5gv0ZZgwr8Uo4AiDw8vE8bQdYhk1eHk30sxt+4+0eWbtpmWq
         YHGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769610583; x=1770215383;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NvwAkydsJHGg+bpnKIjXBjgXWCnzFDla2aq6C1Z3aaY=;
        b=uxxdzuaOhe5C5GKToM9+7k/Pyk0A+6WxHvzMUJZ+qZUs+AqmVAIhAzyk+gITdGmXX4
         PYrTX81mp1msHcpqlVTtOkLpSwdsFwaAVepO8ybbFO8KXlkzFrnjWlcuLgQGrhS3WQm8
         X/SgHj8FOSL1gq7OJLFy9Mds8FBS3o7qQFKiewTFoeOJkJSwA/8375Ta2Pslmpdzyl4x
         fqcXLJzX1g9la2FiQS9GF3XwtvAHpRIwJp9MGUS3dnIaU9yPcberUmFSiKEzTCOxH/Oa
         7QAEONxngNjTh01+WcPcwa/VLmdpmb5O4pS/Pcb92ltix6AAZd5QenVqTT04+hfFHWgZ
         LsVA==
X-Forwarded-Encrypted: i=1; AJvYcCVf+5hIZT9JX/7IS2FHDukqxG6slZTqOtz2ZGYK+Nqx6A64NzJu5n0agMu59cO2If8gWrWUM61pGFdr@vger.kernel.org
X-Gm-Message-State: AOJu0YwrAEZ1HcDKkCWHdK+MMVgerAk2O5snNW9JrnqnStanZ7fHay84
	pTfwiMCifBf8EDz70CkrgTAwyAAKuIptoba+/uAdl6eRITidcLl9Hd0KmxFJKYHS
X-Gm-Gg: AZuq6aLhdl1lRijTkO8wTyjCZK2QbmY6qKB3TVHIlmg4atLoOxa/KLjlL2HEgPukaDr
	W7Pe60o23GXTB4AMpRqkfL19DH4y4TmyIKF3vc+02me4Y3xvShad+kCpYRlM+PINZaWVeqxbP1J
	zNGgugg8aD3bBvQdte9iEbMmHvN8IvKs6LkkAT7rDUU6qqAgdoUgu6MURBL78+xpumC9eo0/oc3
	adAR7b5vrzdtXWZHNUsSMCmCUcRVyKjfhquhlkwZq9q7sRiQZ1nhaZempNI+C+Iq1lKsLu5lam0
	1bJ2L37C6DLoaIy27tKGoTmwEDX9U0vuNxtwVA+4njr0YVyopurAI2m4SPpdcWpMvHLj2AY9Dqh
	+xpuxJzHMLMXi3+Y8BEumKlWhv0HdHgbUPKhvgQ70Zw89nX0QUL1/2Ed4GQa/2+hgfU9E6+DUNG
	rM53o=
X-Received: by 2002:a05:7022:6728:b0:11b:9386:a3bf with SMTP id a92af1059eb24-124a0129edfmr3289311c88.42.1769605012180;
        Wed, 28 Jan 2026 04:56:52 -0800 (PST)
Received: from debian ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-124a9efb4casm2192986c88.16.2026.01.28.04.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 04:56:51 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
To: Qiliang Yuan <realwujing@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Li Huafei <lihuafei1@huawei.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
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
Subject: [PATCH v8] watchdog/hardlockup: simplify perf event probe and remove per-cpu dependency
Date: Wed, 28 Jan 2026 07:56:25 -0500
Message-ID: <20260128125639.1767682-1-realwujing@gmail.com>
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

