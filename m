From: akpm@linux-foundation.org
Subject: + memstick-fix-hangs-on-unexpected-device-removal-in-mspro_blk.patch added to -mm tree
Date: Thu, 05 Aug 2010 15:37:11 -0700
Message-ID: <201008052237.o75MbBNT009396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933169Ab0HEWrS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Aug 2010 18:47:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maximlevitsky@gmail.com, oakad@yahoo.com, stable@kernel.org


The patch titled
     memstick: fix hangs on unexpected device removal in mspro_blk
has been added to the -mm tree.  Its filename is
     memstick-fix-hangs-on-unexpected-device-removal-in-mspro_blk.patch

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
Subject: memstick: fix hangs on unexpected device removal in mspro_blk
From: Maxim Levitsky <maximlevitsky@gmail.com>

mspro_block_remove() is called from detect thread that first calls the
mspro_block_stop(), which stops the request queue.  If we call
del_gendisk() with the queue stopped we get a deadlock.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/memstick/core/mspro_block.c~memstick-fix-hangs-on-unexpected-device-removal-in-mspro_blk drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-fix-hangs-on-unexpected-device-removal-in-mspro_blk
+++ a/drivers/memstick/core/mspro_block.c
@@ -1339,13 +1339,14 @@ static void mspro_block_remove(struct me
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
 	unsigned long flags;
 
-	del_gendisk(msb->disk);
-	dev_dbg(&card->dev, "mspro block remove\n");
 	spin_lock_irqsave(&msb->q_lock, flags);
 	msb->eject = 1;
 	blk_start_queue(msb->queue);
 	spin_unlock_irqrestore(&msb->q_lock, flags);
 
+	del_gendisk(msb->disk);
+	dev_dbg(&card->dev, "mspro block remove\n");
+
 	blk_cleanup_queue(msb->queue);
 	msb->queue = NULL;
 
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

linux-next.patch
maintainers-update-ricoh-smartmedia-xd-driver-file-patterns.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update-2.patch
mmc-make-sdhci-work-with-ricoh-mmc-controller.patch
mmc-add-ricoh-e822-pci-id.patch
memstick-init-sysfs-attributes.patch
memstick-fix-hangs-on-unexpected-device-removal-in-mspro_blk.patch

