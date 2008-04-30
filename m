From: akpm@linux-foundation.org
Subject: + power_supply-cleanup-of-the-olpc-battery-driver.patch added to -mm tree
Date: Wed, 30 Apr 2008 14:56:22 -0700
Message-ID: <200804302156.m3ULuMcR005361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759698AbYD3V4l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 17:56:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, cbou@mail.ru, dilinger@debian.org, dwmw2@infradead.org


The patch titled
     power_supply: cleanup of the OLPC battery driver
has been added to the -mm tree.  Its filename is
     power_supply-cleanup-of-the-olpc-battery-driver.patch

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
Subject: power_supply: cleanup of the OLPC battery driver
From: Andres Salomon <dilinger@queued.net>

Move portions of the massive switch statement into functions.  The layout of
this thing has already caused one bug (a break in the wrong place), it needed
to shrink.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/olpc_battery.c |  191 ++++++++++++++++++++-------------
 1 file changed, 118 insertions(+), 73 deletions(-)

diff -puN drivers/power/olpc_battery.c~power_supply-cleanup-of-the-olpc-battery-driver drivers/power/olpc_battery.c
--- a/drivers/power/olpc_battery.c~power_supply-cleanup-of-the-olpc-battery-driver
+++ a/drivers/power/olpc_battery.c
@@ -86,6 +86,117 @@ static struct power_supply olpc_ac = {
 
 static char bat_serial[17]; /* Ick */
 
+static int olpc_bat_get_status(union power_supply_propval *val, uint8_t ec_byte)
+{
+	if (olpc_platform_info.ecver > 0x44) {
+		if (ec_byte & BAT_STAT_CHARGING)
+			val->intval = POWER_SUPPLY_STATUS_CHARGING;
+		else if (ec_byte & BAT_STAT_DISCHARGING)
+			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+		else if (ec_byte & BAT_STAT_FULL)
+			val->intval = POWER_SUPPLY_STATUS_FULL;
+		else /* er,... */
+			val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
+	} else {
+		/* Older EC didn't report charge/discharge bits */
+		if (!(ec_byte & BAT_STAT_AC)) /* No AC means discharging */
+			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+		else if (ec_byte & BAT_STAT_FULL)
+			val->intval = POWER_SUPPLY_STATUS_FULL;
+		else /* Not _necessarily_ true but EC doesn't tell all yet */
+			val->intval = POWER_SUPPLY_STATUS_CHARGING;
+	}
+
+	return 0;
+}
+
+static int olpc_bat_get_health(union power_supply_propval *val)
+{
+	uint8_t ec_byte;
+	int ret;
+
+	ret = olpc_ec_cmd(EC_BAT_ERRCODE, NULL, 0, &ec_byte, 1);
+	if (ret)
+		return ret;
+
+	switch (ec_byte) {
+	case 0:
+		val->intval = POWER_SUPPLY_HEALTH_GOOD;
+		break;
+
+	case BAT_ERR_OVERTEMP:
+		val->intval = POWER_SUPPLY_HEALTH_OVERHEAT;
+		break;
+
+	case BAT_ERR_OVERVOLTAGE:
+		val->intval = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
+		break;
+
+	case BAT_ERR_INFOFAIL:
+	case BAT_ERR_OUT_OF_CONTROL:
+	case BAT_ERR_ID_FAIL:
+	case BAT_ERR_ACR_FAIL:
+		val->intval = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
+		break;
+
+	default:
+		/* Eep. We don't know this failure code */
+		ret = -EIO;
+	}
+
+	return ret;
+}
+
+static int olpc_bat_get_mfr(union power_supply_propval *val)
+{
+	uint8_t ec_byte;
+	int ret;
+
+	ec_byte = BAT_ADDR_MFR_TYPE;
+	ret = olpc_ec_cmd(EC_BAT_EEPROM, &ec_byte, 1, &ec_byte, 1);
+	if (ret)
+		return ret;
+
+	switch (ec_byte >> 4) {
+	case 1:
+		val->strval = "Gold Peak";
+		break;
+	case 2:
+		val->strval = "BYD";
+		break;
+	default:
+		val->strval = "Unknown";
+		break;
+	}
+
+	return ret;
+}
+
+static int olpc_bat_get_tech(union power_supply_propval *val)
+{
+	uint8_t ec_byte;
+	int ret;
+
+	ec_byte = BAT_ADDR_MFR_TYPE;
+	ret = olpc_ec_cmd(EC_BAT_EEPROM, &ec_byte, 1, &ec_byte, 1);
+	if (ret)
+		return ret;
+
+	switch (ec_byte & 0xf) {
+	case 1:
+		val->intval = POWER_SUPPLY_TECHNOLOGY_NiMH;
+		break;
+	case 2:
+		val->intval = POWER_SUPPLY_TECHNOLOGY_LiFe;
+		break;
+	default:
+		val->intval = POWER_SUPPLY_TECHNOLOGY_UNKNOWN;
+		break;
+	}
+
+	return ret;
+}
+
 /*********************************************************************
  *		Battery properties
  *********************************************************************/
@@ -113,25 +224,10 @@ static int olpc_bat_get_property(struct 
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
-		if (olpc_platform_info.ecver > 0x44) {
-			if (ec_byte & BAT_STAT_CHARGING)
-				val->intval = POWER_SUPPLY_STATUS_CHARGING;
-			else if (ec_byte & BAT_STAT_DISCHARGING)
-				val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
-			else if (ec_byte & BAT_STAT_FULL)
-				val->intval = POWER_SUPPLY_STATUS_FULL;
-			else /* er,... */
-				val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
-		} else {
-			/* Older EC didn't report charge/discharge bits */
-			if (!(ec_byte & BAT_STAT_AC)) /* No AC means discharging */
-				val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
-			else if (ec_byte & BAT_STAT_FULL)
-				val->intval = POWER_SUPPLY_STATUS_FULL;
-			else /* Not _necessarily_ true but EC doesn't tell all yet */
-				val->intval = POWER_SUPPLY_STATUS_CHARGING;
-			break;
-		}
+		ret = olpc_bat_get_status(val, ec_byte);
+		if (ret)
+			return ret;
+		break;
 	case POWER_SUPPLY_PROP_PRESENT:
 		val->intval = !!(ec_byte & BAT_STAT_PRESENT);
 		break;
@@ -140,72 +236,21 @@ static int olpc_bat_get_property(struct 
 		if (ec_byte & BAT_STAT_DESTROY)
 			val->intval = POWER_SUPPLY_HEALTH_DEAD;
 		else {
-			ret = olpc_ec_cmd(EC_BAT_ERRCODE, NULL, 0, &ec_byte, 1);
+			ret = olpc_bat_get_health(val);
 			if (ret)
 				return ret;
-
-			switch (ec_byte) {
-			case 0:
-				val->intval = POWER_SUPPLY_HEALTH_GOOD;
-				break;
-
-			case BAT_ERR_OVERTEMP:
-				val->intval = POWER_SUPPLY_HEALTH_OVERHEAT;
-				break;
-
-			case BAT_ERR_OVERVOLTAGE:
-				val->intval = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
-				break;
-
-			case BAT_ERR_INFOFAIL:
-			case BAT_ERR_OUT_OF_CONTROL:
-			case BAT_ERR_ID_FAIL:
-			case BAT_ERR_ACR_FAIL:
-				val->intval = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
-				break;
-
-			default:
-				/* Eep. We don't know this failure code */
-				return -EIO;
-			}
 		}
 		break;
 
 	case POWER_SUPPLY_PROP_MANUFACTURER:
-		ec_byte = BAT_ADDR_MFR_TYPE;
-		ret = olpc_ec_cmd(EC_BAT_EEPROM, &ec_byte, 1, &ec_byte, 1);
+		ret = olpc_bat_get_mfr(val);
 		if (ret)
 			return ret;
-
-		switch (ec_byte >> 4) {
-		case 1:
-			val->strval = "Gold Peak";
-			break;
-		case 2:
-			val->strval = "BYD";
-			break;
-		default:
-			val->strval = "Unknown";
-			break;
-		}
 		break;
 	case POWER_SUPPLY_PROP_TECHNOLOGY:
-		ec_byte = BAT_ADDR_MFR_TYPE;
-		ret = olpc_ec_cmd(EC_BAT_EEPROM, &ec_byte, 1, &ec_byte, 1);
+		ret = olpc_bat_get_tech(val);
 		if (ret)
 			return ret;
-
-		switch (ec_byte & 0xf) {
-		case 1:
-			val->intval = POWER_SUPPLY_TECHNOLOGY_NiMH;
-			break;
-		case 2:
-			val->intval = POWER_SUPPLY_TECHNOLOGY_LiFe;
-			break;
-		default:
-			val->intval = POWER_SUPPLY_TECHNOLOGY_UNKNOWN;
-			break;
-		}
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
 		ret = olpc_ec_cmd(EC_BAT_VOLTAGE, NULL, 0, (void *)&ec_word, 2);
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
x86-ioremap-ram-check-fix.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup.patch
power_supply-add-eeprom-dump-file-to-olpc_batterys-sysfs.patch
power_supply-cleanup-of-the-olpc-battery-driver.patch
power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery.patch

