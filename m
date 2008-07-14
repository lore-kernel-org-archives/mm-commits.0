From: akpm@linux-foundation.org
Subject: - regulator-ti-bq24022-li-ion-charger-driver-update.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:35:50 -0700
Message-ID: <200807141935.m6EJZo4x023959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756452AbYGNTfw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:35:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: philipp.zabel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     regulator-ti-bq24022-li-ion-charger-driver update
has been removed from the -mm tree.  Its filename was
     regulator-ti-bq24022-li-ion-charger-driver-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

