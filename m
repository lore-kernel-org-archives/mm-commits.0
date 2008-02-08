From: akpm@linux-foundation.org
Subject: - ptrace_stop-fix-the-race-with-ptrace-detachattach.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:13:28 -0800
Message-ID: <200802082013.m18KD9wL010266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49321 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752376AbYBHUuV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:50:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     ptrace_stop: fix the race with ptrace detach+attach
has been removed from the -mm tree.  Its filename was
     ptrace_stop-fix-the-race-with-ptrace-detachattach.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace_stop: fix the race with ptrace detach+attach
From: Oleg Nesterov <oleg@tv-sign.ru>

If the tracer went away (may_ptrace_stop() failed), ptrace_stop() drops
tasklist and then changes the ->state from TASK_TRACED to TASK_RUNNING.

This can fool another tracer which attaches to us in between.  Change the
->state under tasklist_lock to ensure that ptrace_check_attach() can't wrongly
succeed.  Also, remove the unnecessary mb().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/signal.c~ptrace_stop-fix-the-race-with-ptrace-detachattach kernel/signal.c
--- a/kernel/signal.c~ptrace_stop-fix-the-race-with-ptrace-detachattach
+++ a/kernel/signal.c
@@ -1638,11 +1638,11 @@ static void ptrace_stop(int exit_code, i
 	} else {
 		/*
 		 * By the time we got the lock, our tracer went away.
-		 * Don't stop here.
+		 * Don't drop the lock yet, another tracer may come.
 		 */
-		read_unlock(&tasklist_lock);
-		set_current_state(TASK_RUNNING);
+		__set_current_state(TASK_RUNNING);
 		current->exit_code = nostop_code;
+		read_unlock(&tasklist_lock);
 	}
 
 	/*
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
