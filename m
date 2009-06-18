From: akpm@linux-foundation.org
Subject: [merged] copy_process-remove-the-unneeded-clear_tsk_thread_flagtif_sigpending.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:46:50 -0700
Message-ID: <200906182246.n5IMkoc9005914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755664AbZFRW6I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:58:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     copy_process(): remove the unneeded clear_tsk_thread_flag(TIF_SIGPENDING)
has been removed from the -mm tree.  Its filename was
     copy_process-remove-the-unneeded-clear_tsk_thread_flagtif_sigpending.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: copy_process(): remove the unneeded clear_tsk_thread_flag(TIF_SIGPENDING)
From: Oleg Nesterov <oleg@redhat.com>

The forked child can have TIF_SIGPENDING if it was copied from parent's
ti->flags.  But this is harmless and actually almost never happens,
because copy_process() can't succeed if signal_pending() == T.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/fork.c~copy_process-remove-the-unneeded-clear_tsk_thread_flagtif_sigpending kernel/fork.c
--- a/kernel/fork.c~copy_process-remove-the-unneeded-clear_tsk_thread_flagtif_sigpending
+++ a/kernel/fork.c
@@ -1029,7 +1029,6 @@ static struct task_struct *copy_process(
 	p->vfork_done = NULL;
 	spin_lock_init(&p->alloc_lock);
 
-	clear_tsk_thread_flag(p, TIF_SIGPENDING);
 	init_sigpending(&p->pending);
 
 	p->utime = cputime_zero;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
ptrace-wait_task_zombie-do-not-account-traced-sub-threads.patch
linux-next.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

