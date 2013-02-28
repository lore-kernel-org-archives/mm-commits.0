From: akpm@linux-foundation.org
Subject: [merged] nbd-fix-sparse-warning.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:17:08 -0800
Message-ID: <20130228201708.A7C9031C25A@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:52129 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab3B1URJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:17:09 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so245083vcd.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:17:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elder@inktank.com, paul.clements@steeleye.com, paul.clements@us.sios.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nbd: fix sparse warning
has been removed from the -mm tree.  Its filename was
     nbd-fix-sparse-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Elder <elder@inktank.com>
Subject: nbd: fix sparse warning

I just fixed this in "drivers/block/rbd.c" and I noticed that
"drivers/block/nbd.c" has the same problem.  Fix a warning issued by
sparse by adding some lockdep annotations to indicate the queue lock gets
dropped (because it's held when do_nbd_request() is called) and
re-acquired within the function.

Signed-off-by: Alex Elder <elder@inktank.com>
Cc: Paul Clements <paul.clements@steeleye.com>
Cc: Paul Clements <paul.clements@us.sios.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/block/nbd.c~nbd-fix-sparse-warning drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-fix-sparse-warning
+++ a/drivers/block/nbd.c
@@ -564,6 +564,7 @@ static int nbd_thread(void *data)
  */
 
 static void do_nbd_request(struct request_queue *q)
+		__releases(q->queue_lock) __acquires(q->queue_lock)
 {
 	struct request *req;
 	
_

Patches currently in -mm which might be from elder@inktank.com are

origin.patch
linux-next.patch

