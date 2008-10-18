From: akpm@linux-foundation.org
Subject: - olpc-olpc_batteryc-sparse-endian-annotations.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:11:01 -0700
Message-ID: <200810182311.m9INB1nQ027645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751156AbYJRXLO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:11:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dilinger@queued.net, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     olpc: olpc_battery.c sparse endian annotations
has been removed from the -mm tree.  Its filename was
     olpc-olpc_batteryc-sparse-endian-annotations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: olpc: olpc_battery.c sparse endian annotations
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Andres Salomon <dilinger@queued.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/olpc_battery.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff -puN drivers/power/olpc_battery.c~olpc-olpc_batteryc-sparse-endian-annotations drivers/power/olpc_battery.c
--- a/drivers/power/olpc_battery.c~olpc-olpc_batteryc-sparse-endian-annotations
+++ a/drivers/power/olpc_battery.c
@@ -205,9 +205,9 @@ static int olpc_bat_get_property(struct 
 				 union power_supply_propval *val)
 {
 	int ret = 0;
-	int16_t ec_word;
+	__be16 ec_word;
 	uint8_t ec_byte;
-	uint64_t ser_buf;
+	__be64 ser_buf;
 
 	ret = olpc_ec_cmd(EC_BAT_STATUS, NULL, 0, &ec_byte, 1);
 	if (ret)
@@ -257,16 +257,14 @@ static int olpc_bat_get_property(struct 
 		if (ret)
 			return ret;
 
-		ec_word = be16_to_cpu(ec_word);
-		val->intval = ec_word * 9760L / 32;
+		val->intval = (int)be16_to_cpu(ec_word) * 9760L / 32;
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_AVG:
 		ret = olpc_ec_cmd(EC_BAT_CURRENT, NULL, 0, (void *)&ec_word, 2);
 		if (ret)
 			return ret;
 
-		ec_word = be16_to_cpu(ec_word);
-		val->intval = ec_word * 15625L / 120;
+		val->intval = (int)be16_to_cpu(ec_word) * 15625L / 120;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
 		ret = olpc_ec_cmd(EC_BAT_SOC, NULL, 0, &ec_byte, 1);
@@ -278,24 +276,22 @@ static int olpc_bat_get_property(struct 
 		ret = olpc_ec_cmd(EC_BAT_TEMP, NULL, 0, (void *)&ec_word, 2);
 		if (ret)
 			return ret;
-		ec_word = be16_to_cpu(ec_word);
-		val->intval = ec_word * 100 / 256;
+
+		val->intval = (int)be16_to_cpu(ec_word) * 100 / 256;
 		break;
 	case POWER_SUPPLY_PROP_TEMP_AMBIENT:
 		ret = olpc_ec_cmd(EC_AMB_TEMP, NULL, 0, (void *)&ec_word, 2);
 		if (ret)
 			return ret;
 
-		ec_word = be16_to_cpu(ec_word);
-		val->intval = ec_word * 100 / 256;
+		val->intval = (int)be16_to_cpu(ec_word) * 100 / 256;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_COUNTER:
 		ret = olpc_ec_cmd(EC_BAT_ACR, NULL, 0, (void *)&ec_word, 2);
 		if (ret)
 			return ret;
 
-		ec_word = be16_to_cpu(ec_word);
-		val->intval = ec_word * 6250 / 15;
+		val->intval = (int)be16_to_cpu(ec_word) * 6250 / 15;
 		break;
 	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
 		ret = olpc_ec_cmd(EC_BAT_SERIAL, NULL, 0, (void *)&ser_buf, 8);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
byteorder-add-new-headers-for-make-headers-install.patch
byteorder-use-generic-c-version-for-value-byteswapping.patch
byteorder-provide-swabbh-generically-in-asm-byteorderh.patch
byteorder-remove-direct-includes-of-linux-byteorder-swabh.patch

