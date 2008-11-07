From: akpm@linux-foundation.org
Subject: - account_group_exec_runtime-fix-the-racy-usage-of-signal.patch removed from -mm tree
Date: Fri, 07 Nov 2008 08:25:45 -0800
Message-ID: <200811071625.mA7GPkbJ016078@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752317AbYKGQ0f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Nov 2008 11:26:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     account_group_exec_runtime: fix the racy usage of ->signal
has been removed from the -mm tree.  Its filename was
     account_group_exec_runtime-fix-the-racy-usage-of-signal.patch

This patch was dropped because whoops

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: account_group_exec_runtime: fix the racy usage of ->signal
From: Oleg Nesterov <oleg@redhat.com>

Unlike other similar routines, account_group_exec_runtime() could be
called "implicitly" after exit_notify(). This means we can race with
the parent doing release_task(), we can't just check ->signal != NULL.

Take ->siglock to make sure ->signal can't go away.

This is the minimal fix, with this patch we don't need need get/put cpu,
and I think we should uninline this function.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched_stats.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN kernel/sched_stats.h~account_group_exec_runtime-fix-the-racy-usage-of-signal kernel/sched_stats.h
--- a/kernel/sched_stats.h~account_group_exec_runtime-fix-the-racy-usage-of-signal
+++ a/kernel/sched_stats.h
@@ -351,10 +351,12 @@ static inline void account_group_exec_ru
 					      unsigned long long ns)
 {
 	struct signal_struct *sig;
+	unsigned long flags;
 
-	sig = tsk->signal;
-	if (unlikely(!sig))
+	if (unlikely(!lock_task_sighand(tsk, &flags)))
 		return;
+
+	sig = tsk->signal;
 	if (sig->cputime.totals) {
 		struct task_cputime *times;
 
@@ -362,4 +364,6 @@ static inline void account_group_exec_ru
 		times->sum_exec_runtime += ns;
 		put_cpu_no_resched();
 	}
+
+	unlock_task_sighand(tsk, &flags);
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

account_group_exec_runtime-fix-the-racy-usage-of-signal.patch
forkc-cleanup-for-copy_sighand.patch

