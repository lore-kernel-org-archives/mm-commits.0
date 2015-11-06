From: akpm@linux-foundation.org
Subject: [merged]
 watchdog-avoid-race-between-lockup-detector-suspend-resume-and-cpu-hotplug.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:06:20 -0800
Message-ID: <563d083c.yirAheh/a+gUp5FT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033255AbbKFUGU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:06:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, atomlin@redhat.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: avoid race between lockup detector suspend/resume and CPU hotplug
has been removed from the -mm tree.  Its filename was
     watchdog-avoid-race-between-lockup-detector-suspend-resume-and-cpu-hotplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Don Zickus <dzickus@redhat.com>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
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


