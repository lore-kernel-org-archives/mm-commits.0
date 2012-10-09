From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-fix-error-number-for-failed-kthread.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:07:15 -0700
Message-ID: <20121009180715.9D73E1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:35020 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISHQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:07:16 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so660648ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:07:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shangw@linux.vnet.ibm.com, liwanp@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: fix error number for failed kthread
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-error-number-for-failed-kthread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: mm/vmscan: fix error number for failed kthread

Fix the return value while failing to create the kswapd kernel thread. 
Also, the error message is prioritized as KERN_ERR.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-fix-error-number-for-failed-kthread mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-fix-error-number-for-failed-kthread
+++ a/mm/vmscan.c
@@ -3126,9 +3126,9 @@ int kswapd_run(int nid)
 	if (IS_ERR(pgdat->kswapd)) {
 		/* failure at boot is fatal */
 		BUG_ON(system_state == SYSTEM_BOOTING);
-		printk("Failed to start kswapd on node %d\n",nid);
 		pgdat->kswapd = NULL;
-		ret = -1;
+		pr_err("Failed to start kswapd on node %d\n", nid);
+		ret = PTR_ERR(pgdat->kswapd);
 	}
 	return ret;
 }
_

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

origin.patch
mm-slab-remove-duplicate-check.patch
mm-memblock-reduce-overhead-in-binary-search.patch

