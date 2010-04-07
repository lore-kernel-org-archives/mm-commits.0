From: akpm@linux-foundation.org
Subject: [merged] block-elevatorc-fix-block-elevatorc-elevator_get-off-by-one-error.patch removed from -mm tree
Date: Wed, 07 Apr 2010 11:51:00 -0400
Message-ID: <201004071852.o37IqQw2001368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753641Ab0DGSwj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 14:52:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhitong.wangzt@alibaba-inc.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     block/elevator.c: fix block/elevator.c elevator_get() off-by-one error
has been removed from the -mm tree.  Its filename was
     block-elevatorc-fix-block-elevatorc-elevator_get-off-by-one-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block/elevator.c: fix block/elevator.c elevator_get() off-by-one error
From: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

elevator_get() does not check the name length, if the name length >
sizeof(elv), elv will miss the '\0'.  And elv buffer will replace
"-iosched" as something like aaaaaaaaa, so request_module() can
load an untrusted module.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/elevator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/elevator.c~block-elevatorc-fix-block-elevatorc-elevator_get-off-by-one-error block/elevator.c
--- a/block/elevator.c~block-elevatorc-fix-block-elevatorc-elevator_get-off-by-one-error
+++ a/block/elevator.c
@@ -154,7 +154,7 @@ static struct elevator_type *elevator_ge
 
 		spin_unlock(&elv_list_lock);
 
-		sprintf(elv, "%s-iosched", name);
+		snprintf(elv, sizeof(elv), "%s-iosched", name);
 
 		request_module("%s", elv);
 		spin_lock(&elv_list_lock);
_

Patches currently in -mm which might be from zhitong.wangzt@alibaba-inc.com are

linux-next.patch

