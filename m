From: akpm@linux-foundation.org
Subject: [merged]
 watchdog-implement-error-handling-in-lockup_detector_suspend.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:06:12 -0800
Message-ID: <563d0834.LH9Wl/58zQXlbtSg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48493 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161875AbbKFUGM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:06:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, atomlin@redhat.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: implement error handling in lockup_detector_suspend()
has been removed from the -mm tree.  Its filename was
     watchdog-implement-error-handling-in-lockup_detector_suspend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: watchdog: implement error handling in lockup_detector_suspend()

lockup_detector_suspend() now handles errors from watchdog_park_threads().

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Acked-by: Don Zickus <dzickus@redhat.com>
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


