From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-tdo24mc-add-missing-const.patch added to -mm tree
Date: Tue, 23 Oct 2012 12:47:40 -0700
Message-ID: <20121023194741.756085C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:64322 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368Ab2JWTro (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 15:47:44 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so253765bkw.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 12:47:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, eric.y.miao@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/tdo24m.c: add missing const
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-tdo24mc-add-missing-const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/tdo24m.c: add missing const

Add 'const' to static array that was missing it in its definition.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tdo24m.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff -puN drivers/video/backlight/tdo24m.c~drivers-video-backlight-tdo24mc-add-missing-const drivers/video/backlight/tdo24m.c
--- a/drivers/video/backlight/tdo24m.c~drivers-video-backlight-tdo24mc-add-missing-const
+++ a/drivers/video/backlight/tdo24m.c
@@ -47,7 +47,7 @@ struct tdo24m {
 			((x1) << 9) | 0x100 | (x2))
 #define CMD_NULL	(-1)
 
-static uint32_t lcd_panel_reset[] = {
+static const uint32_t lcd_panel_reset[] = {
 	CMD0(0x1), /* reset */
 	CMD0(0x0), /* nop */
 	CMD0(0x0), /* nop */
@@ -55,7 +55,7 @@ static uint32_t lcd_panel_reset[] = {
 	CMD_NULL,
 };
 
-static uint32_t lcd_panel_on[] = {
+static const uint32_t lcd_panel_on[] = {
 	CMD0(0x29),		/* Display ON */
 	CMD2(0xB8, 0xFF, 0xF9),	/* Output Control */
 	CMD0(0x11),		/* Sleep out */
@@ -63,7 +63,7 @@ static uint32_t lcd_panel_on[] = {
 	CMD_NULL,
 };
 
-static uint32_t lcd_panel_off[] = {
+static const uint32_t lcd_panel_off[] = {
 	CMD0(0x28),		/* Display OFF */
 	CMD2(0xB8, 0x80, 0x02),	/* Output Control */
 	CMD0(0x10),		/* Sleep in */
@@ -71,7 +71,7 @@ static uint32_t lcd_panel_off[] = {
 	CMD_NULL,
 };
 
-static uint32_t lcd_vga_pass_through_tdo24m[] = {
+static const uint32_t lcd_vga_pass_through_tdo24m[] = {
 	CMD1(0xB0, 0x16),
 	CMD1(0xBC, 0x80),
 	CMD1(0xE1, 0x00),
@@ -80,7 +80,7 @@ static uint32_t lcd_vga_pass_through_tdo
 	CMD_NULL,
 };
 
-static uint32_t lcd_qvga_pass_through_tdo24m[] = {
+static const uint32_t lcd_qvga_pass_through_tdo24m[] = {
 	CMD1(0xB0, 0x16),
 	CMD1(0xBC, 0x81),
 	CMD1(0xE1, 0x00),
@@ -89,7 +89,7 @@ static uint32_t lcd_qvga_pass_through_td
 	CMD_NULL,
 };
 
-static uint32_t lcd_vga_transfer_tdo24m[] = {
+static const uint32_t lcd_vga_transfer_tdo24m[] = {
 	CMD1(0xcf, 0x02),	/* Blanking period control (1) */
 	CMD2(0xd0, 0x08, 0x04),	/* Blanking period control (2) */
 	CMD1(0xd1, 0x01),	/* CKV timing control on/off */
@@ -102,7 +102,7 @@ static uint32_t lcd_vga_transfer_tdo24m[
 	CMD_NULL,
 };
 
-static uint32_t lcd_qvga_transfer[] = {
+static const uint32_t lcd_qvga_transfer[] = {
 	CMD1(0xd6, 0x02),	/* Blanking period control (1) */
 	CMD2(0xd7, 0x08, 0x04),	/* Blanking period control (2) */
 	CMD1(0xd8, 0x01),	/* CKV timing control on/off */
@@ -115,7 +115,7 @@ static uint32_t lcd_qvga_transfer[] = {
 	CMD_NULL,
 };
 
-static uint32_t lcd_vga_pass_through_tdo35s[] = {
+static const uint32_t lcd_vga_pass_through_tdo35s[] = {
 	CMD1(0xB0, 0x16),
 	CMD1(0xBC, 0x80),
 	CMD1(0xE1, 0x00),
@@ -123,7 +123,7 @@ static uint32_t lcd_vga_pass_through_tdo
 	CMD_NULL,
 };
 
-static uint32_t lcd_qvga_pass_through_tdo35s[] = {
+static const uint32_t lcd_qvga_pass_through_tdo35s[] = {
 	CMD1(0xB0, 0x16),
 	CMD1(0xBC, 0x81),
 	CMD1(0xE1, 0x00),
@@ -131,7 +131,7 @@ static uint32_t lcd_qvga_pass_through_td
 	CMD_NULL,
 };
 
-static uint32_t lcd_vga_transfer_tdo35s[] = {
+static const uint32_t lcd_vga_transfer_tdo35s[] = {
 	CMD1(0xcf, 0x02),	/* Blanking period control (1) */
 	CMD2(0xd0, 0x08, 0x04),	/* Blanking period control (2) */
 	CMD1(0xd1, 0x01),	/* CKV timing control on/off */
@@ -144,7 +144,7 @@ static uint32_t lcd_vga_transfer_tdo35s[
 	CMD_NULL,
 };
 
-static uint32_t lcd_panel_config[] = {
+static const uint32_t lcd_panel_config[] = {
 	CMD2(0xb8, 0xff, 0xf9),	/* Output control */
 	CMD0(0x11),		/* sleep out */
 	CMD1(0xba, 0x01),	/* Display mode (1) */
@@ -175,10 +175,11 @@ static uint32_t lcd_panel_config[] = {
 	CMD_NULL,
 };
 
-static int tdo24m_writes(struct tdo24m *lcd, uint32_t *array)
+static int tdo24m_writes(struct tdo24m *lcd, const uint32_t *array)
 {
 	struct spi_transfer *x = &lcd->xfer;
-	uint32_t data, *p = array;
+	const uint32_t *p = array;
+	uint32_t data;
 	int nparams, err = 0;
 
 	for (; *p != CMD_NULL; p++) {
_

Patches currently in -mm which might be from jg1.han@samsung.com are

backlight-ili9320-add-missing-spi-dependency.patch
linux-next.patch
backlight-da903x_bl-use-dev_get_drvdata-instead-of-platform_get_drvdata.patch
backlight-88pm860x_bl-fix-checkpatch-warning.patch
backlight-atmel-pwm-bl-fix-checkpatch-warning.patch
backlight-corgi_lcd-fix-checkpatch-error-and-warning.patch
backlight-da903x_bl-fix-checkpatch-warning.patch
backlight-generic_bl-fix-checkpatch-warning.patch
backlight-hp680_bl-fix-checkpatch-error-and-warning.patch
backlight-ili9320-fix-checkpatch-error-and-warning.patch
backlight-jornada720-fix-checkpatch-error-and-warning.patch
backlight-l4f00242t03-fix-checkpatch-warning.patch
backlight-lm3630-fix-checkpatch-warning.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch
backlight-omap1-fix-checkpatch-warning.patch
backlight-pcf50633-fix-checkpatch-warning.patch
backlight-platform_lcd-fix-checkpatch-error.patch
backlight-tdo24m-fix-checkpatch-warning.patch
backlight-tosa-fix-checkpatch-error-and-warning.patch
backlight-vgg2432a4-fix-checkpatch-warning.patch
backlight-lms283gf05-use-devm_gpio_request_one.patch
backlight-tosa-use-devm_gpio_request_one.patch
drivers-video-backlight-da9052_blc-add-missing-const.patch
drivers-video-backlight-lms283gf05c-add-missing-const.patch
drivers-video-backlight-tdo24mc-add-missing-const.patch
drivers-video-backlight-vgg2432a4c-add-missing-const.patch

