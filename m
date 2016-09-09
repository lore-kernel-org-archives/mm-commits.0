From: akpm@linux-foundation.org
Subject: +
 hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0.patch added to -mm tree
Date: Fri, 09 Sep 2016 12:53:22 -0700
Message-ID: <57d31332.Oc+e/FjEelaQFCKt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49513 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753269AbcIITxX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2016 15:53:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsiddle@redhat.com, penguin-kernel@i-love.sakura.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: hung_task: allow hung_task_panic when hung_task_warnings is 0
has been added to the -mm tree.  Its filename is
     hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Siddle <jsiddle@redhat.com>
Subject: hung_task: allow hung_task_panic when hung_task_warnings is 0

Previously hung_task_panic would not be respected if enabled after
hung_task_warnings had already been decremented to 0.

Permit the kernel to panic if hung_task_panic is enabled after
hung_task_warnings has already been decremented to 0 and another task
hangs for hung_task_timeout_secs seconds.

Check if hung_task_panic is enabled so we don't return prematurely, and
check if hung_task_warnings is non-zero so we don't print the warning
unnecessarily.

Link: http://lkml.kernel.org/r/1473450214-4049-1-git-send-email-jsiddle@redhat.com
Signed-off-by: John Siddle <jsiddle@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN kernel/hung_task.c~hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0 kernel/hung_task.c
--- a/kernel/hung_task.c~hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0
+++ a/kernel/hung_task.c
@@ -98,7 +98,7 @@ static void check_hung_task(struct task_
 
 	trace_sched_process_hang(t);
 
-	if (!sysctl_hung_task_warnings)
+	if (!sysctl_hung_task_warnings && !sysctl_hung_task_panic)
 		return;
 
 	if (sysctl_hung_task_warnings > 0)
@@ -108,16 +108,18 @@ static void check_hung_task(struct task_
 	 * Ok, the task did not get scheduled for more than 2 minutes,
 	 * complain:
 	 */
-	pr_err("INFO: task %s:%d blocked for more than %ld seconds.\n",
-		t->comm, t->pid, timeout);
-	pr_err("      %s %s %.*s\n",
-		print_tainted(), init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
-	pr_err("\"echo 0 > /proc/sys/kernel/hung_task_timeout_secs\""
-		" disables this message.\n");
-	sched_show_task(t);
-	debug_show_held_locks(t);
+	if (sysctl_hung_task_warnings) {
+		pr_err("INFO: task %s:%d blocked for more than %ld seconds.\n",
+			t->comm, t->pid, timeout);
+		pr_err("      %s %s %.*s\n",
+			print_tainted(), init_utsname()->release,
+			(int)strcspn(init_utsname()->version, " "),
+			init_utsname()->version);
+		pr_err("\"echo 0 > /proc/sys/kernel/hung_task_timeout_secs\""
+			" disables this message.\n");
+		sched_show_task(t);
+		debug_show_held_locks(t);
+	}
 
 	touch_nmi_watchdog();
 
_

Patches currently in -mm which might be from jsiddle@redhat.com are

hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0.patch

