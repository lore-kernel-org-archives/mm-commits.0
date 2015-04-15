From: akpm@linux-foundation.org
Subject: [merged]
 watchdog-move-definition-of-watchdog_proc_mutex-outside-of-proc_dowatchdog.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:08:42 -0700
Message-ID: <552eb73a.lcE0RPxy7TQI6dGR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671AbbDOTIn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:08:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, dzickus@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: move definition of 'watchdog_proc_mutex' outside of proc_dowatchdog()
has been removed from the -mm tree.  Its filename was
     watchdog-move-definition-of-watchdog_proc_mutex-outside-of-proc_dowatchdog.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: watchdog: move definition of 'watchdog_proc_mutex' outside of proc_dowatchdog()

This series removes proc_dowatchdog().  Since multiple new functions need
the 'watchdog_proc_mutex' to serialize access to the watchdog parameters
in /proc/sys/kernel, move the mutex outside of any function.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/watchdog.c~watchdog-move-definition-of-watchdog_proc_mutex-outside-of-proc_dowatchdog kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-move-definition-of-watchdog_proc_mutex-outside-of-proc_dowatchdog
+++ a/kernel/watchdog.c
@@ -701,6 +701,8 @@ static int proc_watchdog_update(void)
 
 }
 
+static DEFINE_MUTEX(watchdog_proc_mutex);
+
 /*
  * proc handler for /proc/sys/kernel/nmi_watchdog,watchdog_thresh
  */
@@ -710,7 +712,6 @@ int proc_dowatchdog(struct ctl_table *ta
 {
 	int err, old_thresh, old_enabled;
 	bool old_hardlockup;
-	static DEFINE_MUTEX(watchdog_proc_mutex);
 
 	mutex_lock(&watchdog_proc_mutex);
 	old_thresh = ACCESS_ONCE(watchdog_thresh);
_

Patches currently in -mm which might be from uobergfe@redhat.com are

origin.patch
linux-next.patch

