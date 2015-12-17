From: akpm@linux-foundation.org
Subject: +
 kernel-hung_taskc-use-timeout-diff-when-timeout-is-updated.patch added to
 -mm tree
Date: Thu, 17 Dec 2015 14:18:21 -0800
Message-ID: <567334ad.BHlRlbqINZbXnScR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38561 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934436AbbLQWSW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Dec 2015 17:18:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, atomlin@redhat.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/hung_task.c: use timeout diff when timeout is updated
has been added to the -mm tree.  Its filename is
     kernel-hung_taskc-use-timeout-diff-when-timeout-is-updated.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-hung_taskc-use-timeout-diff-when-timeout-is-updated.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-hung_taskc-use-timeout-diff-when-timeout-is-updated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: kernel/hung_task.c: use timeout diff when timeout is updated

When new timeout is written to /proc/sys/kernel/hung_task_timeout_secs,
khungtaskd is interrupted and again sleeps for full timeout duration.

This means that hang task will not be checked if new timeout is written
periodically within old timeout duration and/or checking of hang task will
be delayed for up to previous timeout duration.  Fix this by remembering
last time khungtaskd checked hang task.

This change will allow other watchdog tasks (if any) to share khungtaskd
by sleeping for minimal timeout diff of all watchdog tasks.  Doing more
watchdog tasks from khungtaskd will reduce the possibility of printk()
collisions by multiple watchdog threads.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff -puN kernel/hung_task.c~kernel-hung_taskc-use-timeout-diff-when-timeout-is-updated kernel/hung_task.c
--- a/kernel/hung_task.c~kernel-hung_taskc-use-timeout-diff-when-timeout-is-updated
+++ a/kernel/hung_task.c
@@ -185,10 +185,12 @@ static void check_hung_uninterruptible_t
 	rcu_read_unlock();
 }
 
-static unsigned long timeout_jiffies(unsigned long timeout)
+static long hung_timeout_jiffies(unsigned long last_checked,
+				 unsigned long timeout)
 {
 	/* timeout of 0 will disable the watchdog */
-	return timeout ? timeout * HZ : MAX_SCHEDULE_TIMEOUT;
+	return timeout ? last_checked - jiffies + timeout * HZ :
+		MAX_SCHEDULE_TIMEOUT;
 }
 
 /*
@@ -224,18 +226,21 @@ EXPORT_SYMBOL_GPL(reset_hung_task_detect
  */
 static int watchdog(void *dummy)
 {
+	unsigned long hung_last_checked = jiffies;
+
 	set_user_nice(current, 0);
 
 	for ( ; ; ) {
 		unsigned long timeout = sysctl_hung_task_timeout_secs;
+		long t = hung_timeout_jiffies(hung_last_checked, timeout);
 
-		while (schedule_timeout_interruptible(timeout_jiffies(timeout)))
-			timeout = sysctl_hung_task_timeout_secs;
-
-		if (atomic_xchg(&reset_hung_task, 0))
+		if (t <= 0) {
+			if (!atomic_xchg(&reset_hung_task, 0))
+				check_hung_uninterruptible_tasks(timeout);
+			hung_last_checked = jiffies;
 			continue;
