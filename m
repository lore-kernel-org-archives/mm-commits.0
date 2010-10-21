From: akpm@linux-foundation.org
Subject: + video-backlight-adp8860-fix-ambient-light-zone-overwrite-handling.patch added to -mm tree
Date: Thu, 21 Oct 2010 13:18:49 -0700
Message-ID: <201010212018.o9LKInvj001216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755482Ab0JUUTU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 16:19:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, rpurdie@rpsys.net, vapier@gentoo.org


The patch titled
     video: backlight: adp8860: fix ambient light zone overwrite handling
has been added to the -mm tree.  Its filename is
     video-backlight-adp8860-fix-ambient-light-zone-overwrite-handling.patch

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
Subject: video: backlight: adp8860: fix ambient light zone overwrite handling
From: Michael Hennerich <michael.hennerich@analog.com>

This affects the get/set of the current Ambient Light Zone.  Reading
should return an integer between 1..3 (1 = Daylight, 2 = office, 3 =
dark).  Writing a value between 1..3 forces the backlight controller to
enter the corresponding Ambient Light Zone.  Writing 0 returns to normal
operation.

Fix valid range checking so we don't write invalid values to the
controller, and make sure we subtract 1, since this is what the register
definition (CFGR:BLV) requires.  Otherwise the values written don't work
correctly.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp8860_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/adp8860_bl.c~video-backlight-adp8860-fix-ambient-light-zone-overwrite-handling drivers/video/backlight/adp8860_bl.c
--- a/drivers/video/backlight/adp8860_bl.c~video-backlight-adp8860-fix-ambient-light-zone-overwrite-handling
+++ a/drivers/video/backlight/adp8860_bl.c
@@ -614,7 +614,7 @@ static ssize_t adp8860_bl_ambient_light_
 	if (val == 0) {
 		/* Enable automatic ambient light sensing */
 		adp8860_set_bits(data->client, ADP8860_MDCR, CMP_AUTOEN);
-	} else if ((val > 0) && (val < 6)) {
+	} else if ((val > 0) && (val <= 3)) {
 		/* Disable automatic ambient light sensing */
 		adp8860_clr_bits(data->client, ADP8860_MDCR, CMP_AUTOEN);
 
@@ -622,7 +622,7 @@ static ssize_t adp8860_bl_ambient_light_
 		mutex_lock(&data->lock);
 		adp8860_read(data->client, ADP8860_CFGR, &reg_val);
 		reg_val &= ~(CFGR_BLV_MASK << CFGR_BLV_SHIFT);
-		reg_val |= val << CFGR_BLV_SHIFT;
+		reg_val |= (val - 1) << CFGR_BLV_SHIFT;
 		adp8860_write(data->client, ADP8860_CFGR, reg_val);
 		mutex_unlock(&data->lock);
 	}
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

drivers-misc-ad525x_dpot-fix-typo-in-spi-write16-and-write24-transfer-counts.patch
linux-next.patch
video-backlight-adp8860-fix-ambient-light-zone-overwrite-handling.patch
drivers-misc-ad525x_dpot-fix-part-name-typos-in-defines.patch
drivers-misc-ad525x_dpot-new-features.patch
misc-devices-do-not-enable-by-default.patch
gpio-adp5588-gpio-support-interrupt-controller.patch
gpio-adp5588-gpio-support-interrupt-controller-update.patch
gpio-adp5588-gpio-gpio_start-must-be-signed.patch

