From: akpm@linux-foundation.org
Subject: + copy_process-remove-the-unneeded-clear_tsk_thread_flagtif_sigpending.patch added to -mm tree
Date: Mon, 27 Apr 2009 13:00:58 -0700
Message-ID: <200904272000.n3RK0wQ5032030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38130 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756367AbZD0UDw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Apr 2009 16:03:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com


The patch titled
     copy_process(): remove the unneeded clear_tsk_thread_flag(TIF_SIGPENDING)
has been added to the -mm tree.  Its filename is
     copy_process-remove-the-unneeded-clear_tsk_thread_flagtif_sigpending.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: copy_process(): remove the unneeded clear_tsk_thread_flag(TIF_SIGPENDING)
From: Oleg Nesterov <oleg@redhat.com>

The forked child can have TIF_SIGPENDING if it was copied from parent's
ti->flags.  But this is harmless and actually almost never happens,
because copy_process() can't succeed if signal_pending() == T.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/fork.c~copy_process-remove-the-unneeded-clear_tsk_thread_flagtif_sigpending kernel/fork.c
--- a/kernel/fork.c~copy_process-remove-the-unneeded-clear_tsk_thread_flagtif_sigpending
+++ a/kernel/fork.c
@@ -1027,7 +1027,6 @@ static struct task_struct *copy_process(
 	p->vfork_done = NULL;
 	spin_lock_init(&p->alloc_lock);
 
-	clear_tsk_thread_flag(p, TIF_SIGPENDING);
 	init_sigpending(&p->pending);
 
 	p->utime = cputime_zero;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
ptrace-remove-pt_dtrace-from-arch-h8300.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch
ptrace-remove-pt_dtrace-from-arch-m32r.patch
ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch
copy_process-remove-the-unneeded-clear_tsk_thread_flagtif_sigpending.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

