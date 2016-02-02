From: akpm@linux-foundation.org
Subject: + power-charger_manager-convert-to-use-match_string-helper.patch
 added to -mm tree
Date: Mon, 01 Feb 2016 22:10:33 -0800
Message-ID: <56b04859.lo8iUtVzmFGZi5aq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbcBBGKe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 01:10:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, dbaryshkov@gmail.com, dwmw2@infradead.org, sre@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: power: charger_manager: convert to use match_string() helper
has been added to the -mm tree.  Its filename is
     power-charger_manager-convert-to-use-match_string-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/power-charger_manager-convert-to-use-match_string-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/power-charger_manager-convert-to-use-match_string-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
-/**
  * cm_notify_event - charger driver notify Charger Manager of charger event
  * @psy: pointer to instance of charger's power_supply
  * @type: type of charger event
@@ -2057,9 +2036,11 @@ void cm_notify_event(struct power_supply
 
 	mutex_lock(&cm_list_mtx);
 	list_for_each_entry(cm, &cm_list, entry) {
-		found_power_supply = find_power_supply(cm, psy);
-		if (found_power_supply)
+		if (match_string(cm->desc->psy_charger_stat, -1,
+				 psy->desc->name) >= 0) {
+			found_power_supply = true;
 			break;
+		}
 	}
 	mutex_unlock(&cm_list_mtx);
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-string-introduce-match_string-helper.patch
device-property-convert-to-use-match_string-helper.patch
pinctrl-convert-to-use-match_string-helper.patch
drm-edid-convert-to-use-match_string-helper.patch
power-charger_manager-convert-to-use-match_string-helper.patch
power-ab8500-convert-to-use-match_string-helper.patch
ata-hpt366-convert-to-use-match_string-helper.patch
ide-hpt366-convert-to-use-match_string-helper.patch
lib-string_helpers-export-string_units_210-for-others.patch
lib-string_helpers-fix-indentation-in-few-places.patch
x86-efi-use-proper-units-in-efi_find_mirror.patch

