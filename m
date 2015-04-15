From: akpm@linux-foundation.org
Subject: [merged]
 watchdog-clean-up-some-function-names-and-arguments.patch removed from -mm
 tree
Date: Wed, 15 Apr 2015 12:08:52 -0700
Message-ID: <552eb744.a0aBtYpWX+TtLDQ5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695AbbDOTIx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:08:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, dzickus@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: clean up some function names and arguments
has been removed from the -mm tree.  Its filename was
     watchdog-clean-up-some-function-names-and-arguments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: watchdog: clean up some function names and arguments

Rename the update_timers*() functions to update_watchdog*().

Remove the boolean argument from watchdog_enable_all_cpus() because
update_watchdog_all_cpus() is now a generic function to change the run
state of the lockup detectors and to have the lockup detectors use a new
sample period.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN kernel/watchdog.c~watchdog-clean-up-some-function-names-and-arguments kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-clean-up-some-function-names-and-arguments
+++ a/kernel/watchdog.c
@@ -653,7 +653,7 @@ static void restart_watchdog_hrtimer(voi
 				HRTIMER_MODE_REL_PINNED);
 }
 
-static void update_timers(int cpu)
+static void update_watchdog(int cpu)
 {
 	/*
 	 * Make sure that perf event counter will adopt to a new
@@ -668,17 +668,17 @@ static void update_timers(int cpu)
 	watchdog_nmi_enable(cpu);
 }
 
-static void update_timers_all_cpus(void)
+static void update_watchdog_all_cpus(void)
 {
 	int cpu;
 
 	get_online_cpus();
 	for_each_online_cpu(cpu)
-		update_timers(cpu);
+		update_watchdog(cpu);
 	put_online_cpus();
 }
 
-static int watchdog_enable_all_cpus(bool sample_period_changed)
+static int watchdog_enable_all_cpus(void)
 {
 	int err = 0;
 
@@ -688,8 +688,12 @@ static int watchdog_enable_all_cpus(bool
 			pr_err("Failed to create watchdog threads, disabled\n");
 		else
 			watchdog_running = 1;
-	} else if (sample_period_changed) {
-		update_timers_all_cpus();
+	} else {
+		/*
+		 * Enable/disable the lockup detectors or
+		 * change the sample period 'on the fly'.
+		 */
+		update_watchdog_all_cpus();
 	}
 
 	return err;
@@ -721,7 +725,7 @@ static int proc_watchdog_update(void)
 	 * or disabled 'on the fly'.
 	 */
 	if (watchdog_enabled && watchdog_thresh)
-		err = watchdog_enable_all_cpus(true);
+		err = watchdog_enable_all_cpus();
 	else
 		watchdog_disable_all_cpus();
 
@@ -861,5 +865,5 @@ void __init lockup_detector_init(void)
 	set_sample_period();
 
 	if (watchdog_enabled)
-		watchdog_enable_all_cpus(false);
+		watchdog_enable_all_cpus();
 }
_

Patches currently in -mm which might be from uobergfe@redhat.com are

origin.patch
linux-next.patch

