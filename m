From: akpm@linux-foundation.org
Subject: [merged] block-remove-redundant-check-to-bd_openers.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:56:32 -0800
Message-ID: <20130225205632.C0E1431C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:44241 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759857Ab3BYU4d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:56:33 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so159595yen.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:56:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yan@linux.vnet.ibm.com, axboe@kernel.dk, hindessm@uk.ibm.com, knikanth@suse.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: block: remove redundant check to bd_openers()
has been removed from the -mm tree.  Its filename was
     block-remove-redundant-check-to-bd_openers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: block: remove redundant check to bd_openers()

bd_openers is stable under bd_mutex, no need to check it twice.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Guo Chao <yan@linux.vnet.ibm.com>
Cc: M. Hindess <hindessm@uk.ibm.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/block_dev.c~block-remove-redundant-check-to-bd_openers fs/block_dev.c
--- a/fs/block_dev.c~block-remove-redundant-check-to-bd_openers
+++ a/fs/block_dev.c
@@ -1120,7 +1120,7 @@ static int __blkdev_get(struct block_dev
 				}
 			}
 
-			if (!ret && !bdev->bd_openers) {
+			if (!ret) {
 				bd_set_size(bdev,(loff_t)get_capacity(disk)<<9);
 				bdi = blk_get_backing_dev_info(bdev);
 				if (bdi == NULL)
_

Patches currently in -mm which might be from yan@linux.vnet.ibm.com are

linux-next.patch

