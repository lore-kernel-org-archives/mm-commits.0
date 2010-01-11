From: akpm@linux-foundation.org
Subject: [merged] mmc_block-add-dev_t-initialization-check.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:18:35 -0800
Message-ID: <201001112018.o0BKIZvw025497__31918.6530927711$1263242198$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754150Ab0AKUg2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:36:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: EXT-Anna.Lemehova@nokia.com, adrian.hunter@nokia.com, linux-mmc@vger.kernel.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mmc_block: add dev_t initialization check
has been removed from the -mm tree.  Its filename was
     mmc_block-add-dev_t-initialization-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

