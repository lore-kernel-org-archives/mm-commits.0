From: akpm@linux-foundation.org
Subject: + lm85-fix-the-version-check-that-broke-adt7468-probing.patch added to -mm tree
Date: Mon, 02 Mar 2009 15:06:40 -0800
Message-ID: <200903022306.n22N6eXs032166@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758495AbZCBXLm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 18:11:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, khali@linux-fr.org


The patch titled
     lm85: fix the version check that broke adt7468 probing
has been added to the -mm tree.  Its filename is
     lm85-fix-the-version-check-that-broke-adt7468-probing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lm85: fix the version check that broke adt7468 probing
From: "Darrick J. Wong" <djwong@us.ibm.com>

The verstep check in the lm85 driver fails because the upper nibble of the
version register is 0x7, not 0x6, on the adt7468 chip.  Probing of all
adt7468s was broken by 69fc1feba2d5856ff74dedb6ae9d8c490210825c, and this
patch fixes that.  Also add in a missing i2c_device_id that accidentally
got dropped from the original patch.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lm85.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/hwmon/lm85.c~lm85-fix-the-version-check-that-broke-adt7468-probing drivers/hwmon/lm85.c
--- a/drivers/hwmon/lm85.c~lm85-fix-the-version-check-that-broke-adt7468-probing
+++ a/drivers/hwmon/lm85.c
@@ -72,6 +72,7 @@ I2C_CLIENT_INSMOD_7(lm85b, lm85c, adm102
 #define	LM85_COMPANY_SMSC		0x5c
 #define	LM85_VERSTEP_VMASK              0xf0
 #define	LM85_VERSTEP_GENERIC		0x60
+#define	LM85_VERSTEP_GENERIC2		0x70
 #define	LM85_VERSTEP_LM85C		0x60
 #define	LM85_VERSTEP_LM85B		0x62
 #define	LM85_VERSTEP_ADM1027		0x60
@@ -334,6 +335,7 @@ static struct lm85_data *lm85_update_dev
 static const struct i2c_device_id lm85_id[] = {
 	{ "adm1027", adm1027 },
 	{ "adt7463", adt7463 },
+	{ "adt7468", adt7468 },
 	{ "lm85", any_chip },
 	{ "lm85b", lm85b },
 	{ "lm85c", lm85c },
@@ -1153,7 +1155,8 @@ static int lm85_detect(struct i2c_client
 			address, company, verstep);
 
 		/* All supported chips have the version in common */
-		if ((verstep & LM85_VERSTEP_VMASK) != LM85_VERSTEP_GENERIC) {
+		if ((verstep & LM85_VERSTEP_VMASK) != LM85_VERSTEP_GENERIC &&
+		    (verstep & LM85_VERSTEP_VMASK) != LM85_VERSTEP_GENERIC2) {
 			dev_dbg(&adapter->dev, "Autodetection failed: "
 				"unsupported version\n");
 			return -ENODEV;
_

Patches currently in -mm which might be from djwong@us.ibm.com are

lm90-support-the-max6648-6692-chips.patch
lm90-support-the-max6648-6692-chips-fix.patch
lm85-fix-the-version-check-that-broke-adt7468-probing.patch
lm85-add-vrm10-support-for-adt7468-chip.patch

