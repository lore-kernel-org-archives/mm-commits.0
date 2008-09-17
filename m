From: akpm@linux-foundation.org
Subject: + mmc_block-handle-error-from-mmc_register_driver.patch added to -mm tree
Date: Wed, 17 Sep 2008 12:10:34 -0700
Message-ID: <200809171910.m8HJAYp9025968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754740AbYIQTKo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 15:10:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, drzeus-mmc@drzeus.cx


The patch titled
     mmc_block: handle error from mmc_register_driver()
has been added to the -mm tree.  Its filename is
     mmc_block-handle-error-from-mmc_register_driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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
mmc_block-handle-error-from-mmc_register_driver.patch
mmc_test-initialize-mmc_test_lock-statically.patch
anysee-initialize-anysee_usb_mutex-statically.patch
ipr-use-memory_read_from_buffer.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch

