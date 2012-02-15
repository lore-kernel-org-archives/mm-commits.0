From: akpm@linux-foundation.org
Subject: + ptrace-make-ptrace_seize-set-ptrace-options-specified-in-data-parameter.patch added to -mm tree
Date: Wed, 15 Feb 2012 15:02:56 -0800
Message-ID: <20120215230257.00B93A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qw0-f74.google.com ([209.85.216.74]:43478 "EHLO
	mail-qw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab2BOXC6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2012 18:02:58 -0500
Received: by qadb12 with SMTP id b12so256851qad.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2012 15:02:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com, oleg@redhat.com, palves@redhat.com, tj@kernel.org


The patch titled
     Subject: ptrace: make PTRACE_SEIZE set ptrace options specified in 'data' parameter
has been added to the -mm tree.  Its filename is
     ptrace-make-ptrace_seize-set-ptrace-options-specified-in-data-parameter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: ptrace: make PTRACE_SEIZE set ptrace options specified in 'data' parameter

This can be used to close a few corner cases in strace where we get
unwanted racy behavior after attach, but before we have a chance to set
options (the notorious post-execve SIGTRAP comes to mind), and removes the
need to track "did we set opts for this task" state in strace internals.

While we are at it:

Make it possible to extend SEIZE in the future with more functionality by
passing non-zero 'addr' parameter.  To that end, error out if 'addr' is
non-zero.  PTRACE_ATTACH did not (and still does not) have such check, and
users (strace) do pass garbage there...  let's avoid repeating this
mistake with SEIZE.

Set all task->ptrace bits in one operation - before this change, we were
adding PT_SEIZED and PT_PTRACE_CAP with task->ptrace |= BIT ops.  This was
probably ok (not a bug), but let's be on a safer side.

Changes since v2: use (unsigned long) casts instead of (long) ones, move
PTRACE_SEIZE_DEVEL-related code to separate lines of code.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Pedro Alves <palves@redhat.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff -puN kernel/ptrace.c~ptrace-make-ptrace_seize-set-ptrace-options-specified-in-data-parameter kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-make-ptrace_seize-set-ptrace-options-specified-in-data-parameter
+++ a/kernel/ptrace.c
@@ -231,6 +231,7 @@ bool ptrace_may_access(struct task_struc
 }
 
 static int ptrace_attach(struct task_struct *task, long request,
+			 unsigned long addr,
 			 unsigned long flags)
 {
 	bool seize = (request == PTRACE_SEIZE);
@@ -238,19 +239,29 @@ static int ptrace_attach(struct task_str
 
 	/*
 	 * SEIZE will enable new ptrace behaviors which will be implemented
-	 * gradually.  SEIZE_DEVEL is used to prevent applications
+	 * gradually.  SEIZE_DEVEL bit is used to prevent applications
 	 * expecting full SEIZE behaviors trapping on kernel commits which
 	 * are still in the process of implementing them.
 	 *
 	 * Only test programs for new ptrace behaviors being implemented
 	 * should set SEIZE_DEVEL.  If unset, SEIZE will fail with -EIO.
 	 *
-	 * Once SEIZE behaviors are completely implemented, this flag and
-	 * the following test will be removed.
+	 * Once SEIZE behaviors are completely implemented, this flag
+	 * will be removed.
 	 */
 	retval = -EIO;
-	if (seize && !(flags & PTRACE_SEIZE_DEVEL))
-		goto out;
+	if (seize) {
+		if (addr != 0)
+			goto out;
+		if (!(flags & PTRACE_SEIZE_DEVEL))
+			goto out;
+		flags &= ~(unsigned long)PTRACE_SEIZE_DEVEL;
+		if (flags & ~(unsigned long)PTRACE_O_MASK)
+			goto out;
+		flags = PT_PTRACED | PT_SEIZED | (flags << PT_OPT_FLAG_SHIFT);
+	} else {
+		flags = PT_PTRACED;
+	}
 
 	audit_ptrace(task);
 
@@ -282,11 +293,11 @@ static int ptrace_attach(struct task_str
 	if (task->ptrace)
 		goto unlock_tasklist;
 
-	task->ptrace = PT_PTRACED;
 	if (seize)
-		task->ptrace |= PT_SEIZED;
+		flags |= PT_SEIZED;
 	if (ns_capable(task_user_ns(task), CAP_SYS_PTRACE))
-		task->ptrace |= PT_PTRACE_CAP;
+		flags |= PT_PTRACE_CAP;
+	task->ptrace = flags;
 
 	__ptrace_link(task, current);
 
@@ -879,7 +890,7 @@ SYSCALL_DEFINE4(ptrace, long, request, l
 	}
 
 	if (request == PTRACE_ATTACH || request == PTRACE_SEIZE) {
-		ret = ptrace_attach(child, request, data);
+		ret = ptrace_attach(child, request, addr, data);
 		/*
 		 * Some architectures need to do book-keeping after
 		 * a ptrace attach.
@@ -1022,7 +1033,7 @@ asmlinkage long compat_sys_ptrace(compat
 	}
 
 	if (request == PTRACE_ATTACH || request == PTRACE_SEIZE) {
-		ret = ptrace_attach(child, request, data);
+		ret = ptrace_attach(child, request, addr, data);
 		/*
 		 * Some architectures need to do book-keeping after
 		 * a ptrace attach.
_
Subject: Subject: ptrace: make PTRACE_SEIZE set ptrace options specified in 'data' parameter

Patches currently in -mm which might be from vda.linux@googlemail.com are

linux-next.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
ptrace-the-killed-tracee-should-not-enter-the-syscall.patch
ptrace-dont-send-sigtrap-on-exec-if-seized.patch
ptrace-dont-modify-flags-on-ptrace_setoptions-failure.patch
ptrace-simplify-ptrace_foo-constants-and-ptrace_setoptions-code.patch
ptrace-make-ptrace_seize-set-ptrace-options-specified-in-data-parameter.patch
ptrace-renumber-ptrace_event_stop-so-that-future-new-options-and-events-can-match.patch
ptrace-remove-ptrace_seize_devel-bit.patch

