From: akpm@linux-foundation.org
Subject: [merged] thp-remove-khugepaged_loop.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:08:04 -0700
Message-ID: <20121009180804.9E32E1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:53045 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab2JISIF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:08:05 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so661858vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:08:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, hughd@google.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: remove khugepaged_loop
has been removed from the -mm tree.  Its filename was
     thp-remove-khugepaged_loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2339,14 +2339,6 @@ static void khugepaged_wait_work(void)
 		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
 }
 
-static void khugepaged_loop(void)
-{
-	while (likely(khugepaged_enabled())) {
-		khugepaged_do_scan();
-		khugepaged_wait_work();
-	}
-}
