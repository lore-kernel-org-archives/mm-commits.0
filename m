From: akpm@linux-foundation.org
Subject: + lockdep-lockdep_depth-vs-debug_locks-re-bug-workqueue-leaked-lock.patch added to -mm tree
Date: Wed, 21 Mar 2007 23:49:24 -0800
Message-ID: <200703220749.l2M7nOqu015235@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43247 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030234AbXCVHuF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 03:50:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkao2@o2.pl, a.p.zijlstra@chello.nl, folkert@vanheusden.com, mingo@elte.hu, oleg@tv-sign.ru


The patch titled
     lockdep: lockdep_depth vs. debug_locks
has been added to the -mm tree.  Its filename is
     lockdep-lockdep_depth-vs-debug_locks-re-bug-workqueue-leaked-lock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

lockdep-lockdep_depth-vs-debug_locks-re-bug-workqueue-leaked-lock.patch
lockdep-debug_show_all_locks-debug_show_held_locks-vs-debug_locks.patch
