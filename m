From: akpm@linux-foundation.org
Subject: [merged] backlight-lms283gf05-use-devm_gpio_request_one.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:04:50 -0800
Message-ID: <20121218200450.BA01F100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:61799 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUEv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:04:51 -0500
Received: by mail-ye0-f202.google.com with SMTP id l7so125509yen.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:04:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, marex@denx.de, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: lms283gf05: use devm_gpio_request_one
has been removed from the -mm tree.  Its filename was
     backlight-lms283gf05-use-devm_gpio_request_one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: lms283gf05: use devm_gpio_request_one

By using devm_gpio_request_one it is possible to set the direction
and initial value in one shot. Thus, using devm_gpio_request_one
can make the code simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Acked-by: Marek Vasut <marex@denx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lms283gf05.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/video/backlight/lms283gf05.c~backlight-lms283gf05-use-devm_gpio_request_one drivers/video/backlight/lms283gf05.c
--- a/drivers/video/backlight/lms283gf05.c~backlight-lms283gf05-use-devm_gpio_request_one
+++ a/drivers/video/backlight/lms283gf05.c
@@ -158,13 +158,9 @@ static int lms283gf05_probe(struct spi_d
 	int ret = 0;
 
 	if (pdata != NULL) {
-		ret = devm_gpio_request(&spi->dev, pdata->reset_gpio,
-					"LMS285GF05 RESET");
-		if (ret)
-			return ret;
