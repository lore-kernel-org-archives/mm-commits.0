From: akpm@linux-foundation.org
Subject: + power-ab8500-convert-to-use-match_string-helper.patch added to
 -mm tree
Date: Mon, 01 Feb 2016 22:10:34 -0800
Message-ID: <56b0485a.A5jo4vY4b19H8fQ/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbcBBGKf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 01:10:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linus.walleij@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: power: ab8500: convert to use match_string() helper
has been added to the -mm tree.  Its filename is
     power-ab8500-convert-to-use-match_string-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/power-ab8500-convert-to-use-match_string-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/power-ab8500-convert-to-use-match_string-helper.patch

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
Subject: power: ab8500: convert to use match_string() helper

The new helper returns index of the mathing string in an array.  We would
use it here.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/ab8500_btemp.c    |   15 +++++----------
 drivers/power/ab8500_charger.c  |   16 +++++-----------
 drivers/power/ab8500_fg.c       |   15 +++++----------
 drivers/power/abx500_chargalg.c |   14 +++++---------
 4 files changed, 20 insertions(+), 40 deletions(-)

diff -puN drivers/power/ab8500_btemp.c~power-ab8500-convert-to-use-match_string-helper drivers/power/ab8500_btemp.c
--- a/drivers/power/ab8500_btemp.c~power-ab8500-convert-to-use-match_string-helper
+++ a/drivers/power/ab8500_btemp.c
@@ -906,26 +906,21 @@ static int ab8500_btemp_get_property(str
 static int ab8500_btemp_get_ext_psy_data(struct device *dev, void *data)
 {
 	struct power_supply *psy;
-	struct power_supply *ext;
+	struct power_supply *ext = dev_get_drvdata(dev);
+	const char **supplicants = (const char **)ext->supplied_to;
 	struct ab8500_btemp *di;
 	union power_supply_propval ret;
-	int i, j;
-	bool psy_found = false;
+	int j;
 
 	psy = (struct power_supply *)data;
-	ext = dev_get_drvdata(dev);
 	di = power_supply_get_drvdata(psy);
 
 	/*
 	 * For all psy where the name of your driver
 	 * appears in any supplied_to
 	 */
-	for (i = 0; i < ext->num_supplicants; i++) {
-		if (!strcmp(ext->supplied_to[i], psy->desc->name))
-			psy_found = true;
-	}
-
-	if (!psy_found)
+	j = match_string(supplicants, ext->num_supplicants, psy->desc->name);
+	if (j < 0)
 		return 0;
 
 	/* Go through all properties for the psy */
diff -puN drivers/power/ab8500_charger.c~power-ab8500-convert-to-use-match_string-helper drivers/power/ab8500_charger.c
--- a/drivers/power/ab8500_charger.c~power-ab8500-convert-to-use-match_string-helper
+++ a/drivers/power/ab8500_charger.c
@@ -1929,11 +1929,11 @@ static int ab8540_charger_usb_pre_chg_en
 static int ab8500_charger_get_ext_psy_data(struct device *dev, void *data)
 {
 	struct power_supply *psy;
-	struct power_supply *ext;
+	struct power_supply *ext = dev_get_drvdata(dev);
+	const char **supplicants = (const char **)ext->supplied_to;
 	struct ab8500_charger *di;
 	union power_supply_propval ret;
-	int i, j;
-	bool psy_found = false;
+	int j;
 	struct ux500_charger *usb_chg;
 
 	usb_chg = (struct ux500_charger *)data;
@@ -1941,15 +1941,9 @@ static int ab8500_charger_get_ext_psy_da
 
 	di = to_ab8500_charger_usb_device_info(usb_chg);
 
-	ext = dev_get_drvdata(dev);
-
 	/* For all psy where the driver name appears in any supplied_to */
-	for (i = 0; i < ext->num_supplicants; i++) {
-		if (!strcmp(ext->supplied_to[i], psy->desc->name))
-			psy_found = true;
-	}
-
-	if (!psy_found)
+	j = match_string(supplicants, ext->num_supplicants, psy->desc->name);
+	if (j < 0)
 		return 0;
 
 	/* Go through all properties for the psy */
diff -puN drivers/power/ab8500_fg.c~power-ab8500-convert-to-use-match_string-helper drivers/power/ab8500_fg.c
--- a/drivers/power/ab8500_fg.c~power-ab8500-convert-to-use-match_string-helper
+++ a/drivers/power/ab8500_fg.c
@@ -2168,26 +2168,21 @@ static int ab8500_fg_get_property(struct
 static int ab8500_fg_get_ext_psy_data(struct device *dev, void *data)
 {
 	struct power_supply *psy;
-	struct power_supply *ext;
+	struct power_supply *ext = dev_get_drvdata(dev);
+	const char **supplicants = (const char **)ext->supplied_to;
 	struct ab8500_fg *di;
 	union power_supply_propval ret;
-	int i, j;
-	bool psy_found = false;
+	int j;
 
 	psy = (struct power_supply *)data;
-	ext = dev_get_drvdata(dev);
 	di = power_supply_get_drvdata(psy);
 
 	/*
 	 * For all psy where the name of your driver
 	 * appears in any supplied_to
 	 */
-	for (i = 0; i < ext->num_supplicants; i++) {
-		if (!strcmp(ext->supplied_to[i], psy->desc->name))
-			psy_found = true;
-	}
-
-	if (!psy_found)
+	j = match_string(supplicants, ext->num_supplicants, psy->desc->name);
+	if (j < 0)
 		return 0;
 
 	/* Go through all properties for the psy */
diff -puN drivers/power/abx500_chargalg.c~power-ab8500-convert-to-use-match_string-helper drivers/power/abx500_chargalg.c
--- a/drivers/power/abx500_chargalg.c~power-ab8500-convert-to-use-match_string-helper
+++ a/drivers/power/abx500_chargalg.c
@@ -975,22 +975,18 @@ static void handle_maxim_chg_curr(struct
 static int abx500_chargalg_get_ext_psy_data(struct device *dev, void *data)
 {
 	struct power_supply *psy;
-	struct power_supply *ext;
+	struct power_supply *ext = dev_get_drvdata(dev);
+	const char **supplicants = (const char **)ext->supplied_to;
 	struct abx500_chargalg *di;
 	union power_supply_propval ret;
-	int i, j;
-	bool psy_found = false;
+	int j;
 	bool capacity_updated = false;
 
 	psy = (struct power_supply *)data;
-	ext = dev_get_drvdata(dev);
 	di = power_supply_get_drvdata(psy);
 	/* For all psy where the driver name appears in any supplied_to */
-	for (i = 0; i < ext->num_supplicants; i++) {
-		if (!strcmp(ext->supplied_to[i], psy->desc->name))
-			psy_found = true;
-	}
-	if (!psy_found)
+	j = match_string(supplicants, ext->num_supplicants, psy->desc->name);
+	if (j < 0)
 		return 0;
 
 	/*
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

