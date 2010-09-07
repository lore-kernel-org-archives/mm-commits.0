From: akpm@linux-foundation.org
Subject: + mmc_test-use-api-to-check-card-type.patch added to -mm tree
Date: Tue, 07 Sep 2010 15:30:01 -0700
Message-ID: <201009072230.o87MU1lp010207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080Ab0IGWaF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 18:30:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andy.shevchenko@gmail.com, ext-andriy.shevchenko@nokia.com, linux-mmc@vger.kernel.org


The patch titled
     mmc_test: use API to check card type
has been added to the -mm tree.  Its filename is
     mmc_test-use-api-to-check-card-type.patch

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
Subject: mmc_test: use API to check card type
From: Andy Shevchenko <andy.shevchenko@gmail.com>

There are methods to check card type. Let's use them instead of direct checking
type bits.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/mmc_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/card/mmc_test.c~mmc_test-use-api-to-check-card-type drivers/mmc/card/mmc_test.c
--- a/drivers/mmc/card/mmc_test.c~mmc_test-use-api-to-check-card-type
+++ a/drivers/mmc/card/mmc_test.c
@@ -1977,7 +1977,7 @@ static int mmc_test_probe(struct mmc_car
 {
 	int ret;
 
-	if ((card->type != MMC_TYPE_MMC) && (card->type != MMC_TYPE_SD))
+	if (!mmc_card_mmc(card) && !mmc_card_sd(card))
 		return -ENODEV;
 
 	ret = device_create_file(&card->dev, &dev_attr_test);
_

Patches currently in -mm which might be from andy.shevchenko@gmail.com are

linux-next.patch
lib-bitmapc-use-hex_to_bin.patch
mmc-make-dev_to_mmc_card-macro-public.patch
mmc-rename-dev_to_mmc_card-to-mmc_dev_to_card.patch
mmc_test-use-api-to-check-card-type.patch
mmc_test-change-simple_strtol-to-strict_strtol.patch
mmc_test-collect-data-and-show-it-via-sysfs-by-demand.patch

