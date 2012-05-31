From: akpm@linux-foundation.org
Subject: [merged] leds-use-kcalloc-instead-of-kzalloc-to-allocate-array.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:34 -0700
Message-ID: <20120531191934.6D0B0A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:63242 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072Ab2EaTTf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:19:35 -0400
Received: by mail-yw0-f74.google.com with SMTP id m50so146999yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thomas@m3y3r.de, bryan.wu@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: leds: Use kcalloc instead of kzalloc to allocate array
has been removed from the -mm tree.  Its filename was
     leds-use-kcalloc-instead-of-kzalloc-to-allocate-array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Thomas Meyer <thomas@m3y3r.de>
Subject: leds: Use kcalloc instead of kzalloc to allocate array

The advantage of kcalloc is that will prevent integer overflows which
could result from the multiplication of number of elements and size and it
is also a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Cc: Bryan Wu <bryan.wu@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-mc13783.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-mc13783.c~leds-use-kcalloc-instead-of-kzalloc-to-allocate-array drivers/leds/leds-mc13783.c
--- a/drivers/leds/leds-mc13783.c~leds-use-kcalloc-instead-of-kzalloc-to-allocate-array
+++ a/drivers/leds/leds-mc13783.c
@@ -280,7 +280,7 @@ static int __devinit mc13783_led_probe(s
 		return -EINVAL;
 	}
 
-	led = kzalloc(sizeof(*led) * pdata->num_leds, GFP_KERNEL);
+	led = kcalloc(pdata->num_leds, sizeof(*led), GFP_KERNEL);
 	if (led == NULL) {
 		dev_err(&pdev->dev, "failed to alloc memory\n");
 		return -ENOMEM;
_

Patches currently in -mm which might be from thomas@m3y3r.de are

origin.patch

