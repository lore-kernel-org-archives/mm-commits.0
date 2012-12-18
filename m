From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-vgg2432a4c-add-missing-const.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:05:17 -0800
Message-ID: <20121218200518.21DA420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f73.google.com ([74.125.82.73]:32799 "EHLO
	mail-wg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUFU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:05:20 -0500
Received: by mail-wg0-f73.google.com with SMTP id dt12so63237wgb.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:05:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, ben-linux@fluff.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/vgg2432a4.c: add missing const
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-vgg2432a4c-add-missing-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/vgg2432a4.c: add missing const

Add 'const' to static array that was missing it in its definition.  Also,
'const' is added to ili9320_write_regs(), because it is called by
vgg2432a4 driver.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ili9320.c   |    2 +-
 drivers/video/backlight/ili9320.h   |    2 +-
 drivers/video/backlight/vgg2432a4.c |    8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/video/backlight/ili9320.c~drivers-video-backlight-vgg2432a4c-add-missing-const drivers/video/backlight/ili9320.c
--- a/drivers/video/backlight/ili9320.c~drivers-video-backlight-vgg2432a4c-add-missing-const
+++ a/drivers/video/backlight/ili9320.c
@@ -59,7 +59,7 @@ int ili9320_write(struct ili9320 *ili, u
 EXPORT_SYMBOL_GPL(ili9320_write);
 
 int ili9320_write_regs(struct ili9320 *ili,
-		       struct ili9320_reg *values,
+		       const struct ili9320_reg *values,
 		       int nr_values)
 {
 	int index;
diff -puN drivers/video/backlight/ili9320.h~drivers-video-backlight-vgg2432a4c-add-missing-const drivers/video/backlight/ili9320.h
--- a/drivers/video/backlight/ili9320.h~drivers-video-backlight-vgg2432a4c-add-missing-const
+++ a/drivers/video/backlight/ili9320.h
@@ -63,7 +63,7 @@ extern int ili9320_write(struct ili9320 
 			 unsigned int reg, unsigned int value);
 
 extern int ili9320_write_regs(struct ili9320 *ili,
-			      struct ili9320_reg *values,
+			      const struct ili9320_reg *values,
 			      int nr_values);
 
 /* Device probe */
diff -puN drivers/video/backlight/vgg2432a4.c~drivers-video-backlight-vgg2432a4c-add-missing-const drivers/video/backlight/vgg2432a4.c
--- a/drivers/video/backlight/vgg2432a4.c~drivers-video-backlight-vgg2432a4c-add-missing-const
+++ a/drivers/video/backlight/vgg2432a4.c
@@ -26,7 +26,7 @@
 
 /* Device initialisation sequences */
 
-static struct ili9320_reg vgg_init1[] = {
+static const struct ili9320_reg vgg_init1[] = {
 	{
 		.address = ILI9320_POWER1,
 		.value	 = ILI9320_POWER1_AP(0) | ILI9320_POWER1_BT(0),
@@ -43,7 +43,7 @@ static struct ili9320_reg vgg_init1[] = 
 	},
 };
 
-static struct ili9320_reg vgg_init2[] = {
+static const struct ili9320_reg vgg_init2[] = {
 	{
 		.address = ILI9320_POWER1,
 		.value   = (ILI9320_POWER1_AP(3) | ILI9320_POWER1_APE |
@@ -54,7 +54,7 @@ static struct ili9320_reg vgg_init2[] = 
 	}
 };
 
-static struct ili9320_reg vgg_gamma[] = {
+static const struct ili9320_reg vgg_gamma[] = {
 	{
 		.address = ILI9320_GAMMA1,
 		.value	 = 0x0000,
@@ -89,7 +89,7 @@ static struct ili9320_reg vgg_gamma[] = 
 
 };
 
-static struct ili9320_reg vgg_init0[] = {
+static const struct ili9320_reg vgg_init0[] = {
 	[0]	= {
 		/* set direction and scan mode gate */
 		.address = ILI9320_DRIVER,
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch

