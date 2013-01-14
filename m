From: akpm@linux-foundation.org
Subject: + drivers-block-swim3c-fix-null-pointer-dereference.patch added to -mm tree
Date: Mon, 14 Jan 2013 13:29:51 -0800
Message-ID: <20130114212951.8D1DD100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:36044 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab3ANV3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 16:29:52 -0500
Received: by mail-yh0-f74.google.com with SMTP id w68so545020yhw.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 13:29:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dinggnu@gmail.com, axboe@kernel.dk


The patch titled
     Subject: drivers/block/swim3.c: fix null pointer dereference
has been added to the -mm tree.  Its filename is
     drivers-block-swim3c-fix-null-pointer-dereference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cong Ding <dinggnu@gmail.com>
Subject: drivers/block/swim3.c: fix null pointer dereference

The use of pointer fs should be after the null check.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/swim3.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/block/swim3.c~drivers-block-swim3c-fix-null-pointer-dereference drivers/block/swim3.c
--- a/drivers/block/swim3.c~drivers-block-swim3c-fix-null-pointer-dereference
+++ a/drivers/block/swim3.c
@@ -1090,10 +1090,13 @@ static const struct block_device_operati
 static void swim3_mb_event(struct macio_dev* mdev, int mb_state)
 {
 	struct floppy_state *fs = macio_get_drvdata(mdev);
-	struct swim3 __iomem *sw = fs->swim3;
+	struct swim3 __iomem *sw;
 
 	if (!fs)
 		return;
+
+	sw = fs->swim3;
+
 	if (mb_state != MB_FD)
 		return;
 
_

Patches currently in -mm which might be from dinggnu@gmail.com are

linux-next.patch
drivers-block-swim3c-fix-null-pointer-dereference.patch

