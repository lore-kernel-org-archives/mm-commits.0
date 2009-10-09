From: akpm@linux-foundation.org
Subject: [merged] lis3lv02d_spi-module-unload-didnt-remove-sysfs-entry.patch removed from -mm tree
Date: Fri, 09 Oct 2009 15:05:22 -0700
Message-ID: <200910092205.n99M5MwV021309@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934680AbZJIWGR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 18:06:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samu.p.onkalo@nokia.com, daniel@caiaq.de, eric.piel@tremplin-utc.net, kalhan.trisal@intel.com, mm-commits@vger.kernel.org


The patch titled
     lis3lv02d_spi: module unload didn't remove sysfs entry
has been removed from the -mm tree.  Its filename was
     lis3lv02d_spi-module-unload-didnt-remove-sysfs-entry.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: lis3lv02d_spi: module unload didn't remove sysfs entry
=46rom: Samu Onkalo <samu.p.onkalo@nokia.com>

In module unload, lis3lv02d core driver sysfs clean up was not called.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Daniel Mack <daniel@caiaq.de>
Cc: =C9ric Piel <eric.piel@tremplin-utc.net>
Cc: "Trisal, Kalhan" <kalhan.trisal@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

origin.patch
lis3lv02d-axis-remap-and-resource-setup-release.patch
lis3lv02d-i2c-support.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
