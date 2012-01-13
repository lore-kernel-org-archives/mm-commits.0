From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-adp88x0_blc-fix-bit-testing-logic.patch added to -mm tree
Date: Fri, 13 Jan 2012 14:11:08 -0800
Message-ID: <20120113221108.8F42A100073@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:50540 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018Ab2AMWLJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 17:11:09 -0500
Received: by yenl1 with SMTP id l1so81755yen.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 14:11:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, michael.hennerich@analog.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/adp88x0_bl.c: fix bit testing logic
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-adp88x0_blc-fix-bit-testing-logic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: drivers/video/backlight/adp88x0_bl.c: fix bit testing logic

We need to write new value if the bit mask fields of new value is not
equal to old value.  It does not make sense to write new value only when
all the bit_mask bits are zero.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp8860_bl.c |    2 +-
 drivers/video/backlight/adp8870_bl.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/adp8860_bl.c~drivers-video-backlight-adp88x0_blc-fix-bit-testing-logic drivers/video/backlight/adp8860_bl.c
--- a/drivers/video/backlight/adp8860_bl.c~drivers-video-backlight-adp88x0_blc-fix-bit-testing-logic
+++ a/drivers/video/backlight/adp8860_bl.c
@@ -146,7 +146,7 @@ static int adp8860_set_bits(struct i2c_c
 
 	ret = adp8860_read(client, reg, &reg_val);
 
-	if (!ret && ((reg_val & bit_mask) == 0)) {
+	if (!ret && ((reg_val & bit_mask) != bit_mask)) {
 		reg_val |= bit_mask;
 		ret = adp8860_write(client, reg, reg_val);
 	}
diff -puN drivers/video/backlight/adp8870_bl.c~drivers-video-backlight-adp88x0_blc-fix-bit-testing-logic drivers/video/backlight/adp8870_bl.c
--- a/drivers/video/backlight/adp8870_bl.c~drivers-video-backlight-adp88x0_blc-fix-bit-testing-logic
+++ a/drivers/video/backlight/adp8870_bl.c
@@ -160,7 +160,7 @@ static int adp8870_set_bits(struct i2c_c
 
 	ret = adp8870_read(client, reg, &reg_val);
 
-	if (!ret && ((reg_val & bit_mask) == 0)) {
+	if (!ret && ((reg_val & bit_mask) != bit_mask)) {
 		reg_val |= bit_mask;
 		ret = adp8870_write(client, reg, reg_val);
 	}
_
Subject: Subject: drivers/video/backlight/adp88x0_bl.c: fix bit testing logic

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
drivers-video-backlight-adp88x0_blc-fix-bit-testing-logic.patch

