From: akpm@linux-foundation.org
Subject: + cciss-use-check_signature.patch added to -mm tree
Date: Tue, 14 Aug 2012 15:49:57 -0700
Message-ID: <20120814224958.0B1F620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:55963 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab2HNWuA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Aug 2012 18:50:00 -0400
Received: by lbbge1 with SMTP id ge1so48974lbb.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Aug 2012 15:49:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, axboe@kernel.dk, mike.miller@hp.com, scameron@beardog.cce.hp.com


The patch titled
     Subject: cciss: use check_signature
has been added to the -mm tree.  Its filename is
     cciss-use-check_signature.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: cciss: use check_signature

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
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch
cciss-cleanup-bitops-usage.patch
cciss-use-check_signature.patch

