From: akpm@linux-foundation.org
Subject: + nbd-remove-bogus-bug_on-in-nbd_clear_que.patch added to -mm
 tree
Date: Tue, 18 Jun 2013 14:06:02 -0700
Message-ID: <51c0cbba.oimL+xHHj7kau3ex%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275Ab3FRVGD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jun 2013 17:06:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paul.clements@steeleye.com, belczyk@bsd.krakow.pl

Subject: + nbd-remove-bogus-bug_on-in-nbd_clear_que.patch added to -mm tree
To: belczyk@bsd.krakow.pl,paul.clements@steeleye.com
From: akpm@linux-foundation.org
Date: Tue, 18 Jun 2013 14:06:02 -0700


The patch titled
     Subject: nbd: remove bogus BUG_ON in NBD_CLEAR_QUE
has been added to the -mm tree.  Its filename is
     nbd-remove-bogus-bug_on-in-nbd_clear_que.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

nbd-remove-bogus-bug_on-in-nbd_clear_que.patch

