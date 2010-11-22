From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-l4f00242t03c-make-1-bit-signed-field-unsigned.patch added to -mm tree
Date: Mon, 22 Nov 2010 14:45:48 -0800
Message-ID: <201011222245.oAMMjmq5013532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757707Ab0KVWp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Nov 2010 17:45:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mk@lab.zgora.pl, rpurdie@linux.intel.com


The patch titled
     drivers/video/backlight/l4f00242t03.c: make 1-bit signed field unsigned
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-l4f00242t03c-make-1-bit-signed-field-unsigned.patch

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
Subject: drivers/video/backlight/l4f00242t03.c: make 1-bit signed field unsigned
From: Mariusz Kozlowski <mk@lab.zgora.pl>

Fixes sparse warning:
drivers/video/backlight/l4f00242t03.c:28:21: error: dubious one-bit
signed bitfield

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

drivers-video-backlight-l4f00242t03c-make-1-bit-signed-field-unsigned.patch

