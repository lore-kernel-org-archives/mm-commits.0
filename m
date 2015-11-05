From: akpm@linux-foundation.org
Subject: +
 watchdog-avoid-race-between-lockup-detector-suspend-resume-and-cpu-hotplug.patch added to -mm tree
Date: Thu, 05 Nov 2015 02:30:44 -0800
Message-ID: <563b2fd4.XTPARFEzLiFXf1uq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031089AbbKEKap (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 05:30:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, atomlin@redhat.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: avoid race between lockup detector suspend/resume and CPU hotplug
has been added to the -mm tree.  Its filename is
     watchdog-avoid-race-between-lockup-detector-suspend-resume-and-cpu-hotplug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-avoid-race-between-lockup-detector-suspend-resume-and-cpu-hotplug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-avoid-race-between-lockup-detector-suspend-resume-and-cpu-hotplug.patch

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
Subject: kernel/watchdog.c: avoid race between lockup detector suspend/resume and CPU hotplug

The lockup detector suspend/resume interface that was introduced by
8c073d27d7ad293bf ("watchdog: introduce watchdog_suspend() and
watchdog_resume()") does not protect itself against races with CPU
hotplug.  Hence, theoretically it is possible that a new watchdog thread
is started on a hotplugged CPU while the lockup detector is suspended, and
the thread could thus interfere unexpectedly with the code that requested
to suspend the lockup detector.

Avoid the race by calling

  get_online_cpus() in lockup_detector_suspend()
  put_online_cpus() in lockup_detector_resume()

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/watchdog.c~watchdog-avoid-race-between-lockup-detector-suspend-resume-and-cpu-hotplug kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-avoid-race-between-lockup-detector-suspend-resume-and-cpu-hotplug
+++ a/kernel/watchdog.c
@@ -719,6 +719,7 @@ int lockup_detector_suspend(void)
 {
 	int ret = 0;
 
+	get_online_cpus();
 	mutex_lock(&watchdog_proc_mutex);
 	/*
 	 * Multiple suspend requests can be active in parallel (counted by
@@ -759,6 +760,7 @@ void lockup_detector_resume(void)
 		watchdog_unpark_threads();
 
 	mutex_unlock(&watchdog_proc_mutex);
+	put_online_cpus();
 }
 
 static int update_watchdog_all_cpus(void)
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

