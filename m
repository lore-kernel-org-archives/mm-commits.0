From: akpm@linux-foundation.org
Subject: [merged] nbd-remove-bogus-bug_on-in-nbd_clear_que.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 12:36:52 -0700
Message-ID: <51db14d4.eZAbv1Wgq4T5mBSB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab3GHTgw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:36:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paul.clements@steeleye.com, belczyk@bsd.krakow.pl

Subject: [merged] nbd-remove-bogus-bug_on-in-nbd_clear_que.patch removed from -mm tree
To: belczyk@bsd.krakow.pl,paul.clements@steeleye.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:36:52 -0700


The patch titled
     Subject: nbd: remove bogus BUG_ON in NBD_CLEAR_QUE
has been removed from the -mm tree.  Its filename was
     nbd-remove-bogus-bug_on-in-nbd_clear_que.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Belczyk <belczyk@bsd.krakow.pl>
Subject: nbd: remove bogus BUG_ON in NBD_CLEAR_QUE

The NBD_CLEAR_QUE ioctl has been deprecated for quite some time (its job
is now done by two other ioctls).  We should stop trying to make bogus
assertions in it.  Also, user-level code should remove calls to
NBD_CLEAR_QUE, ASAP.

Signed-off-by: Michal Belczyk <belczyk@bsd.krakow.pl>
Signed-off-by: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/block/nbd.c~nbd-remove-bogus-bug_on-in-nbd_clear_que drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-remove-bogus-bug_on-in-nbd_clear_que
+++ a/drivers/block/nbd.c
@@ -751,7 +751,6 @@ static int __nbd_ioctl(struct block_devi
 		 * This is for compatibility only.  The queue is always cleared
 		 * by NBD_DO_IT or NBD_CLEAR_SOCK.
 		 */
-		BUG_ON(!nbd->sock && !list_empty(&nbd->queue_head));
 		return 0;
 
 	case NBD_PRINT_DEBUG:
_

Patches currently in -mm which might be from belczyk@bsd.krakow.pl are

origin.patch

