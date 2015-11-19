From: akpm@linux-foundation.org
Subject: +
 ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task.patch
 added to -mm tree
Date: Thu, 19 Nov 2015 15:11:24 -0800
Message-ID: <564e571c.5+hYfVr3i/9elSaC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52332 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758294AbbKSXLZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Nov 2015 18:11:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, aryabinin@virtuozzo.com, jan.kratochvil@redhat.com, palves@redhat.com, roland@hack.frob.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace: task_stopped_code(ptrace => true) can't see TASK_STOPPED task
has been added to the -mm tree.  Its filename is
     ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ptrace-task_stopped_codeptrace-%3D-true-cant-see-task_stopped-task.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ptrace-task_stopped_codeptrace-%3D-true-cant-see-task_stopped-task.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ptrace: task_stopped_code(ptrace => true) can't see TASK_STOPPED task

task_stopped_code()->task_is_stopped_or_traced() doesn't look right, the
traced task must never be TASK_STOPPED.

We can not add WARN_ON(task_is_stopped(p)), but this is only because
do_wait() can race with PTRACE_ATTACH from another thread.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Pedro Alves <palves@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task kernel/exit.c
--- a/kernel/exit.c~ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task
+++ a/kernel/exit.c
@@ -1120,7 +1120,7 @@ static int wait_task_zombie(struct wait_
 static int *task_stopped_code(struct task_struct *p, bool ptrace)
 {
 	if (ptrace) {
-		if (task_is_stopped_or_traced(p) &&
+		if (task_is_traced(p) &&
 		    !(p->jobctl & JOBCTL_LISTENING))
 			return &p->exit_code;
 	} else {
_

Patches currently in -mm which might be from oleg@redhat.com are

ptrace-make-wait_on_bitjobctl_trapping_bit-in-ptrace_attach-killable.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task.patch

