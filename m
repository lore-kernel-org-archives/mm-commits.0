From: akpm@linux-foundation.org
Subject: + fbdev-remove-outdated-advice-about-i2c-configuration.patch added to -mm tree
Date: Fri, 08 May 2009 13:59:13 -0700
Message-ID: <200905082059.n48KxDEg022136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754285AbZEHVBC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 May 2009 17:01:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, krzysztof.h1@poczta.fm


The patch titled
     fbdev: remove outdated advice about I2C configuration
has been added to the -mm tree.  Its filename is
     fbdev-remove-outdated-advice-about-i2c-configuration.patch

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
