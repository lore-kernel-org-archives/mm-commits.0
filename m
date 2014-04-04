From: akpm@linux-foundation.org
Subject: [merged] backlight-adp8870-remove-unnecessary-oom-messages.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:33:22 -0700
Message-ID: <533f0902.TlzDa3mVN5Xe27yL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbaDDTdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, michael.hennerich@analog.com, jg1.han@samsung.com

Subject: [merged] backlight-adp8870-remove-unnecessary-oom-messages.patch removed from -mm tree
To: jg1.han@samsung.com,michael.hennerich@analog.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:22 -0700


The patch titled
     Subject: backlight: adp8870: remove unnecessary OOM messages
has been removed from the -mm tree.  Its filename was
     backlight-adp8870-remove-unnecessary-oom-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: adp8870: remove unnecessary OOM messages

The site-specific OOM messages are unnecessary, because they duplicate the
MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp8870_bl.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/video/backlight/adp8870_bl.c~backlight-adp8870-remove-unnecessary-oom-messages drivers/video/backlight/adp8870_bl.c
--- a/drivers/video/backlight/adp8870_bl.c~backlight-adp8870-remove-unnecessary-oom-messages
+++ a/drivers/video/backlight/adp8870_bl.c
@@ -246,10 +246,8 @@ static int adp8870_led_probe(struct i2c_
 
 	led = devm_kzalloc(&client->dev, pdata->num_leds * sizeof(*led),
 				GFP_KERNEL);
-	if (led == NULL) {
-		dev_err(&client->dev, "failed to alloc memory\n");
+	if (led == NULL)
 		return -ENOMEM;
-	}
 
 	ret = adp8870_write(client, ADP8870_ISCLAW, pdata->led_fade_law);
 	if (ret)
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

