From: akpm@linux-foundation.org
Subject: [merged]
 signals-change-wait_for_helper-to-use-kernel_sigaction.patch removed from
 -mm tree
Date: Mon, 09 Jun 2014 12:34:27 -0700
Message-ID: <53960c43.hulSmg46QOCspCwd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaFITe2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:34:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tj@kernel.org, rostedt@goodmis.org, richard@nod.at, peterz@infradead.org, mingo@kernel.org, mathieu.desnoyers@efficios.com, geert@linux-m68k.org, fweisbec@gmail.com, dwmw2@infradead.org, oleg@redhat.com

Subject: [merged] signals-change-wait_for_helper-to-use-kernel_sigaction.patch removed from -mm tree
To: oleg@redhat.com,dwmw2@infradead.org,fweisbec@gmail.com,geert@linux-m68k.org,mathieu.desnoyers@efficios.com,mingo@kernel.org,peterz@infradead.org,richard@nod.at,rostedt@goodmis.org,tj@kernel.org,viro@ZenIV.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:34:27 -0700


The patch titled
     Subject: signals: change wait_for_helper() to use kernel_sigaction()
has been removed from the -mm tree.  Its filename was
     signals-change-wait_for_helper-to-use-kernel_sigaction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: signals: change wait_for_helper() to use kernel_sigaction()

Now that we have kernel_sigaction() we can change wait_for_helper() to use
it and cleans up the code a bit.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/kmod.c~signals-change-wait_for_helper-to-use-kernel_sigaction kernel/kmod.c
--- a/kernel/kmod.c~signals-change-wait_for_helper-to-use-kernel_sigaction
+++ a/kernel/kmod.c
@@ -285,10 +285,7 @@ static int wait_for_helper(void *data)
 	pid_t pid;
 
 	/* If SIGCLD is ignored sys_wait4 won't populate the status. */
-	spin_lock_irq(&current->sighand->siglock);
-	current->sighand->action[SIGCHLD-1].sa.sa_handler = SIG_DFL;
-	spin_unlock_irq(&current->sighand->siglock);
