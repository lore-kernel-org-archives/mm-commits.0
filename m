From: akpm@linux-foundation.org
Subject: [patch 057/102] ptrace: clear TIF_SYSCALL_TRACE on ptrace detach
Date: Tue, 11 Oct 2016 13:53:46 -0700
Message-ID: <57fd515a.dj6Tsr8ig4CWzXFS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38049 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752710AbcJKUxs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:53:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, alnovak@suse.cz, jkosina@suse.cz, oleg@redhat.com

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
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>
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
