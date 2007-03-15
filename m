From: akpm@linux-foundation.org
Subject: + futex-restartable-futex_wait-fix.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:48:02 -0800
Message-ID: <200703151848.l2FIm4UJ023219@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35301 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbXCOSsn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:48:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, drepper@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, roland@redhat.com, rusty@rustcorp.com.au


The patch titled
     fix for futex restart patch
has been added to the -mm tree.  Its filename is
     futex-restartable-futex_wait-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix for futex restart patch
From: Nick Piggin <npiggin@suse.de>

This uses absolute timeouts for futex restarts, so that we never lose a jiffy
during the restart. Can be folded with the other futex patch.

Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |   39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff -puN kernel/futex.c~futex-restartable-futex_wait-fix kernel/futex.c
--- a/kernel/futex.c~futex-restartable-futex_wait-fix
+++ a/kernel/futex.c
@@ -1001,12 +1001,14 @@ static void unqueue_me_pi(struct futex_q
 }
 
 static long futex_wait_restart(struct restart_block *restart);
-static int futex_wait(u32 __user *uaddr, u32 val, unsigned long time)
+static int futex_wait_abstime(u32 __user *uaddr, u32 val,
+			int timed, unsigned long abs_time)
 {
 	struct task_struct *curr = current;
 	DECLARE_WAITQUEUE(wait, curr);
 	struct futex_hash_bucket *hb;
 	struct futex_q q;
+	unsigned long time_left = 0;
 	u32 uval;
 	int ret;
 
@@ -1086,8 +1088,21 @@ static int futex_wait(u32 __user *uaddr,
 	 * !list_empty() is safe here without any lock.
 	 * q.lock_ptr != 0 is not safe, because of ordering against wakeup.
 	 */
-	if (likely(!list_empty(&q.list)))
-		time = schedule_timeout(time);
+	time_left = 0;
+	if (likely(!list_empty(&q.list))) {
+		unsigned long rel_time;
+
+		if (timed) {
+			unsigned long now = jiffies;
+			if (time_after(now, abs_time))
+				rel_time = 0;
+			else
+				rel_time = abs_time - now;
+		} else
+			rel_time = MAX_SCHEDULE_TIMEOUT;
+
+		time_left = schedule_timeout(rel_time);
+	}
 	__set_current_state(TASK_RUNNING);
 
 	/*
@@ -1098,14 +1113,14 @@ static int futex_wait(u32 __user *uaddr,
 	/* If we were woken (and unqueued), we succeeded, whatever. */
 	if (!unqueue_me(&q))
 		return 0;
-	if (time == 0)
+	if (time_left == 0)
 		return -ETIMEDOUT;
 
 	/*
 	 * We expect signal_pending(current), but another thread may
 	 * have handled it for us already.
 	 */
-	if (time == MAX_SCHEDULE_TIMEOUT)
+	if (time_left == MAX_SCHEDULE_TIMEOUT)
 		return -ERESTARTSYS;
 	else {
 		struct restart_block *restart;
@@ -1113,7 +1128,8 @@ static int futex_wait(u32 __user *uaddr,
 		restart->fn = futex_wait_restart;
 		restart->arg0 = (unsigned long)uaddr;
 		restart->arg1 = (unsigned long)val;
-		restart->arg2 = time;
+		restart->arg2 = (unsigned long)timed;
+		restart->arg3 = abs_time;
 		return -ERESTART_RESTARTBLOCK;
 	}
 
@@ -1125,14 +1141,21 @@ static int futex_wait(u32 __user *uaddr,
 	return ret;
 }
 
+static int futex_wait(u32 __user *uaddr, u32 val, unsigned long rel_time)
+{
+	int timed = (rel_time != MAX_SCHEDULE_TIMEOUT);
+	return futex_wait_abstime(uaddr, val, timed, jiffies+rel_time);
+}
+
 static long futex_wait_restart(struct restart_block *restart)
 {
 	u32 __user *uaddr = (u32 __user *)restart->arg0;
 	u32 val = (u32)restart->arg1;
-	unsigned long time = restart->arg2;
+	int timed = (int)restart->arg2;
+	unsigned long abs_time = restart->arg3;
 
 	restart->fn = do_no_restart_syscall;
-	return (long)futex_wait(uaddr, val, time);
+	return (long)futex_wait_abstime(uaddr, val, timed, abs_time);
 }
 
 
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-fix-madvise-infinine-loop.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
splice-dont-steal.patch
splice-dont-readpage.patch
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
as-fix-antic_expire-check.patch
