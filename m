From: akpm@linux-foundation.org
Subject: + block-block_dump-add-number-of-sectors-to-debug-output.patch added to -mm tree
Date: Mon, 13 Sep 2010 15:48:56 -0700
Message-ID: <201009132248.o8DMmuPq025744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412Ab0IMWtI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Sep 2010 18:49:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: san@android.com, axboe@kernel.dk, linus.walleij@stericsson.com


The patch titled
     block: block_dump: Add number of sectors to debug output
has been added to the -mm tree.  Its filename is
     block-block_dump-add-number-of-sectors-to-debug-output.patch

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
Subject: block: block_dump: Add number of sectors to debug output
From: San Mehat <san@android.com>

Signed-off-by: San Mehat <san@android.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN block/blk-core.c~block-block_dump-add-number-of-sectors-to-debug-output block/blk-core.c
--- a/block/blk-core.c~block-block_dump-add-number-of-sectors-to-debug-output
+++ a/block/blk-core.c
@@ -1620,11 +1620,12 @@ void submit_bio(int rw, struct bio *bio)
 
 		if (unlikely(block_dump)) {
 			char b[BDEVNAME_SIZE];
-			printk(KERN_DEBUG "%s(%d): %s block %Lu on %s\n",
+			printk(KERN_DEBUG "%s(%d): %s block %Lu on %s (%u sectors)\n",
 			current->comm, task_pid_nr(current),
 				(rw & WRITE) ? "WRITE" : "READ",
 				(unsigned long long)bio->bi_sector,
-				bdevname(bio->bi_bdev, b));
+				bdevname(bio->bi_bdev, b),
+				count);
 		}
 	}
 
_

Patches currently in -mm which might be from san@android.com are

block-block_dump-add-number-of-sectors-to-debug-output.patch

