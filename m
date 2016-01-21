From: akpm@linux-foundation.org
Subject: [merged]
 ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task.patch
 removed from -mm tree
Date: Thu, 21 Jan 2016 14:59:48 -0800
Message-ID: <56a162e4.4IlL2UOgbIzyj/59%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbcAUW7t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:59:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, aryabinin@virtuozzo.com, jan.kratochvil@redhat.com, palves@redhat.com, roland@hack.frob.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace: task_stopped_code(ptrace => true) can't see TASK_STOPPED task
has been removed from the -mm tree.  Its filename was
     ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ptrace: task_stopped_code(ptrace => true) can't see TASK_STOPPED task

task_stopped_code()->task_is_stopped_or_traced() doesn't look right, the
traced task must never be TASK_STOPPED.

We can not add WARN_ON(task_is_stopped(p)), but this is only because
do_wait() can race with PTRACE_ATTACH from another thread.

[akpm@linux-foundation.org: teeny cleanup]
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Roland McGrath <roland@hack.frob.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Pedro Alves <palves@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/exit.c~ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task kernel/exit.c
--- a/kernel/exit.c~ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task
+++ a/kernel/exit.c
@@ -1120,8 +1120,7 @@ static int wait_task_zombie(struct wait_
 static int *task_stopped_code(struct task_struct *p, bool ptrace)
 {
 	if (ptrace) {
-		if (task_is_stopped_or_traced(p) &&
-		    !(p->jobctl & JOBCTL_LISTENING))
+		if (task_is_traced(p) && !(p->jobctl & JOBCTL_LISTENING))
 			return &p->exit_code;
 	} else {
 		if (p->signal->flags & SIGNAL_STOP_STOPPED)
_

Patches currently in -mm which might be from oleg@redhat.com are


