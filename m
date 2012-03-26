From: akpm@linux-foundation.org
Subject: [merged] ptrace-dont-modify-flags-on-ptrace_setoptions-failure.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:32:03 -0700
Message-ID: <20120326193203.7F01AA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:64249 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab2CZTcF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:32:05 -0400
Received: by mail-wi0-f202.google.com with SMTP id hj13so233297wib.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:32:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, jan.kratochvil@redhat.com, oleg@redhat.com, palves@redhat.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace: don't modify flags on PTRACE_SETOPTIONS failure
has been removed from the -mm tree.  Its filename was
     ptrace-dont-modify-flags-on-ptrace_setoptions-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from vda.linux@googlemail.com are

origin.patch
linux-next.patch

