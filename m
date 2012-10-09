From: akpm@linux-foundation.org
Subject: [merged] thp-remove-wake_up_interruptible-in-the-exit-path.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:07:43 -0700
Message-ID: <20121009180744.6AED220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:62484 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab2JISHq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:07:46 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so365109wey.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:07:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, hughd@google.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: remove wake_up_interruptible in the exit path
has been removed from the -mm tree.  Its filename was
     thp-remove-wake_up_interruptible-in-the-exit-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: thp: remove wake_up_interruptible in the exit path

Add the check of kthread_should_stop() to the conditions which are used to
wakeup on khugepaged_wait, then kthread_stop is enough to let the thread
exit

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff -puN mm/huge_memory.c~thp-remove-wake_up_interruptible-in-the-exit-path mm/huge_memory.c
--- a/mm/huge_memory.c~thp-remove-wake_up_interruptible-in-the-exit-path
+++ a/mm/huge_memory.c
@@ -154,8 +154,6 @@ static int start_khugepaged(void)
 
 		set_recommended_min_free_kbytes();
 	} else if (khugepaged_thread) {
-		/* wakeup to exit */
-		wake_up_interruptible(&khugepaged_wait);
 		kthread_stop(khugepaged_thread);
 		khugepaged_thread = NULL;
 	}
@@ -2221,7 +2219,7 @@ static int khugepaged_has_work(void)
 static int khugepaged_wait_event(void)
 {
 	return !list_empty(&khugepaged_scan.mm_head) ||
-		!khugepaged_enabled();
+		kthread_should_stop();
 }
 
 static void khugepaged_do_scan(struct page **hpage)
@@ -2288,6 +2286,24 @@ static struct page *khugepaged_alloc_hug
 }
 #endif
 
+static void khugepaged_wait_work(void)
+{
+	try_to_freeze();
+
+	if (khugepaged_has_work()) {
+		if (!khugepaged_scan_sleep_millisecs)
+			return;
+
+		wait_event_freezable_timeout(khugepaged_wait,
+					     kthread_should_stop(),
+			msecs_to_jiffies(khugepaged_scan_sleep_millisecs));
+		return;
+	}
+
+	if (khugepaged_enabled())
+		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
+}
+
 static void khugepaged_loop(void)
 {
 	struct page *hpage;
@@ -2312,17 +2328,8 @@ static void khugepaged_loop(void)
 		if (hpage)
 			put_page(hpage);
 #endif
-		try_to_freeze();
-		if (unlikely(kthread_should_stop()))
-			break;
-		if (khugepaged_has_work()) {
-			if (!khugepaged_scan_sleep_millisecs)
-				continue;
-			wait_event_freezable_timeout(khugepaged_wait, false,
-			    msecs_to_jiffies(khugepaged_scan_sleep_millisecs));
-		} else if (khugepaged_enabled())
-			wait_event_freezable(khugepaged_wait,
-					     khugepaged_wait_event());
+
+		khugepaged_wait_work();
 	}
 }
 
_

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

origin.patch
linux-next.patch

