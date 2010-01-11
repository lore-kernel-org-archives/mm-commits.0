From: akpm@linux-foundation.org
Subject: [merged] mmc_block-fix-probe-error-cleanup-bug.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:18:38 -0800
Message-ID: <201001112018.o0BKIcBp025501__2641.54367982901$1263242199$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754151Ab0AKUg2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:36:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkko.lavinen@nokia.com, adrian.hunter@nokia.com, linux-mmc@vger.kernel.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mmc_block: fix probe error cleanup bug
has been removed from the -mm tree.  Its filename was
     mmc_block-fix-probe-error-cleanup-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc_block: fix probe error cleanup bug
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>

If mmc_blk_set_blksize() fails mmc_blk_probe() the request queue and its
thread have been set up and they need to be shut down properly before
putting the disk.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: <linux-mmc@vger.kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/block.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mmc/card/block.c~mmc_block-fix-probe-error-cleanup-bug drivers/mmc/card/block.c
--- a/drivers/mmc/card/block.c~mmc_block-fix-probe-error-cleanup-bug
+++ a/drivers/mmc/card/block.c
@@ -618,6 +618,7 @@ static int mmc_blk_probe(struct mmc_card
 	return 0;
 
  out:
+	mmc_cleanup_queue(&md->queue);
 	mmc_blk_put(md);
 
 	return err;
_

Patches currently in -mm which might be from jarkko.lavinen@nokia.com are

origin.patch

