From: akpm@linux-foundation.org
Subject: [merged]
 lib-klistc-del-waiter-from-klist_remove_waiters-before-waking-waiting-process.patch removed from -mm tree
Date: Wed, 22 May 2013 12:33:18 -0700
Message-ID: <519d1d7e.p7SsMIDBlCIO3VcM%akpm__32288.3696215742$1369251210$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab3EVTdT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 May 2013 15:33:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yanmin_zhang@linux.intel.com, stable@vger.kernel.org, peterz@infradead.org, mingo@elte.hu, biao.wang@intel.com

Subject: [merged] lib-klistc-del-waiter-from-klist_remove_waiters-before-waking-waiting-process.patch removed from -mm tree
To: biao.wang@intel.com,mingo@elte.hu,peterz@infradead.org,stable@vger.kernel.org,yanmin_zhang@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 May 2013 12:33:18 -0700


The patch titled
     Subject: lib/klist.c: del waiter from klist_remove_waiters before waking waiting process
has been removed from the -mm tree.  Its filename was
     lib-klistc-del-waiter-from-klist_remove_waiters-before-waking-waiting-process.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "wang, biao" <biao.wang@intel.com>
Subject: lib/klist.c: del waiter from klist_remove_waiters before waking waiting process

There is a race between klist_remove() and klist_release().

klist_remove() uses a local var `waiter' stored on the stack.  When
klist_release() calls wake_up_process(waiter->process) to wake up the
waiter, the waiter might run immediately and reuse the stack.  Then,
klist_release() calls list_del(&waiter->list) to change previous wait data
and causes corruption in the waiting thread's stack area.

Signed-off-by: wang, biao <biao.wang@intel.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/klist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/klist.c~lib-klistc-del-waiter-from-klist_remove_waiters-before-waking-waiting-process lib/klist.c
--- a/lib/klist.c~lib-klistc-del-waiter-from-klist_remove_waiters-before-waking-waiting-process
+++ a/lib/klist.c
@@ -193,10 +193,10 @@ static void klist_release(struct kref *k
 		if (waiter->node != n)
 			continue;
 
+		list_del(&waiter->list);
 		waiter->woken = 1;
 		mb();
 		wake_up_process(waiter->process);
-		list_del(&waiter->list);
 	}
 	spin_unlock(&klist_remove_lock);
 	knode_set_klist(n, NULL);
_

Patches currently in -mm which might be from biao.wang@intel.com are

linux-next.patch

