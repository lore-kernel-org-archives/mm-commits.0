From: akpm@linux-foundation.org
Subject: + thp-remove-some-code-depend-on-config_numa.patch added to -mm tree
Date: Mon, 20 Aug 2012 14:08:21 -0700
Message-ID: <20120820210822.5F861100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:64575 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab2HTVIX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 17:08:23 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4073792obb.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 14:08:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, hughd@google.com, rientjes@google.com


The patch titled
     Subject: thp: remove some code depend on CONFIG_NUMA
has been added to the -mm tree.  Its filename is
     thp-remove-some-code-depend-on-config_numa.patch

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
Subject: thp: remove some code depend on CONFIG_NUMA

If NUMA is disabled, hpage is used as page pre-alloc, so there are two
cases for hpage:

- it is !NULL, means the page is not consumed otherwise,
- the page has been consumed

If NUMA is enabled, hpage is just used as alloc-fail indicator which is
not a real page, NULL means not fail triggered.

So, we can release the page only if !IS_ERR_OR_NULL

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN mm/huge_memory.c~thp-remove-some-code-depend-on-config_numa mm/huge_memory.c
--- a/mm/huge_memory.c~thp-remove-some-code-depend-on-config_numa
+++ a/mm/huge_memory.c
@@ -2307,11 +2307,8 @@ static void khugepaged_wait_work(void)
 
 static void khugepaged_loop(void)
 {
-	struct page *hpage;
+	struct page *hpage = NULL;
 
-#ifdef CONFIG_NUMA
-	hpage = NULL;
-#endif
 	while (likely(khugepaged_enabled())) {
 #ifndef CONFIG_NUMA
 		hpage = khugepaged_alloc_hugepage();
@@ -2325,10 +2322,9 @@ static void khugepaged_loop(void)
 #endif
 
 		khugepaged_do_scan(&hpage);
-#ifndef CONFIG_NUMA
-		if (hpage)
+
+		if (!IS_ERR_OR_NULL(hpage))
 			put_page(hpage);
-#endif
 
 		khugepaged_wait_work();
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

