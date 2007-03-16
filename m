From: akpm@linux-foundation.org
Subject: + hwmon-w83793-kconfig-fix.patch added to -mm tree
Date: Thu, 15 Mar 2007 17:37:07 -0800
Message-ID: <200703160137.l2G1b7FH032157@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48521 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934008AbXCPBhn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 21:37:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefano.brivio@polimi.it, khali@linux-fr.org


The patch titled
     hwmon: Build fix for SENSORS_W83793
has been added to the -mm tree.  Its filename is
     hwmon-w83793-kconfig-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hwmon: Build fix for SENSORS_W83793
From: Stefano Brivio <stefano.brivio@polimi.it>

We need vid_which_vrm and vid_from_reg in the w83793 module.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/hwmon/Kconfig~hwmon-w83793-kconfig-fix drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~hwmon-w83793-kconfig-fix
+++ a/drivers/hwmon/Kconfig
@@ -527,6 +527,7 @@ config SENSORS_W83792D
 config SENSORS_W83793
 	tristate "Winbond W83793"
 	depends on HWMON && I2C && EXPERIMENTAL
+	select HWMON_VID
 	help
 	  If you say yes here you get support for the Winbond W83793
 	  hardware monitoring chip.
_

Patches currently in -mm which might be from stefano.brivio@polimi.it are

hwmon-w83793-kconfig-fix.patch
git-wireless.patch
