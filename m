From: akpm@linux-foundation.org
Subject: + thp-remove-khugepaged_loop.patch added to -mm tree
Date: Mon, 20 Aug 2012 14:08:34 -0700
Message-ID: <20120820210835.961C720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:48375 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab2HTVIh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 17:08:37 -0400
Received: by mail-we0-f202.google.com with SMTP id r1so312557wey.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 14:08:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, hughd@google.com, rientjes@google.com


The patch titled
     Subject: thp: remove khugepaged_loop
has been added to the -mm tree.  Its filename is
     thp-remove-khugepaged_loop.patch

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
Subject: thp: remove khugepaged_loop

Merge khugepaged_loop into khugepaged

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN mm/huge_memory.c~thp-remove-khugepaged_loop mm/huge_memory.c
--- a/mm/huge_memory.c~thp-remove-khugepaged_loop
+++ a/mm/huge_memory.c
@@ -2340,14 +2340,6 @@ static void khugepaged_wait_work(void)
 		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
 }
 
-static void khugepaged_loop(void)
-{
-	while (likely(khugepaged_enabled())) {
-		khugepaged_do_scan();
-		khugepaged_wait_work();
-	}
-}
-
 static int khugepaged(void *none)
 {
 	struct mm_slot *mm_slot;
@@ -2355,8 +2347,10 @@ static int khugepaged(void *none)
 	set_freezable();
 	set_user_nice(current, 19);
 
-	while (!kthread_should_stop())
-		khugepaged_loop();
+	while (!kthread_should_stop()) {
+		khugepaged_do_scan();
+		khugepaged_wait_work();
+	}
 
 	spin_lock(&khugepaged_mm_lock);
 	mm_slot = khugepaged_scan.mm_slot;
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

