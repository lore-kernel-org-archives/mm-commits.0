From: akpm@linux-foundation.org
Subject: [merged] input-remove-unnecessary-work-pending-test.patch removed from -mm tree
Date: Fri, 22 Nov 2013 13:22:09 -0800
Message-ID: <528fcb01.JcPgCI3LX4AvFVkz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56912 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109Ab3KVVWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 16:22:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, fery@cypress.com, dmitry.torokhov@gmail.com, xiexiuqi@huawei.com

Subject: [merged] input-remove-unnecessary-work-pending-test.patch removed from -mm tree
To: xiexiuqi@huawei.com,dmitry.torokhov@gmail.com,fery@cypress.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 13:22:09 -0800


The patch titled
     Subject: drivers/input/touchscreen/cyttsp4_core.c: : remove unnecessary work pending test
has been removed from the -mm tree.  Its filename was
     input-remove-unnecessary-work-pending-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xie XiuQi <xiexiuqi@huawei.com>
Subject: drivers/input/touchscreen/cyttsp4_core.c: : remove unnecessary work pending test

Remove unnecessary work pending test before calling schedule_work().  It
has been tested in queue_work_on() already.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: Ferruh Yigit <fery@cypress.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/cyttsp4_core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/input/touchscreen/cyttsp4_core.c~input-remove-unnecessary-work-pending-test drivers/input/touchscreen/cyttsp4_core.c
--- a/drivers/input/touchscreen/cyttsp4_core.c~input-remove-unnecessary-work-pending-test
+++ a/drivers/input/touchscreen/cyttsp4_core.c
@@ -1246,8 +1246,7 @@ static void cyttsp4_watchdog_timer(unsig
 
 	dev_vdbg(cd->dev, "%s: Watchdog timer triggered\n", __func__);
 
-	if (!work_pending(&cd->watchdog_work))
-		schedule_work(&cd->watchdog_work);
+	schedule_work(&cd->watchdog_work);
 
 	return;
 }
_

Patches currently in -mm which might be from xiexiuqi@huawei.com are

origin.patch
linux-next.patch

