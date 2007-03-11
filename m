From: akpm@linux-foundation.org
Subject: + futex-restartable-futex_wait.patch added to -mm tree
Date: Sun, 11 Mar 2007 00:14:36 -0800
Message-ID: <200703110814.l2B8EaI1007615@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39563 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbXCKIPP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 04:15:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, drepper@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, roland@redhat.com, rusty@rustcorp.com.au


The patch titled
     futex: restartable futex_wait
has been added to the -mm tree.  Its filename is
     futex-restartable-futex_wait.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: futex: restartable futex_wait
From: Nick Piggin <npiggin@suse.de>

LTP test sigaction_16_24 fails, because it expects sem_wait to be restarted
if SA_RESTART is set.  sem_wait is implemented with futex_wait, that
currently doesn't support being restarted.  Ulrich confirms that the call
should be restartable.

Implement a restart_block method to handle the relative timeout, and allow
restarts.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff -puN kernel/futex.c~futex-restartable-futex_wait kernel/futex.c
--- a/kernel/futex.c~futex-restartable-futex_wait
+++ a/kernel/futex.c
@@ -978,6 +978,7 @@ static void unqueue_me_pi(struct futex_q
 	drop_futex_key_refs(&q->key);
 }
 
+static long futex_wait_restart(struct restart_block *restart);
 static int futex_wait(u32 __user *uaddr, u32 val, unsigned long time)
 {
 	struct task_struct *curr = current;
@@ -1077,11 +1078,22 @@ static int futex_wait(u32 __user *uaddr,
 		return 0;
 	if (time == 0)
 		return -ETIMEDOUT;
+
 	/*
 	 * We expect signal_pending(current), but another thread may
 	 * have handled it for us already.
 	 */
-	return -EINTR;
+	if (time == MAX_SCHEDULE_TIMEOUT)
+		return -ERESTARTSYS;
+	else {
+		struct restart_block *restart;
+		restart = &current_thread_info()->restart_block;
+		restart->fn = futex_wait_restart;
+		restart->arg0 = (unsigned long)uaddr;
+		restart->arg1 = (unsigned long)val;
+		restart->arg2 = time;
+		return -ERESTART_RESTARTBLOCK;
+	}
 
  out_unlock_release_sem:
 	queue_unlock(&q, hb);
@@ -1091,6 +1103,17 @@ static int futex_wait(u32 __user *uaddr,
 	return ret;
 }
 
+static long futex_wait_restart(struct restart_block *restart)
+{
+	u32 __user *uaddr = (u32 __user *)restart->arg0;
+	u32 val = (u32)restart->arg1;
+	unsigned long time = restart->arg2;
+
+	restart->fn = do_no_restart_syscall;
+	return (long)futex_wait(uaddr, val, time);
+}
+
+
 /*
  * Userspace tried a 0 -> TID atomic transition of the futex value
  * and failed. The kernel side here does the whole locking operation:
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-fix-madvise-infinine-loop.patch
futex-restartable-futex_wait.patch
mm-remove-gcc-workaround.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch
mm-simplify-filemap_nopage.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
exec-fix-remove_arg_zero.patch
exec-fix-remove_arg_zero-add-comment.patch
