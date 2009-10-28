From: akpm@linux-foundation.org
Subject: + block-fix-use-after-free-bug-in-__blkdev_get.patch added to -mm tree
Date: Wed, 28 Oct 2009 15:46:00 -0700
Message-ID: <200910282246.n9SMk0BE012022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752684AbZJ1Wqa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Oct 2009 18:46:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, jens.axboe@oracle.com, stable@kernel.org, tj@kernel.org


The patch titled
     block: fix use after free bug in __blkdev_get
has been added to the -mm tree.  Its filename is
     block-fix-use-after-free-bug-in-__blkdev_get.patch

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
Subject: block: fix use after free bug in __blkdev_get
From: Neil Brown <neilb@suse.de>

commit 0762b8bde9729f10f8e6249809660ff2ec3ad735 ("block: always set
bdev->bd_part") (from 14 months ago) introduced a use-after-free bug which
has just recently started manifesting in my md testing.  I tried git
bisect to find out what caused the bug to start manifesting, and it could
have been the recent change to blk_unregister_queue (48c0d4d4c04) but the
results were inconclusive.

This patch certainly fixes my symptoms and looks correct as the two calls
are now in the same order as elsewhere in that function.

Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/block_dev.c~block-fix-use-after-free-bug-in-__blkdev_get fs/block_dev.c
--- a/fs/block_dev.c~block-fix-use-after-free-bug-in-__blkdev_get
+++ a/fs/block_dev.c
@@ -1258,8 +1258,8 @@ static int __blkdev_get(struct block_dev
 			bd_set_size(bdev, (loff_t)bdev->bd_part->nr_sects << 9);
 		}
 	} else {
-		put_disk(disk);
 		module_put(disk->fops->owner);
+		put_disk(disk);
 		disk = NULL;
 		if (bdev->bd_contains == bdev) {
 			if (bdev->bd_disk->fops->open) {
_

Patches currently in -mm which might be from neilb@suse.de are

linux-next.patch
block-fix-use-after-free-bug-in-__blkdev_get.patch
lib-vsprintfc-add-%pu-to-print-uuid-guids.patch
drivers-md-mdc-use-%pu-to-print-uuids.patch
lib-unified-uuid-guid-definition.patch

