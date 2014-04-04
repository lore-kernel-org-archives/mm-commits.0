From: akpm@linux-foundation.org
Subject: [merged]
 backlight-lm3533_bl-remove-unnecessary-oom-messages.patch removed from -mm
 tree
Date: Fri, 04 Apr 2014 12:33:34 -0700
Message-ID: <533f090e.nM2lsZxxrRjCs1v8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbaDDTde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jhovold@gmail.com, jg1.han@samsung.com

Subject: [merged] backlight-lm3533_bl-remove-unnecessary-oom-messages.patch removed from -mm tree
To: jg1.han@samsung.com,jhovold@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:34 -0700


The patch titled
     Subject: backlight: lm3533_bl: remove unnecessary OOM messages
has been removed from the -mm tree.  Its filename was
     backlight-lm3533_bl-remove-unnecessary-oom-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: lm3533_bl: remove unnecessary OOM messages

The site-specific OOM messages are unnecessary, because they duplicate the
MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lm3533_bl.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/video/backlight/lm3533_bl.c~backlight-lm3533_bl-remove-unnecessary-oom-messages drivers/video/backlight/lm3533_bl.c
--- a/drivers/video/backlight/lm3533_bl.c~backlight-lm3533_bl-remove-unnecessary-oom-messages
+++ a/drivers/video/backlight/lm3533_bl.c
@@ -296,11 +296,8 @@ static int lm3533_bl_probe(struct platfo
 	}
 
 	bl = devm_kzalloc(&pdev->dev, sizeof(*bl), GFP_KERNEL);
-	if (!bl) {
-		dev_err(&pdev->dev,
-				"failed to allocate memory for backlight\n");
+	if (!bl)
 		return -ENOMEM;
-	}
 
 	bl->lm3533 = lm3533;
 	bl->id = pdev->id;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

