From: akpm@linux-foundation.org
Subject: [to-be-updated] workqueues-add-kerneldoc-for-flush_scheduled_work.patch removed from -mm tree
Date: Wed, 12 Aug 2009 15:02:37 -0700
Message-ID: <200908122202.n7CM2biX025314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751885AbZHLWCq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Aug 2009 18:02:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     workqueues: add kerneldoc for flush_scheduled_work()
has been removed from the -mm tree.  Its filename was
     workqueues-add-kerneldoc-for-flush_scheduled_work.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: workqueues: add kerneldoc for flush_scheduled_work()
From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1279) adds kerneldoc for flush_scheduled_work()
containing a stern warning that the function should be avoided.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN kernel/workqueue.c~workqueues-add-kerneldoc-for-flush_scheduled_work kernel/workqueue.c
--- a/kernel/workqueue.c~workqueues-add-kerneldoc-for-flush_scheduled_work
+++ a/kernel/workqueue.c
@@ -689,6 +689,24 @@ int schedule_on_each_cpu(work_func_t fun
 	return 0;
 }
 
+/**
+ * flush_scheduled_work - ensure that all work scheduled on keventd_wq has run to completion.
+ *
+ * Blocks until all works on the keventd_wq global workqueue have completed.
+ * We sleep until all works present upon entry have been handled, but we
+ * are not livelocked by new incoming ones.
+ *
+ * Use of this function is discouraged, as it is highly prone to deadlock.
+ * It should never be called from within a work routine on the global
+ * queue, and it should never be called while holding a mutex required
+ * by one of the works on the global queue.  But the fact that keventd_wq
+ * _is_ global means that it can contain works requiring practically any
+ * mutex.  Hence this routine shouldn't be called while holding any mutex.
+ *
+ * Consider using cancel_work_sync() or cancel_delayed_work_sync() instead.
+ * They don't do the same thing (they cancel the work instead of waiting
+ * for it to complete), but in most cases they will suffice.
+ */
 void flush_scheduled_work(void)
 {
 	flush_workqueue(keventd_wq);
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

origin.patch
linux-next.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
workqueues-add-kerneldoc-for-flush_scheduled_work.patch

