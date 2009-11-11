From: akpm@linux-foundation.org
Subject: + acerhdf-return-temperature-in-milidegree-instead-of-degree.patch added to -mm tree
Date: Wed, 11 Nov 2009 15:27:55 -0800
Message-ID: <200911112327.nABNRt3S026985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759611AbZKKX23 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Nov 2009 18:28:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter@piie.net, andi@lisas.de, lenb@kernel.org, petkovbb@gmail.com


The patch titled
     acerhdf: return temperature in milidegree instead of degree
has been added to the -mm tree.  Its filename is
     acerhdf-return-temperature-in-milidegree-instead-of-degree.patch

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
Subject: acerhdf: return temperature in milidegree instead of degree
=46rom: Peter Feuerer <peter@piie.net>

Return temperature in milidegree instead of degree, as sysfs-api requir=
es
the temperature in milidegree.

Signed-off-by: Peter Feuerer <peter@piie.net>
Tested-by: Borislav Petkov <petkovbb@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/acerhdf.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/platform/x86/acerhdf.c~acerhdf-return-temperature-in-=
milidegree-instead-of-degree drivers/platform/x86/acerhdf.c
--- a/drivers/platform/x86/acerhdf.c~acerhdf-return-temperature-in-mili=
degree-instead-of-degree
+++ a/drivers/platform/x86/acerhdf.c
@@ -52,7 +52,7 @@
  */
 #undef START_IN_KERNEL_MODE
=20
-#define DRV_VER "0.5.17"
+#define DRV_VER "0.5.18"
=20
 /*
  * According to the Atom N270 datasheet,
@@ -61,7 +61,7 @@
  * measured by the on-die thermal monitor are within 0 <=3D Tj <=3D 90=
=2E So,
  * assume 89=C2=B0C is critical temperature.
  */
-#define ACERHDF_TEMP_CRIT 89
+#define ACERHDF_TEMP_CRIT 89000
 #define ACERHDF_FAN_OFF 0
 #define ACERHDF_FAN_AUTO 1
=20
@@ -69,7 +69,7 @@
  * No matter what value the user puts into the fanon variable, turn on=
 the fan
  * at 80 degree Celsius to prevent hardware damage
  */
-#define ACERHDF_MAX_FANON 80
+#define ACERHDF_MAX_FANON 80000
=20
 /*
  * Maximum interval between two temperature checks is 15 seconds, as t=
he die
@@ -85,8 +85,8 @@ static int kernelmode;
 #endif
=20
 static unsigned int interval =3D 10;
-static unsigned int fanon =3D 63;
-static unsigned int fanoff =3D 58;
+static unsigned int fanon =3D 63000;
+static unsigned int fanoff =3D 58000;
 static unsigned int verbose;
 static unsigned int fanstate =3D ACERHDF_FAN_AUTO;
 static char force_bios[16];
@@ -171,7 +171,7 @@ static int acerhdf_get_temp(int *temp)
 	if (ec_read(bios_cfg->tempreg, &read_temp))
 		return -EINVAL;
=20
-	*temp =3D read_temp;
+	*temp =3D read_temp * 1000;
=20
 	return 0;
 }
_

Patches currently in -mm which might be from peter@piie.net are

acerhdf-return-temperature-in-milidegree-instead-of-degree.patch
acerhdf-added-new-bios-versions.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
