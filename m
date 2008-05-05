From: akpm@linux-foundation.org
Subject: - power_supply-support-serial-number-and-acr-in-olpc_battery.patch removed from -mm tree
Date: Mon, 05 May 2008 12:16:54 -0700
Message-ID: <200805051916.m45JGsWG000340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761016AbYEETRI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 15:17:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwmw2@infradead.org, cbou@mail.ru, dilinger@debian.org, mm-commits@vger.kernel.org


The patch titled
     power_supply: support serial number and ACR in olpc_battery
has been removed from the -mm tree.  Its filename was
     power_supply-support-serial-number-and-acr-in-olpc_battery.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: power_supply: support serial number and ACR in olpc_battery
=46rom: David Woodhouse <dwmw2@infradead.org>

This adds serial number and accumulated current support to the OLPC bat=
tery
driver.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Anton Vorontsov <cbou@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/olpc_battery.c       |   23 ++++++++++++++++++++++-
 drivers/power/power_supply_sysfs.c |    1 +
 include/linux/power_supply.h       |    1 +
 3 files changed, 24 insertions(+), 1 deletion(-)

diff -puN drivers/power/olpc_battery.c~power_supply-support-serial-numb=
er-and-acr-in-olpc_battery drivers/power/olpc_battery.c
--- a/drivers/power/olpc_battery.c~power_supply-support-serial-number-a=
nd-acr-in-olpc_battery
+++ a/drivers/power/olpc_battery.c
@@ -19,7 +19,7 @@
=20
 #define EC_BAT_VOLTAGE	0x10	/* uint16_t,	*9.76/32,    mV   */
 #define EC_BAT_CURRENT	0x11	/* int16_t,	*15.625/120, mA   */
-#define EC_BAT_ACR	0x12
+#define EC_BAT_ACR	0x12	/* int16_t,	*416.667,    =C2=B5Ah  */
 #define EC_BAT_TEMP	0x13	/* uint16_t,	*100/256,   =C2=B0C  */
 #define EC_AMB_TEMP	0x14	/* uint16_t,	*100/256,   =C2=B0C  */
 #define EC_BAT_STATUS	0x15	/* uint8_t,	bitmask */
@@ -84,6 +84,8 @@ static struct power_supply olpc_ac =3D {
 	.get_property =3D olpc_ac_get_prop,
 };
=20
+static char bat_serial[17]; /* Ick */
+
 /*********************************************************************
  *		Battery properties
  *********************************************************************=
/
@@ -94,6 +96,7 @@ static int olpc_bat_get_property(struct=20
 	int ret =3D 0;
 	int16_t ec_word;
 	uint8_t ec_byte;
+	uint64_t ser_buf;
=20
 	ret =3D olpc_ec_cmd(EC_BAT_STATUS, NULL, 0, &ec_byte, 1);
 	if (ret)
@@ -241,6 +244,22 @@ static int olpc_bat_get_property(struct=20
 		ec_word =3D be16_to_cpu(ec_word);
 		val->intval =3D ec_word * 100 / 256;
 		break;
+	case POWER_SUPPLY_PROP_ACCUM_CURRENT:
+		ret =3D olpc_ec_cmd(EC_BAT_ACR, NULL, 0, (void *)&ec_word, 2);
+		if (ret)
+			return ret;
+
+		ec_word =3D be16_to_cpu(ec_word);
+		val->intval =3D ec_word;
+		break;
+	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
+		ret =3D olpc_ec_cmd(EC_BAT_SERIAL, NULL, 0, (void *)&ser_buf, 8);
+		if (ret)
+			return ret;
+
+		sprintf(bat_serial, "%016llx", (long long)be64_to_cpu(ser_buf));
+		val->strval =3D bat_serial;
+		break;
 	default:
 		ret =3D -EINVAL;
 		break;
@@ -259,7 +278,9 @@ static enum power_supply_property olpc_b
 	POWER_SUPPLY_PROP_CAPACITY,
 	POWER_SUPPLY_PROP_TEMP,
 	POWER_SUPPLY_PROP_TEMP_AMBIENT,
+	POWER_SUPPLY_PROP_ACCUM_CURRENT,
 	POWER_SUPPLY_PROP_MANUFACTURER,
+	POWER_SUPPLY_PROP_SERIAL_NUMBER,
 };
=20
 /*********************************************************************
diff -puN drivers/power/power_supply_sysfs.c~power_supply-support-seria=
l-number-and-acr-in-olpc_battery drivers/power/power_supply_sysfs.c
--- a/drivers/power/power_supply_sysfs.c~power_supply-support-serial-nu=
mber-and-acr-in-olpc_battery
+++ a/drivers/power/power_supply_sysfs.c
@@ -112,6 +112,7 @@ static struct device_attribute power_sup
 	POWER_SUPPLY_ATTR(time_to_empty_avg),
 	POWER_SUPPLY_ATTR(time_to_full_now),
 	POWER_SUPPLY_ATTR(time_to_full_avg),
+	POWER_SUPPLY_ATTR(accum_current),
 	/* Properties of type `const char *' */
 	POWER_SUPPLY_ATTR(model_name),
 	POWER_SUPPLY_ATTR(manufacturer),
diff -puN include/linux/power_supply.h~power_supply-support-serial-numb=
er-and-acr-in-olpc_battery include/linux/power_supply.h
--- a/include/linux/power_supply.h~power_supply-support-serial-number-a=
nd-acr-in-olpc_battery
+++ a/include/linux/power_supply.h
@@ -91,6 +91,7 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
 	POWER_SUPPLY_PROP_TIME_TO_FULL_NOW,
 	POWER_SUPPLY_PROP_TIME_TO_FULL_AVG,
+	POWER_SUPPLY_PROP_ACCUM_CURRENT,
 	/* Properties of type `const char *' */
 	POWER_SUPPLY_PROP_MODEL_NAME,
 	POWER_SUPPLY_PROP_MANUFACTURER,
_

Patches currently in -mm which might be from dwmw2@infradead.org are

jffs2-summary-allocation-dont-use-vmalloc.patch
git-battery.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
