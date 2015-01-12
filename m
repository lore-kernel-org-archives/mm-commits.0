From: akpm@linux-foundation.org
Subject: [merged]
 exit-fix-race-between-wait_consider_task-and-wait_task_zombie.patch removed from -mm tree
Date: Mon, 12 Jan 2015 11:33:11 -0800
Message-ID: <54b42177.llEmLPp3Gjn/eEQv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbbALTdM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 14:33:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, el@laramies.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: fix race between wait_consider_task() and wait_task_zombie()
has been removed from the -mm tree.  Its filename was
     exit-fix-race-between-wait_consider_task-and-wait_task_zombie.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: fix race between wait_consider_task() and wait_task_zombie()

wait_consider_task() checks EXIT_ZOMBIE after EXIT_DEAD/EXIT_TRACE and
both checks can fail if we race with EXIT_ZOMBIE -> EXIT_DEAD/EXIT_TRACE
change in between, gcc needs to reload p->exit_state after
security_task_wait().  In this case ->notask_error will be wrongly cleared
and do_wait() can hang forever if it was the last eligible child.

Many thanks to Arne who carefully investigated the problem.

Note: this bug is very old but it was pure theoretical until b3ab03160dfa
"wait: completely ignore the EXIT_DEAD tasks".  Before this commit "-O2"
was probably enough to guarantee that compiler won't read ->exit_state
twice.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Arne Goedeke <el@laramies.com>
Tested-by: Arne Goedeke <el@laramies.com>
Cc: <stable@vger.kernel.org>	[3.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN kernel/exit.c~exit-fix-race-between-wait_consider_task-and-wait_task_zombie kernel/exit.c
--- a/kernel/exit.c~exit-fix-race-between-wait_consider_task-and-wait_task_zombie
+++ a/kernel/exit.c
@@ -1287,9 +1287,15 @@ static int wait_task_continued(struct wa
 static int wait_consider_task(struct wait_opts *wo, int ptrace,
 				struct task_struct *p)
 {
+	/*
+	 * We can race with wait_task_zombie() from another thread.
+	 * Ensure that EXIT_ZOMBIE -> EXIT_DEAD/EXIT_TRACE transition
+	 * can't confuse the checks below.
+	 */
+	int exit_state = ACCESS_ONCE(p->exit_state);
 	int ret;
 
-	if (unlikely(p->exit_state == EXIT_DEAD))
+	if (unlikely(exit_state == EXIT_DEAD))
 		return 0;
 
 	ret = eligible_child(wo, p);
@@ -1310,7 +1316,7 @@ static int wait_consider_task(struct wai
 		return 0;
 	}
 
-	if (unlikely(p->exit_state == EXIT_TRACE)) {
+	if (unlikely(exit_state == EXIT_TRACE)) {
 		/*
 		 * ptrace == 0 means we are the natural parent. In this case
 		 * we should clear notask_error, debugger will notify us.
@@ -1337,7 +1343,7 @@ static int wait_consider_task(struct wai
 	}
 
 	/* slay zombie? */
-	if (p->exit_state == EXIT_ZOMBIE) {
+	if (exit_state == EXIT_ZOMBIE) {
 		/* we don't reap group leaders with subthreads */
 		if (!delay_group_leader(p)) {
 			/*
_

Patches currently in -mm which might be from oleg@redhat.com are

oom-dont-count-on-mm-less-current-process.patch
oom-make-sure-that-tif_memdie-is-set-under-task_lock.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch
ptrace-remove-linux-compath-inclusion-under-config_compat.patch
linux-next.patch

