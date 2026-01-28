Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B471325C6F9
	for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 14:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769609542; cv=none; b=Nn9wmvUQpIp2LG4Bcu6xElRcqKuTLyVVY8PmbHJR4OLlN/qtk0tQALNg/KxnlP5U0iqb4lcdrKohSsdUxlRX/cDCWDda71jnXhOOPt/iiIZc2v2O2qrs2ZjAXhifgT0GFAk9hxeBP5DntG7KXLEJ2HgrVOLh+z++0ZkVJCbJ8yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769609542; c=relaxed/simple;
	bh=e4Y0gnq911FKNdWWWGAQnFXylREVdGWOawghZntWz9g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BdjFbwznihM4ObKD7YYViqQqh6P8AUJBiagOuPHwwaOCx6aW7ffFRSxK3xOATiIsc5YrvheeVihYt8fnc/6CtmkNJAbd5nOYIzc2flXngIZg+YyTWTJ2FDicId9xx5hA9aOYFTunXMXNTH/m3UqNj9BkFV0f7NRoS14945BWobA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WBqGhhuD; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WBqGhhuD"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-503347e8715so15584621cf.2
        for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 06:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769609539; x=1770214339; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NvwAkydsJHGg+bpnKIjXBjgXWCnzFDla2aq6C1Z3aaY=;
        b=WBqGhhuDueWKMTwZANCo4YGxLFH9OYDcmSa/hIweW5oIu19XeQJyL/gAakSRmnENlG
         cw+YC7lHvD8R9b4QR9vEF3375ZDK3LgN6gnxsyyUfs9TnhPhWqOIk8oEHPqDHSFdEOER
         F5j7Cu+bVNFrHSoxUQKwQDFtImw+eOIzSa5jZa3Y+lW4KxdKva58Ue/n4zXkZLaBCvYI
         jmTNVmzQACtu67pIJQ/7EZMVnGdBv+U1ujxAulO/CjTOawAuZ3TczUfDTjqniJtn4JLY
         eyrrHhWurD+hkM9jC5f4Z5BTXlZ51/AdgrJ2nfHwrYQhJ+YWZqd1VPHZFfFWWrkgD+Ak
         +RKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769609539; x=1770214339;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NvwAkydsJHGg+bpnKIjXBjgXWCnzFDla2aq6C1Z3aaY=;
        b=opRVL37lKQxNZcpZQU4fgemgLgbHB1d9N58FpI5Fe18JGW0PI0ZAmGm7z7vElh6zBJ
         fugVzEz0S+lKuwECTWfwA62jVLcbqogUdpsHb11++5B9NDxmGgB6OC8UwICKXczN774L
         EoNQ2m9Qux+DkHdi4N30MyiAWPlPVpYkBtzHxowYWx6CTrlYFWX19Cb65ux1V2XN47t4
         leN0z6maNcf/TBBgpJKCkXd7TBd4dxYVcqMVLDMYzOjijJvPTB/UCKzG1O8JkH+07H14
         zMMEMDlg016FegCFqDY7SxzzdTHGIgQDh+GWVAsME5ymH9rI9nIZOiB/a2exg/Ci1Yke
         llpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVj17Cs8LbWmXV1pLUr6+YFRfgt/BK425cCwvAVjoGSy1aOui+OHNlRtV3J34IMZU0ONnwhszXcHM6h@vger.kernel.org
X-Gm-Message-State: AOJu0YwOCn/5FQTP++iSYyFNsHTHhq4Ap+OwgMTQT2SJhueGL1lny1gO
	mjzCFcqJVcII8vXVurONVTmvhUb6wC6ZK8cDO9u8+AEJpxkiPcEgv1s81XbjORl0
X-Gm-Gg: AZuq6aKIpXO2zrCeEPHDE96koSUuLfzNScG9F2ms8ePYp/ueRAp0F3S6MKKKGq+pcs4
	9K9AAQJjconBDan6/NDRIUCsq1DvL7y5pPIykBQ2x6oAKOJKh+vPecMm64adfzhQ5jwqw/Pf/P2
	uzWGgluwxmiINSTWrnyQeuwquR0krmv5rdKgywUyCqyLu7QtzUoMxVBPUpRyGr+ILjItRmdaMsS
	XeMdS5hJU9UPhsNq5ydSUaU+ni+19Yt9SOUaesHdslnDNgbXTkd0oifNoz20ZK0Sitxdq2eLR1d
	9aApYvWOW0lWIcn4k7YhPebbyie/91don5OjMpviEgTCnuByml/InO/UVpm9myLb+XmWzbHzl0m
	+XWKz14njoJRpu83fvvRIVTmaMMG0tLLoZxts1rpTDAuWY2zQpdnEmD6+rH77q891F9o3jFGWMs
	d6zJw=
X-Received: by 2002:a05:7301:1698:b0:2b7:32fe:4bbb with SMTP id 5a478bee46e88-2b78d910144mr2963994eec.11.1769603031325;
        Wed, 28 Jan 2026 04:23:51 -0800 (PST)
Received: from debian ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a1abe57csm2783833eec.22.2026.01.28.04.23.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 04:23:50 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Li Huafei <lihuafei1@huawei.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jinchao Wang <wangjinchao600@gmail.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Yicong Yang <yangyicong@hisilicon.com>
Cc: linux-watchdog@vger.kernel.org,
	mm-commits@vger.kernel.org,
	Qiliang Yuan <realwujing@gmail.com>,
	Shouxin Sun <sunshx@chinatelecom.cn>,
	Junnan Zhang <zhangjn11@chinatelecom.cn>,
	Qiliang Yuan <yuanql9@chinatelecom.cn>,
	Douglas Anderson <dianders@chromium.org>,
	Song Liu <song@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8] watchdog/hardlockup: simplify perf event probe and remove per-cpu dependency
Date: Wed, 28 Jan 2026 07:23:15 -0500
Message-ID: <20260128122330.1761777-1-realwujing@gmail.com>
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

