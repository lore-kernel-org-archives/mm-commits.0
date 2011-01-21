From: akpm@linux-foundation.org
Subject: [merged] backlight-fix-88pm860x_bl-macro-collision.patch removed from -mm tree
Date: Fri, 21 Jan 2011 12:31:58 -0800
Message-ID: <201101212031.p0LKVwPI031662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751577Ab1AUUmU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Jan 2011 15:42:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, haojian.zhuang@marvell.com, rpurdie@rpsys.net, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     backlight: fix 88pm860x_bl macro collision
has been removed from the -mm tree.  Its filename was
     backlight-fix-88pm860x_bl-macro-collision.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight: fix 88pm860x_bl macro collision
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix collision with kernel-supplied #define:

drivers/video/backlight/88pm860x_bl.c:24:1: warning: "CURRENT_MASK" redefined
arch/x86/include/asm/page_64_types.h:6:1: warning: this is the location of the previous definition

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/88pm860x_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/88pm860x_bl.c~backlight-fix-88pm860x_bl-macro-collision drivers/video/backlight/88pm860x_bl.c
--- a/drivers/video/backlight/88pm860x_bl.c~backlight-fix-88pm860x_bl-macro-collision
+++ a/drivers/video/backlight/88pm860x_bl.c
@@ -21,7 +21,7 @@
 #define MAX_BRIGHTNESS		(0xFF)
 #define MIN_BRIGHTNESS		(0)
 
-#define CURRENT_MASK		(0x1F << 1)
+#define CURRENT_BITMASK		(0x1F << 1)
 
 struct pm860x_backlight_data {
 	struct pm860x_chip *chip;
@@ -85,7 +85,7 @@ static int pm860x_backlight_set(struct b
 	if ((data->current_brightness == 0) && brightness) {
 		if (data->iset) {
 			ret = pm860x_set_bits(data->i2c, wled_idc(data->port),
-					      CURRENT_MASK, data->iset);
+					      CURRENT_BITMASK, data->iset);
 			if (ret < 0)
 				goto out;
 		}
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
tty-serial-fix-apbuart-build.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

