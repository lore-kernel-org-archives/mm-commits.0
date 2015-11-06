From: akpm@linux-foundation.org
Subject: [merged]
 watchdog-fix-error-handling-in-proc_watchdog_thresh.patch removed from -mm
 tree
Date: Fri, 06 Nov 2015 12:06:05 -0800
Message-ID: <563d082d.ozcVRk7eVxGxvsBq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48483 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161814AbbKFUGG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:06:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, atomlin@redhat.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: fix error handling in proc_watchdog_thresh()
has been removed from the -mm tree.  Its filename was
     watchdog-fix-error-handling-in-proc_watchdog_thresh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: watchdog: fix error handling in proc_watchdog_thresh()

The original watchdog_park_threads() function that was introduced by
81a4beef91ba4a9 ("watchdog: introduce watchdog_park_threads() and
watchdog_unpark_threads()") takes a very simple approach to handle errors
returned by kthread_park(): It attempts to roll back all watchdog threads
to the unparked state.  However, this may be undesired behaviour from the
perspective of the caller which may want to handle errors as appropriate
in its specific context.  Currently, there are two possible call chains:

- watchdog suspend/resume interface

    lockup_detector_suspend
      watchdog_park_threads

- write to parameters in /proc/sys/kernel

    proc_watchdog_update
      watchdog_enable_all_cpus
        update_watchdog_all_cpus
          watchdog_park_threads

Instead of 'blindly' attempting to unpark the watchdog threads if a
kthread_park() call fails, the new approach is to disable the lockup
detectors in the above call chains.  Failure becomes visible to the user
as follows:

- error messages from lockup_detector_suspend()
                   or watchdog_enable_all_cpus()

- the state that can be read from /proc/sys/kernel/watchdog_enabled

- the 'write' system call in the latter call chain returns an error


I did not experience kthread_park() failures in practice, I used some
instrumentation to fake error returns from kthread_park() in order to test
the patches.


This patch (of 5):

Restore the previous value of watchdog_thresh _and_ sample_period if
proc_watchdog_update() returns an error.  The variables must be consistent
to avoid false positives of the lockup detectors.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/watchdog.c~watchdog-fix-error-handling-in-proc_watchdog_thresh kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-fix-error-handling-in-proc_watchdog_thresh
+++ a/kernel/watchdog.c
@@ -914,13 +914,14 @@ int proc_watchdog_thresh(struct ctl_tabl
 		goto out;
 
 	/*
-	 * Update the sample period.
-	 * Restore 'watchdog_thresh' on failure.
+	 * Update the sample period. Restore on failure.
 	 */
 	set_sample_period();
 	err = proc_watchdog_update();
-	if (err)
+	if (err) {
 		watchdog_thresh = old;
+		set_sample_period();
+	}
 out:
 	mutex_unlock(&watchdog_proc_mutex);
 	return err;
_

Patches currently in -mm which might be from uobergfe@redhat.com are


