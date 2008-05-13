From: akpm@linux-foundation.org
Subject: + power_supply-add-charge_counter-property-and-olpc_battery-support-for-it-fix.patch added to -mm tree
Date: Tue, 13 May 2008 13:27:44 -0700
Message-ID: <200805132027.m4DKRipI030517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758148AbYEMU26 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 16:28:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, cbouatmailru@gmail.com, dilinger@debian.org, richard@laptop.org


The patch titled
     power_supply: fix up CHARGE_COUNTER output to be more precise
has been added to the -mm tree.  Its filename is
     power_supply-add-charge_counter-property-and-olpc_battery-support-=
for-it-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: power_supply: fix up CHARGE_COUNTER output to be more precise
=46rom: Andres Salomon <dilinger@queued.net>

As Richard Smith pointed out, ACR * 6250 / 15 provides for less
precision loss than ACR * 4167 / 10, _and_ it doesn't overflow.  Switch
to using that equation for CHARGE_COUNTER.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: "Richard A. Smith" <richard@laptop.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/olpc_battery.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/power/olpc_battery.c~power_supply-add-charge_counter-=
property-and-olpc_battery-support-for-it-fix drivers/power/olpc_battery=
=2Ec
--- a/drivers/power/olpc_battery.c~power_supply-add-charge_counter-prop=
erty-and-olpc_battery-support-for-it-fix
+++ a/drivers/power/olpc_battery.c
@@ -19,7 +19,7 @@
=20
 #define EC_BAT_VOLTAGE	0x10	/* uint16_t,	*9.76/32,    mV   */
 #define EC_BAT_CURRENT	0x11	/* int16_t,	*15.625/120, mA   */
-#define EC_BAT_ACR	0x12	/* int16_t,	*416.7,      =C2=B5Ah  */
+#define EC_BAT_ACR	0x12	/* int16_t,	*6250/15,    =C2=B5Ah  */
 #define EC_BAT_TEMP	0x13	/* uint16_t,	*100/256,   =C2=B0C  */
 #define EC_AMB_TEMP	0x14	/* uint16_t,	*100/256,   =C2=B0C  */
 #define EC_BAT_STATUS	0x15	/* uint8_t,	bitmask */
@@ -295,7 +295,7 @@ static int olpc_bat_get_property(struct=20
 			return ret;
=20
 		ec_word =3D be16_to_cpu(ec_word);
-		val->intval =3D ec_word * 4167 / 10;
+		val->intval =3D ec_word * 6250 / 15;
 		break;
 	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
 		ret =3D olpc_ec_cmd(EC_BAT_SERIAL, NULL, 0, (void *)&ser_buf, 8);
_

Patches currently in -mm which might be from dilinger@queued.net are

git-input.patch
git-battery.patch
power_supply-add-charge_counter-property-and-olpc_battery-support-for-i=
t-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
