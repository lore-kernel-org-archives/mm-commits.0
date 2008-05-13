From: akpm@linux-foundation.org
Subject: - power_supply-add-charge_counter-property-and-olpc_battery-support-for-it.patch removed from -mm tree
Date: Tue, 13 May 2008 14:34:56 -0700
Message-ID: <200805132134.m4DLYuCk000969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759518AbYEMVfI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:35:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@debian.org, cbouatmailru@gmail.com, richard@laptop.org, mm-commits@vger.kernel.org


The patch titled
     power_supply: add CHARGE_COUNTER property and olpc_battery support=
 for it
has been removed from the -mm tree.  Its filename was
     power_supply-add-charge_counter-property-and-olpc_battery-support-=
for-it.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: power_supply: add CHARGE_COUNTER property and olpc_battery sup=
port for it
=46rom: Andres Salomon <dilinger@debian.org>

This adds PROP_CHARGE_COUNTER to the power supply class (documenting it=
 as
well).  The OLPC battery driver uses this for spitting out its ACR valu=
es
(in uAh).  We have some rounding errors (the data sheet claims 416.7, t=
he
math actually works out to 416.666667, so we're forced to choose betwee=
n
overflows or precision loss.  I chose precision loss, and stuck w/ data
sheet values), but I don't think anyone will care that much.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: "Richard A. Smith" <richard@laptop.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/power/power_supply_class.txt |    4 ++++
 drivers/power/olpc_battery.c               |   11 ++++++++++-
 drivers/power/power_supply_sysfs.c         |    1 +
 include/linux/power_supply.h               |    1 +
 4 files changed, 16 insertions(+), 1 deletion(-)

diff -puN Documentation/power/power_supply_class.txt~power_supply-add-c=
harge_counter-property-and-olpc_battery-support-for-it Documentation/po=
wer/power_supply_class.txt
--- a/Documentation/power/power_supply_class.txt~power_supply-add-charg=
e_counter-property-and-olpc_battery-support-for-it
+++ a/Documentation/power/power_supply_class.txt
@@ -101,6 +101,10 @@ of charge when battery became full/empty
 charge when battery considered full/empty at given conditions (tempera=
ture,
 age)". I.e. these attributes represents real thresholds, not design va=
lues.
=20
+CHARGE_COUNTER - the current charge counter (in =C2=B5Ah).  This could=
 easily
+be negative; there is no empty or full value.  It is only useful for
+relative, time-based measurements.
+
 ENERGY_FULL, ENERGY_EMPTY - same as above but for energy.
=20
 CAPACITY - capacity in percents.
diff -puN drivers/power/olpc_battery.c~power_supply-add-charge_counter-=
property-and-olpc_battery-support-for-it drivers/power/olpc_battery.c
--- a/drivers/power/olpc_battery.c~power_supply-add-charge_counter-prop=
erty-and-olpc_battery-support-for-it
+++ a/drivers/power/olpc_battery.c
@@ -19,7 +19,7 @@
=20
 #define EC_BAT_VOLTAGE	0x10	/* uint16_t,	*9.76/32,    mV   */
 #define EC_BAT_CURRENT	0x11	/* int16_t,	*15.625/120, mA   */
-#define EC_BAT_ACR	0x12
+#define EC_BAT_ACR	0x12	/* int16_t,	*416.7,      =C2=B5Ah  */
 #define EC_BAT_TEMP	0x13	/* uint16_t,	*100/256,   =C2=B0C  */
 #define EC_AMB_TEMP	0x14	/* uint16_t,	*100/256,   =C2=B0C  */
 #define EC_BAT_STATUS	0x15	/* uint8_t,	bitmask */
@@ -289,6 +289,14 @@ static int olpc_bat_get_property(struct=20
 		ec_word =3D be16_to_cpu(ec_word);
 		val->intval =3D ec_word * 100 / 256;
 		break;
+	case POWER_SUPPLY_PROP_CHARGE_COUNTER:
+		ret =3D olpc_ec_cmd(EC_BAT_ACR, NULL, 0, (void *)&ec_word, 2);
+		if (ret)
+			return ret;
+
+		ec_word =3D be16_to_cpu(ec_word);
+		val->intval =3D ec_word * 4167 / 10;
+		break;
 	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
 		ret =3D olpc_ec_cmd(EC_BAT_SERIAL, NULL, 0, (void *)&ser_buf, 8);
 		if (ret)
@@ -317,6 +325,7 @@ static enum power_supply_property olpc_b
 	POWER_SUPPLY_PROP_TEMP_AMBIENT,
 	POWER_SUPPLY_PROP_MANUFACTURER,
 	POWER_SUPPLY_PROP_SERIAL_NUMBER,
+	POWER_SUPPLY_PROP_CHARGE_COUNTER,
 };
=20
 /* EEPROM reading goes completely around the power_supply API, sadly *=
/
diff -puN drivers/power/power_supply_sysfs.c~power_supply-add-charge_co=
unter-property-and-olpc_battery-support-for-it drivers/power/power_supp=
ly_sysfs.c
--- a/drivers/power/power_supply_sysfs.c~power_supply-add-charge_counte=
r-property-and-olpc_battery-support-for-it
+++ a/drivers/power/power_supply_sysfs.c
@@ -99,6 +99,7 @@ static struct device_attribute power_sup
 	POWER_SUPPLY_ATTR(charge_empty),
 	POWER_SUPPLY_ATTR(charge_now),
 	POWER_SUPPLY_ATTR(charge_avg),
+	POWER_SUPPLY_ATTR(charge_counter),
 	POWER_SUPPLY_ATTR(energy_full_design),
 	POWER_SUPPLY_ATTR(energy_empty_design),
 	POWER_SUPPLY_ATTR(energy_full),
diff -puN include/linux/power_supply.h~power_supply-add-charge_counter-=
property-and-olpc_battery-support-for-it include/linux/power_supply.h
--- a/include/linux/power_supply.h~power_supply-add-charge_counter-prop=
erty-and-olpc_battery-support-for-it
+++ a/include/linux/power_supply.h
@@ -78,6 +78,7 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_CHARGE_EMPTY,
 	POWER_SUPPLY_PROP_CHARGE_NOW,
 	POWER_SUPPLY_PROP_CHARGE_AVG,
+	POWER_SUPPLY_PROP_CHARGE_COUNTER,
 	POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN,
 	POWER_SUPPLY_PROP_ENERGY_EMPTY_DESIGN,
 	POWER_SUPPLY_PROP_ENERGY_FULL,
_

Patches currently in -mm which might be from dilinger@debian.org are

fix-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch
git-input.patch
git-battery.patch
power_supply-add-charge_counter-property-and-olpc_battery-support-for-i=
t-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
