From: akpm@linux-foundation.org
Subject: [merged]
 staging-olpc_dcon-remove-unnecessary-work-pending-test.patch removed from
 -mm tree
Date: Thu, 26 Sep 2013 12:31:18 -0700
Message-ID: <52448b86.Oo4DiPEFDtTPq8x5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab3IZTbT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Sep 2013 15:31:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, jon.nettleton@gmail.com, jfrederich@gmail.com, gregkh@linuxfoundation.org, dsd@laptop.org, xiexiuqi@huawei.com

Subject: [merged] staging-olpc_dcon-remove-unnecessary-work-pending-test.patch removed from -mm tree
To: xiexiuqi@huawei.com,dsd@laptop.org,gregkh@linuxfoundation.org,jfrederich@gmail.com,jon.nettleton@gmail.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 26 Sep 2013 12:31:18 -0700


The patch titled
     Subject: drivers/staging/olpc_dcon/olpc_dcon.c: remove unnecessary work pending test
has been removed from the -mm tree.  Its filename was
     staging-olpc_dcon-remove-unnecessary-work-pending-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xie XiuQi <xiexiuqi@huawei.com>
Subject: drivers/staging/olpc_dcon/olpc_dcon.c: remove unnecessary work pending test

Remove unnecessary work pending test before calling schedule_work().
It has been tested in queue_work_on() already. No functional changed.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Jens Frederich <jfrederich@gmail.com>
Cc: Daniel Drake <dsd@laptop.org>
Cc: Jon Nettleton <jon.nettleton@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/olpc_dcon/olpc_dcon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/olpc_dcon/olpc_dcon.c~staging-olpc_dcon-remove-unnecessary-work-pending-test drivers/staging/olpc_dcon/olpc_dcon.c
--- a/drivers/staging/olpc_dcon/olpc_dcon.c~staging-olpc_dcon-remove-unnecessary-work-pending-test
+++ a/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -383,7 +383,7 @@ static void dcon_set_source(struct dcon_
 
 	dcon->pending_src = arg;
 
-	if ((dcon->curr_src != arg) && !work_pending(&dcon->switch_source))
+	if (dcon->curr_src != arg)
 		schedule_work(&dcon->switch_source);
 }
 
_

Patches currently in -mm which might be from xiexiuqi@huawei.com are

input-remove-unnecessary-work-pending-test.patch
lib-remove-unnecessary-work-pending-test.patch
ipc-remove-unnecessary-work-pending-test.patch
linux-next.patch

