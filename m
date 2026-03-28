Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF5F337BB0
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671962; cv=none; b=N0aEoLv6qLRTJeq1Yt25KCoK0e3L2tRZsm8FBHFKkY3lIZpRSXo3J3Ii8a7+IHnEBsR+fw3xm8JpCMkTnTYYB8PvN6QWLoJZ2ef2fw43UM1cKCSKWVFCQ3Sxf5oBxo3vh7zVq9JnYi5W1rgXax30N/nurrtHAgXGUpvNbuahy0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671962; c=relaxed/simple;
	bh=kxPBscnAxNgHl1K47jZdlV1pkc2Bd4rKxyPR197RyAo=;
	h=Date:To:From:Subject:Message-Id; b=jk9GvpgYUPRCKu4qUMilmPc9wdQKoSg1qzsbAlgqiTqXM9PxuDtyXssNpGHrcgutx6dodz+EXFgF6z/KPq8UKFulDqkUO/t8KTK/aYdRCotDdrbcDsiI3js+sBZi+o8hCNK/rEc6ME1gltit1rs74CZEK39a7l8i8g3AfB56N/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JnidR3g4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JnidR3g4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088E6C19424;
	Sat, 28 Mar 2026 04:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671962;
	bh=kxPBscnAxNgHl1K47jZdlV1pkc2Bd4rKxyPR197RyAo=;
	h=Date:To:From:Subject:From;
	b=JnidR3g4AnTYqXZjk3DFYD/74W9dt9v2NTqMcex/bOoBeAMEt265kmNsRSSGkzJ6X
	 ITbROtmaWw8l8MJiX4zW+s5peJytjM3yLfQG7NonSF/GRMYJdzFhYxFfUUR9AZMSzt
	 UbMzj0lQcqiNoU6CmecwDU8TAnbNoo/KTmRoffW8=
Date: Fri, 27 Mar 2026 21:26:01 -0700
To: mm-commits@vger.kernel.org,wangjinchao600@gmail.com,skhan@linuxfoundation.org,pmladek@suse.com,max.kellermann@ionos.com,lihuafei1@huawei.com,irogers@google.com,eranian@google.com,dianders@chromium.org,cuiyunhui@bytedance.com,corbet@lwn.net,mrungta@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-hardlockup-improve-buddy-system-detection-timeliness.patch removed from -mm tree
Message-Id: <20260328042602.088E6C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog/hardlockup: improve buddy system detection timeliness
has been removed from the -mm tree.  Its filename was
     watchdog-hardlockup-improve-buddy-system-detection-timeliness.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mayank Rungta <mrungta@google.com>
Subject: watchdog/hardlockup: improve buddy system detection timeliness
Date: Thu, 12 Mar 2026 16:22:05 -0700

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

Link: https://lkml.kernel.org/r/20260312-hardlockup-watchdog-fixes-v2-4-45bd8a0cc7ed@google.com
Signed-off-by: Mayank Rungta <mrungta@google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: Max Kellermann <max.kellermann@ionos.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Stephane Erainan <eranian@google.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Yunhui Cui <cuiyunhui@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h     |    1 +
 kernel/watchdog.c       |   19 ++++++++++++++++---
 kernel/watchdog_buddy.c |    9 +--------
 3 files changed, 18 insertions(+), 11 deletions(-)

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
@@ -159,7 +167,7 @@ void watchdog_hardlockup_touch_cpu(unsig
 	per_cpu(watchdog_hardlockup_touched, cpu) = true;
 }
 
-static void watchdog_hardlockup_update(unsigned int cpu)
+static void watchdog_hardlockup_update_reset(unsigned int cpu)
 {
 	int hrint = atomic_read(&per_cpu(hrtimer_interrupts, cpu));
 
@@ -169,6 +177,7 @@ static void watchdog_hardlockup_update(u
 	 * written/read by a single CPU.
 	 */
 	per_cpu(hrtimer_interrupts_saved, cpu) = hrint;
+	per_cpu(hrtimer_interrupts_missed, cpu) = 0;
 }
 
 static bool is_hardlockup(unsigned int cpu)
@@ -176,10 +185,14 @@ static bool is_hardlockup(unsigned int c
 	int hrint = atomic_read(&per_cpu(hrtimer_interrupts, cpu));
 
 	if (per_cpu(hrtimer_interrupts_saved, cpu) != hrint) {
-		watchdog_hardlockup_update(cpu);
+		watchdog_hardlockup_update_reset(cpu);
 		return false;
 	}
 
+	per_cpu(hrtimer_interrupts_missed, cpu)++;
+	if (per_cpu(hrtimer_interrupts_missed, cpu) % watchdog_hardlockup_miss_thresh)
+		return false;
+
 	return true;
 }
 
@@ -198,7 +211,7 @@ void watchdog_hardlockup_check(unsigned
 	unsigned long flags;
 
 	if (per_cpu(watchdog_hardlockup_touched, cpu)) {
-		watchdog_hardlockup_update(cpu);
+		watchdog_hardlockup_update_reset(cpu);
 		per_cpu(watchdog_hardlockup_touched, cpu) = false;
 		return;
 	}
_

Patches currently in -mm which might be from mrungta@google.com are


