From: akpm@linux-foundation.org
Subject: - wait_task_zombie-remove-exit_state-exit_signal-checks-for-wnowait.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:13:49 -0800
Message-ID: <200802082013.m18KDU8D010295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46115 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752275AbYBHUuI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:50:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     wait_task_zombie: remove ->exit_state/exit_signal checks for WNOWAIT
has been removed from the -mm tree.  Its filename was
     wait_task_zombie-remove-exit_state-exit_signal-checks-for-wnowait.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wait_task_zombie: remove ->exit_state/exit_signal checks for WNOWAIT
From: Oleg Nesterov <oleg@tv-sign.ru>

The first "p->exit_state != EXIT_ZOMBIE" check doesn't make too much sense. 
The exit_state was EXIT_ZOMBIE when the function was called, and another
thread can change it to EXIT_DEAD right after the check.

The second condition is not possible, detached non-traced threads were already
filtered out by eligible_child(), we didn't drop tasklist since then.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN kernel/exit.c~wait_task_zombie-remove-exit_state-exit_signal-checks-for-wnowait kernel/exit.c
--- a/kernel/exit.c~wait_task_zombie-remove-exit_state-exit_signal-checks-for-wnowait
+++ a/kernel/exit.c
@@ -1196,10 +1196,6 @@ static int wait_task_zombie(struct task_
 		int exit_code = p->exit_code;
 		int why, status;
 
-		if (unlikely(p->exit_state != EXIT_ZOMBIE))
-			return 0;
-		if (unlikely(p->exit_signal == -1 && p->ptrace == 0))
-			return 0;
 		get_task_struct(p);
 		read_unlock(&tasklist_lock);
 		if ((exit_code & 0x7f) == 0) {
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
