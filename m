From: akpm@linux-foundation.org
Subject: + ptrace-clear-tif_syscall_trace-on-ptrace-detach.patch added to
 -mm tree
Date: Thu, 01 Sep 2016 15:02:53 -0700
Message-ID: <57c8a58d.2KKB2IPfLIn4FSAR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59496 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752353AbcIAWCy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2016 18:02:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alnovak@suse.cz, jkosina@suse.cz, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace: clear TIF_SYSCALL_TRACE on ptrace detach
has been added to the -mm tree.  Its filename is
     ptrace-clear-tif_syscall_trace-on-ptrace-detach.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ptrace-clear-tif_syscall_trace-on-ptrace-detach.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ptrace-clear-tif_syscall_trace-on-ptrace-detach.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ales Novak <alnovak@suse.cz>
Subject: ptrace: clear TIF_SYSCALL_TRACE on ptrace detach

On __ptrace_detach(), called from do_exit()->exit_notify()->
forget_original_parent()->exit_ptrace(), the TIF_SYSCALL_TRACE in
thread->flags of the tracee is not cleared up.  This results in the
tracehook_report_syscall_* being called (though there's no longer a tracer
listening to that) upon its further syscalls.

Example scenario - attach "strace" to a running process and kill it (the
strace) with SIGKILL.  You'll see that the syscall trace hooks are still
being called.

The clearing of this flag should be moved from ptrace_detach() to
__ptrace_detach().

Link: http://lkml.kernel.org/r/1472759493-20554-1-git-send-email-alnovak@suse.cz
Signed-off-by: Ales Novak <alnovak@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/ptrace.c~ptrace-clear-tif_syscall_trace-on-ptrace-detach kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-clear-tif_syscall_trace-on-ptrace-detach
+++ a/kernel/ptrace.c
@@ -73,6 +73,8 @@ void __ptrace_unlink(struct task_struct
 {
 	BUG_ON(!child->ptrace);
 
+	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
+
 	child->parent = child->real_parent;
 	list_del_init(&child->ptrace_entry);
 
@@ -489,7 +491,6 @@ static int ptrace_detach(struct task_str
 
 	/* Architecture-specific hardware disable .. */
 	ptrace_disable(child);
-	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 
 	write_lock_irq(&tasklist_lock);
 	/*
_

Patches currently in -mm which might be from alnovak@suse.cz are

ptrace-clear-tif_syscall_trace-on-ptrace-detach.patch

