From: akpm@linux-foundation.org
Subject: [merged] thp-merge-page-pre-alloc-in-khugepaged_loop-into-khugepaged_do_scan.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:07:53 -0700
Message-ID: <20121009180753.EA0A81E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:50267 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab2JISHz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:07:55 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so573789yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:07:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, hughd@google.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: merge page pre-alloc in khugepaged_loop into khugepaged_do_scan
has been removed from the -mm tree.  Its filename was
     thp-merge-page-pre-alloc-in-khugepaged_loop-into-khugepaged_do_scan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: thp: merge page pre-alloc in khugepaged_loop into khugepaged_do_scan

There are two pre-alloc operations in these two function, the different is:
- it allows to sleep if page alloc fail in khugepaged_loop
- it exits immediately if page alloc fail in khugepaged_do_scan

Actually, in khugepaged_do_scan, we can allow the pre-alloc to sleep on
the first failure, then the operation in khugepaged_loop can be removed

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   97 ++++++++++++++++++++-------------------------
 1 file changed, 45 insertions(+), 52 deletions(-)

diff -puN mm/huge_memory.c~thp-merge-page-pre-alloc-in-khugepaged_loop-into-khugepaged_do_scan mm/huge_memory.c
--- a/mm/huge_memory.c~thp-merge-page-pre-alloc-in-khugepaged_loop-into-khugepaged_do_scan
+++ a/mm/huge_memory.c
@@ -2222,10 +2222,40 @@ static int khugepaged_wait_event(void)
 		kthread_should_stop();
 }
 
-static void khugepaged_do_scan(struct page **hpage)
+static void khugepaged_alloc_sleep(void)
 {
+	wait_event_freezable_timeout(khugepaged_wait, false,
+			msecs_to_jiffies(khugepaged_alloc_sleep_millisecs));
+}
+
+#ifndef CONFIG_NUMA
+static struct page *khugepaged_alloc_hugepage(bool *wait)
+{
+	struct page *hpage;
+
+	do {
+		hpage = alloc_hugepage(khugepaged_defrag());
+		if (!hpage) {
+			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
+			if (!*wait)
+				return NULL;
+
+			*wait = false;
+			khugepaged_alloc_sleep();
+		} else
+			count_vm_event(THP_COLLAPSE_ALLOC);
+	} while (unlikely(!hpage) && likely(khugepaged_enabled()));
+
+	return hpage;
+}
+#endif
+
+static void khugepaged_do_scan(void)
+{
+	struct page *hpage = NULL;
 	unsigned int progress = 0, pass_through_head = 0;
 	unsigned int pages = khugepaged_pages_to_scan;
+	bool wait = true;
 
 	barrier(); /* write khugepaged_pages_to_scan to local stack */
 
@@ -2233,17 +2263,18 @@ static void khugepaged_do_scan(struct pa
 		cond_resched();
 
 #ifndef CONFIG_NUMA
-		if (!*hpage) {
-			*hpage = alloc_hugepage(khugepaged_defrag());
-			if (unlikely(!*hpage)) {
-				count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
+		if (!hpage)
+			hpage = khugepaged_alloc_hugepage(&wait);
+
+		if (unlikely(!hpage))
+			break;
+#else
+		if (IS_ERR(hpage)) {
+			if (!wait)
 				break;
-			}
-			count_vm_event(THP_COLLAPSE_ALLOC);
+			wait = false;
+			khugepaged_alloc_sleep();
 		}
-#else
-		if (IS_ERR(*hpage))
-			break;
 #endif
 
 		if (unlikely(kthread_should_stop() || freezing(current)))
@@ -2255,37 +2286,16 @@ static void khugepaged_do_scan(struct pa
 		if (khugepaged_has_work() &&
 		    pass_through_head < 2)
 			progress += khugepaged_scan_mm_slot(pages - progress,
-							    hpage);
+							    &hpage);
 		else
 			progress = pages;
 		spin_unlock(&khugepaged_mm_lock);
 	}
-}
 
-static void khugepaged_alloc_sleep(void)
-{
-	wait_event_freezable_timeout(khugepaged_wait, false,
-			msecs_to_jiffies(khugepaged_alloc_sleep_millisecs));
+	if (!IS_ERR_OR_NULL(hpage))
+		put_page(hpage);
 }
 
-#ifndef CONFIG_NUMA
-static struct page *khugepaged_alloc_hugepage(void)
-{
-	struct page *hpage;
-
-	do {
-		hpage = alloc_hugepage(khugepaged_defrag());
-		if (!hpage) {
-			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
-			khugepaged_alloc_sleep();
-		} else
-			count_vm_event(THP_COLLAPSE_ALLOC);
-	} while (unlikely(!hpage) &&
-		 likely(khugepaged_enabled()));
-	return hpage;
-}
-#endif
-
 static void khugepaged_wait_work(void)
 {
 	try_to_freeze();
@@ -2306,25 +2316,8 @@ static void khugepaged_wait_work(void)
 
 static void khugepaged_loop(void)
 {
-	struct page *hpage = NULL;
-
 	while (likely(khugepaged_enabled())) {
-#ifndef CONFIG_NUMA
-		hpage = khugepaged_alloc_hugepage();
-		if (unlikely(!hpage))
-			break;
-#else
-		if (IS_ERR(hpage)) {
-			khugepaged_alloc_sleep();
-			hpage = NULL;
-		}
-#endif
-
-		khugepaged_do_scan(&hpage);
-
-		if (!IS_ERR_OR_NULL(hpage))
-			put_page(hpage);
