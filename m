From: akpm@linux-foundation.org
Subject: [merged] thp-remove-some-code-depend-on-config_numa.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:07:48 -0700
Message-ID: <20121009180749.E672C5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:54463 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab2JISHx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:07:53 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so362949lbo.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:07:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, hughd@google.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: remove some code depend on CONFIG_NUMA
has been removed from the -mm tree.  Its filename was
     thp-remove-some-code-depend-on-config_numa.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2306,11 +2306,8 @@ static void khugepaged_wait_work(void)
 
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
@@ -2324,10 +2321,9 @@ static void khugepaged_loop(void)
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

origin.patch
linux-next.patch

