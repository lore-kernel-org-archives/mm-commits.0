From: akpm@linux-foundation.org
Subject: - fix-tsk-exit_state-usage-resend.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:53:06 -0700
Message-ID: <200710192253.l9JMr6b3024403@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35153 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966966AbXJSXGP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eugeneteo@kernel.sg, oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Fix tsk->exit_state usage
has been removed from the -mm tree.  Its filename was
     fix-tsk-exit_state-usage-resend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix tsk->exit_state usage
From: Eugene Teo <eugeneteo@kernel.sg>

tsk->exit_state can only be 0, EXIT_ZOMBIE, or EXIT_DEAD.  A non-zero test
is the same as tsk->exit_state & (EXIT_ZOMBIE | EXIT_DEAD), so just testing
tsk->exit_state is sufficient.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    3 +--
 kernel/fork.c   |    2 +-
 kernel/sched.c  |    2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/proc/array.c~fix-tsk-exit_state-usage-resend fs/proc/array.c
--- a/fs/proc/array.c~fix-tsk-exit_state-usage-resend
+++ a/fs/proc/array.c
@@ -146,8 +146,7 @@ static inline const char *get_task_state
 					    TASK_UNINTERRUPTIBLE |
 					    TASK_STOPPED |
 					    TASK_TRACED)) |
-			(tsk->exit_state & (EXIT_ZOMBIE |
-					    EXIT_DEAD));
+					   tsk->exit_state;
 	const char **p = &task_state_array[0];
 
 	while (state) {
diff -puN kernel/fork.c~fix-tsk-exit_state-usage-resend kernel/fork.c
--- a/kernel/fork.c~fix-tsk-exit_state-usage-resend
+++ a/kernel/fork.c
@@ -117,7 +117,7 @@ EXPORT_SYMBOL(free_task);
 
 void __put_task_struct(struct task_struct *tsk)
 {
-	WARN_ON(!(tsk->exit_state & (EXIT_DEAD | EXIT_ZOMBIE)));
+	WARN_ON(!tsk->exit_state);
 	WARN_ON(atomic_read(&tsk->usage));
 	WARN_ON(tsk == current);
 
diff -puN kernel/sched.c~fix-tsk-exit_state-usage-resend kernel/sched.c
--- a/kernel/sched.c~fix-tsk-exit_state-usage-resend
+++ a/kernel/sched.c
@@ -5279,7 +5279,7 @@ static void migrate_dead(unsigned int de
 	struct rq *rq = cpu_rq(dead_cpu);
 
 	/* Must be exiting, otherwise would be on tasklist. */
-	BUG_ON(p->exit_state != EXIT_ZOMBIE && p->exit_state != EXIT_DEAD);
+	BUG_ON(!p->exit_state);
 
 	/* Cannot have done final schedule yet: would have vanished. */
 	BUG_ON(p->state == TASK_DEAD);
_

Patches currently in -mm which might be from eugeneteo@kernel.sg are

origin.patch
