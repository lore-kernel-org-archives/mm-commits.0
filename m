From: akpm@linux-foundation.org
Subject: - backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update.patch removed from -mm tree
Date: Fri, 22 Aug 2008 13:32:12 -0700
Message-ID: <200808222032.m7MKWCHx015178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751593AbYHVUdI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 16:33:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: private@claudio.ch, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc update
has been removed from the -mm tree.  Its filename was
     backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update.patch

This patch was dropped because it was folded into backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc update
From: Claudio Nieder <private@claudio.ch>

Hi,

> I believe the mdelay()s could be converted to the preferable msleep()?

thank you for the remark. I have changed the mdelay to msleep in my
patch, reapplied it to the current Linus tree, built a kernel, installed
it on my computer and tested it. It works perfectly as you surely
expected. The corrected patch is included here.

BTW: I have noticed that some other drivers in video/backlight still use
mdelay: ili9320.c, locomolcd.c and vgg2432a4.c.

Signed-off-by: Claudio Nieder <private@claudio.ch>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/kb3886_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/kb3886_bl.c~backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update drivers/video/backlight/kb3886_bl.c
--- a/drivers/video/backlight/kb3886_bl.c~backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update
+++ a/drivers/video/backlight/kb3886_bl.c
@@ -40,9 +40,9 @@ void kb3886_bl_set_intensity(int intensi
 	mutex_lock(&bl_mutex);
 	intensity = intensity&0xff;
 	outb(KB3886_ADC_DAC_PWM, KB3886_PARENT);
-	mdelay(10);
+	msleep(10);
 	outb(KB3886_PWM0_WRITE, KB3886_IO);
-	mdelay(10);
+	msleep(10);
 	outb(intensity, KB3886_IO);
 	mutex_unlock(&bl_mutex);
 }
_

Patches currently in -mm which might be from private@claudio.ch are

backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-checkpatch-fixes.patch

