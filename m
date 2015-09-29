From: akpm@linux-foundation.org
Subject: +
 watchdog-implement-error-handling-in-update_watchdog_all_cpus-and-callers.patch added to -mm tree
Date: Tue, 29 Sep 2015 16:40:21 -0700
Message-ID: <560b2165.d4gE/F3PMW7bLuXz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47069 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbbI2XkW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Sep 2015 19:40:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, atomlin@redhat.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: implement error handling in update_watchdog_all_cpus() and callers
has been added to the -mm tree.  Its filename is
     watchdog-implement-error-handling-in-update_watchdog_all_cpus-and-callers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-implement-error-handling-in-update_watchdog_all_cpus-and-callers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-implement-error-handling-in-update_watchdog_all_cpus-and-callers.patch

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
Subject: watchdog: implement error handling in update_watchdog_all_cpus() and callers

update_watchdog_all_cpus() now passes errors from watchdog_park_threads()
up to functions in the call chain.  This allows watchdog_enable_all_cpus()
and proc_watchdog_update() to handle such errors too.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff -puN kernel/watchdog.c~watchdog-implement-error-handling-in-update_watchdog_all_cpus-and-callers kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-implement-error-handling-in-update_watchdog_all_cpus-and-callers
+++ a/kernel/watchdog.c
@@ -731,10 +731,17 @@ void lockup_detector_resume(void)
 	mutex_unlock(&watchdog_proc_mutex);
 }
 
-static void update_watchdog_all_cpus(void)
+static int update_watchdog_all_cpus(void)
 {
-	watchdog_park_threads();
+	int ret;
+
+	ret = watchdog_park_threads();
+	if (ret)
+		return ret;
+
 	watchdog_unpark_threads();
+
+	return 0;
 }
 
 static int watchdog_enable_all_cpus(void)
@@ -753,9 +760,17 @@ static int watchdog_enable_all_cpus(void
 		 * Enable/disable the lockup detectors or
 		 * change the sample period 'on the fly'.
 		 */
-		update_watchdog_all_cpus();
+		err = update_watchdog_all_cpus();
+
+		if (err) {
+			watchdog_disable_all_cpus();
+			pr_err("Failed to update lockup detectors, disabled\n");
+		}
 	}
 
+	if (err)
+		watchdog_enabled = 0;
+
 	return err;
 }
 
@@ -851,12 +866,13 @@ static int proc_watchdog_common(int whic
 		} while (cmpxchg(&watchdog_enabled, old, new) != old);
 
 		/*
-		 * Update the run state of the lockup detectors.
-		 * Restore 'watchdog_enabled' on failure.
+		 * Update the run state of the lockup detectors. There is _no_
+		 * need to check the value returned by proc_watchdog_update()
+		 * and to restore the previous value of 'watchdog_enabled' as
+		 * both lockup detectors are disabled if proc_watchdog_update()
+		 * returns an error.
 		 */
 		err = proc_watchdog_update();
-		if (err)
-			watchdog_enabled = old;
 	}
 out:
 	mutex_unlock(&watchdog_proc_mutex);
_

Patches currently in -mm which might be from uobergfe@redhat.com are

watchdog-fix-error-handling-in-proc_watchdog_thresh.patch
watchdog-move-watchdog_disable_all_cpus-outside-of-ifdef.patch
watchdog-implement-error-handling-in-update_watchdog_all_cpus-and-callers.patch
watchdog-implement-error-handling-in-lockup_detector_suspend.patch
watchdog-do-not-unpark-threads-in-watchdog_park_threads-on-error.patch

