From: akpm@linux-foundation.org
Subject: +
 watchdog-avoid-races-between-proc-handlers-and-cpu-hotplug.patch added to
 -mm tree
Date: Thu, 05 Nov 2015 02:30:46 -0800
Message-ID: <563b2fd6.83HLhS8hTYBy3v8Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031089AbbKEKar (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 05:30:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, atomlin@redhat.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: avoid races between /proc handlers and CPU hotplug
has been added to the -mm tree.  Its filename is
     watchdog-avoid-races-between-proc-handlers-and-cpu-hotplug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-avoid-races-between-proc-handlers-and-cpu-hotplug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-avoid-races-between-proc-handlers-and-cpu-hotplug.patch

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
Subject: kernel/watchdog.c: avoid races between /proc handlers and CPU hotplug

The handler functions for watchdog parameters in /proc/sys/kernel do not
protect themselves against races with CPU hotplug.  Hence, theoretically
it is possible that a new watchdog thread is started on a hotplugged CPU
while a parameter is being modified, and the thread could thus use a
parameter value that is 'in transition'.

For example, if 'watchdog_thresh' is being set to zero (note: this
disables the lockup detectors) the thread would erroneously use the value
zero as the sample period.

To avoid such races and to keep the /proc handler code consistent,
call
     {get|put}_online_cpus() in proc_watchdog_common()
     {get|put}_online_cpus() in proc_watchdog_thresh()
     {get|put}_online_cpus() in proc_watchdog_cpumask()

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN kernel/watchdog.c~watchdog-avoid-races-between-proc-handlers-and-cpu-hotplug kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-avoid-races-between-proc-handlers-and-cpu-hotplug
+++ a/kernel/watchdog.c
@@ -857,6 +857,7 @@ static int proc_watchdog_common(int whic
 	int err, old, new;
 	int *watchdog_param = (int *)table->data;
 
+	get_online_cpus();
 	mutex_lock(&watchdog_proc_mutex);
 
 	if (watchdog_suspended) {
@@ -908,6 +909,7 @@ static int proc_watchdog_common(int whic
 	}
 out:
 	mutex_unlock(&watchdog_proc_mutex);
+	put_online_cpus();
 	return err;
 }
 
@@ -949,6 +951,7 @@ int proc_watchdog_thresh(struct ctl_tabl
 {
 	int err, old;
 
+	get_online_cpus();
 	mutex_lock(&watchdog_proc_mutex);
 
 	if (watchdog_suspended) {
@@ -974,6 +977,7 @@ int proc_watchdog_thresh(struct ctl_tabl
 	}
 out:
 	mutex_unlock(&watchdog_proc_mutex);
+	put_online_cpus();
 	return err;
 }
 
@@ -988,6 +992,7 @@ int proc_watchdog_cpumask(struct ctl_tab
 {
 	int err;
 
+	get_online_cpus();
 	mutex_lock(&watchdog_proc_mutex);
 
 	if (watchdog_suspended) {
@@ -1015,6 +1020,7 @@ int proc_watchdog_cpumask(struct ctl_tab
 	}
 out:
 	mutex_unlock(&watchdog_proc_mutex);
+	put_online_cpus();
 	return err;
 }
 
_

Patches currently in -mm which might be from uobergfe@redhat.com are

watchdog-fix-error-handling-in-proc_watchdog_thresh.patch
watchdog-move-watchdog_disable_all_cpus-outside-of-ifdef.patch
watchdog-implement-error-handling-in-update_watchdog_all_cpus-and-callers.patch
watchdog-implement-error-handling-in-lockup_detector_suspend.patch
watchdog-do-not-unpark-threads-in-watchdog_park_threads-on-error.patch
watchdog-avoid-race-between-lockup-detector-suspend-resume-and-cpu-hotplug.patch
watchdog-avoid-races-between-proc-handlers-and-cpu-hotplug.patch
watchdog-remove-getput_online_cpus-from-watchdog_parkunpark_threads.patch
watchdog-fix-race-between-proc_watchdog_thresh-and-watchdog_timer_fn.patch

