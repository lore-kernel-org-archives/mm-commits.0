From: akpm@linux-foundation.org
Subject: + ptrace-dont-run-write_locktasklist_lock-if-the-parent-doesnt-ptrace-other-processes.patch added to -mm tree
Date: Wed, 21 Jul 2010 14:49:50 -0700
Message-ID: <201007212149.o6LLnopp017094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758819Ab0GUVuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 17:50:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yanmin_zhang@linux.intel.com, andi@firstfloor.org, oleg@redhat.com, rientjes@google.com, roland@redhat.com, stable@kernel.org


The patch titled
     ptrace: don't run write_lock(tasklist_lock) if the parent doesn't ptrace other processes
has been added to the -mm tree.  Its filename is
     ptrace-dont-run-write_locktasklist_lock-if-the-parent-doesnt-ptrace-other-processes.patch

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
Subject: ptrace: don't run write_lock(tasklist_lock) if the parent doesn't ptrace other processes
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>

We run some sub-cases (fork, exec, pipe, tcp, udp) of aim7 on 8-socket
machine.  Perf shows write_lock_irq(&tasklist_lock) consumes more than 50%
cpu time.

One hot caller is exit_ptrace.  If the exiting process doesn't ptrace
other processes, kernel needn't apply for the write lock on tasklist_lock.

With this patch against kernel 2.6.35-rc5, we get more than 10% result
improvement.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/ptrace.c~ptrace-dont-run-write_locktasklist_lock-if-the-parent-doesnt-ptrace-other-processes kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-dont-run-write_locktasklist_lock-if-the-parent-doesnt-ptrace-other-processes
+++ a/kernel/ptrace.c
@@ -331,6 +331,9 @@ void exit_ptrace(struct task_struct *tra
 	struct task_struct *p, *n;
 	LIST_HEAD(ptrace_dead);
 
+	if (list_empty(&tracer->ptraced))
+		return;
+
 	write_lock_irq(&tasklist_lock);
 	list_for_each_entry_safe(p, n, &tracer->ptraced, ptrace_entry) {
 		if (__ptrace_detach(tracer, p))
_

Patches currently in -mm which might be from yanmin_zhang@linux.intel.com are

ptrace-dont-run-write_locktasklist_lock-if-the-parent-doesnt-ptrace-other-processes.patch
linux-next.patch

