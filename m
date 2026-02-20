Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740942FF158
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 21:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771622449; cv=none; b=qZ/1Az1+HdOTHeIigL0U7KIW4oLkVJYoCCqIV0VrY8OwVXd47sar5AcfJP04JRIvieD+Bo9sMzzei+WgyLsvIDam9mEsAMTxAiDuwlMkJbdeGH4bxSl9AIxnOZ0YO+yBanZW4yI7Cqg02I5Axp1gRnkkogm53btciu6K9lHVel4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771622449; c=relaxed/simple;
	bh=4ASFJnVVieFHqs28f7IUui9PksP1DOmDBKiiY/QjLBk=;
	h=Date:To:From:Subject:Message-Id; b=eSAy3xaj2s+tQxIXyo4ou2ts9a+c/MM0didwiq1HU90+RIJdZ1U+gvfOHx6eSCOa74j2VJD1p01WUJ2RJTZDSDQD2X4GLm/aT/ylQkL+wiKlUI/Gb6d2PhFZoZXsDPRN4HVsYrDcLDm1zIAqtEIbz62siYgiSJWfdIXCvgq1rc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rlkaaalD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rlkaaalD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C91C116C6;
	Fri, 20 Feb 2026 21:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771622449;
	bh=4ASFJnVVieFHqs28f7IUui9PksP1DOmDBKiiY/QjLBk=;
	h=Date:To:From:Subject:From;
	b=rlkaaalDmeepmq16wsLM8p2lIlqCUCGqy3kMyuBS/TTWv7/JKqPbUFp0t1OFVFg0d
	 /rZRJb/22WbNBl+uJkKPzZLqM9quVz21X8pDlC6saSv4FsGBVfaQhhVWGry9q3CqKY
	 00FRcRg6Y+ptRKVBaU0UNIR64WiZlbDLZgtHkXMg=
Date: Fri, 20 Feb 2026 13:20:48 -0800
To: mm-commits@vger.kernel.org,wangjinchao600@gmail.com,pmladek@suse.com,max.kellermann@ionos.com,lihuafei1@huawei.com,irogers@google.com,eranian@google.com,dianders@chromium.org,cuiyunhui@bytedance.com,corbet@lwn.net,mrungta@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-hardlockup-improve-buddy-system-detection-timeliness.patch added to mm-nonmm-unstable branch
Message-Id: <20260220212049.28C91C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog/hardlockup: improve buddy system detection timeliness
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-hardlockup-improve-buddy-system-detection-timeliness.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-hardlockup-improve-buddy-system-detection-timeliness.patch

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
From: Mayank Rungta <mrungta@google.com>
Subject: watchdog/hardlockup: improve buddy system detection timeliness
Date: Thu, 12 Feb 2026 14:12:12 -0700

Currently, the buddy system only performs checks every 3rd sample.  With a
4-second interval.  If a check window is missed, the next check occurs 12
seconds later, potentially delaying hard lockup detection for up to 24
seconds.

Modify the buddy system to perform checks at every interval (4s). 
Introduce a missed-interrupt threshold to maintain the existing grace
period while reducing the detection window to 8-12 seconds.

Best and worst case detection scenarios:

Before (12s check window):
- Best case: Lockup occurs after first check but just before heartbeat
  interval. Detected in ~8s (8s till next check).
- Worst case: Lockup occurs just after a check.
  Detected in ~24s (missed check + 12s till next check + 12s logic).

After (4s check window with threshold of 3):
- Best case: Lockup occurs just before a check.
  Detected in ~8s (0s till 1st check + 4s till 2nd + 4s till 3rd).
- Worst case: Lockup occurs just after a check.
  Detected in ~12s (4s till 1st check + 4s till 2nd + 4s till 3rd).

Link: https://lkml.kernel.org/r/20260212-hardlockup-watchdog-fixes-v1-3-745f1dce04c3@google.com
Signed-off-by: Mayank Rungta <mrungta@google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: Max Kellermann <max.kellermann@ionos.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Stephane Erainan <eranian@google.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Yunhui Cui <cuiyunhui@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h     |    1 +
 kernel/watchdog.c       |   18 ++++++++++++++++--
 kernel/watchdog_buddy.c |    9 +--------
 3 files changed, 18 insertions(+), 10 deletions(-)

--- a/include/linux/nmi.h~watchdog-hardlockup-improve-buddy-system-detection-timeliness
+++ a/include/linux/nmi.h
@@ -21,6 +21,7 @@ void lockup_detector_soft_poweroff(void)
 extern int watchdog_user_enabled;
 extern int watchdog_thresh;
 extern unsigned long watchdog_enabled;
+extern int watchdog_hardlockup_miss_thresh;
 
 extern struct cpumask watchdog_cpumask;
 extern unsigned long *watchdog_cpumask_bits;
--- a/kernel/watchdog_buddy.c~watchdog-hardlockup-improve-buddy-system-detection-timeliness
+++ a/kernel/watchdog_buddy.c
@@ -21,6 +21,7 @@ static unsigned int watchdog_next_cpu(un
 
 int __init watchdog_hardlockup_probe(void)
 {
+	watchdog_hardlockup_miss_thresh = 3;
 	return 0;
 }
 
@@ -86,14 +87,6 @@ void watchdog_buddy_check_hardlockup(int
 {
 	unsigned int next_cpu;
 
-	/*
-	 * Test for hardlockups every 3 samples. The sample period is
-	 *  watchdog_thresh * 2 / 5, so 3 samples gets us back to slightly over
-	 *  watchdog_thresh (over by 20%).
-	 */
-	if (hrtimer_interrupts % 3 != 0)
-		return;
-
 	/* check for a hardlockup on the next CPU */
 	next_cpu = watchdog_next_cpu(smp_processor_id());
 	if (next_cpu >= nr_cpu_ids)
--- a/kernel/watchdog.c~watchdog-hardlockup-improve-buddy-system-detection-timeliness
+++ a/kernel/watchdog.c
@@ -61,6 +61,13 @@ int __read_mostly sysctl_hardlockup_all_
 # endif /* CONFIG_SMP */
 
 /*
+ * Number of consecutive missed interrupts before declaring a lockup.
+ * Default to 1 (immediate) for NMI/Perf. Buddy will overwrite this to 3.
+ */
+int __read_mostly watchdog_hardlockup_miss_thresh = 1;
+EXPORT_SYMBOL_GPL(watchdog_hardlockup_miss_thresh);
+
+/*
  * Should we panic when a soft-lockup or hard-lockup occurs:
  */
 unsigned int __read_mostly hardlockup_panic =
@@ -137,6 +144,7 @@ __setup("nmi_watchdog=", hardlockup_pani
 
 static DEFINE_PER_CPU(atomic_t, hrtimer_interrupts);
 static DEFINE_PER_CPU(int, hrtimer_interrupts_saved);
+static DEFINE_PER_CPU(int, hrtimer_interrupts_missed);
 static DEFINE_PER_CPU(bool, watchdog_hardlockup_warned);
 static DEFINE_PER_CPU(bool, watchdog_hardlockup_touched);
 static unsigned long hard_lockup_nmi_warn;
@@ -163,8 +171,13 @@ static bool is_hardlockup(unsigned int c
 {
 	int hrint = atomic_read(&per_cpu(hrtimer_interrupts, cpu));
 
-	if (per_cpu(hrtimer_interrupts_saved, cpu) == hrint)
-		return true;
+	if (per_cpu(hrtimer_interrupts_saved, cpu) == hrint) {
+		per_cpu(hrtimer_interrupts_missed, cpu)++;
+		if (per_cpu(hrtimer_interrupts_missed, cpu) >= watchdog_hardlockup_miss_thresh)
+			return true;
+
+		return false;
+	}
 
 	/*
 	 * NOTE: we don't need any fancy atomic_t or READ_ONCE/WRITE_ONCE
@@ -172,6 +185,7 @@ static bool is_hardlockup(unsigned int c
 	 * written/read by a single CPU.
 	 */
 	per_cpu(hrtimer_interrupts_saved, cpu) = hrint;
+	per_cpu(hrtimer_interrupts_missed, cpu) = 0;
 
 	return false;
 }
_

Patches currently in -mm which might be from mrungta@google.com are

watchdog-hardlockup-always-update-saved-interrupts-during-check.patch
doc-watchdog-clarify-hardlockup-detection-timing.patch
watchdog-hardlockup-improve-buddy-system-detection-timeliness.patch
doc-watchdog-document-buddy-detector.patch

