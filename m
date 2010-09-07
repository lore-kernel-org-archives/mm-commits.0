From: akpm@linux-foundation.org
Subject: + mmc_test-change-simple_strtol-to-strict_strtol.patch added to -mm tree
Date: Tue, 07 Sep 2010 15:30:03 -0700
Message-ID: <201009072230.o87MU3tk010210__12413.2777135403$1283898612$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751436Ab0IGWaG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 18:30:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andy.shevchenko@gmail.com, ext-andriy.shevchenko@nokia.com, linux-mmc@vger.kernel.org


The patch titled
     mmc_test: change simple_strtol() to strict_strtol()
has been added to the -mm tree.  Its filename is
     mmc_test-change-simple_strtol-to-strict_strtol.patch

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
Subject: mmc_test: change simple_strtol() to strict_strtol()
From: Andy Shevchenko <andy.shevchenko@gmail.com>

It's better to use strict_strtol() to convert user's input and strictly check
it. At least it forbids to interpret wrong input as a 0 and prevents to run all
tests.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/mmc_test.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/card/mmc_test.c~mmc_test-change-simple_strtol-to-strict_strtol drivers/mmc/card/mmc_test.c
--- a/drivers/mmc/card/mmc_test.c~mmc_test-change-simple_strtol-to-strict_strtol
+++ a/drivers/mmc/card/mmc_test.c
@@ -1937,9 +1937,10 @@ static ssize_t mmc_test_store(struct dev
 {
 	struct mmc_card *card = mmc_dev_to_card(dev);
 	struct mmc_test_card *test;
-	int testcase;
+	long testcase;
 
-	testcase = simple_strtol(buf, NULL, 10);
+	if (strict_strtol(buf, 10, &testcase))
+		return -EINVAL;
 
 	test = kzalloc(sizeof(struct mmc_test_card), GFP_KERNEL);
 	if (!test)
_

Patches currently in -mm which might be from andy.shevchenko@gmail.com are

linux-next.patch
lib-bitmapc-use-hex_to_bin.patch
mmc-make-dev_to_mmc_card-macro-public.patch
mmc-rename-dev_to_mmc_card-to-mmc_dev_to_card.patch
mmc_test-use-api-to-check-card-type.patch
mmc_test-change-simple_strtol-to-strict_strtol.patch
mmc_test-collect-data-and-show-it-via-sysfs-by-demand.patch

