From: akpm@linux-foundation.org
Subject: [merged] thp-remove-unnecessary-check-in-start_khugepaged.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:07:31 -0700
Message-ID: <20121009180732.2207E5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:45893 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISHe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:07:34 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so285461wib.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:07:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, hughd@google.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: remove unnecessary check in start_khugepaged
has been removed from the -mm tree.  Its filename was
     thp-remove-unnecessary-check-in-start_khugepaged.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: thp: remove unnecessary check in start_khugepaged

The check is unnecessary since if mm_slot_cache or mm_slots_hash
initialize failed, no sysfs interface will be created

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN mm/huge_memory.c~thp-remove-unnecessary-check-in-start_khugepaged mm/huge_memory.c
--- a/mm/huge_memory.c~thp-remove-unnecessary-check-in-start_khugepaged
+++ a/mm/huge_memory.c
@@ -140,10 +140,7 @@ static int start_khugepaged(void)
 	int err = 0;
 	if (khugepaged_enabled()) {
 		int wakeup;
-		if (unlikely(!mm_slot_cache || !mm_slots_hash)) {
-			err = -ENOMEM;
-			goto out;
-		}
+
 		mutex_lock(&khugepaged_mutex);
 		if (!khugepaged_thread)
 			khugepaged_thread = kthread_run(khugepaged, NULL,
@@ -163,7 +160,7 @@ static int start_khugepaged(void)
 	} else
 		/* wakeup to exit */
 		wake_up_interruptible(&khugepaged_wait);
-out:
+
 	return err;
 }
 
_

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

origin.patch
linux-next.patch

