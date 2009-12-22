From: akpm@linux-foundation.org
Subject: + mmc_block-add-dev_t-initialization-check.patch added to -mm tree
Date: Tue, 22 Dec 2009 14:21:01 -0800
Message-ID: <200912222221.nBMML2OT027721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755064AbZLVWWM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Dec 2009 17:22:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: EXT-Anna.Lemehova@nokia.com, adrian.hunter@nokia.com, linux-mmc@vger.kernel.org, stable@kernel.org


The patch titled
     mmc_block: add dev_t initialization check
has been added to the -mm tree.  Its filename is
     mmc_block-add-dev_t-initialization-check.patch

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
Subject: mmc_block: add dev_t initialization check
From: Anna Lemehova <EXT-Anna.Lemehova@nokia.com>

When a card is removed before mmc_blk_probe() has called add_disk(), then
the minor field is uninitialized and has value 0.  This caused
mmc_blk_put() to always release devidx 0 even if 0 was still in use.  Then
the next mmc_blk_probe() used the first free idx of 0, which oopses in
sysfs, since it is used by another card.

Signed-off-by: Anna Lemehova <EXT-Anna.Lemehova@nokia.com>
Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: <linux-mmc@vger.kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/block.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/mmc/card/block.c~mmc_block-add-dev_t-initialization-check drivers/mmc/card/block.c
--- a/drivers/mmc/card/block.c~mmc_block-add-dev_t-initialization-check
+++ a/drivers/mmc/card/block.c
@@ -85,7 +85,12 @@ static void mmc_blk_put(struct mmc_blk_d
 	mutex_lock(&open_lock);
 	md->usage--;
 	if (md->usage == 0) {
+		int devmaj = MAJOR(disk_devt(md->disk));
 		int devidx = MINOR(disk_devt(md->disk)) >> MMC_SHIFT;
+
+		if (!devmaj)
+			devidx = md->disk->first_minor >> MMC_SHIFT;
+
 		__clear_bit(devidx, dev_use);
 
 		put_disk(md->disk);
_

Patches currently in -mm which might be from EXT-Anna.Lemehova@nokia.com are

mmc_block-add-dev_t-initialization-check.patch

