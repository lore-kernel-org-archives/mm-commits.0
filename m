From: akpm@linux-foundation.org
Subject: + watchdog-store-the-watchdog-sample-period-as-a-variable.patch added to -mm tree
Date: Tue, 04 Dec 2012 11:58:11 -0800
Message-ID: <20121204195812.6DA3120044F@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:51052 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab2LDT6O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2012 14:58:14 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so311138fae.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Dec 2012 11:58:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chuansheng.liu@intel.com, dzickus@redhat.com


The patch titled
     Subject: watchdog: store the watchdog sample period as a variable
has been added to the -mm tree.  Its filename is
     watchdog-store-the-watchdog-sample-period-as-a-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chuansheng Liu <chuansheng.liu@intel.com>
Subject: watchdog: store the watchdog sample period as a variable

Currently getting the sample period is always thru a complex
calculation: get_softlockup_thresh() * ((u64)NSEC_PER_SEC / 5).

We can store the sample period as a variable, and set it as __read_mostly
type.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
Cc: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN kernel/watchdog.c~watchdog-store-the-watchdog-sample-period-as-a-variable kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-store-the-watchdog-sample-period-as-a-variable
+++ a/kernel/watchdog.c
@@ -31,6 +31,7 @@
 int watchdog_enabled = 1;
 int __read_mostly watchdog_thresh = 10;
 static int __read_mostly watchdog_disabled;
+static u64 __read_mostly sample_period;
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
 static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
@@ -116,7 +117,7 @@ static unsigned long get_timestamp(int t
 	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
 }
 
-static u64 get_sample_period(void)
+static void set_sample_period(void)
 {
 	/*
 	 * convert watchdog_thresh from seconds to ns
@@ -125,7 +126,7 @@ static u64 get_sample_period(void)
 	 * and hard thresholds) to increment before the
 	 * hardlockup detector generates a warning
 	 */
-	return get_softlockup_thresh() * ((u64)NSEC_PER_SEC / 5);
+	sample_period = get_softlockup_thresh() * ((u64)NSEC_PER_SEC / 5);
 }
 
 /* Commands for resetting the watchdog */
@@ -277,7 +278,7 @@ static enum hrtimer_restart watchdog_tim
 	wake_up_process(__this_cpu_read(softlockup_watchdog));
 
 	/* .. and repeat */
-	hrtimer_forward_now(hrtimer, ns_to_ktime(get_sample_period()));
+	hrtimer_forward_now(hrtimer, ns_to_ktime(sample_period));
 
 	if (touch_ts == 0) {
 		if (unlikely(__this_cpu_read(softlockup_touch_sync))) {
@@ -360,7 +361,7 @@ static void watchdog_enable(unsigned int
 	hrtimer->function = watchdog_timer_fn;
 
 	/* done here because hrtimer_start can only pin to smp_processor_id() */
-	hrtimer_start(hrtimer, ns_to_ktime(get_sample_period()),
+	hrtimer_start(hrtimer, ns_to_ktime(sample_period),
 		      HRTIMER_MODE_REL_PINNED);
 
 	/* initialize timestamp */
@@ -387,7 +388,7 @@ static int watchdog_should_run(unsigned 
 /*
  * The watchdog thread function - touches the timestamp.
  *
- * It only runs once every get_sample_period() seconds (4 seconds by
+ * It only runs once every sample_period seconds (4 seconds by
  * default) to reset the softlockup timestamp. If this gets delayed
  * for more than 2*watchdog_thresh seconds then the debug-printout
  * triggers in watchdog_timer_fn().
@@ -520,6 +521,7 @@ int proc_dowatchdog(struct ctl_table *ta
 	if (ret || !write)
 		return ret;
 
+	set_sample_period();
 	if (watchdog_enabled && watchdog_thresh)
 		watchdog_enable_all_cpus();
 	else
@@ -541,6 +543,7 @@ static struct smp_hotplug_thread watchdo
 
 void __init lockup_detector_init(void)
 {
+	set_sample_period();
 	if (smpboot_register_percpu_thread(&watchdog_threads)) {
 		pr_err("Failed to create watchdog threads, disabled\n");
 		watchdog_disabled = -ENODEV;
_

Patches currently in -mm which might be from chuansheng.liu@intel.com are

linux-next.patch
watchdog-store-the-watchdog-sample-period-as-a-variable.patch

