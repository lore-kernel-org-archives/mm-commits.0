From: akpm@linux-foundation.org
Subject: [merged] wait_consider_task-kill-parent-argument.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:35:20 -0700
Message-ID: <200909241935.n8OJZKKY032765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753768AbZIXTgA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:36:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mingo@elte.hu, rnalumasu@gmail.com, roland@redhat.com, vmayatsk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     wait_consider_task: kill "parent" argument
has been removed from the -mm tree.  Its filename was
     wait_consider_task-kill-parent-argument.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wait_consider_task: kill "parent" argument
From: Oleg Nesterov <oleg@redhat.com>

Kill the unused "parent" argument in wait_consider_task(), it was never used.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ratan Nalumasu <rnalumasu@gmail.com>
Cc: Vitaly Mayatskikh <vmayatsk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/exit.c~wait_consider_task-kill-parent-argument kernel/exit.c
--- a/kernel/exit.c~wait_consider_task-kill-parent-argument
+++ a/kernel/exit.c
@@ -1481,8 +1481,8 @@ static int wait_task_continued(struct wa
  * then ->notask_error is 0 if @p is an eligible child,
  * or another error from security_task_wait(), or still -ECHILD.
  */
-static int wait_consider_task(struct wait_opts *wo, struct task_struct *parent,
-				int ptrace, struct task_struct *p)
+static int wait_consider_task(struct wait_opts *wo, int ptrace,
+				struct task_struct *p)
 {
 	int ret = eligible_child(wo, p);
 	if (!ret)
@@ -1550,7 +1550,7 @@ static int do_wait_thread(struct wait_op
 		 * Do not consider detached threads.
 		 */
 		if (!task_detached(p)) {
-			int ret = wait_consider_task(wo, tsk, 0, p);
+			int ret = wait_consider_task(wo, 0, p);
 			if (ret)
 				return ret;
 		}
@@ -1564,7 +1564,7 @@ static int ptrace_do_wait(struct wait_op
 	struct task_struct *p;
 
 	list_for_each_entry(p, &tsk->ptraced, ptrace_entry) {
-		int ret = wait_consider_task(wo, tsk, 1, p);
+		int ret = wait_consider_task(wo, 1, p);
 		if (ret)
 			return ret;
 	}
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
utrace-core.patch

