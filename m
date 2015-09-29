From: akpm@linux-foundation.org
Subject: +
 watchdog-implement-error-handling-in-lockup_detector_suspend.patch added to -mm tree
Date: Tue, 29 Sep 2015 16:40:23 -0700
Message-ID: <560b2167.8RKb4VtNzr+ZBIJQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47071 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbbI2XkY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Sep 2015 19:40:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, atomlin@redhat.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: implement error handling in lockup_detector_suspend()
has been added to the -mm tree.  Its filename is
     watchdog-implement-error-handling-in-lockup_detector_suspend.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-implement-error-handling-in-lockup_detector_suspend.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-implement-error-handling-in-lockup_detector_suspend.patch

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
Subject: watchdog: implement error handling in lockup_detector_suspend()

lockup_detector_suspend() now handles errors from watchdog_park_threads().

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN kernel/watchdog.c~watchdog-implement-error-handling-in-lockup_detector_suspend kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-implement-error-handling-in-lockup_detector_suspend
+++ a/kernel/watchdog.c
@@ -707,6 +707,11 @@ int lockup_detector_suspend(void)
 
 	if (ret == 0)
 		watchdog_suspended++;
+	else {
+		watchdog_disable_all_cpus();
+		pr_err("Failed to suspend lockup detectors, disabled\n");
+		watchdog_enabled = 0;
+	}
 
 	mutex_unlock(&watchdog_proc_mutex);
 
_

Patches currently in -mm which might be from uobergfe@redhat.com are

watchdog-fix-error-handling-in-proc_watchdog_thresh.patch
watchdog-move-watchdog_disable_all_cpus-outside-of-ifdef.patch
watchdog-implement-error-handling-in-update_watchdog_all_cpus-and-callers.patch
watchdog-implement-error-handling-in-lockup_detector_suspend.patch
watchdog-do-not-unpark-threads-in-watchdog_park_threads-on-error.patch

