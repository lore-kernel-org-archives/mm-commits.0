From: akpm@linux-foundation.org
Subject: + signals-jffs2-fix-the-wrong-usage-of-disallow_signal.patch
 added to -mm tree
Date: Tue, 15 Apr 2014 12:28:52 -0700
Message-ID: <534d8874.qlzPEF19A3dbl9KR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbaDOT2x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Apr 2014 15:28:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tj@kernel.org, rostedt@goodmis.org, richard@nod.at, peterz@infradead.org, mingo@kernel.org, mathieu.desnoyers@efficios.com, geert@linux-m68k.org, fweisbec@gmail.com, dwmw2@infradead.org, oleg@redhat.com

Subject: + signals-jffs2-fix-the-wrong-usage-of-disallow_signal.patch added to -mm tree
To: oleg@redhat.com,dwmw2@infradead.org,fweisbec@gmail.com,geert@linux-m68k.org,mathieu.desnoyers@efficios.com,mingo@kernel.org,peterz@infradead.org,richard@nod.at,rostedt@goodmis.org,tj@kernel.org,viro@ZenIV.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 15 Apr 2014 12:28:52 -0700


The patch titled
     Subject: signals: jffs2: fix the wrong usage of disallow_signal()
has been added to the -mm tree.  Its filename is
     signals-jffs2-fix-the-wrong-usage-of-disallow_signal.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/signals-jffs2-fix-the-wrong-usage-of-disallow_signal.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/signals-jffs2-fix-the-wrong-usage-of-disallow_signal.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: signals: jffs2: fix the wrong usage of disallow_signal()

jffs2_garbage_collect_thread() does disallow_signal(SIGHUP) around
jffs2_garbage_collect_pass() and the comment says "We don't want SIGHUP to
interrupt us".

But disallow_signal() can't ensure that jffs2_garbage_collect_pass() won't
be interrupted by SIGHUP, the problem is that SIGHUP can be already
pending when disallow_signal() is called, and in this case any
interruptible sleep won't block.

Note: this is in fact because disallow_signal() is buggy and should be
fixed, see the next changes.

But there is another reason why disallow_signal() is wrong: SIG_IGN set by
disallow_signal() silently discards any SIGHUP which can be sent before
the next allow_signal(SIGHUP).

Change this code to use sigprocmask(SIG_UNBLOCK/SIG_BLOCK, SIGHUP).  This
even matches the old (and wrong) semantics allow/disallow had when this
logic was written.

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

 fs/jffs2/background.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN fs/jffs2/background.c~signals-jffs2-fix-the-wrong-usage-of-disallow_signal fs/jffs2/background.c
--- a/fs/jffs2/background.c~signals-jffs2-fix-the-wrong-usage-of-disallow_signal
+++ a/fs/jffs2/background.c
@@ -75,10 +75,13 @@ void jffs2_stop_garbage_collect_thread(s
 static int jffs2_garbage_collect_thread(void *_c)
 {
 	struct jffs2_sb_info *c = _c;
+	sigset_t hupmask;
 
+	siginitset(&hupmask, sigmask(SIGHUP));
 	allow_signal(SIGKILL);
 	allow_signal(SIGSTOP);
 	allow_signal(SIGCONT);
+	allow_signal(SIGHUP);
 
 	c->gc_task = current;
 	complete(&c->gc_thread_start);
@@ -87,7 +90,7 @@ static int jffs2_garbage_collect_thread(
 
 	set_freezable();
 	for (;;) {
-		allow_signal(SIGHUP);
+		sigprocmask(SIG_UNBLOCK, &hupmask, NULL);
 	again:
 		spin_lock(&c->erase_completion_lock);
 		if (!jffs2_thread_should_wake(c)) {
@@ -95,10 +98,9 @@ static int jffs2_garbage_collect_thread(
 			spin_unlock(&c->erase_completion_lock);
 			jffs2_dbg(1, "%s(): sleeping...\n", __func__);
 			schedule();
-		} else
+		} else {
 			spin_unlock(&c->erase_completion_lock);
-			
-
+		}
 		/* Problem - immediately after bootup, the GCD spends a lot
 		 * of time in places like jffs2_kill_fragtree(); so much so
 		 * that userspace processes (like gdm and X) are starved
@@ -150,7 +152,7 @@ static int jffs2_garbage_collect_thread(
 			}
 		}
 		/* We don't want SIGHUP to interrupt us. STOP and KILL are OK though. */
-		disallow_signal(SIGHUP);
+		sigprocmask(SIG_BLOCK, &hupmask, NULL);
 
 		jffs2_dbg(1, "%s(): pass\n", __func__);
 		if (jffs2_garbage_collect_pass(c) == -ENOSPC) {
_

Patches currently in -mm which might be from oleg@redhat.com are

signals-kill-sigfindinword.patch
signals-s-siginitset-sigemptyset-in-do_sigtimedwait.patch
signals-kill-rm_from_queue-change-prepare_signal-to-use-for_each_thread.patch
signals-rename-rm_from_queue_full-to-flush_sigqueue_mask.patch
signals-cleanup-the-usage-of-t-current-in-do_sigaction.patch
signals-mv-disallow_signal-from-schedh-exitc-to-signal.patch
signals-jffs2-fix-the-wrong-usage-of-disallow_signal.patch
signals-kill-the-obsolete-sigdelset-and-recalc_sigpending-in-allow_signal.patch
signals-disallow_signal-should-flush-the-potentially-pending-signal.patch
signals-introduce-kernel_sigaction.patch
signals-change-wait_for_helper-to-use-kernel_sigaction.patch

