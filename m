From: akpm@linux-foundation.org
Subject: [merged] cciss-use-check_signature.patch removed from -mm tree
Date: Mon, 12 Nov 2012 13:09:38 -0800
Message-ID: <20121112210938.A8B49100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:40825 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab2KLVJk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Nov 2012 16:09:40 -0500
Received: by mail-ye0-f202.google.com with SMTP id r11so783366yen.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Nov 2012 13:09:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, axboe@kernel.dk, mike.miller@hp.com, scameron@beardog.cce.hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cciss: use check_signature()
has been removed from the -mm tree.  Its filename was
     cciss-use-check_signature.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: cciss: use check_signature()

Use check_signature() to find a signature in the mmio address.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/block/cciss.c~cciss-use-check_signature drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-use-check_signature
+++ a/drivers/block/cciss.c
@@ -42,8 +42,8 @@
 #include <linux/compat.h>
 #include <linux/mutex.h>
 #include <linux/bitmap.h>
+#include <linux/io.h>
 #include <asm/uaccess.h>
-#include <asm/io.h>
 
 #include <linux/dma-mapping.h>
 #include <linux/blkdev.h>
@@ -4267,10 +4267,7 @@ static void __devinit cciss_find_board_p
 
 static inline bool CISS_signature_present(ctlr_info_t *h)
 {
-	if ((readb(&h->cfgtable->Signature[0]) != 'C') ||
-	    (readb(&h->cfgtable->Signature[1]) != 'I') ||
-	    (readb(&h->cfgtable->Signature[2]) != 'S') ||
-	    (readb(&h->cfgtable->Signature[3]) != 'S')) {
+	if (!check_signature(h->cfgtable->Signature, "CISS", 4)) {
 		dev_warn(&h->pdev->dev, "not a valid CISS config table\n");
 		return false;
 	}
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch

