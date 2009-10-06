From: akpm@linux-foundation.org
Subject: + lis3lv02d_spi-module-unload-didnt-remove-sysfs-entry.patch added to -mm tree
Date: Tue, 06 Oct 2009 14:45:50 -0700
Message-ID: <200910062145.n96Ljoof026390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933241AbZJFVql (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 17:46:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samu.p.onkalo@nokia.com, daniel@caiaq.de, eric.piel@tremplin-utc.net


The patch titled
     lis3lv02d_spi: module unload didn't remove sysfs entry
has been added to the -mm tree.  Its filename is
     lis3lv02d_spi-module-unload-didnt-remove-sysfs-entry.patch

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
Subject: lis3lv02d_spi: module unload didn't remove sysfs entry
=46rom: Samu Onkalo <samu.p.onkalo@nokia.com>

In module unload, lis3lv02d core driver sysfs clean up was not called.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Daniel Mack <daniel@caiaq.de>
Cc: =C9ric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d_spi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/hwmon/lis3lv02d_spi.c~lis3lv02d_spi-module-unload-did=
nt-remove-sysfs-entry drivers/hwmon/lis3lv02d_spi.c
--- a/drivers/hwmon/lis3lv02d_spi.c~lis3lv02d_spi-module-unload-didnt-r=
emove-sysfs-entry
+++ a/drivers/hwmon/lis3lv02d_spi.c
@@ -83,7 +83,8 @@ static int __devexit lis302dl_spi_remove
 	struct lis3lv02d *lis3 =3D spi_get_drvdata(spi);
 	lis3lv02d_joystick_disable();
 	lis3lv02d_poweroff(lis3);
-	return 0;
+
+	return lis3lv02d_remove_fs(&lis3_dev);
 }
=20
 #ifdef CONFIG_PM
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com ar=
e

lis3lv02d_spi-module-unload-didnt-remove-sysfs-entry.patch
lis3lv02d-axis-remap-and-resource-setup-release.patch
lis3lv02d-i2c-support.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
