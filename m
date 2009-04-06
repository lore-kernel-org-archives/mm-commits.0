From: akpm@linux-foundation.org
Subject: [merged] reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:42 -0700
Message-ID: <200904061935.n36JZglV012142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753364AbZDFTjI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:39:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     reparent_thread: don't call kill_orphaned_pgrp() if task_detached()
has been removed from the -mm tree.  Its filename was
     reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reparent_thread: don't call kill_orphaned_pgrp() if task_detached()
From: Oleg Nesterov <oleg@redhat.com>

If task_detached(p) == T, then either

  a) p is not the main thread, we will find the group leader on the
     ->children list.

or

  b) p is the group leader but its ->exit_state = EXIT_DEAD.  This
     can only happen when the last sub-thread has died, but in that case
     that thread has already called kill_orphaned_pgrp() from
     exit_notify().

In both cases kill_orphaned_pgrp() looks bogus.

Move the task_detached() check up and simplify the code, this is also
right from the "common sense" pov: we should do nothing with the detached
childs, except move them to the new parent's ->children list.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/exit.c~reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached kernel/exit.c
--- a/kernel/exit.c~reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached
+++ a/kernel/exit.c
@@ -818,6 +818,8 @@ static void reparent_thread(struct task_
 
 	list_move_tail(&p->sibling, &p->real_parent->children);
 
+	if (task_detached(p))
+		return;
 	/* If this is a threaded reparent there is no need to
 	 * notify anyone anything has happened.
 	 */
@@ -825,15 +827,13 @@ static void reparent_thread(struct task_
 		return;
 
 	/* We don't want people slaying init.  */
-	if (!task_detached(p))
-		p->exit_signal = SIGCHLD;
+	p->exit_signal = SIGCHLD;
 
 	/* If we'd notified the old parent about this child's death,
 	 * also notify the new parent.
 	 */
 	if (!ptrace_reparented(p) &&
-	    p->exit_state == EXIT_ZOMBIE &&
-	    !task_detached(p) && thread_group_empty(p))
+	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p))
 		do_notify_parent(p, p->exit_signal);
 
 	kill_orphaned_pgrp(p, father);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
getrusage-fill-ru_maxrss-value.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

