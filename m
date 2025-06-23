Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D774AA95C
	for <mm-commits@vger.kernel.org>; Mon, 23 Jun 2025 23:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750721455; cv=none; b=eTWxPnJaCzxSepq1akorLss1M05if6xu+hPPM0xvGu0SIFh6kdHVBiTs83fBFaGtD6yUaXONBt00Pbw3r2zMB9JUnnaRdQaohqB+CxQmQuYw/MCXN1YT8NxT28LVawog1JgpkiXgzTQ1gYc84WqHS9UYFTk84LWlIGTp2WrIAIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750721455; c=relaxed/simple;
	bh=jR4wUYPP4lz2shEJwb5x7Rin008j1gHdK3GLBAY3fwk=;
	h=Date:To:From:Subject:Message-Id; b=QCyAmXZqVA+CPV8MBU5HCAH+Clxr/ZVi1GhMyBhq8INYXrXIEmAzmzc3mpBAbpxTng1P94EF8A/rNTK5B00cOhrlhGXmTJqRzbInaOeHzlP0H9y0r9EO0sh7kTknC1LHbdFSNHs3c6RJFKyqAdYSDZqKM5NiE33mq3td69X93Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zzoN/upr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zzoN/upr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A57C4CEEA;
	Mon, 23 Jun 2025 23:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750721453;
	bh=jR4wUYPP4lz2shEJwb5x7Rin008j1gHdK3GLBAY3fwk=;
	h=Date:To:From:Subject:From;
	b=zzoN/uprVq/zyu+P1Uz5tQFAfxG21pC/mlBeVV/NGKhdzS5jhK2Gngzi7mbSclAnM
	 H2ikiTPVobwQgnsAh8U0RkJW59eh8UEBXmTsiZsskVTvPTRy6fsPMlec0elG2DKg/Y
	 7TZh6N8ww/gMhXiwEzwW3v/awJLEdryH2AG1DUDE=
Date: Mon, 23 Jun 2025 16:30:52 -0700
To: mm-commits@vger.kernel.org,zhanjie9@hisilicon.com,will@kernel.org,viresh.kumar@linaro.org,tglx@linutronix.de,sumit.garg@linaro.org,song@kernel.org,rafael@kernel.org,prime.zeng@hisilicon.com,lecopzer.chen@mediatek.com,kernelfans@gmail.com,Jonathan.Cameron@huawei.com,dianders@chromium.org,catalin.marinas@arm.com,yangyicong@hisilicon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-perf-provide-function-for-adjusting-the-event-period.patch added to mm-nonmm-unstable branch
Message-Id: <20250623233053.57A57C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog/perf: provide function for adjusting the event period
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-perf-provide-function-for-adjusting-the-event-period.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-perf-provide-function-for-adjusting-the-event-period.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yicong Yang <yangyicong@hisilicon.com>
Subject: watchdog/perf: provide function for adjusting the event period
Date: Thu, 19 Jun 2025 19:48:04 +0800

Patch series "Update the watchdog period according to real CPU frequency",
v2.

watchdog perf needs architecture to provide method for converting the
watchdog thresh to counter period.  For arm64 we're using the max CPU
frequency for doing the conversion which is from cpufreq driver.  But some
cpufreq driver are registered lately, for example cppc_cpufreq will be
registered at late initcall which is after the initialization of watchdog
perf (initialized in armv8_pmuv3 of device initcall).  In such case the
period of watchdog will not be accurate enough.  Fix this by registering a
cpufreq notifier and update the watchdog period once the cpufreq driver is
initialized.

Attach some Q&A raised by Andrew last time: [1]
https://lore.kernel.org/linux-arm-kernel/20250512160612.c10464075df3c7842b13da11@linux-foundation.org/

Q: What is the impact of this change?  Is the current code causing
   problems?  If so, what are they?  How is the end-user experience
   improved by this change?  Important info!

A: This will make NMI watchdog (hardlockup detector) work more
   accurately.  HARDLOCKUP_DETECTOR_PERF is driven by the PMU sample
   interrupts of cpu cycle event with period related to the watchdog
   threshold.  User will set the watchdog threshold in seconds (e.g.  10s
   by default) and for HARDLOCKUP_DETECTOR_PERF we need to convert the
   seconds to cycles to setup the PMU counter.  The coversion method is
   provided by the arhitecture by implementing hw_nmi_get_sample_period().
   For arm64 it's using max_cpufreq to do the conversion:

       cycle_event_period = threshold(s) * max_cpufreq(hz)

   Since arm64 doesn't have an architectural way to get the
   max_cpufreq, we use cpufreq_driver to get it.  If cpufreq_driver is not
   available, currently we use a safe max_cpufreq as 5GHz.  Without this
   patchset, if the cpufreq_driver is initialized after the hardlockup
   detector we'll use 5GHz for calculating the event period.  It's my case
   here as described in the coverletter.  That means in the default case
   (10s threshold) if the real max_cpufreq is 2.5GHz, the NMI watchdog is
   actually working in a 20s period.  With this patchset the period can be
   calibrated after the cpufreq driver is initialized, much more accurate.

Q: As far as I can tell, this patchset impacts arm64 only.  Do you
   think that other architectures should implement this?

A: It highly depends on the architecure's implementation of their
   HARDLOCKUP_DETECTOR_PERF (the implementation of
   hw_nmi_get_sample_period()).  If other architectures can gain the
   max_cpufreq without cpufreq driver they don't have this problems (seems
   x86 implement in another way and can gain the cpufreq by some
   arhitectural way).

Q: As far as I can tell, this patchset affects all cpufreq drivers
   which use late_initcall() (on arm64, of course).  Is this correct?

A: cpufreq drivers are not touched.  we registered a notifier block to
   the cpufreq framework so the changes to the cpufreq will notify us to
   see whether it's needed to modify the event period.

Q: It is asserted that we should use the *maximum* possible CPU
   frequency for this calculation.  Why?  I assume this is because we care
   about the minimum watchdog period?

A: Because it's impossbile to use the current frequency for calculating
   the counter period as it may change at any time.  Using maximum
   frequency will make the real period as close as possible to the
   expected watchdog thresh in a simplest way.


This patch (of 2):

Architectures using perf events for hard lockup detection need to convert
the watchdog_thresh to the event's period, some architectures (for example
arm64) perform this conversion using the CPU's maximum frequency which will
be acquired by cpufreq.

However when the lockup detector is initialized the cpufreq driver may not
be initialized, thus launching a watchdog with an inaccurate period.  

Provide a function hardlockup_detector_perf_adjust_period() to allowing
adjusting the event period.  Then the architecture can update with more
accurate period if cpufreq is initialized.

Link: https://lkml.kernel.org/r/20250619114805.16968-1-yangyicong@huawei.com
Link: https://lkml.kernel.org/r/20250619114805.16968-2-yangyicong@huawei.com
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Jie Zhan <zhanjie9@hisilicon.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Liu Pingfan <kernelfans@gmail.com>
Cc: Song Liu <song@kernel.org>
Cc: Sumit Garg <sumit.garg@linaro.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Zeng Tao <prime.zeng@hisilicon.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h    |    2 ++
 kernel/watchdog_perf.c |   23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+)

--- a/include/linux/nmi.h~watchdog-perf-provide-function-for-adjusting-the-event-period
+++ a/include/linux/nmi.h
@@ -103,10 +103,12 @@ void watchdog_hardlockup_check(unsigned
 extern void hardlockup_detector_perf_stop(void);
 extern void hardlockup_detector_perf_restart(void);
 extern void hardlockup_config_perf_event(const char *str);
+extern void hardlockup_detector_perf_adjust_period(int cpu, u64 period);
 #else
 static inline void hardlockup_detector_perf_stop(void) { }
 static inline void hardlockup_detector_perf_restart(void) { }
 static inline void hardlockup_config_perf_event(const char *str) { }
+static inline void hardlockup_detector_perf_adjust_period(int cpu, u64 period) { }
 #endif
 
 void watchdog_hardlockup_stop(void);
--- a/kernel/watchdog_perf.c~watchdog-perf-provide-function-for-adjusting-the-event-period
+++ a/kernel/watchdog_perf.c
@@ -187,6 +187,29 @@ void watchdog_hardlockup_disable(unsigne
 }
 
 /**
+ * hardlockup_detector_perf_adjust_period - Adjust the event period due
+ *                                          to cpu frequency change
+ * @cpu: The CPU whose event period will be adjusted
+ * @period: The target period to be set
+ */
+void hardlockup_detector_perf_adjust_period(int cpu, u64 period)
+{
+	struct perf_event *event = per_cpu(watchdog_ev, cpu);
+
+	if (!(watchdog_enabled & WATCHDOG_HARDLOCKUP_ENABLED))
+		return;
+
+	if (!event)
+		return;
+
+	if (event->attr.sample_period == period)
+		return;
+
+	if (perf_event_period(event, period))
+		pr_err("failed to change period to %llu\n", period);
+}
+
+/**
  * hardlockup_detector_perf_stop - Globally stop watchdog events
  *
  * Special interface for x86 to handle the perf HT bug.
_

Patches currently in -mm which might be from yangyicong@hisilicon.com are

watchdog-perf-provide-function-for-adjusting-the-event-period.patch
arm64-watchdog_hld-add-a-cpufreq-notifier-for-update-watchdog-thresh.patch

