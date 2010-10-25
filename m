From: akpm@linux-foundation.org
Subject: + drivers-block-drbd-drbd_mainc-fix-error-path.patch added to -mm tree
Date: Mon, 25 Oct 2010 15:50:12 -0700
Message-ID: <201010252250.o9PMoC5Q020891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210Ab0JYWu2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Oct 2010 18:50:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nikai@nikai.net, axboe@kernel.dk, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com


The patch titled
     drivers/block/drbd/drbd_main.c: fix error path
has been added to the -mm tree.  Its filename is
     drivers-block-drbd-drbd_mainc-fix-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/drbd/drbd_main.c: fix error path
From: Nicolas Kaiser <nikai@nikai.net>

Failure to create drbd_ee_mempool appears not to get checked.  Looks like
a copy-and-paste problem to me.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/drbd/drbd_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/drbd/drbd_main.c~drivers-block-drbd-drbd_mainc-fix-error-path drivers/block/drbd/drbd_main.c
--- a/drivers/block/drbd/drbd_main.c~drivers-block-drbd-drbd_mainc-fix-error-path
+++ a/drivers/block/drbd/drbd_main.c
@@ -2982,7 +2982,7 @@ static int drbd_create_mempools(void)
 
 	drbd_ee_mempool = mempool_create(number,
 		mempool_alloc_slab, mempool_free_slab, drbd_ee_cache);
-	if (drbd_request_mempool == NULL)
+	if (drbd_ee_mempool == NULL)
 		goto Enomem;
 
 	/* drbd's page pool */
_

Patches currently in -mm which might be from nikai@nikai.net are

origin.patch
linux-next.patch
drivers-media-video-gspca-cpia1c-fix-error-check.patch
drivers-block-drbd-drbd_mainc-fix-error-path.patch
drivers-crypto-dubious-error-check.patch

