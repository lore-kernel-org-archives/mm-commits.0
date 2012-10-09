From: akpm@linux-foundation.org
Subject: [merged] thp-remove-unnecessary-khugepaged_thread-check.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:07:39 -0700
Message-ID: <20121009180740.29DFB20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:45291 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab2JISHm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:07:42 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so59026eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:07:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, hughd@google.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: remove unnecessary khugepaged_thread check
has been removed from the -mm tree.  Its filename was
     thp-remove-unnecessary-khugepaged_thread-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: thp: remove unnecessary khugepaged_thread check

Now, khugepaged creation and cancel are completely serial under the
protection of khugepaged_mutex, it is impossible that many khugepaged
entities are running

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/huge_memory.c~thp-remove-unnecessary-khugepaged_thread-check mm/huge_memory.c
--- a/mm/huge_memory.c~thp-remove-unnecessary-khugepaged_thread-check
+++ a/mm/huge_memory.c
@@ -2333,11 +2333,8 @@ static int khugepaged(void *none)
 	set_freezable();
 	set_user_nice(current, 19);
 
-	while (!kthread_should_stop()) {
-		VM_BUG_ON(khugepaged_thread != current);
+	while (!kthread_should_stop())
 		khugepaged_loop();
-		VM_BUG_ON(khugepaged_thread != current);
-	}
 
 	spin_lock(&khugepaged_mm_lock);
 	mm_slot = khugepaged_scan.mm_slot;
_

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

origin.patch
linux-next.patch

