From: akpm@linux-foundation.org
Subject: + rivafb-fix-i2c-getscl-callback-function.patch added to -mm tree
Date: Wed, 09 May 2007 21:37:36 -0700
Message-ID: <200705100437.l4A4baxs012121@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754859AbXEJEiG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 00:38:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, adaplas@gmail.com


The patch titled
     rivafb: Fix I2C getscl callback function
has been added to the -mm tree.  Its filename is
     rivafb-fix-i2c-getscl-callback-function.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rivafb: Fix I2C getscl callback function
From: Jean Delvare <khali@linux-fr.org>

Fix rivafb's I2C getscl callback function, as was done in nvidiafb recently.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/riva/rivafb-i2c.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/video/riva/rivafb-i2c.c~rivafb-fix-i2c-getscl-callback-function drivers/video/riva/rivafb-i2c.c
--- a/drivers/video/riva/rivafb-i2c.c~rivafb-fix-i2c-getscl-callback-function
+++ a/drivers/video/riva/rivafb-i2c.c
@@ -70,8 +70,6 @@ static int riva_gpio_getscl(void* data)
 	if (VGA_RD08(par->riva.PCIO, 0x3d5) & 0x04)
 		val = 1;
 
-	val = VGA_RD08(par->riva.PCIO, 0x3d5);
-
 	return val;
 }
 
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
fix-i2c-pxa-build.patch
git-alsa.patch
git-dvb.patch
fix-jdelvare-i2c-i2c-at91-support-new-style-binding.patch
rivafb-fix-i2c-getscl-callback-function.patch
nvidiafb-enable-debugging-messages-a-kconfig-option.patch
