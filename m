From: akpm@linux-foundation.org
Subject: + ipc-remove-unnecessary-work-pending-test.patch added to -mm
 tree
Date: Thu, 19 Sep 2013 15:04:58 -0700
Message-ID: <523b750a.Izfb0zhhgPw7YzHa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab3ISWE7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 18:04:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, xiexiuqi@huawei.com

Subject: + ipc-remove-unnecessary-work-pending-test.patch added to -mm tree
To: xiexiuqi@huawei.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 15:04:58 -0700


The patch titled
     Subject: ipc/util.c: remove unnecessary work pending test
has been added to the -mm tree.  Its filename is
     ipc-remove-unnecessary-work-pending-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-remove-unnecessary-work-pending-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-remove-unnecessary-work-pending-test.patch

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
Subject: ipc/util.c: remove unnecessary work pending test

Remove unnecessary work pending test before calling schedule_work().  It
has been tested in queue_work_on() already.  No functional changed.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN ipc/util.c~ipc-remove-unnecessary-work-pending-test ipc/util.c
--- a/ipc/util.c~ipc-remove-unnecessary-work-pending-test
+++ a/ipc/util.c
@@ -75,10 +75,8 @@ static int ipc_memory_callback(struct no
 		 * In order not to keep the lock on the hotplug memory chain
 		 * for too long, queue a work item that will, when waken up,
 		 * activate the ipcns notification chain.
-		 * No need to keep several ipc work items on the queue.
 		 */
-		if (!work_pending(&ipc_memory_wq))
-			schedule_work(&ipc_memory_wq);
+		schedule_work(&ipc_memory_wq);
 		break;
 	case MEM_GOING_ONLINE:
 	case MEM_GOING_OFFLINE:
_

Patches currently in -mm which might be from xiexiuqi@huawei.com are

input-remove-unnecessary-work-pending-test.patch
lib-remove-unnecessary-work-pending-test.patch
staging-olpc_dcon-remove-unnecessary-work-pending-test.patch
ipc-remove-unnecessary-work-pending-test.patch

