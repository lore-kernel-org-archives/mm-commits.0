From: akpm@linux-foundation.org
Subject: + kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch added to -mm tree
Date: Tue, 24 Jan 2012 16:20:26 -0800
Message-ID: <20120125002027.7D23DA009D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:59886 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab2AYAU2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2012 19:20:28 -0500
Received: by yenr8 with SMTP id r8so456613yen.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2012 16:20:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vda.linux@googlemail.com, oleg@redhat.com


The patch titled
     Subject: kernel/exit.c: if init dies, log a signal which killed it, if any
has been added to the -mm tree.  Its filename is
     kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch

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

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/exit.c~kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any kernel/exit.c
--- a/kernel/exit.c~kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any
+++ a/kernel/exit.c
@@ -710,8 +710,11 @@ static struct task_struct *find_new_reap
 
 	if (unlikely(pid_ns->child_reaper == father)) {
 		write_unlock_irq(&tasklist_lock);
-		if (unlikely(pid_ns == &init_pid_ns))
-			panic("Attempted to kill init!");
+		if (unlikely(pid_ns == &init_pid_ns)) {
+			panic("Attempted to kill init! exitcode=%08x\n",
+				father->signal->group_exit_code ?:
+					father->exit_code);
+		}
 
 		zap_pid_ns_processes(pid_ns);
 		write_lock_irq(&tasklist_lock);
_
Subject: Subject: kernel/exit.c: if init dies, log a signal which killed it, if any

Patches currently in -mm which might be from vda.linux@googlemail.com are

kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch

