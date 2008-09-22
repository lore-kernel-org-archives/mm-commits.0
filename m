From: akpm@linux-foundation.org
Subject: - mmc_block-handle-error-from-mmc_register_driver.patch removed from -mm tree
Date: Mon, 22 Sep 2008 00:12:01 -0700
Message-ID: <200809220712.m8M7C1tw028693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751050AbYIVHML (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Sep 2008 03:12:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, drzeus-mmc@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     mmc_block: handle error from mmc_register_driver()
has been removed from the -mm tree.  Its filename was
     mmc_block-handle-error-from-mmc_register_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc_block: handle error from mmc_register_driver()
From: Akinobu Mita <akinobu.mita@gmail.com>

Check error from mmc_register_driver() and properly unwind block device
registration.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/block.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/card/block.c~mmc_block-handle-error-from-mmc_register_driver drivers/mmc/card/block.c
--- a/drivers/mmc/card/block.c~mmc_block-handle-error-from-mmc_register_driver
+++ a/drivers/mmc/card/block.c
@@ -585,14 +585,19 @@ static struct mmc_driver mmc_driver = {
 
 static int __init mmc_blk_init(void)
 {
-	int res = -ENOMEM;
+	int res;
 
 	res = register_blkdev(MMC_BLOCK_MAJOR, "mmc");
 	if (res)
 		goto out;
 
-	return mmc_register_driver(&mmc_driver);
+	res = mmc_register_driver(&mmc_driver);
+	if (res)
+		goto out2;
 
+	return 0;
+ out2:
+	unregister_blkdev(MMC_BLOCK_MAJOR, "mmc");
  out:
 	return res;
 }
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

ibmasr-remove-unnecessary-spin_unlock.patch
linux-next.patch
anysee-initialize-anysee_usb_mutex-statically.patch
ipr-use-memory_read_from_buffer.patch

