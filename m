From: akpm@linux-foundation.org
Subject: + backlight-fix-88pm860x_bl-macro-collision.patch added to -mm tree
Date: Fri, 18 Jun 2010 14:11:05 -0700
Message-ID: <201006182111.o5ILB5cS023594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752446Ab0FRVMH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 17:12:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, haojian.zhuang@marvell.com, rpurdie@rpsys.net


The patch titled
     backlight: fix 88pm860x_bl macro collision
has been added to the -mm tree.  Its filename is
     backlight-fix-88pm860x_bl-macro-collision.patch

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
Subject: backlight: fix 88pm860x_bl macro collision
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix collision with kernel-supplied #define:

drivers/video/backlight/88pm860x_bl.c:24:1: warning: "CURRENT_MASK" redefined
arch/x86/include/asm/page_64_types.h:6:1: warning: this is the location of the previous definition

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
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

linux-next.patch
compal-laptop-uses-hwmon-interfaces-depends-on-hwmon.patch
dib3000mc-reduce-large-stack-usage-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-fix-88pm860x_bl-macro-collision.patch
scsi-fix-pmcraid-build-errors.patch
scsi-fix-be2iscsi-build.patch
scsi-fix-bnx2i-build-errors.patch
virtio_9ph-include-linux-typesh.patch
submittingpatches-add-more-about-patch-descriptions.patch
fusion-fix-kernel-doc-warnings.patch
timerc-fix-kernel-doc-warning.patch
mtd-nand_base-fix-kernel-doc-warnings-typos.patch
docbook-need-xmldoclinks-for-all-doc-types.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

