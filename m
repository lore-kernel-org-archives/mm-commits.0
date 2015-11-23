From: akpm@linux-foundation.org
Subject: [merged] signal-unexport-sigsuspend.patch removed from -mm tree
Date: Mon, 23 Nov 2015 12:15:17 -0800
Message-ID: <565373d5.ECf9BZlJjJSkDLie%akpm__46527.8882220902$1448309775$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbbKWUPS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 15:15:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, oleg@redhat.com, stable@vger.kernel.org, vegard.nossum@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/signal.c: unexport sigsuspend()
has been removed from the -mm tree.  Its filename was
     signal-unexport-sigsuspend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Richard Weinberger <richard@nod.at>
Subject: kernel/signal.c: unexport sigsuspend()

sigsuspend() is nowhere used except in signal.c itself, so we can mark it
static do not pollute the global namespace.

But this patch is more than a boring cleanup patch, it fixes a real issue
on UserModeLinux.  UML has a special console driver to display ttys using
xterm, or other terminal emulators, on the host side.  Vegard reported
that sometimes UML is unable to spawn a xterm and he's facing the
following warning:

WARNING: CPU: 0 PID: 908 at include/linux/thread_info.h:128 sigsuspend+0xab/0xc0()

It turned out that this warning makes absolutely no sense as the UML xterm
code calls sigsuspend() on the host side, at least it tries.  But as the
kernel itself offers a sigsuspend() symbol the linker choose this one
instead of the glibc wrapper.  Interestingly this code used to work since
ever but always blocked signals on the wrong side.  Some recent kernel
change made the WARN_ON() trigger and uncovered the bug.

It is a wonderful example of how much works by chance on computers. :-)

Fixes: 68f3f16d9ad0f1 ("new helper: sigsuspend()")
Signed-off-by: Richard Weinberger <richard@nod.at>
Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Tested-by: Vegard Nossum <vegard.nossum@oracle.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>	[3.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |    1 -
 kernel/signal.c        |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/signal.h~signal-unexport-sigsuspend include/linux/signal.h
--- a/include/linux/signal.h~signal-unexport-sigsuspend
+++ a/include/linux/signal.h
@@ -239,7 +239,6 @@ extern int sigprocmask(int, sigset_t *,
 extern void set_current_blocked(sigset_t *);
 extern void __set_current_blocked(const sigset_t *);
 extern int show_unhandled_signals;
-extern int sigsuspend(sigset_t *);
 
 struct sigaction {
 #ifndef __ARCH_HAS_IRIX_SIGACTION
diff -puN kernel/signal.c~signal-unexport-sigsuspend kernel/signal.c
--- a/kernel/signal.c~signal-unexport-sigsuspend
+++ a/kernel/signal.c
@@ -3503,7 +3503,7 @@ SYSCALL_DEFINE0(pause)
 
 #endif
 
-int sigsuspend(sigset_t *set)
+static int sigsuspend(sigset_t *set)
 {
 	current->saved_sigmask = current->blocked;
 	set_current_blocked(set);
_

Patches currently in -mm which might be from richard@nod.at are


