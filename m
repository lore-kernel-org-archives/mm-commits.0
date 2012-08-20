From: akpm@linux-foundation.org
Subject: + thp-remove-wake_up_interruptible-in-the-exit-path.patch added to -mm tree
Date: Mon, 20 Aug 2012 14:08:18 -0700
Message-ID: <20120820210819.3C8C21E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-iy0-f202.google.com ([209.85.210.202]:51393 "EHLO
	mail-iy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab2HTVIU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 17:08:20 -0400
Received: by ialo24 with SMTP id o24so925435ial.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 14:08:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, hughd@google.com, rientjes@google.com


The patch titled
     Subject: thp: remove wake_up_interruptible in the exit path
has been added to the -mm tree.  Its filename is
     thp-remove-wake_up_interruptible-in-the-exit-path.patch

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
@@ -2222,7 +2220,7 @@ static int khugepaged_has_work(void)
 static int khugepaged_wait_event(void)
 {
 	return !list_empty(&khugepaged_scan.mm_head) ||
-		!khugepaged_enabled();
+		kthread_should_stop();
 }
 
 static void khugepaged_do_scan(struct page **hpage)
@@ -2289,6 +2287,24 @@ static struct page *khugepaged_alloc_hug
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
@@ -2313,17 +2329,8 @@ static void khugepaged_loop(void)
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

linux-next.patch
thp-fix-the-count-of-thp_collapse_alloc.patch
thp-remove-unnecessary-check-in-start_khugepaged.patch
thp-move-khugepaged_mutex-out-of-khugepaged.patch
thp-remove-unnecessary-khugepaged_thread-check.patch
thp-remove-wake_up_interruptible-in-the-exit-path.patch
thp-remove-some-code-depend-on-config_numa.patch
thp-merge-page-pre-alloc-in-khugepaged_loop-into-khugepaged_do_scan.patch
thp-release-page-in-page-pre-alloc-path.patch
thp-introduce-khugepaged_prealloc_page-and-khugepaged_alloc_page.patch
thp-remove-khugepaged_loop.patch
thp-use-khugepaged_enabled-to-remove-duplicate-code.patch
thp-remove-unnecessary-set_recommended_min_free_kbytes.patch

