From: akpm@linux-foundation.org
Subject: [merged] ptrace-introduce-ptrace_o_exitkill.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:09:03 -0800
Message-ID: <20121218200903.C8EBF820055@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:44550 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246Ab2LRUJF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:09:05 -0500
Received: by mail-gg0-f201.google.com with SMTP id o6so125992ggm.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:09:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dhowells@redhat.com, dvlasenk@redhat.com, ebiederm@xmission.com, mtk.manpages@gmail.com, scarybeasts@gmail.com, serge.hallyn@canonical.com, u3557@miso.sublimeip.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace: introduce PTRACE_O_EXITKILL
has been removed from the -mm tree.  Its filename was
     ptrace-introduce-ptrace_o_exitkill.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ptrace: introduce PTRACE_O_EXITKILL

Ptrace jailers want to be sure that the tracee can never escape
from the control. However if the tracer dies unexpectedly the
tracee continues to run in potentially unsafe mode.

Add the new ptrace option PTRACE_O_EXITKILL. If the tracer exits
it sends SIGKILL to every tracee which has this bit set.

Note that the new option is not equal to the last-option << 1.  Because
currently all options have an event, and the new one starts the eventless
group.  It uses the random 20 bit, so we have the room for 12 more events,
but we can also add the new eventless options below this one.

Suggested by Amnon Shiloh.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Tested-by: Amnon Shiloh <u3557@miso.sublimeip.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Chris Evans <scarybeasts@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h      |    2 ++
 include/uapi/linux/ptrace.h |    5 ++++-
 kernel/ptrace.c             |    3 +++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff -puN include/linux/ptrace.h~ptrace-introduce-ptrace_o_exitkill include/linux/ptrace.h
--- a/include/linux/ptrace.h~ptrace-introduce-ptrace_o_exitkill
+++ a/include/linux/ptrace.h
@@ -32,6 +32,8 @@
 #define PT_TRACE_EXIT		PT_EVENT_FLAG(PTRACE_EVENT_EXIT)
 #define PT_TRACE_SECCOMP	PT_EVENT_FLAG(PTRACE_EVENT_SECCOMP)
 
+#define PT_EXITKILL		(PTRACE_O_EXITKILL << PT_OPT_FLAG_SHIFT)
+
 /* single stepping state bits (used on ARM and PA-RISC) */
 #define PT_SINGLESTEP_BIT	31
 #define PT_SINGLESTEP		(1<<PT_SINGLESTEP_BIT)
diff -puN include/uapi/linux/ptrace.h~ptrace-introduce-ptrace_o_exitkill include/uapi/linux/ptrace.h
--- a/include/uapi/linux/ptrace.h~ptrace-introduce-ptrace_o_exitkill
+++ a/include/uapi/linux/ptrace.h
@@ -73,7 +73,10 @@
 #define PTRACE_O_TRACEEXIT	(1 << PTRACE_EVENT_EXIT)
 #define PTRACE_O_TRACESECCOMP	(1 << PTRACE_EVENT_SECCOMP)
 
-#define PTRACE_O_MASK		0x000000ff
+/* eventless options */
+#define PTRACE_O_EXITKILL	(1 << 20)
+
+#define PTRACE_O_MASK		(0x000000ff | PTRACE_O_EXITKILL)
 
 #include <asm/ptrace.h>
 
diff -puN kernel/ptrace.c~ptrace-introduce-ptrace_o_exitkill kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-introduce-ptrace_o_exitkill
+++ a/kernel/ptrace.c
@@ -457,6 +457,9 @@ void exit_ptrace(struct task_struct *tra
 		return;
 
 	list_for_each_entry_safe(p, n, &tracer->ptraced, ptrace_entry) {
+		if (unlikely(p->ptrace & PT_EXITKILL))
+			send_sig_info(SIGKILL, SEND_SIG_FORCED, p);
+
 		if (__ptrace_detach(tracer, p))
 			list_add(&p->ptrace_entry, &ptrace_dead);
 	}
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch

