From: akpm@linux-foundation.org
Subject: + watchdog-introduce-the-proc_watchdog_update-function.patch
 added to -mm tree
Date: Mon, 23 Feb 2015 13:20:41 -0800
Message-ID: <54eb99a9.dDQE2+tEDGUpgUYm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45180 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbbBWVUm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 16:20:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, dzickus@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: introduce the proc_watchdog_update() function
has been added to the -mm tree.  Its filename is
     watchdog-introduce-the-proc_watchdog_update-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-introduce-the-proc_watchdog_update-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-introduce-the-proc_watchdog_update-function.patch

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
Subject: watchdog: introduce the proc_watchdog_update() function

This series introduces a separate handler for each watchdog parameter in
/proc/sys/kernel.  The separate handlers need a common function that they
can call to update the run state of the lockup detectors, or to have the
lockup detectors use a new sample period.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN kernel/watchdog.c~watchdog-introduce-the-proc_watchdog_update-function kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-introduce-the-proc_watchdog_update-function
+++ a/kernel/watchdog.c
@@ -679,6 +679,29 @@ static void watchdog_disable_all_cpus(vo
 }
 
 /*
+ * Update the run state of the lockup detectors.
+ */
+static int proc_watchdog_update(void)
+{
+	int err = 0;
+
+	/*
+	 * Watchdog threads won't be started if they are already active.
+	 * The 'watchdog_running' variable in watchdog_*_all_cpus() takes
+	 * care of this. If those threads are already active, the sample
+	 * period will be updated and the lockup detectors will be enabled
+	 * or disabled 'on the fly'.
+	 */
+	if (watchdog_enabled && watchdog_thresh)
+		err = watchdog_enable_all_cpus(true);
+	else
+		watchdog_disable_all_cpus();
+
+	return err;
+
+}
+
+/*
  * proc handler for /proc/sys/kernel/nmi_watchdog,watchdog_thresh
  */
 
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

