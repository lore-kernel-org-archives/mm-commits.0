From: akpm@linux-foundation.org
Subject: [to-be-updated] futex-fix-reference-leak.patch removed from -mm tree
Date: Tue, 17 Feb 2009 11:46:48 -0800
Message-ID: <200902171946.n1HJkmtw001910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754571AbZBQTrm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 14:47:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterz@infradead.org, a.p.zijlstra@chello.nl, catalin.marinas@arm.com, dvhltc@us.ibm.com, mingo@elte.hu, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     futex: fix reference leak
has been removed from the -mm tree.  Its filename was
     futex-fix-reference-leak.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: futex: fix reference leak
From: Peter Zijlstra <peterz@infradead.org>

Catalin noticed that (38d47c1b7075: futex: rely on get_user_pages() for
shared futexes) caused an mm_struct leak.

Some tracing with the function graph tracer quickly pointed out that
futex_wait() has exit paths with unbalanced reference counts.

This regression was discovered by kmemleak.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Tested-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff -puN kernel/futex.c~futex-fix-reference-leak kernel/futex.c
--- a/kernel/futex.c~futex-fix-reference-leak
+++ a/kernel/futex.c
@@ -1289,18 +1289,23 @@ retry:
 	 */
 
 	/* If we were woken (and unqueued), we succeeded, whatever. */
-	if (!unqueue_me(&q))
-		return 0;
-	if (rem)
-		return -ETIMEDOUT;
+	if (!unqueue_me(&q)) {
+		ret = 0;
+		goto out_put_key;
+	}
+	if (rem) {
+		ret = -ETIMEDOUT;
+		goto out_put_key;
+	}
 
 	/*
 	 * We expect signal_pending(current), but another thread may
 	 * have handled it for us already.
 	 */
-	if (!abs_time)
-		return -ERESTARTSYS;
-	else {
+	if (!abs_time) {
+		ret = -ERESTARTSYS;
+		goto out_put_key;
+	} else {
 		struct restart_block *restart;
 		restart = &current_thread_info()->restart_block;
 		restart->fn = futex_wait_restart;
@@ -1314,11 +1319,13 @@ retry:
 			restart->futex.flags |= FLAGS_SHARED;
 		if (clockrt)
 			restart->futex.flags |= FLAGS_CLOCKRT;
-		return -ERESTART_RESTARTBLOCK;
+		ret = -ERESTART_RESTARTBLOCK;
+		goto out_put_key;
 	}
 
 out_unlock_put_key:
 	queue_unlock(&q, hb);
+out_put_key:
 	put_futex_key(fshared, &q.key);
 
 out:
_

Patches currently in -mm which might be from peterz@infradead.org are

linux-next.patch
futex-fix-reference-leak.patch
fs-superc-add-lockdep-annotation-to-s_umount.patch
workqueue-avoid-recursion-in-run_workqueue.patch

