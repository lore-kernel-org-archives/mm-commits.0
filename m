From: akpm@linux-foundation.org
Subject: - lockdep-lockdep_depth-vs-debug_locks-re-bug-workqueue-leaked-lock.patch removed from -mm tree
Date: Sun, 25 Mar 2007 17:05:11 -0800
Message-ID: <200703260105.l2Q15BsQ008698@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38532 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933340AbXCZBFm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 21:05:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkao2@o2.pl, a.p.zijlstra@chello.nl, folkert@vanheusden.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     lockdep: lockdep_depth vs. debug_locks
has been removed from the -mm tree.  Its filename was
     lockdep-lockdep_depth-vs-debug_locks-re-bug-workqueue-leaked-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: lockdep_depth vs. debug_locks
From: Jarek Poplawski <jarkao2@o2.pl>

lockdep found a bug during a run of workqueue function - this could be also
caused by a bug from other code running simultaneously.

lockdep really shouldn't be used when debug_locks == 0!

Reported-by: Folkert van Heusden <folkert@vanheusden.com>
Inspired-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockdep.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/lockdep.h~lockdep-lockdep_depth-vs-debug_locks-re-bug-workqueue-leaked-lock include/linux/lockdep.h
--- a/include/linux/lockdep.h~lockdep-lockdep_depth-vs-debug_locks-re-bug-workqueue-leaked-lock
+++ a/include/linux/lockdep.h
@@ -245,7 +245,7 @@ extern void lock_release(struct lockdep_
 
 # define INIT_LOCKDEP				.lockdep_recursion = 0,
 
-#define lockdep_depth(tsk)	((tsk)->lockdep_depth)
+#define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
 
 #else /* !LOCKDEP */
 
_

Patches currently in -mm which might be from jarkao2@o2.pl are
