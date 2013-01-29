From: akpm@linux-foundation.org
Subject: + block-remove-redundant-check-to-bd_openers.patch added to -mm tree
Date: Mon, 28 Jan 2013 16:40:11 -0800
Message-ID: <20130129004012.6D67E5A4207@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:43495 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab3A2AkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 19:40:13 -0500
Received: by mail-ob0-f202.google.com with SMTP id lz20so713209obb.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 16:40:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yan@linux.vnet.ibm.com, axboe@kernel.dk, hindessm@uk.ibm.com, knikanth@suse.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: block: remove redundant check to bd_openers()
has been added to the -mm tree.  Its filename is
     block-remove-redundant-check-to-bd_openers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
block-use-i_size_write-in-bd_set_size.patch
block-remove-redundant-check-to-bd_openers.patch
loopdev-fix-a-deadlock.patch
loopdev-update-block-device-size-in-loop_set_status.patch
loopdev-move-common-code-into-loop_figure_size.patch
loopdev-remove-an-user-triggerable-oops.patch
loopdev-ignore-negative-offset-when-calculate-loop-device-size.patch

