From: akpm@linux-foundation.org
Subject: + signals-do_group_exit-use-signal_group_exit-more-consistently.patch added to -mm tree
Date: Fri, 15 Feb 2008 13:05:58 -0800
Message-ID: <200802152105.m1FL5wDI023899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54817 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765948AbYBOVGx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 16:06:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: do_group_exit(): use signal_group_exit() more consistently
has been added to the -mm tree.  Its filename is
     signals-do_group_exit-use-signal_group_exit-more-consistently.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1053,12 +1053,13 @@ asmlinkage long sys_exit(int error_code)
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

mmap_region-cleanup-the-final-vma_merge-related-code.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
signals-do_group_exit-use-signal_group_exit-more-consistently.patch
timers-simplify-lockdep-stuff.patch
hrtimers-simplify-lockdep-stuff.patch
kill-double_spin_lock.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
