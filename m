From: akpm@linux-foundation.org
Subject: [merged] gpio-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:13:39 -0800
Message-ID: <20130228201339.BC43431C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:52976 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab3B1UNl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:13:41 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so244785vch.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:13:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, grant.likely@secretlab.ca, linus.walleij@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: gpio: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     gpio-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: gpio: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/gpio/gpiolib.c~gpio-convert-to-idr_alloc drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpio-convert-to-idr_alloc
+++ a/drivers/gpio/gpiolib.c
@@ -411,15 +411,10 @@ static int gpio_setup_irq(struct gpio_de
 			goto err_out;
 		}
 
-		do {
-			ret = -ENOMEM;
-			if (idr_pre_get(&dirent_idr, GFP_KERNEL))
-				ret = idr_get_new_above(&dirent_idr, value_sd,
-							1, &id);
-		} while (ret == -EAGAIN);
