From: akpm@linux-foundation.org
Subject: [merged] ptrace_untrace-fix-the-signal_stop_stopped-check.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:57 -0700
Message-ID: <200904061935.n36JZvvY012270@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752089AbZDFUUp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:20:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dvlasenk@redhat.com, jmarchan@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace_untrace: fix the SIGNAL_STOP_STOPPED check
has been removed from the -mm tree.  Its filename was
     ptrace_untrace-fix-the-signal_stop_stopped-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace_untrace: fix the SIGNAL_STOP_STOPPED check
From: Oleg Nesterov <oleg@redhat.com>

This bug is ancient too. ptrace_untrace() must not resume the task
if the group stop in progress, we should set TASK_STOPPED instead.

Unfortunately, we still have problems here:

	- if the process/thread was traced, SIGNAL_STOP_STOPPED
	  does not necessary means this thread group is stopped.

	- ptrace breaks the bookkeeping of ->group_stop_count.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN kernel/ptrace.c~ptrace_untrace-fix-the-signal_stop_stopped-check kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace_untrace-fix-the-signal_stop_stopped-check
+++ a/kernel/ptrace.c
@@ -60,11 +60,15 @@ static void ptrace_untrace(struct task_s
 {
 	spin_lock(&child->sighand->siglock);
 	if (task_is_traced(child)) {
-		if (child->signal->flags & SIGNAL_STOP_STOPPED) {
+		/*
+		 * If the group stop is completed or in progress,
+		 * this thread was already counted as stopped.
+		 */
+		if (child->signal->flags & SIGNAL_STOP_STOPPED ||
+		    child->signal->group_stop_count)
 			__set_task_state(child, TASK_STOPPED);
-		} else {
+		else
 			signal_wake_up(child, 1);
-		}
 	}
 	spin_unlock(&child->sighand->siglock);
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
getrusage-fill-ru_maxrss-value.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

