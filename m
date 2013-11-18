From: akpm@linux-foundation.org
Subject: [merged]
 drivers-infiniband-core-cmc-convert-to-using-idr_alloc_cyclic.patch removed from -mm tree
Date: Mon, 18 Nov 2013 12:06:03 -0800
Message-ID: <528a732b.jpnLzwzCBsl6+6Xk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab3KRUGE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Nov 2013 15:06:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, sean.hefty@intel.com, roland@kernel.org, zhaohongjiang@huawei.com

Subject: [merged] drivers-infiniband-core-cmc-convert-to-using-idr_alloc_cyclic.patch removed from -mm tree
To: zhaohongjiang@huawei.com,roland@kernel.org,sean.hefty@intel.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 18 Nov 2013 12:06:03 -0800


The patch titled
     Subject: drivers/infiniband/core/cm.c: convert to using idr_alloc_cyclic()
has been removed from the -mm tree.  Its filename was
     drivers-infiniband-core-cmc-convert-to-using-idr_alloc_cyclic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: drivers/infiniband/core/cm.c: convert to using idr_alloc_cyclic()

commit 3e6628c4b347 ("idr: introduce idr_alloc_cyclic()") adds a new
idr_alloc_cyclic routine and converts several of these users to it.  This
is just a missed one - add it.

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/core/cm.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/infiniband/core/cm.c~drivers-infiniband-core-cmc-convert-to-using-idr_alloc_cyclic drivers/infiniband/core/cm.c
--- a/drivers/infiniband/core/cm.c~drivers-infiniband-core-cmc-convert-to-using-idr_alloc_cyclic
+++ a/drivers/infiniband/core/cm.c
@@ -383,14 +383,11 @@ static int cm_alloc_id(struct cm_id_priv
 {
 	unsigned long flags;
 	int id;
-	static int next_id;
 
 	idr_preload(GFP_KERNEL);
 	spin_lock_irqsave(&cm.lock, flags);
 
-	id = idr_alloc(&cm.local_id_table, cm_id_priv, next_id, 0, GFP_NOWAIT);
-	if (id >= 0)
-		next_id = max(id + 1, 0);
+	id = idr_alloc_cyclic(&cm.local_id_table, cm_id_priv, 0, 0, GFP_NOWAIT);
 
 	spin_unlock_irqrestore(&cm.lock, flags);
 	idr_preload_end();
_

Patches currently in -mm which might be from zhaohongjiang@huawei.com are

origin.patch
linux-next.patch

