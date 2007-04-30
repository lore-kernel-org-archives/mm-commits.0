From: akpm@linux-foundation.org
Subject: - futex-restartable-futex_wait-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:39:59 -0700
Message-ID: <200704301939.l3UJdxQq013131@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946738AbXD3TkX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:40:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, drepper@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, roland@redhat.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     fix for futex restart patch
has been removed from the -mm tree.  Its filename was
     futex-restartable-futex_wait-fix.patch

This patch was dropped because it was folded into futex-restartable-futex_wait.patch

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
@@ -981,12 +981,14 @@ static void unqueue_me_pi(struct futex_q
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
 
@@ -1066,8 +1068,21 @@ static int futex_wait(u32 __user *uaddr,
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
@@ -1078,14 +1093,14 @@ static int futex_wait(u32 __user *uaddr,
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
@@ -1093,7 +1108,8 @@ static int futex_wait(u32 __user *uaddr,
 		restart->fn = futex_wait_restart;
 		restart->arg0 = (unsigned long)uaddr;
 		restart->arg1 = (unsigned long)val;
-		restart->arg2 = time;
+		restart->arg2 = (unsigned long)timed;
+		restart->arg3 = abs_time;
 		return -ERESTART_RESTARTBLOCK;
 	}
 
@@ -1105,14 +1121,21 @@ static int futex_wait(u32 __user *uaddr,
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

mm-remove-gcc-workaround.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
mm-simplify-filemap_nopage.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
mm-madvise-avoid-exclusive-mmap_sem.patch
mm-document-fault_data-and-flags.patch
oom-fix-constraint-deadlock.patch
exec-fix-remove_arg_zero.patch
as-fix-antic_expire-check.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
