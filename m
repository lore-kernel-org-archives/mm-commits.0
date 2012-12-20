From: akpm@linux-foundation.org
Subject: + backlight-s6e63m0-use-lowercase-names-of-structs.patch added to -mm tree
Date: Thu, 20 Dec 2012 12:35:48 -0800
Message-ID: <20121220203549.91A7C20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f201.google.com ([74.125.82.201]:37980 "EHLO
	mail-we0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab2LTUfv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 15:35:51 -0500
Received: by mail-we0-f201.google.com with SMTP id t11so207881wey.4
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 12:35:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: backlight: s6e63m0: use lowercase names of structs
has been added to the -mm tree.  Its filename is
     backlight-s6e63m0-use-lowercase-names-of-structs.patch

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
Subject: backlight: s6e63m0: use lowercase names of structs

Lowercase names of structs should be used, because they are
not preprocessor macros.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/s6e63m0.c |   40 ++++++++++++++--------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff -puN drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-use-lowercase-names-of-structs drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-use-lowercase-names-of-structs
+++ a/drivers/video/backlight/s6e63m0.c
@@ -57,7 +57,7 @@ struct s6e63m0 {
 	struct lcd_platform_data	*lcd_pd;
 };
 
-static const unsigned short SEQ_PANEL_CONDITION_SET[] = {
+static const unsigned short seq_panel_condition_set[] = {
 	0xF8, 0x01,
 	DATA_ONLY, 0x27,
 	DATA_ONLY, 0x27,
@@ -76,7 +76,7 @@ static const unsigned short SEQ_PANEL_CO
 	ENDDEF, 0x0000
 };
 
-static const unsigned short SEQ_DISPLAY_CONDITION_SET[] = {
+static const unsigned short seq_display_condition_set[] = {
 	0xf2, 0x02,
 	DATA_ONLY, 0x03,
 	DATA_ONLY, 0x1c,
@@ -90,7 +90,7 @@ static const unsigned short SEQ_DISPLAY_
 	ENDDEF, 0x0000
 };
 
-static const unsigned short SEQ_GAMMA_SETTING[] = {
+static const unsigned short seq_gamma_setting[] = {
 	0xfa, 0x00,
 	DATA_ONLY, 0x18,
 	DATA_ONLY, 0x08,
@@ -119,7 +119,7 @@ static const unsigned short SEQ_GAMMA_SE
 	ENDDEF, 0x0000
 };
 
-static const unsigned short SEQ_ETC_CONDITION_SET[] = {
+static const unsigned short seq_etc_condition_set[] = {
 	0xf6, 0x00,
 	DATA_ONLY, 0x8c,
 	DATA_ONLY, 0x07,
@@ -318,47 +318,47 @@ static const unsigned short SEQ_ETC_COND
 	ENDDEF, 0x0000
 };
 
-static const unsigned short SEQ_ACL_ON[] = {
+static const unsigned short seq_acl_on[] = {
 	/* ACL on */
 	0xc0, 0x01,
 
 	ENDDEF, 0x0000
 };
 
-static const unsigned short SEQ_ACL_OFF[] = {
+static const unsigned short seq_acl_off[] = {
 	/* ACL off */
 	0xc0, 0x00,
 
 	ENDDEF, 0x0000
 };
 
-static const unsigned short SEQ_ELVSS_ON[] = {
+static const unsigned short seq_elvss_on[] = {
 	/* ELVSS on */
 	0xb1, 0x0b,
 
 	ENDDEF, 0x0000
 };
 
-static const unsigned short SEQ_ELVSS_OFF[] = {
+static const unsigned short seq_elvss_off[] = {
 	/* ELVSS off */
 	0xb1, 0x0a,
 
 	ENDDEF, 0x0000
 };
 
-static const unsigned short SEQ_STAND_BY_OFF[] = {
+static const unsigned short seq_stand_by_off[] = {
 	0x11, COMMAND_ONLY,
 
 	ENDDEF, 0x0000
 };
 
-static const unsigned short SEQ_STAND_BY_ON[] = {
+static const unsigned short seq_stand_by_on[] = {
 	0x10, COMMAND_ONLY,
 
 	ENDDEF, 0x0000
 };
 
-static const unsigned short SEQ_DISPLAY_ON[] = {
+static const unsigned short seq_display_on[] = {
 	0x29, COMMAND_ONLY,
 
 	ENDDEF, 0x0000
@@ -457,12 +457,12 @@ static int s6e63m0_ldi_init(struct s6e63
 {
 	int ret, i;
 	const unsigned short *init_seq[] = {
-		SEQ_PANEL_CONDITION_SET,
-		SEQ_DISPLAY_CONDITION_SET,
-		SEQ_GAMMA_SETTING,
-		SEQ_ETC_CONDITION_SET,
-		SEQ_ACL_ON,
-		SEQ_ELVSS_ON,
+		seq_panel_condition_set,
+		seq_display_condition_set,
+		seq_gamma_setting,
+		seq_etc_condition_set,
+		seq_acl_on,
+		seq_elvss_on,
 	};
 
 	for (i = 0; i < ARRAY_SIZE(init_seq); i++) {
@@ -478,8 +478,8 @@ static int s6e63m0_ldi_enable(struct s6e
 {
 	int ret = 0, i;
 	const unsigned short *enable_seq[] = {
-		SEQ_STAND_BY_OFF,
-		SEQ_DISPLAY_ON,
+		seq_stand_by_off,
+		seq_display_on,
 	};
 
 	for (i = 0; i < ARRAY_SIZE(enable_seq); i++) {
@@ -495,7 +495,7 @@ static int s6e63m0_ldi_disable(struct s6
 {
 	int ret;
 
-	ret = s6e63m0_panel_send_sequence(lcd, SEQ_STAND_BY_ON);
+	ret = s6e63m0_panel_send_sequence(lcd, seq_stand_by_on);
 
 	return ret;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-add-lms501kf03-lcd-driver.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-ld9040-use-sleep-instead-of-delay.patch
backlight-ld9040-remove-unnecessary-null-deference-check.patch
backlight-ld9040-replace-efault-with-einval.patch
backlight-ld9040-remove-redundant-return-variables.patch
backlight-ld9040-reorder-inclusions-of-linux-xxxh.patch
backlight-s6e63m0-use-lowercase-names-of-structs.patch
backlight-s6e63m0-use-sleep-instead-of-delay.patch
backlight-s6e63m0-remove-unnecessary-null-deference-check.patch
backlight-s6e63m0-replace-efault-with-einval.patch
backlight-s6e63m0-remove-redundant-variable-before_power.patch
backlight-s6e63m0-reorder-inclusions-of-linux-xxxh.patch

