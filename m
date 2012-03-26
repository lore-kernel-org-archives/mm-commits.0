From: akpm@linux-foundation.org
Subject: [merged] ptrace-make-ptrace_seize-set-ptrace-options-specified-in-data-parameter.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:32:07 -0700
Message-ID: <20120326193207.7F8A1A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:45421 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab2CZTcJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:32:09 -0400
Received: by mail-fa0-f74.google.com with SMTP id a19so298511faa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:32:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, jan.kratochvil@redhat.com, oleg@redhat.com, palves@redhat.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace: make PTRACE_SEIZE set ptrace options specified in 'data' parameter
has been removed from the -mm tree.  Its filename was
     ptrace-make-ptrace_seize-set-ptrace-options-specified-in-data-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from vda.linux@googlemail.com are

origin.patch
linux-next.patch

