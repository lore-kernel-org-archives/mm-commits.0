From: akpm@linux-foundation.org
Subject: + watchdog-clean-up-some-function-names-and-arguments.patch added to -mm tree
Date: Mon, 23 Feb 2015 13:20:53 -0800
Message-ID: <54eb99b5.MNY6DKmOZRIiMe8V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbbBWVUy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 16:20:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, dzickus@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: clean up some function names and arguments
has been added to the -mm tree.  Its filename is
     watchdog-clean-up-some-function-names-and-arguments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-clean-up-some-function-names-and-arguments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-clean-up-some-function-names-and-arguments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -641,7 +641,7 @@ static void restart_watchdog_hrtimer(voi
 				HRTIMER_MODE_REL_PINNED);
 }
 
-static void update_timers(int cpu)
+static void update_watchdog(int cpu)
 {
 	/*
 	 * Make sure that perf event counter will adopt to a new
@@ -656,17 +656,17 @@ static void update_timers(int cpu)
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
 
@@ -676,8 +676,12 @@ static int watchdog_enable_all_cpus(bool
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
@@ -709,7 +713,7 @@ static int proc_watchdog_update(void)
 	 * or disabled 'on the fly'.
 	 */
 	if (watchdog_enabled && watchdog_thresh)
-		err = watchdog_enable_all_cpus(true);
+		err = watchdog_enable_all_cpus();
 	else
 		watchdog_disable_all_cpus();
 
@@ -849,5 +853,5 @@ void __init lockup_detector_init(void)
 	set_sample_period();
 
 	if (watchdog_enabled)
-		watchdog_enable_all_cpus(false);
+		watchdog_enable_all_cpus();
 }
_

Patches currently in -mm which might be from uobergfe@redhat.com are

watchdog-new-definitions-and-variables-initialization.patch
watchdog-introduce-the-proc_watchdog_update-function.patch
watchdog-move-definition-of-watchdog_proc_mutex-outside-of-proc_dowatchdog.patch
watchdog-introduce-the-proc_watchdog_common-function.patch
watchdog-introduce-separate-handlers-for-parameters-in-proc-sys-kernel.patch
watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events.patch
watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism.patch
watchdog-clean-up-some-function-names-and-arguments.patch
watchdog-introduce-the-hardlockup_detector_disable-function.patch

