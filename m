From: akpm@linux-foundation.org
Subject: [merged] drivers-block-swim3c-fix-null-pointer-dereference.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:56:23 -0800
Message-ID: <20130225205623.9ED6E5A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:51761 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759416Ab3BYU4Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:56:24 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so363529qah.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:56:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dinggnu@gmail.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/block/swim3.c: fix null pointer dereference
has been removed from the -mm tree.  Its filename was
     drivers-block-swim3c-fix-null-pointer-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

