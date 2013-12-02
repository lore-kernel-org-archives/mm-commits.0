From: akpm@linux-foundation.org
Subject: [merged] fork-no-need-to-initialize-child-exit_state.patch
 removed from -mm tree
Date: Mon, 02 Dec 2013 12:37:31 -0800
Message-ID: <529cef8b.ku6Wa/UOoucLEZ6b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab3LBUhc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Dec 2013 15:37:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, peterz@infradead.org, mingo@kernel.org, geert@linux-m68k.org, David.Laight@ACULAB.COM, oleg@redhat.com

Subject: [merged] fork-no-need-to-initialize-child-exit_state.patch removed from -mm tree
To: oleg@redhat.com,David.Laight@ACULAB.COM,geert@linux-m68k.org,mingo@kernel.org,peterz@infradead.org,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 02 Dec 2013 12:37:31 -0800


The patch titled
     Subject: fork: no need to initialize child->exit_state
has been removed from the -mm tree.  Its filename was
     fork-no-need-to-initialize-child-exit_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: fork: no need to initialize child->exit_state

A zombie task obviously can't fork(), remove the unnecessary
initialization of child->exit_state.  It is zero anyway after
dup_task_struct().

Note: copy_process() is huge and it has a lot of chaotic initializations,
probably it makes sense to move them into the new helper called by
dup_task_struct().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/fork.c~fork-no-need-to-initialize-child-exit_state kernel/fork.c
--- a/kernel/fork.c~fork-no-need-to-initialize-child-exit_state
+++ a/kernel/fork.c
@@ -1402,13 +1402,11 @@ static struct task_struct *copy_process(
 		p->tgid = p->pid;
 	}
 
-	p->pdeath_signal = 0;
-	p->exit_state = 0;
-
 	p->nr_dirtied = 0;
 	p->nr_dirtied_pause = 128 >> (PAGE_SHIFT - 10);
 	p->dirty_paused_when = 0;
 
+	p->pdeath_signal = 0;
 	INIT_LIST_HEAD(&p->thread_group);
 	p->task_works = NULL;
 
_

Patches currently in -mm which might be from oleg@redhat.com are

autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch
coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch
coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
proc-fix-the-potential-use-after-free-in-first_tid.patch
proc-change-first_tid-to-use-while_each_thread-rather-than-next_thread.patch
proc-dont-abuse-group_leader-in-proc_task_readdir-paths.patch
proc-fix-f_pos-overflows-in-first_tid.patch
exec-check_unsafe_exec-use-while_each_thread-rather-than-next_thread.patch
exec-check_unsafe_exec-kill-the-dead-eagain-and-clear_in_exec-logic.patch
exec-move-the-final-allow_write_access-fput-into-free_bprm.patch
exec-kill-task_struct-did_exec.patch
fs-proc-arrayc-change-do_task_stat-to-use-while_each_thread.patch
kernel-sysc-k_getrusage-can-use-while_each_thread.patch
kernel-signalc-change-do_signal_stop-do_sigaction-to-use-while_each_thread.patch
linux-next.patch

