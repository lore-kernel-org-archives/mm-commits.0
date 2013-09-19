From: akpm@linux-foundation.org
Subject: + staging-olpc_dcon-remove-unnecessary-work-pending-test.patch
 added to -mm tree
Date: Thu, 19 Sep 2013 15:04:57 -0700
Message-ID: <523b7509.iJyy43ep6fs7oxZa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab3ISWE6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 18:04:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, jon.nettleton@gmail.com, jfrederich@gmail.com, gregkh@linuxfoundation.org, dsd@laptop.org, xiexiuqi@huawei.com

Subject: + staging-olpc_dcon-remove-unnecessary-work-pending-test.patch added to -mm tree
To: xiexiuqi@huawei.com,dsd@laptop.org,gregkh@linuxfoundation.org,jfrederich@gmail.com,jon.nettleton@gmail.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 15:04:57 -0700


The patch titled
     Subject: drivers/staging/olpc_dcon/olpc_dcon.c: remove unnecessary work pending test
has been added to the -mm tree.  Its filename is
     staging-olpc_dcon-remove-unnecessary-work-pending-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/staging-olpc_dcon-remove-unnecessary-work-pending-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/staging-olpc_dcon-remove-unnecessary-work-pending-test.patch

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
staging-olpc_dcon-remove-unnecessary-work-pending-test.patch
ipc-remove-unnecessary-work-pending-test.patch

