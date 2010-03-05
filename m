From: akpm@linux-foundation.org
Subject: [merged] staging-rt2860-correct-onstack-wait_queue_head-declaration.patch removed from -mm tree
Date: Fri, 05 Mar 2010 11:03:24 -0800
Message-ID: <201003051903.o25J3OBd022027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755350Ab0CETDa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 14:03:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yong.zhang0@gmail.com, a.beregalov@gmail.com, bzolnier@gmail.com, davem@davemloft.net, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     staging: rt2860: correct onstack wait_queue_head declaration
has been removed from the -mm tree.  Its filename was
     staging-rt2860-correct-onstack-wait_queue_head-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: staging: rt2860: correct onstack wait_queue_head declaration
From: Yong Zhang <yong.zhang0@gmail.com>

Use DECLARE_WAIT_QUEUE_HEAD_ONSTACK to make lockdep happy.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rt2860/rt_main_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/rt2860/rt_main_dev.c~staging-rt2860-correct-onstack-wait_queue_head-declaration drivers/staging/rt2860/rt_main_dev.c
--- a/drivers/staging/rt2860/rt_main_dev.c~staging-rt2860-correct-onstack-wait_queue_head-declaration
+++ a/drivers/staging/rt2860/rt_main_dev.c
@@ -216,7 +216,7 @@ int rt28xx_close(struct net_device *dev)
 	u32 i = 0;
 
 #ifdef RTMP_MAC_USB
-	DECLARE_WAIT_QUEUE_HEAD(unlink_wakeup);
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(unlink_wakeup);
 	DECLARE_WAITQUEUE(wait, current);
 #endif /* RTMP_MAC_USB // */
 
_

Patches currently in -mm which might be from yong.zhang0@gmail.com are

origin.patch
linux-next.patch
v4l-dvb-gspca-sn9c20x-correct-onstack-wait_queue_head-declaration.patch
scsi-bfa-correct-onstack-wait_queue_head-declaration.patch

