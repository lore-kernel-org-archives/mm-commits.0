From: akpm@linux-foundation.org
Subject: + fb-backlight-add-the-himax-hx-8357b-lcd-controller-remove-useless-error-message.patch added to -mm tree
Date: Wed, 13 Feb 2013 14:49:44 -0800
Message-ID: <20130213224944.B6FB45A41D5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:57682 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab3BMWtq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Feb 2013 17:49:46 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so170476yhz.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Feb 2013 14:49:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maxime.ripard@free-electrons.com, FlorianSchandinat@gmx.de, jg1.han@samsung.com, joe@perches.com, rpurdie@rpsys.net


The patch titled
     Subject: fb: hx8357: Remove useless error message
has been added to the -mm tree.  Its filename is
     fb-backlight-add-the-himax-hx-8357b-lcd-controller-remove-useless-error-message.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: fb: hx8357: Remove useless error message

In case of a failing allocation, a dump stack will be printed anyway, so
the dev_err is redundant.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/hx8357.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/video/backlight/hx8357.c~fb-backlight-add-the-himax-hx-8357b-lcd-controller-remove-useless-error-message drivers/video/backlight/hx8357.c
--- a/drivers/video/backlight/hx8357.c~fb-backlight-add-the-himax-hx-8357b-lcd-controller-remove-useless-error-message
+++ a/drivers/video/backlight/hx8357.c
@@ -96,10 +96,8 @@ static int hx8357_spi_write_then_read(st
 
 		local_txbuf = kcalloc(txlen, sizeof(*local_txbuf), GFP_KERNEL);
 
-		if (!local_txbuf) {
-			dev_err(&lcdev->dev, "Couldn't allocate data buffer.\n");
+		if (!local_txbuf)
 			return -ENOMEM;
-		}
 
 		for (i = 0; i < txlen; i++) {
 			local_txbuf[i] = txbuf[i];
_

Patches currently in -mm which might be from maxime.ripard@free-electrons.com are

linux-next.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-change-parameters-of-the-write-function-to-u8.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-fix-inverted-parameters-for-kcalloc.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-remove-useless-error-message.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-remove-trailing-period.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-use-static-arrays-for-lcd-configuration.patch

