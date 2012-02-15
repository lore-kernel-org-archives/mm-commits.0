From: akpm@linux-foundation.org
Subject: + ptrace-dont-modify-flags-on-ptrace_setoptions-failure.patch added to -mm tree
Date: Wed, 15 Feb 2012 15:02:52 -0800
Message-ID: <20120215230253.5B86CA016A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:63863 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab2BOXCz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2012 18:02:55 -0500
Received: by eaaf13 with SMTP id f13so51688eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2012 15:02:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com, oleg@redhat.com, palves@redhat.com, tj@kernel.org


The patch titled
     Subject: ptrace: don't modify flags on PTRACE_SETOPTIONS failure
has been added to the -mm tree.  Its filename is
     ptrace-dont-modify-flags-on-ptrace_setoptions-failure.patch

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
Subject: ptrace: don't modify flags on PTRACE_SETOPTIONS failure

On ptrace(PTRACE_SETOPTIONS, pid, 0, <opts>), we used to set those option
bits which are known, and then fail with -EINVAL if there are some unknown
bits in <opts>.

This is inconsistent with typical error handling, which does not change
any state if input is invalid.

This patch changes PTRACE_SETOPTIONS behavior so that in this case, we
return -EINVAL and don't change any bits in task->ptrace.

It's very unlikely that there is userspace code in the wild which will be
affected by this change: it should have the form

    ptrace(PTRACE_SETOPTIONS, pid, 0, PTRACE_O_BOGUSOPT)

where PTRACE_O_BOGUSOPT is a constant unknown to the kernel.  But kernel
headers, naturally, don't contain any PTRACE_O_BOGUSOPTs, thus the only
way userspace can use one if it defines one itself.  I can't see why
anyone would do such a thing deliberately.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Pedro Alves <palves@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/ptrace.c~ptrace-dont-modify-flags-on-ptrace_setoptions-failure kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-dont-modify-flags-on-ptrace_setoptions-failure
+++ a/kernel/ptrace.c
@@ -528,6 +528,9 @@ int ptrace_writedata(struct task_struct 
 
 static int ptrace_setoptions(struct task_struct *child, unsigned long data)
 {
+	if (data & ~(unsigned long)PTRACE_O_MASK)
+		return -EINVAL;
+
 	child->ptrace &= ~PT_TRACE_MASK;
 
 	if (data & PTRACE_O_TRACESYSGOOD)
@@ -551,7 +554,7 @@ static int ptrace_setoptions(struct task
 	if (data & PTRACE_O_TRACEEXIT)
 		child->ptrace |= PT_TRACE_EXIT;
 
-	return (data & ~PTRACE_O_MASK) ? -EINVAL : 0;
+	return 0;
 }
 
 static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
_
Subject: Subject: ptrace: don't modify flags on PTRACE_SETOPTIONS failure

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

