From: akpm@linux-foundation.org
Subject: + regulator-ti-bq24022-li-ion-charger-driver-update.patch added to -mm tree
Date: Sat, 12 Jul 2008 18:53:07 -0700
Message-ID: <200807130153.m6D1r7PO031460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753114AbYGMBxJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Jul 2008 21:53:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: philipp.zabel@gmail.com


The patch titled
     regulator-ti-bq24022-li-ion-charger-driver update
has been added to the -mm tree.  Its filename is
     regulator-ti-bq24022-li-ion-charger-driver-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: regulator-ti-bq24022-li-ion-charger-driver update
From: Philipp Zabel <philipp.zabel@gmail.com>

This adds a regulator driver for the TI bq24022 Single-Chip
Li-Ion Charger with its nCE and ISET2 pins connected to GPIOs.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/bq24022.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/regulator/bq24022.c~regulator-ti-bq24022-li-ion-charger-driver-update drivers/regulator/bq24022.c
--- a/drivers/regulator/bq24022.c~regulator-ti-bq24022-li-ion-charger-driver-update
+++ a/drivers/regulator/bq24022.c
@@ -145,12 +145,12 @@ static struct platform_driver bq24022_dr
 	.remove = __devexit_p(bq24022_remove),
 };
 
-static int __init bq24022_init()
+static int __init bq24022_init(void)
 {
-	platform_driver_probe(&bq24022_driver, bq24022_probe);
+	return platform_driver_probe(&bq24022_driver, bq24022_probe);
 }
 
-static void __exit bq24022_exit()
+static void __exit bq24022_exit(void)
 {
 	platform_driver_unregister(&bq24022_driver);
 }
_

Patches currently in -mm which might be from philipp.zabel@gmail.com are

origin.patch
linux-next.patch
regulator-ti-bq24022-li-ion-charger-driver.patch
regulator-ti-bq24022-li-ion-charger-driver-update.patch
regulator-virtual-consumer-current-limit-support.patch
regulator-include-suspendh-in-machineh-for-suspend_state_t.patch

