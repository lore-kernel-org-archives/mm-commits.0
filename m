From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-fix-error-return-in-kswapd_run.patch removed from -mm tree
Date: Mon, 22 Apr 2013 13:06:58 -0700
Message-ID: <20130422200658.7BA5D31C082@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:46399 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab3DVUG7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 16:06:59 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so378660qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 13:06:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, fengguang.wu@intel.com, liwanp@linux.vnet.ibm.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: fix error return in kswapd_run()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-error-return-in-kswapd_run.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm/vmscan: fix error return in kswapd_run()

Fix the error return value in kswapd_run().  The bug was introduced by
d5dc0ad928fb9 ("mm/vmscan: fix error number for failed kthread").

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-fix-error-return-in-kswapd_run mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-fix-error-return-in-kswapd_run
+++ a/mm/vmscan.c
@@ -3188,9 +3188,9 @@ int kswapd_run(int nid)
 	if (IS_ERR(pgdat->kswapd)) {
 		/* failure at boot is fatal */
 		BUG_ON(system_state == SYSTEM_BOOTING);
-		pgdat->kswapd = NULL;
 		pr_err("Failed to start kswapd on node %d\n", nid);
 		ret = PTR_ERR(pgdat->kswapd);
+		pgdat->kswapd = NULL;
 	}
 	return ret;
 }
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

linux-next.patch

