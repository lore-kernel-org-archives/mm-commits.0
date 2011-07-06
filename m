From: akpm@linux-foundation.org
Subject: + backlight-ams369fg06-fix-section-mismatch-warning.patch added to -mm tree
Date: Wed, 06 Jul 2011 13:52:44 -0700
Message-ID: <201107062052.p66KqiQL030821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756285Ab1GFUxZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jul 2011 16:53:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, anish198519851985@gmail.com, inki.dae@samsung.com, rpurdie@rpsys.net


The patch titled
     backlight: ams369fg06: fix section mismatch warning
has been added to the -mm tree.  Its filename is
     backlight-ams369fg06-fix-section-mismatch-warning.patch

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
Subject: backlight: ams369fg06: fix section mismatch warning
From: Jingoo Han <jg1.han@samsung.com>

Fix section mismatch warning by adding the correct annotation __devinit
to the driver's probe function.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: anish singh <anish198519851985@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ams369fg06.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-fix-section-mismatch-warning drivers/video/backlight/ams369fg06.c
--- a/drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-fix-section-mismatch-warning
+++ a/drivers/video/backlight/ams369fg06.c
@@ -473,7 +473,7 @@ static const struct backlight_ops ams369
 	.update_status = ams369fg06_set_brightness,
 };
 
-static int __init ams369fg06_probe(struct spi_device *spi)
+static int __devinit ams369fg06_probe(struct spi_device *spi)
 {
 	int ret = 0;
 	struct ams369fg06 *lcd = NULL;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
backlight-add-ams369fg06-amoled-driver.patch
backlight-add-ams369fg06-amoled-driver-fix.patch
backlight-add-ams369fg06-amoled-driver-unregister-backlight-device-when-unload-the-module.patch
backlight-ams369fg06-fix-section-mismatch-warning.patch

