From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-lms283gf05c-use-gpiof_init-flags-when-using-devm_gpio_request_one.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:05:45 -0800
Message-ID: <20121218200545.B9F0B82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:32994 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab2LRUFq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:05:46 -0500
Received: by mail-qc0-f201.google.com with SMTP id a6so125598qch.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:05:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, marex@denx.de, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/lms283gf05.c: use GPIOF_INIT flags when using devm_gpio_request_one()
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-lms283gf05c-use-gpiof_init-flags-when-using-devm_gpio_request_one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/lms283gf05.c: use GPIOF_INIT flags when using devm_gpio_request_one()

GPIOF_DIR_OUT and GPIOF_DIR_IN are defined as below:
 GPIOF_DIR_OUT   (0 << 0)
 GPIOF_DIR_IN    (1 << 0)
So, when !pdata->reset_inverted is 1, the gpio pin can be set as
input, instead of output.

To prevent this problem, GPIOF_INIT flag should be used when using
devm_gpio_request_one().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Marek Vasut <marex@denx.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lms283gf05.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/backlight/lms283gf05.c~drivers-video-backlight-lms283gf05c-use-gpiof_init-flags-when-using-devm_gpio_request_one drivers/video/backlight/lms283gf05.c
--- a/drivers/video/backlight/lms283gf05.c~drivers-video-backlight-lms283gf05c-use-gpiof_init-flags-when-using-devm_gpio_request_one
+++ a/drivers/video/backlight/lms283gf05.c
@@ -159,7 +159,8 @@ static int lms283gf05_probe(struct spi_d
 
 	if (pdata != NULL) {
 		ret = devm_gpio_request_one(&spi->dev, pdata->reset_gpio,
-				GPIOF_DIR_OUT | !pdata->reset_inverted,
+				GPIOF_DIR_OUT | (!pdata->reset_inverted ?
+				GPIOF_INIT_HIGH : GPIOF_INIT_LOW),
 				"LMS285GF05 RESET");
 		if (ret)
 			return ret;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch

