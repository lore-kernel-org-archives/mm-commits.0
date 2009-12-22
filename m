From: akpm@linux-foundation.org
Subject: + mmc-allow-for-mmc-v44.patch added to -mm tree
Date: Tue, 22 Dec 2009 14:22:35 -0800
Message-ID: <200912222222.nBMMMZT7027863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755211AbZLVWXJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Dec 2009 17:23:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adrian.hunter@nokia.com, linux-mmc@vger.kernel.org


The patch titled
     mmc: allow for MMC v4.4
has been added to the -mm tree.  Its filename is
     mmc-allow-for-mmc-v44.patch

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
Subject: mmc: allow for MMC v4.4
From: Adrian Hunter <adrian.hunter@nokia.com>

JEDEC eMMC specification version 4.4 (MMCA 4.4) defines Extended CSD
structure versions up to 5.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/mmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/core/mmc.c~mmc-allow-for-mmc-v44 drivers/mmc/core/mmc.c
--- a/drivers/mmc/core/mmc.c~mmc-allow-for-mmc-v44
+++ a/drivers/mmc/core/mmc.c
@@ -207,7 +207,7 @@ static int mmc_read_ext_csd(struct mmc_c
 	}
 
 	card->ext_csd.rev = ext_csd[EXT_CSD_REV];
-	if (card->ext_csd.rev > 3) {
+	if (card->ext_csd.rev > 5) {
 		printk(KERN_ERR "%s: unrecognised EXT_CSD structure "
 			"version %d\n", mmc_hostname(card->host),
 			card->ext_csd.rev);
_

Patches currently in -mm which might be from adrian.hunter@nokia.com are

mmc_block-add-dev_t-initialization-check.patch
mmc_block-fix-probe-error-cleanup-bug.patch
mmc_block-fix-queue-cleanup.patch
mmc-allow-for-mmc-v44.patch

