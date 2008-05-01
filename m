From: akpm@linux-foundation.org
Subject: - signals-check_kill_permission-check-session-under-tasklist_lock.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:02 -0700
Message-ID: <200805010927.m419R23A030364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756764AbYEAJ2Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, a-tsuji@bk.jp.nec.com, roland@redhat.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     signals: check_kill_permission: check session under tasklist_lock
has been removed from the -mm tree.  Its filename was
     signals-check_kill_permission-check-session-under-tasklist_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: check_kill_permission: check session under tasklist_lock
From: Oleg Nesterov <oleg@tv-sign.ru>

This wasn't documented, but as Atsushi Tsuji pointed out
check_kill_permission() needs tasklist_lock for task_session_nr().  I missed
this fact when removed tasklist from the callers.

Change check_kill_permission() to take tasklist_lock for the SIGCONT case. 
Re-order security checks so that we take tasklist_lock only if/when it is
actually needed.  This is a minimal fix for now, tasklist will be removed
later.

Also change the code to use task_session() instead of task_session_nr().

Also, remove the SIGCONT check from cap_task_kill(), it is bogus (and the
whole function is bogus.  Serge, Eric, why it is still alive?).

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff -puN kernel/signal.c~signals-check_kill_permission-check-session-under-tasklist_lock kernel/signal.c
--- a/kernel/signal.c~signals-check_kill_permission-check-session-under-tasklist_lock
+++ a/kernel/signal.c
@@ -533,6 +533,7 @@ static int rm_from_queue(unsigned long m
 static int check_kill_permission(int sig, struct siginfo *info,
 				 struct task_struct *t)
 {
+	struct pid *sid;
 	int error;
 
 	if (!valid_signal(sig))
@@ -545,11 +546,24 @@ static int check_kill_permission(int sig
 	if (error)
 		return error;
 
-	if (((sig != SIGCONT) || (task_session_nr(current) != task_session_nr(t)))
-	    && (current->euid ^ t->suid) && (current->euid ^ t->uid)
-	    && (current->uid ^ t->suid) && (current->uid ^ t->uid)
-	    && !capable(CAP_KILL))
-		return -EPERM;
+	if ((current->euid ^ t->suid) && (current->euid ^ t->uid) &&
+	    (current->uid  ^ t->suid) && (current->uid  ^ t->uid) &&
+	    !capable(CAP_KILL)) {
+		switch (sig) {
+		case SIGCONT:
+			read_lock(&tasklist_lock);
+			sid = task_session(t);
+			read_unlock(&tasklist_lock);
+			/*
+			 * We don't return the error if sid == NULL. The
+			 * task was unhashed, the caller must notice this.
+			 */
+			if (!sid || sid == task_session(current))
+				break;
+		default:
+			return -EPERM;
+		}
+	}
 
 	return security_task_kill(t, info, sig, 0);
 }
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

