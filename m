From: akpm@linux-foundation.org
Subject: [merged] video-backlight-adp8860-fix-ambient-light-zone-overwrite-handling.patch removed from -mm tree
Date: Tue, 16 Nov 2010 11:31:05 -0800
Message-ID: <201011161934.oAGJYHVV003190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756408Ab0KPTeu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 14:34:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, rpurdie@linux.intel.com, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     drivers/video/backlight/adp8860_bl.c: fix ambient light zone overwrite handling
has been removed from the -mm tree.  Its filename was
     video-backlight-adp8860-fix-ambient-light-zone-overwrite-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/backlight/adp8860_bl.c: fix ambient light zone overwrite handling
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
Acked-by: Richard Purdie <rpurdie@linux.intel.com>
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

linux-next.patch

