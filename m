From: akpm@linux-foundation.org
Subject: [merged] kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:28:28 -0700
Message-ID: <20120326192828.3CB3BA0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:52765 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2CZT23 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:28:29 -0400
Received: by qcsp5 with SMTP id p5so513560qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:28:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/exit.c: if init dies, log a signal which killed it, if any
has been removed from the -mm tree.  Its filename was
     kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: kernel/exit.c: if init dies, log a signal which killed it, if any

I just received another user's pleas for help when their init mysteriously
died.  I again explained that they need to check whether it died because
of bad instruction, a segv, or something else.  Which was an annoying
detour into writing a trivial C program to spawn his init and print its
exit code:

http://lists.busybox.net/pipermail/busybox/2012-January/077172.html

I hear you saying "just test it under /bin/sh".  Well, the crashing init
_was_ /bin/sh.

Which prompted me to make kernel do this first step automatically.  We can
print exit code, which makes it possible to see that death was from e.g. 
SIGILL without writing test programs.

[akpm@linux-foundation.org: add 0x to hex number output]
Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/exit.c~kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any kernel/exit.c
--- a/kernel/exit.c~kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any
+++ a/kernel/exit.c
@@ -711,8 +711,11 @@ static struct task_struct *find_new_reap
 
 	if (unlikely(pid_ns->child_reaper == father)) {
 		write_unlock_irq(&tasklist_lock);
-		if (unlikely(pid_ns == &init_pid_ns))
-			panic("Attempted to kill init!");
+		if (unlikely(pid_ns == &init_pid_ns)) {
+			panic("Attempted to kill init! exitcode=0x%08x\n",
+				father->signal->group_exit_code ?:
+					father->exit_code);
+		}
 
 		zap_pid_ns_processes(pid_ns);
 		write_lock_irq(&tasklist_lock);
_

Patches currently in -mm which might be from vda.linux@googlemail.com are

origin.patch
linux-next.patch

