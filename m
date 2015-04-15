From: akpm@linux-foundation.org
Subject: [merged]
 watchdog-introduce-the-proc_watchdog_update-function.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:08:40 -0700
Message-ID: <552eb738.O8hUnkMSSwc27Ogh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932667AbbDOTIk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:08:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, dzickus@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: introduce the proc_watchdog_update() function
has been removed from the -mm tree.  Its filename was
     watchdog-introduce-the-proc_watchdog_update-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

