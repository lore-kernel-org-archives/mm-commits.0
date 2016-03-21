From: akpm@linux-foundation.org
Subject: [merged]
 power-charger_manager-convert-to-use-match_string-helper.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:42:11 -0700
Message-ID: <56f04083.VXjDm3CgSl12SbQo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757940AbcCUTVV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:21:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, dbaryshkov@gmail.com, dwmw2@infradead.org, sre@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: power: charger_manager: convert to use match_string() helper
has been removed from the -mm tree.  Its filename was
     power-charger_manager-convert-to-use-match_string-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: power: charger_manager: convert to use match_string() helper

The new helper returns index of the mathing string in an array. We would use it
here.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/charger-manager.c |   27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff -puN drivers/power/charger-manager.c~power-charger_manager-convert-to-use-match_string-helper drivers/power/charger-manager.c
--- a/drivers/power/charger-manager.c~power-charger_manager-convert-to-use-match_string-helper
+++ a/drivers/power/charger-manager.c
@@ -2020,27 +2020,6 @@ static void __exit charger_manager_clean
 module_exit(charger_manager_cleanup);
 
 /**
- * find_power_supply - find the associated power_supply of charger
- * @cm: the Charger Manager representing the battery
- * @psy: pointer to instance of charger's power_supply
- */
-static bool find_power_supply(struct charger_manager *cm,
-			struct power_supply *psy)
-{
-	int i;
-	bool found = false;
-
-	for (i = 0; cm->desc->psy_charger_stat[i]; i++) {
-		if (!strcmp(psy->desc->name, cm->desc->psy_charger_stat[i])) {
-			found = true;
-			break;
-		}
-	}
-
-	return found;
-}
