From: akpm@linux-foundation.org
Subject: + nbd-fix-sparse-warning.patch added to -mm tree
Date: Wed, 27 Feb 2013 14:02:33 -0800
Message-ID: <20130227220233.97BC95A40AC@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:38316 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab3B0WCe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 17:02:34 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so121028ghb.4
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 14:02:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: elder@inktank.com, paul.clements@steeleye.com, paul.clements@us.sios.com


The patch titled
     Subject: nbd: fix sparse warning
has been added to the -mm tree.  Its filename is
     nbd-fix-sparse-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
nbd-fix-sparse-warning.patch

