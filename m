From: akpm@linux-foundation.org
Subject: + fb-backlight-add-the-himax-hx-8357b-lcd-controller-fix-inverted-parameters-for-kcalloc.patch added to -mm tree
Date: Wed, 13 Feb 2013 14:49:41 -0800
Message-ID: <20130213224941.B39965A41D5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:44704 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3BMWtn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Feb 2013 17:49:43 -0500
Received: by mail-qc0-f201.google.com with SMTP id o22so179468qcr.2
        for <mm-commits@vger.kernel.org>; Wed, 13 Feb 2013 14:49:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maxime.ripard@free-electrons.com, FlorianSchandinat@gmx.de, jg1.han@samsung.com, joe@perches.com, rpurdie@rpsys.net


The patch titled
     Subject: fb: hx8357: Fix inverted parameters for kcalloc
has been added to the -mm tree.  Its filename is
     fb-backlight-add-the-himax-hx-8357b-lcd-controller-fix-inverted-parameters-for-kcalloc.patch

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
Subject: fb: hx8357: Fix inverted parameters for kcalloc

The element size and the number of elements was inverted in the kcalloc
call.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/hx8357.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/hx8357.c~fb-backlight-add-the-himax-hx-8357b-lcd-controller-fix-inverted-parameters-for-kcalloc drivers/video/backlight/hx8357.c
--- a/drivers/video/backlight/hx8357.c~fb-backlight-add-the-himax-hx-8357b-lcd-controller-fix-inverted-parameters-for-kcalloc
+++ a/drivers/video/backlight/hx8357.c
@@ -94,7 +94,7 @@ static int hx8357_spi_write_then_read(st
 	if (txlen) {
 		int i;
 
-		local_txbuf = kcalloc(sizeof(*local_txbuf), txlen, GFP_KERNEL);
+		local_txbuf = kcalloc(txlen, sizeof(*local_txbuf), GFP_KERNEL);
 
 		if (!local_txbuf) {
 			dev_err(&lcdev->dev, "Couldn't allocate data buffer.\n");
_

Patches currently in -mm which might be from maxime.ripard@free-electrons.com are

linux-next.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-change-parameters-of-the-write-function-to-u8.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-fix-inverted-parameters-for-kcalloc.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-remove-useless-error-message.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-remove-trailing-period.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-use-static-arrays-for-lcd-configuration.patch

