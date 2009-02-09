From: akpm@linux-foundation.org
Subject: + futex-fix-reference-leak.patch added to -mm tree
Date: Mon, 09 Feb 2009 12:40:52 -0800
Message-ID: <200902092040.n19Kete9008580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699AbZBIUm3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 15:42:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterz@infradead.org, a.p.zijlstra@chello.nl, catalin.marinas@arm.com, mingo@elte.hu, venkatesh.pallipadi@intel.com


The patch titled
     futex: fix reference leak
has been added to the -mm tree.  Its filename is
     futex-fix-reference-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches.patch
mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches-fix.patch
futex-fix-reference-leak.patch
linux-next.patch

