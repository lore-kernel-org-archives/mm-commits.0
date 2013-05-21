From: akpm@linux-foundation.org
Subject: +
 lib-klistc-del-waiter-from-klist_remove_waiters-before-waking-waiting-process.patch added to -mm tree
Date: Tue, 21 May 2013 13:54:00 -0700
Message-ID: <519bdee8.ux2EDV6h/hhLAViB%akpm__25787.5810996213$1369169652$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab3EUUyB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 May 2013 16:54:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yanmin_zhang@linux.intel.com, stable@vger.kernel.org, peterz@infradead.org, mingo@elte.hu, biao.wang@intel.com

Subject: + lib-klistc-del-waiter-from-klist_remove_waiters-before-waking-waiting-process.patch added to -mm tree
To: biao.wang@intel.com,mingo@elte.hu,peterz@infradead.org,stable@vger.kernel.org,yanmin_zhang@linux.intel.com
From: akpm@linux-foundation.org
Date: Tue, 21 May 2013 13:54:00 -0700


The patch titled
     Subject: lib/klist.c: del waiter from klist_remove_waiters before waking waiting process
has been added to the -mm tree.  Its filename is
     lib-klistc-del-waiter-from-klist_remove_waiters-before-waking-waiting-process.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-klistc-del-waiter-from-klist_remove_waiters-before-waking-waiting-process.patch

