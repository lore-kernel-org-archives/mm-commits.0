From: akpm@linux-foundation.org
Subject: [merged] um-fix-crash-while-os_dump_core.patch removed from -mm tree
Date: Wed, 25 May 2011 13:31:08 -0700
Message-ID: <201105252029.p4PKTVQn014848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932173Ab1EYUaH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:30:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     um: fix crash while os_dump_core()
has been removed from the -mm tree.  Its filename was
     um-fix-crash-while-os_dump_core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: fix crash while os_dump_core()
From: Richard Weinberger <richard@nod.at>

os_dump_core() emits SIGTERM to terminate all UML processes.  Kernel
threads have to exit on SIGTERM instead of calling last_ditch_exit(). 
Multiple calls to last_ditch_exit() can cause a crash.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/process.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/um/os-Linux/process.c~um-fix-crash-while-os_dump_core arch/um/os-Linux/process.c
--- a/arch/um/os-Linux/process.c~um-fix-crash-while-os_dump_core
+++ a/arch/um/os-Linux/process.c
@@ -253,6 +253,7 @@ void init_new_thread_signals(void)
 		    SA_ONSTACK | SA_RESTART, SIGUSR1, SIGIO, SIGWINCH, SIGALRM,
 		    SIGVTALRM, -1);
 	signal(SIGWINCH, SIG_IGN);
+	signal(SIGTERM, SIG_DFL);
 }
 
 int run_kernel_thread(int (*fn)(void *), void *arg, jmp_buf **jmp_ptr)
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch

