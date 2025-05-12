Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4C32EB10;
	Mon, 12 May 2025 00:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011371; cv=none; b=tJ4/GSMFQyxFdtRIsjV09dWVV9xQOem8kINCdWpY2HKMKHtXmHU4hmQD2bq4nQj/sZmbVNB1hNN38KKbehoRh9c1Eik7i62A5P8A9wXlDSv3nuwVh0cODbJ7qDsxOxzySQAsOl4y10IQwzf+XDceLJW6BfaKt7JhnpbSx1dgufg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011371; c=relaxed/simple;
	bh=VyoSqGrn/4tIikcnuM1J+sqlVZSbA3GDZkWE8V5poBQ=;
	h=Date:To:From:Subject:Message-Id; b=D7xHKsqxXILxp5NYjYj2G/N40wprytsgA8ChCV4jnQEeq1X1QTIR/h5v/zu9BCDqIA5Nj21sB+rXBMR5IGet8bI0YzTMMvKm7gEHEYdvrnoHBnfXbeg9NYZOoJFOtdR7/a3bkY7xjjOojcasyfiLwTt8az6MaAlu1DsS68j057c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xkApBvup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xkApBvup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23725C4CEE4;
	Mon, 12 May 2025 00:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011371;
	bh=VyoSqGrn/4tIikcnuM1J+sqlVZSbA3GDZkWE8V5poBQ=;
	h=Date:To:From:Subject:From;
	b=xkApBvup31kry0zxueuTRyID9x0ZG2Z/v1CpHQU0g2AdpQxxjI2GJW0eyryTU3jNf
	 kb3voN+fwdi0eFG5toaiRSsp2/jAN9MVr+BDt6yVsXKSrgac2xtOp43z9Jv45oNGLm
	 d7dha6/0ENhrNeSIhEh5rqF6U+bqbegob+QdeZgY=
Date: Sun, 11 May 2025 17:56:10 -0700
To: mm-commits@vger.kernel.org,venkat88@linux.ibm.com,tglx@linutronix.de,stable@vger.kernel.org,song@kernel.org,nysal@linux.ibm.com,joel.granados@kernel.org,dianders@chromium.org,luogengkun@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-fix-watchdog-may-detect-false-positive-of-softlockup.patch removed from -mm tree
Message-Id: <20250512005611.23725C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog: fix watchdog may detect false positive of softlockup
has been removed from the -mm tree.  Its filename was
     watchdog-fix-watchdog-may-detect-false-positive-of-softlockup.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Luo Gengkun <luogengkun@huaweicloud.com>
Subject: watchdog: fix watchdog may detect false positive of softlockup
Date: Mon, 21 Apr 2025 03:50:21 +0000

When updating `watchdog_thresh`, there is a race condition between writing
the new `watchdog_thresh` value and stopping the old watchdog timer.  If
the old timer triggers during this window, it may falsely detect a
softlockup due to the old interval and the new `watchdog_thresh` value
being used.  The problem can be described as follow:

 # We asuume previous watchdog_thresh is 60, so the watchdog timer is
 # coming every 24s.
echo 10 > /proc/sys/kernel/watchdog_thresh (User space)
|
+------>+ update watchdog_thresh (We are in kernel now)
	|
	|	  # using old interval and new `watchdog_thresh`
	+------>+ watchdog hrtimer (irq context: detect softlockup)
		|
		|
	+-------+
	|
	|
	+ softlockup_stop_all

To fix this problem, introduce a shadow variable for `watchdog_thresh`. 
The update to the actual `watchdog_thresh` is delayed until after the old
timer is stopped, preventing false positives.

The following testcase may help to understand this problem.

---------------------------------------------
echo RT_RUNTIME_SHARE > /sys/kernel/debug/sched/features
echo -1 > /proc/sys/kernel/sched_rt_runtime_us
echo 0 > /sys/kernel/debug/sched/fair_server/cpu3/runtime
echo 60 > /proc/sys/kernel/watchdog_thresh
taskset -c 3 chrt -r 99 /bin/bash -c "while true;do true; done" &
echo 10 > /proc/sys/kernel/watchdog_thresh &
---------------------------------------------

The test case above first removes the throttling restrictions for
real-time tasks.  It then sets watchdog_thresh to 60 and executes a
real-time task ,a simple while(1) loop, on cpu3.  Consequently, the final
command gets blocked because the presence of this real-time thread
prevents kworker:3 from being selected by the scheduler.  This eventually
triggers a softlockup detection on cpu3 due to watchdog_timer_fn operating
with inconsistent variable - using both the old interval and the updated
watchdog_thresh simultaneously.

[nysal@linux.ibm.com: fix the SOFTLOCKUP_DETECTOR=n case]
  Link: https://lkml.kernel.org/r/20250502111120.282690-1-nysal@linux.ibm.com
Link: https://lkml.kernel.org/r/20250421035021.3507649-1-luogengkun@huaweicloud.com
Signed-off-by: Luo Gengkun <luogengkun@huaweicloud.com>
Signed-off-by: Nysal Jan K.A. <nysal@linux.ibm.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: "Nysal Jan K.A." <nysal@linux.ibm.com>
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

--- a/kernel/watchdog.c~watchdog-fix-watchdog-may-detect-false-positive-of-softlockup
+++ a/kernel/watchdog.c
@@ -47,6 +47,7 @@ int __read_mostly watchdog_user_enabled
 static int __read_mostly watchdog_hardlockup_user_enabled = WATCHDOG_HARDLOCKUP_DEFAULT;
 static int __read_mostly watchdog_softlockup_user_enabled = 1;
 int __read_mostly watchdog_thresh = 10;
+static int __read_mostly watchdog_thresh_next;
 static int __read_mostly watchdog_hardlockup_available;
 
 struct cpumask watchdog_cpumask __read_mostly;
@@ -870,12 +871,20 @@ int lockup_detector_offline_cpu(unsigned
 	return 0;
 }
 
-static void __lockup_detector_reconfigure(void)
+static void __lockup_detector_reconfigure(bool thresh_changed)
 {
 	cpus_read_lock();
 	watchdog_hardlockup_stop();
 
 	softlockup_stop_all();
+	/*
+	 * To prevent watchdog_timer_fn from using the old interval and
+	 * the new watchdog_thresh at the same time, which could lead to
+	 * false softlockup reports, it is necessary to update the
+	 * watchdog_thresh after the softlockup is completed.
+	 */
+	if (thresh_changed)
+		watchdog_thresh = READ_ONCE(watchdog_thresh_next);
 	set_sample_period();
 	lockup_detector_update_enable();
 	if (watchdog_enabled && watchdog_thresh)
@@ -888,7 +897,7 @@ static void __lockup_detector_reconfigur
 void lockup_detector_reconfigure(void)
 {
 	mutex_lock(&watchdog_mutex);
-	__lockup_detector_reconfigure();
+	__lockup_detector_reconfigure(false);
 	mutex_unlock(&watchdog_mutex);
 }
 
@@ -908,27 +917,29 @@ static __init void lockup_detector_setup
 		return;
 
 	mutex_lock(&watchdog_mutex);
-	__lockup_detector_reconfigure();
+	__lockup_detector_reconfigure(false);
 	softlockup_initialized = true;
 	mutex_unlock(&watchdog_mutex);
 }
 
 #else /* CONFIG_SOFTLOCKUP_DETECTOR */
-static void __lockup_detector_reconfigure(void)
+static void __lockup_detector_reconfigure(bool thresh_changed)
 {
 	cpus_read_lock();
 	watchdog_hardlockup_stop();
+	if (thresh_changed)
+		watchdog_thresh = READ_ONCE(watchdog_thresh_next);
 	lockup_detector_update_enable();
 	watchdog_hardlockup_start();
 	cpus_read_unlock();
 }
 void lockup_detector_reconfigure(void)
 {
-	__lockup_detector_reconfigure();
+	__lockup_detector_reconfigure(false);
 }
 static inline void lockup_detector_setup(void)
 {
-	__lockup_detector_reconfigure();
+	__lockup_detector_reconfigure(false);
 }
 #endif /* !CONFIG_SOFTLOCKUP_DETECTOR */
 
@@ -946,11 +957,11 @@ void lockup_detector_soft_poweroff(void)
 #ifdef CONFIG_SYSCTL
 
 /* Propagate any changes to the watchdog infrastructure */
-static void proc_watchdog_update(void)
+static void proc_watchdog_update(bool thresh_changed)
 {
 	/* Remove impossible cpus to keep sysctl output clean. */
 	cpumask_and(&watchdog_cpumask, &watchdog_cpumask, cpu_possible_mask);
-	__lockup_detector_reconfigure();
+	__lockup_detector_reconfigure(thresh_changed);
 }
 
 /*
@@ -984,7 +995,7 @@ static int proc_watchdog_common(int whic
 	} else {
 		err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 		if (!err && old != READ_ONCE(*param))
-			proc_watchdog_update();
+			proc_watchdog_update(false);
 	}
 	mutex_unlock(&watchdog_mutex);
 	return err;
@@ -1035,11 +1046,13 @@ static int proc_watchdog_thresh(const st
 
 	mutex_lock(&watchdog_mutex);
 
-	old = READ_ONCE(watchdog_thresh);
+	watchdog_thresh_next = READ_ONCE(watchdog_thresh);
+
+	old = watchdog_thresh_next;
 	err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 
-	if (!err && write && old != READ_ONCE(watchdog_thresh))
-		proc_watchdog_update();
+	if (!err && write && old != READ_ONCE(watchdog_thresh_next))
+		proc_watchdog_update(true);
 
 	mutex_unlock(&watchdog_mutex);
 	return err;
@@ -1060,7 +1073,7 @@ static int proc_watchdog_cpumask(const s
 
 	err = proc_do_large_bitmap(table, write, buffer, lenp, ppos);
 	if (!err && write)
-		proc_watchdog_update();
+		proc_watchdog_update(false);
 
 	mutex_unlock(&watchdog_mutex);
 	return err;
@@ -1080,7 +1093,7 @@ static const struct ctl_table watchdog_s
 	},
 	{
 		.procname	= "watchdog_thresh",
-		.data		= &watchdog_thresh,
+		.data		= &watchdog_thresh_next,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_watchdog_thresh,
_

Patches currently in -mm which might be from luogengkun@huaweicloud.com are


