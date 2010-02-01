From: akpm@linux-foundation.org
Subject: + mmc_test-block-addressed-cards.patch added to -mm tree
Date: Mon, 01 Feb 2010 14:15:42 -0800
Message-ID: <201002012215.o11MFgYg015848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215Ab0BAWPr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 17:15:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johan.kristell@axis.com, linux-mmc@vger.kernel.org


The patch titled
     mmc_test: block addressed cards
has been added to the -mm tree.  Its filename is
     mmc_test-block-addressed-cards.patch

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
Subject: mmc_test: block addressed cards
From: Johan Kristell <johan.kristell@axis.com>

The tests in mmc_test assumes that all cards are byte addressable.  This
patch updates the tests to also work with cards that use block addresses.

Signed-off-by: Johan Kristell <johan.kristell@axis.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/mmc_test.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/mmc/card/mmc_test.c~mmc_test-block-addressed-cards drivers/mmc/card/mmc_test.c
--- a/drivers/mmc/card/mmc_test.c~mmc_test-block-addressed-cards
+++ a/drivers/mmc/card/mmc_test.c
@@ -74,6 +74,9 @@ static void mmc_test_prepare_mrq(struct 
 	}
 
 	mrq->cmd->arg = dev_addr;
+	if (!mmc_card_blockaddr(test->card))
+		mrq->cmd->arg <<= 9;
+
 	mrq->cmd->flags = MMC_RSP_R1 | MMC_CMD_ADTC;
 
 	if (blocks == 1)
@@ -190,7 +193,7 @@ static int __mmc_test_prepare(struct mmc
 	}
 
 	for (i = 0;i < BUFFER_SIZE / 512;i++) {
-		ret = mmc_test_buffer_transfer(test, test->buffer, i * 512, 512, 1);
+		ret = mmc_test_buffer_transfer(test, test->buffer, i, 512, 1);
 		if (ret)
 			return ret;
 	}
@@ -219,7 +222,7 @@ static int mmc_test_cleanup(struct mmc_t
 	memset(test->buffer, 0, 512);
 
 	for (i = 0;i < BUFFER_SIZE / 512;i++) {
-		ret = mmc_test_buffer_transfer(test, test->buffer, i * 512, 512, 1);
+		ret = mmc_test_buffer_transfer(test, test->buffer, i, 512, 1);
 		if (ret)
 			return ret;
 	}
@@ -426,7 +429,7 @@ static int mmc_test_transfer(struct mmc_
 		for (i = 0;i < sectors;i++) {
 			ret = mmc_test_buffer_transfer(test,
 				test->buffer + i * 512,
-				dev_addr + i * 512, 512, 0);
+				dev_addr + i, 512, 0);
 			if (ret)
 				return ret;
 		}
_

Patches currently in -mm which might be from johan.kristell@axis.com are

mmc_test-block-addressed-cards.patch

