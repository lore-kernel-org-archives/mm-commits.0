From: akpm@linux-foundation.org
Subject: - signals-do_group_exit-use-signal_group_exit-more-consistently.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:54 -0700
Message-ID: <200805010925.m419PsCI030249@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755950AbYEAJ1A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:27:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: do_group_exit(): use signal_group_exit() more consistently
has been removed from the -mm tree.  Its filename was
     signals-do_group_exit-use-signal_group_exit-more-consistently.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: do_group_exit(): use signal_group_exit() more consistently
From: Oleg Nesterov <oleg@tv-sign.ru>

do_group_exit() checks SIGNAL_GROUP_EXIT to avoid taking sighand->siglock. 
Since ed5d2cac114202fe2978a9cbcab8f5032796d538 exec() doesn't set this
flag, we should use signal_group_exit().

This is not needed for correctness, but can speedup the multithreaded exec
and makes the code more consistent.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/exit.c~signals-do_group_exit-use-signal_group_exit-more-consistently kernel/exit.c
--- a/kernel/exit.c~signals-do_group_exit-use-signal_group_exit-more-consistently
+++ a/kernel/exit.c
@@ -1115,12 +1115,13 @@ asmlinkage long sys_exit(int error_code)
 NORET_TYPE void
 do_group_exit(int exit_code)
 {
+	struct signal_struct *sig = current->signal;
+
 	BUG_ON(exit_code & 0x80); /* core dumps don't get here */
 
-	if (current->signal->flags & SIGNAL_GROUP_EXIT)
-		exit_code = current->signal->group_exit_code;
+	if (signal_group_exit(sig))
+		exit_code = sig->group_exit_code;
 	else if (!thread_group_empty(current)) {
-		struct signal_struct *const sig = current->signal;
 		struct sighand_struct *const sighand = current->sighand;
 		spin_lock_irq(&sighand->siglock);
 		if (signal_group_exit(sig))
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

