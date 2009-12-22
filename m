From: akpm@linux-foundation.org
Subject: + mmc_block-fix-probe-error-cleanup-bug.patch added to -mm tree
Date: Tue, 22 Dec 2009 14:21:03 -0800
Message-ID: <200912222221.nBMML3HS027725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755163AbZLVWWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Dec 2009 17:22:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkko.lavinen@nokia.com, adrian.hunter@nokia.com, linux-mmc@vger.kernel.org, stable@kernel.org


The patch titled
     mmc_block: fix probe error cleanup bug
has been added to the -mm tree.  Its filename is
     mmc_block-fix-probe-error-cleanup-bug.patch

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

mmc_block-fix-probe-error-cleanup-bug.patch

