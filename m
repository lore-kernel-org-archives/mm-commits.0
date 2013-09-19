From: akpm@linux-foundation.org
Subject: + lib-remove-unnecessary-work-pending-test.patch added to -mm
 tree
Date: Thu, 19 Sep 2013 15:04:56 -0700
Message-ID: <523b7508.A3nHfpqkXd68tAWb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab3ISWE5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 18:04:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, xiexiuqi@huawei.com

Subject: + lib-remove-unnecessary-work-pending-test.patch added to -mm tree
To: xiexiuqi@huawei.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 15:04:56 -0700


The patch titled
     Subject: lib/debugobjects.c: remove unnecessary work pending test
has been added to the -mm tree.  Its filename is
     lib-remove-unnecessary-work-pending-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-remove-unnecessary-work-pending-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-remove-unnecessary-work-pending-test.patch

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
Subject: lib/debugobjects.c: remove unnecessary work pending test

Remove unnecessary work pending test before calling schedule_work().  It
has been tested in queue_work_on() already.  No functional changed.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/debugobjects.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/debugobjects.c~lib-remove-unnecessary-work-pending-test lib/debugobjects.c
--- a/lib/debugobjects.c~lib-remove-unnecessary-work-pending-test
+++ a/lib/debugobjects.c
@@ -196,7 +196,7 @@ static void free_object(struct debug_obj
 	 * initialized:
 	 */
 	if (obj_pool_free > ODEBUG_POOL_SIZE && obj_cache)
-		sched = keventd_up() && !work_pending(&debug_obj_work);
+		sched = keventd_up();
 	hlist_add_head(&obj->node, &obj_pool);
 	obj_pool_free++;
 	obj_pool_used--;
_

Patches currently in -mm which might be from xiexiuqi@huawei.com are

input-remove-unnecessary-work-pending-test.patch
lib-remove-unnecessary-work-pending-test.patch
staging-olpc_dcon-remove-unnecessary-work-pending-test.patch
ipc-remove-unnecessary-work-pending-test.patch

