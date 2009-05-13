From: akpm@linux-foundation.org
Subject: [merged] fbdev-remove-outdated-advice-about-i2c-configuration.patch removed from -mm tree
Date: Wed, 13 May 2009 11:31:50 -0700
Message-ID: <200905131831.n4DIVoDC018592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753023AbZEMSe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 14:34:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fbdev: remove outdated advice about I2C configuration
has been removed from the -mm tree.  Its filename was
     fbdev-remove-outdated-advice-about-i2c-configuration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: remove outdated advice about I2C configuration
From: Jean Delvare <khali@linux-fr.org>

The required I2C modules are now selected automatically by the means
of select statements in Kconfig, so there is no point in confusing the
users with options he/she would be supposed to enable manually.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |   23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff -puN drivers/video/Kconfig~fbdev-remove-outdated-advice-about-i2c-configuration drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-remove-outdated-advice-about-i2c-configuration
+++ a/drivers/video/Kconfig
@@ -1128,13 +1128,6 @@ config FB_INTEL
           830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/965G/965GM chipsets.
           Say Y if you have and plan to use such a board.
 
-	  If you say Y here and want DDC/I2C support you must first say Y to
-	  "I2C support" and "I2C bit-banging support" in the character devices
-	  section.
-
-	  If you say M here then "I2C support" and "I2C bit-banging support"
-	  can be build either as modules or built-in.
-
 	  To compile this driver as a module, choose M here: the
 	  module will be called intelfb.
 
@@ -1207,11 +1200,10 @@ config FB_MATROX_G
 	  pixel and 32 bpp packed pixel. You can also use font widths
 	  different from 8.
 
-	  If you need support for G400 secondary head, you must first say Y to
-	  "I2C support" in the character devices section, and then to
-	  "Matrox I2C support" and "G400 second head support" here in the
-	  framebuffer section. G450/G550 secondary head and digital output
-	  are supported without additional modules.
+	  If you need support for G400 secondary head, you must say Y to
+	  "Matrox I2C support" and "G400 second head support" right below.
+	  G450/G550 secondary head and digital output are supported without
+	  additional modules.
 
 	  The driver starts in monitor mode. You must use the matroxset tool 
 	  (available at <ftp://platan.vc.cvut.cz/pub/linux/matrox-latest/>) to 
@@ -1310,13 +1302,6 @@ config FB_RADEON
 	  a framebuffer device.  There are both PCI and AGP versions.  You
 	  don't need to choose this to run the Radeon in plain VGA mode.
 
-	  If you say Y here and want DDC/I2C support you must first say Y to
-	  "I2C support" and "I2C bit-banging support" in the character devices
-	  section.
-
-	  If you say M here then "I2C support" and "I2C bit-banging support" 
-	  can be build either as modules or built-in.
