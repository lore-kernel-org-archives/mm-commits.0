Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D51D3EBF01;
	Sat, 24 Jan 2026 23:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769297446; cv=none; b=PuajNM9cMHjcRZCbdXW0Aeqnf+AbbUIweT9nyqYU96GGkufGUWlMvlOedNhWd04SSfoGcMgS5OYyHv8HwF/7xnhWdbbJi7r1F7ZC8sWpF+Fh7CqWizd5E07iTy+fAAtqf32Z8DE/66+U+whBYFg+gSOJh6YIaGn6t/eOsxqk45w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769297446; c=relaxed/simple;
	bh=KtuxpYhTJgxrsVD9d5MOe40dD9EQTJrjGyg/UnFbEwE=;
	h=Date:To:From:Subject:Message-Id; b=Zho+GTDRe2IZvRbC1dLJWvxFUNHS6PPaJm6mnCm0XitPvhyYxqpKyJZOJVMgXk28WT/i1Fpr5lwDGhal74KVR5rOMo/0hZVq1Ntz8Tte4xhZKkRcBlpZe8suy/a/5TTZ4XZYBdWEqMJWCwCZnjCscaQhti57eOJucmo0LFTqK0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r1KYNGMC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r1KYNGMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B402C116D0;
	Sat, 24 Jan 2026 23:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769297445;
	bh=KtuxpYhTJgxrsVD9d5MOe40dD9EQTJrjGyg/UnFbEwE=;
	h=Date:To:From:Subject:From;
	b=r1KYNGMC+JPYgqMmiD7HoPvxhN7uA7qQBl+9AQ0bsaBeNfDvb8Jz1Aiiec5+IyNWF
	 /DbQUNcL6YAktc3V6jMY/p8Zbg+3hPHGUFliEZRrlyi3hCzIi7hZwZ1Ih1Lflz9hMP
	 IO120baqdLNsMM3JGTYXYZ9NSQ50xmf6YEpHP6c4=
Date: Sat, 24 Jan 2026 15:30:44 -0800
To: mm-commits@vger.kernel.org,zhangjn11@chinatelecom.cn,yuanql9@chinatelecom.cn,yangyicong@hisilicon.com,wangjinchao600@gmail.com,thorsten.blum@linux.dev,sunshx@chinatelecom.cn,stable@vger.kernel.org,song@kernel.org,mingo@kernel.org,lihuafei1@huawei.com,dianders@chromium.org,realwujing@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-hardlockup-fix-uaf-in-perf-event-cleanup-due-to-migration-race.patch added to mm-nonmm-unstable branch
Message-Id: <20260124233045.5B402C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog/hardlockup: fix UAF in perf event cleanup due to migration race
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-hardlockup-fix-uaf-in-perf-event-cleanup-due-to-migration-race.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-hardlockup-fix-uaf-in-perf-event-cleanup-due-to-migration-race.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Qiliang Yuan <realwujing@gmail.com>
Subject: watchdog/hardlockup: fix UAF in perf event cleanup due to migration race
Date: Sat, 24 Jan 2026 02:08:14 -0500

Original analysis on Linux 4.19 showed a race condition in the hardlockup
detector's initialization phase.  Specifically, during the early probe
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
released the event on CPU 2, but then migrated to CPU 3 before the cleanup
logic could run.  This left watchdog_ev on CPU 2 pointing to a freed
event, resulting in a UAF when later accessed:

[26.540732] BUG: KASAN: use-after-free in perf_event_ctx_lock_nested.isra.72+0x6b/0x140
[26.542442] Read of size 8 at addr ff110006b360d718 by task kworker/2:1/94

Fix this by refactoring hardlockup_detector_event_create() to return the
created perf event instead of directly assigning it to the per-cpu
variable.  In the probe function, use an arbitrary CPU but ensure it
remains online via cpu_hotplug_disable() during the check.

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

watchdog-hardlockup-fix-uaf-in-perf-event-cleanup-due-to-migration-race.patch

