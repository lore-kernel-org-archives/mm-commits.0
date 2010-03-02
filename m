From: akpm@linux-foundation.org
Subject: + acpi-put-acpi_battery_get-set_alarm-into-config_acpi_sysfs_power.patch added to -mm tree
Date: Tue, 02 Mar 2010 15:13:17 -0800
Message-ID: <201003022313.o22NDH6u003035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752312Ab0CBXOK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 18:14:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, lenb@kernel.org


The patch titled
     acpi: put acpi_battery_get/set_alarm into  CONFIG_ACPI_SYSFS_POWER
has been added to the -mm tree.  Its filename is
     acpi-put-acpi_battery_get-set_alarm-into-config_acpi_sysfs_power.p=
atch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: acpi: put acpi_battery_get/set_alarm into  CONFIG_ACPI_SYSFS_P=
OWER
=46rom: Rakib Mullick <rakib.mullick@gmail.com>

acpi_battery_get/set_alarm is only used when CONFIG_ACPI_SYSFS_POWER=3D=
y.=20
So put this two functions under CONFIG_ACPI_SYSFS_POWER by shifting it
upward.

We were warned by the following warnings:

drivers/acpi/sbs.c:399: warning: =91acpi_battery_get_alarm=92 defined b=
ut not used
drivers/acpi/sbs.c:406: warning: =91acpi_battery_set_alarm=92 defined b=
ut not used

Also fixes a checkpatch warning in acpi_ac_get_present.

ERROR: space prohibited after that '&' (ctx:WxW)
#13: FILE: drivers/acpi/sbs.c:405:
+				 0x13, (u8 *) & status);
 				              ^

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sbs.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff -puN drivers/acpi/sbs.c~acpi-put-acpi_battery_get-set_alarm-into-c=
onfig_acpi_sysfs_power drivers/acpi/sbs.c
--- a/drivers/acpi/sbs.c~acpi-put-acpi_battery_get-set_alarm-into-confi=
g_acpi_sysfs_power
+++ a/drivers/acpi/sbs.c
@@ -400,6 +400,20 @@ static int acpi_battery_get_state(struct
 	return result;
 }
=20
+static int acpi_ac_get_present(struct acpi_sbs *sbs)
+{
+	int result;
+	u16 status;
+
+	result =3D acpi_smbus_read(sbs->hc, SMBUS_READ_WORD, ACPI_SBS_CHARGER=
,
+				 0x13, (u8 *) &status);
+	if (!result)
+		sbs->charger_present =3D (status >> 15) & 0x1;
+	return result;
+}
+
+#ifdef CONFIG_ACPI_SYSFS_POWER
+
 static int acpi_battery_get_alarm(struct acpi_battery *battery)
 {
 	return acpi_smbus_read(battery->sbs->hc, SMBUS_READ_WORD,
@@ -436,19 +450,6 @@ static int acpi_battery_set_alarm(struct
 	return ret;
 }
=20
-static int acpi_ac_get_present(struct acpi_sbs *sbs)
-{
-	int result;
-	u16 status;
-
-	result =3D acpi_smbus_read(sbs->hc, SMBUS_READ_WORD, ACPI_SBS_CHARGER=
,
-				 0x13, (u8 *) & status);
-	if (!result)
-		sbs->charger_present =3D (status >> 15) & 0x1;
-	return result;
-}
