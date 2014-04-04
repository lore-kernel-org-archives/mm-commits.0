From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-spear-remove-unnecessary-oom-messages.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:35:02 -0700
Message-ID: <533f0966.dJU8FAgI1m7gCZs2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43503 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbaDDTfC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:35:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viresh.kumar@linaro.org, jg1.han@samsung.com

Subject: [merged] rtc-rtc-spear-remove-unnecessary-oom-messages.patch removed from -mm tree
To: jg1.han@samsung.com,viresh.kumar@linaro.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:35:02 -0700


The patch titled
     Subject: rtc: rtc-spear: remove unnecessary OOM messages
has been removed from the -mm tree.  Its filename was
     rtc-rtc-spear-remove-unnecessary-oom-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-spear: remove unnecessary OOM messages

The site-specific OOM messages are unnecessary, because they duplicate the
MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-spear.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-spear.c~rtc-rtc-spear-remove-unnecessary-oom-messages drivers/rtc/rtc-spear.c
--- a/drivers/rtc/rtc-spear.c~rtc-rtc-spear-remove-unnecessary-oom-messages
+++ a/drivers/rtc/rtc-spear.c
@@ -365,10 +365,8 @@ static int spear_rtc_probe(struct platfo
 	}
 
 	config = devm_kzalloc(&pdev->dev, sizeof(*config), GFP_KERNEL);
-	if (!config) {
-		dev_err(&pdev->dev, "out of memory\n");
+	if (!config)
 		return -ENOMEM;
-	}
 
 	/* alarm irqs */
 	irq = platform_get_irq(pdev, 0);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

