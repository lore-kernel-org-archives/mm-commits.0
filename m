From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-l4f00242t03c-make-1-bit-signed-field-unsigned.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:03:30 -0800
Message-ID: <201101132006.p0DK6Btj029706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933606Ab1AMUGs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:06:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mk@lab.zgora.pl, rpurdie@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/video/backlight/l4f00242t03.c: make 1-bit signed field unsigned
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-l4f00242t03c-make-1-bit-signed-field-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/backlight/l4f00242t03.c: make 1-bit signed field unsigned
From: Mariusz Kozlowski <mk@lab.zgora.pl>

Fixes sparse warning:
drivers/video/backlight/l4f00242t03.c:28:21: error: dubious one-bit signed bitfield

Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
Acked-by: Richard Purdie <rpurdie@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/l4f00242t03.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/l4f00242t03.c~drivers-video-backlight-l4f00242t03c-make-1-bit-signed-field-unsigned drivers/video/backlight/l4f00242t03.c
--- a/drivers/video/backlight/l4f00242t03.c~drivers-video-backlight-l4f00242t03c-make-1-bit-signed-field-unsigned
+++ a/drivers/video/backlight/l4f00242t03.c
@@ -25,7 +25,7 @@
 struct l4f00242t03_priv {
 	struct spi_device	*spi;
 	struct lcd_device	*ld;
-	int lcd_on:1;
+	unsigned int lcd_on:1;
 	struct regulator *io_reg;
 	struct regulator *core_reg;
 };
_

Patches currently in -mm which might be from mk@lab.zgora.pl are

origin.patch

