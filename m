From: akpm@linux-foundation.org
Subject: - signals-cleanup-the-usage-of-print_fatal_signal.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:55 -0700
Message-ID: <200805010926.m419QtXa030346@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752287AbYEAJmm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:42:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: cleanup the usage of print_fatal_signal()
has been removed from the -mm tree.  Its filename was
     signals-cleanup-the-usage-of-print_fatal_signal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: cleanup the usage of print_fatal_signal()
From: Oleg Nesterov <oleg@tv-sign.ru>

Move the callsite of print_fatal_signal() down, under "if
(sig_kernel_coredump(signr))", so we don't need to check signr != SIGKILL.

We are only interested in the sig_kernel_coredump() signals anyway, and due to
the previous changes we almost never can see other fatal signals here except
SIGKILL.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/signal.c~signals-cleanup-the-usage-of-print_fatal_signal kernel/signal.c
--- a/kernel/signal.c~signals-cleanup-the-usage-of-print_fatal_signal
+++ a/kernel/signal.c
@@ -1787,9 +1787,10 @@ relock:
 		 * Anything else is fatal, maybe with a core dump.
 		 */
 		current->flags |= PF_SIGNALED;
-		if ((signr != SIGKILL) && print_fatal_signals)
-			print_fatal_signal(regs, signr);
+
 		if (sig_kernel_coredump(signr)) {
+			if (print_fatal_signals)
+				print_fatal_signal(regs, signr);
 			/*
 			 * If it was able to dump core, this kills all
 			 * other threads in the group and synchronizes with
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

