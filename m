From: akpm@linux-foundation.org
Subject: + ptrace-introduce-ptrace_o_exitkill.patch added to -mm tree
Date: Mon, 19 Nov 2012 14:53:23 -0800
Message-ID: <20121119225323.A7D7B82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:65198 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2KSWx0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Nov 2012 17:53:26 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so616719vbi.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Nov 2012 14:53:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dhowells@redhat.com, dvlasenk@redhat.com, ebiederm@xmission.com, mtk.manpages@gmail.com, scarybeasts@gmail.com, serge.hallyn@canonical.com, u3557@miso.sublimeip.com


The patch titled
     Subject: ptrace: introduce PTRACE_O_EXITKILL
has been added to the -mm tree.  Its filename is
     ptrace-introduce-ptrace_o_exitkill.patch

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

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Suggested-by: Amnon Shiloh <u3557@miso.sublimeip.com>
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

linux-next.patch
mm-oom-change-type-of-oom_score_adj-to-short.patch
mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin.patch
percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarily.patch
percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessari-lyfix.patch
uprobes-use-percpu_rw_semaphore-to-fix-register-unregister-vs-dup_mmap-race.patch
ptrace-introduce-ptrace_o_exitkill.patch
procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers.patch
fs-eventfd-add-procfs-fdinfo-helper.patch
fs-epoll-add-procfs-fdinfo-helper-v2.patch
fdinfo-show-sigmask-for-signalfd-fd-v3.patch
fs-exportfs-escape-nil-dereference-if-no-s_export_op-present.patch
fs-exportfs-add-exportfs_encode_inode_fh-helper.patch
fs-notify-add-procfs-fdinfo-helper-v6.patch
fs-notify-add-procfs-fdinfo-helper-v6-fix.patch

