From: akpm@linux-foundation.org
Subject: + mmc_test-initialize-mmc_test_lock-statically.patch added to -mm tree
Date: Wed, 17 Sep 2008 12:10:36 -0700
Message-ID: <200809171910.m8HJAbFT025973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754759AbYIQTKo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 15:10:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, drzeus-mmc@drzeus.cx


The patch titled
     mmc_test: initialize mmc_test_lock statically
has been added to the -mm tree.  Its filename is
     mmc_test-initialize-mmc_test_lock-statically.patch

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
Subject: mmc_test: initialize mmc_test_lock statically
From: Akinobu Mita <akinobu.mita@gmail.com>

The mutex mmc_test_lock is initialized at every time mmc_test device is
probed.  Probing another mmc_test device may break the mutex, if the probe
function is called while the mutex is locked.

This patch fixes it by statically initializing mmc_test_lock.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/mmc_test.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/mmc/card/mmc_test.c~mmc_test-initialize-mmc_test_lock-statically drivers/mmc/card/mmc_test.c
--- a/drivers/mmc/card/mmc_test.c~mmc_test-initialize-mmc_test_lock-statically
+++ a/drivers/mmc/card/mmc_test.c
@@ -1040,7 +1040,7 @@ static const struct mmc_test_case mmc_te
 
 };
 
-static struct mutex mmc_test_lock;
+static DEFINE_MUTEX(mmc_test_lock);
 
 static void mmc_test_run(struct mmc_test_card *test, int testcase)
 {
@@ -1171,8 +1171,6 @@ static int mmc_test_probe(struct mmc_car
 	if ((card->type != MMC_TYPE_MMC) && (card->type != MMC_TYPE_SD))
 		return -ENODEV;
 
-	mutex_init(&mmc_test_lock);
