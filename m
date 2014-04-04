From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-moxart-remove-unnecessary-oom-messages.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:34:50 -0700
Message-ID: <533f095a.ekiMHyJFtb8d6XJ2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaDDTeu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] rtc-rtc-moxart-remove-unnecessary-oom-messages.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:50 -0700


The patch titled
     Subject: rtc: rtc-moxart: remove unnecessary OOM messages
has been removed from the -mm tree.  Its filename was
     rtc-rtc-moxart-remove-unnecessary-oom-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-moxart: remove unnecessary OOM messages

The site-specific OOM messages are unnecessary, because they duplicate the
MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-moxart.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-moxart.c~rtc-rtc-moxart-remove-unnecessary-oom-messages drivers/rtc/rtc-moxart.c
--- a/drivers/rtc/rtc-moxart.c~rtc-rtc-moxart-remove-unnecessary-oom-messages
+++ a/drivers/rtc/rtc-moxart.c
@@ -247,10 +247,8 @@ static int moxart_rtc_probe(struct platf
 	int ret = 0;
 
 	moxart_rtc = devm_kzalloc(&pdev->dev, sizeof(*moxart_rtc), GFP_KERNEL);
-	if (!moxart_rtc) {
-		dev_err(&pdev->dev, "devm_kzalloc failed\n");
+	if (!moxart_rtc)
 		return -ENOMEM;
-	}
 
 	moxart_rtc->gpio_data = of_get_named_gpio(pdev->dev.of_node,
 						  "gpio-rtc-data", 0);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

