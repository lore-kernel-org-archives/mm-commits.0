From: akpm@linux-foundation.org
Subject: + input-remove-unnecessary-work-pending-test.patch added to -mm
 tree
Date: Thu, 19 Sep 2013 15:04:55 -0700
Message-ID: <523b7507.UhXfitNtZsGxhH9+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab3ISWE4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 18:04:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, fery@cypress.com, dmitry.torokhov@gmail.com, xiexiuqi@huawei.com

Subject: + input-remove-unnecessary-work-pending-test.patch added to -mm tree
To: xiexiuqi@huawei.com,dmitry.torokhov@gmail.com,fery@cypress.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 15:04:55 -0700


The patch titled
     Subject: drivers/input/touchscreen/cyttsp4_core.c: : remove unnecessary work pending test
has been added to the -mm tree.  Its filename is
     input-remove-unnecessary-work-pending-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/input-remove-unnecessary-work-pending-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/input-remove-unnecessary-work-pending-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

input-remove-unnecessary-work-pending-test.patch
lib-remove-unnecessary-work-pending-test.patch
staging-olpc_dcon-remove-unnecessary-work-pending-test.patch
ipc-remove-unnecessary-work-pending-test.patch

