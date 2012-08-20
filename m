From: akpm@linux-foundation.org
Subject: + thp-merge-page-pre-alloc-in-khugepaged_loop-into-khugepaged_do_scan.patch added to -mm tree
Date: Mon, 20 Aug 2012 14:08:24 -0700
Message-ID: <20120820210825.9CDF55C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:48375 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab2HTVI2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 17:08:28 -0400
Received: by weyr1 with SMTP id r1so312557wey.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 14:08:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, hughd@google.com, rientjes@google.com


The patch titled
     Subject: thp: merge page pre-alloc in khugepaged_loop into khugepaged_do_scan
has been added to the -mm tree.  Its filename is
     thp-merge-page-pre-alloc-in-khugepaged_loop-into-khugepaged_do_scan.patch

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
@@ -2223,10 +2223,40 @@ static int khugepaged_wait_event(void)
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
 
@@ -2234,17 +2264,18 @@ static void khugepaged_do_scan(struct pa
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
@@ -2256,37 +2287,16 @@ static void khugepaged_do_scan(struct pa
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
@@ -2307,25 +2317,8 @@ static void khugepaged_wait_work(void)
 
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
