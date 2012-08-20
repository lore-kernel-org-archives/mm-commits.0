From: akpm@linux-foundation.org
Subject: + thp-move-khugepaged_mutex-out-of-khugepaged.patch added to -mm tree
Date: Mon, 20 Aug 2012 14:08:12 -0700
Message-ID: <20120820210813.49951100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:64575 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab2HTVIO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 17:08:14 -0400
Received: by obbwc20 with SMTP id wc20so4073792obb.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 14:08:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, hughd@google.com, rientjes@google.com


The patch titled
     Subject: thp: move khugepaged_mutex out of khugepaged
has been added to the -mm tree.  Its filename is
     thp-move-khugepaged_mutex-out-of-khugepaged.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: thp: move khugepaged_mutex out of khugepaged

Currently, hugepaged_mutex is used really complexly and hard to
understand, actually, it is just used to serialize start_khugepaged and
khugepaged for these reasons:

- khugepaged_thread is shared between them
- the thp disable path (echo never > transparent_hugepage/enabled) is
  nonblocking, so we need to protect khugepaged_thread to get a stable
  running state

These can be avoided by:

- use the lock to serialize the thread creation and cancel
- thp disable path can not finised until the thread exits

Then khugepaged_thread is fully controlled by start_khugepaged, khugepaged
will be happy without the lock

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff -puN mm/huge_memory.c~thp-move-khugepaged_mutex-out-of-khugepaged mm/huge_memory.c
--- a/mm/huge_memory.c~thp-move-khugepaged_mutex-out-of-khugepaged
+++ a/mm/huge_memory.c
@@ -139,9 +139,6 @@ static int start_khugepaged(void)
 {
 	int err = 0;
 	if (khugepaged_enabled()) {
-		int wakeup;
-
-		mutex_lock(&khugepaged_mutex);
 		if (!khugepaged_thread)
 			khugepaged_thread = kthread_run(khugepaged, NULL,
 							"khugepaged");
@@ -151,15 +148,17 @@ static int start_khugepaged(void)
 			err = PTR_ERR(khugepaged_thread);
 			khugepaged_thread = NULL;
 		}
-		wakeup = !list_empty(&khugepaged_scan.mm_head);
-		mutex_unlock(&khugepaged_mutex);
-		if (wakeup)
+
+		if (!list_empty(&khugepaged_scan.mm_head))
 			wake_up_interruptible(&khugepaged_wait);
 
 		set_recommended_min_free_kbytes();
-	} else
+	} else if (khugepaged_thread) {
 		/* wakeup to exit */
 		wake_up_interruptible(&khugepaged_wait);
+		kthread_stop(khugepaged_thread);
+		khugepaged_thread = NULL;
+	}
 
 	return err;
 }
@@ -221,7 +220,12 @@ static ssize_t enabled_store(struct kobj
 				TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG);
 
 	if (ret > 0) {
-		int err = start_khugepaged();
+		int err;
+
+		mutex_lock(&khugepaged_mutex);
+		err = start_khugepaged();
+		mutex_unlock(&khugepaged_mutex);
+
 		if (err)
 			ret = err;
 	}
@@ -2330,20 +2334,10 @@ static int khugepaged(void *none)
 	set_freezable();
 	set_user_nice(current, 19);
 
-	/* serialize with start_khugepaged() */
-	mutex_lock(&khugepaged_mutex);
-
-	for (;;) {
-		mutex_unlock(&khugepaged_mutex);
+	while (!kthread_should_stop()) {
 		VM_BUG_ON(khugepaged_thread != current);
 		khugepaged_loop();
 		VM_BUG_ON(khugepaged_thread != current);
-
-		mutex_lock(&khugepaged_mutex);
-		if (!khugepaged_enabled())
-			break;
-		if (unlikely(kthread_should_stop()))
-			break;
 	}
 
 	spin_lock(&khugepaged_mm_lock);
@@ -2352,10 +2346,6 @@ static int khugepaged(void *none)
 	if (mm_slot)
 		collect_mm_slot(mm_slot);
 	spin_unlock(&khugepaged_mm_lock);
-
-	khugepaged_thread = NULL;
-	mutex_unlock(&khugepaged_mutex);
