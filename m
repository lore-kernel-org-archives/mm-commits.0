From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-lpc32xx-remove-unnecessary-oom-messages.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:35:00 -0700
Message-ID: <533f0964.6q9POLe6ZCSibiEs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbaDDTfA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:35:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] rtc-rtc-lpc32xx-remove-unnecessary-oom-messages.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:35:00 -0700


The patch titled
     Subject: rtc: rtc-lpc32xx: remove unnecessary OOM messages
has been removed from the -mm tree.  Its filename was
     rtc-rtc-lpc32xx-remove-unnecessary-oom-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-lpc32xx: remove unnecessary OOM messages

The site-specific OOM messages are unnecessary, because they duplicate the
MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-lpc32xx.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-lpc32xx.c~rtc-rtc-lpc32xx-remove-unnecessary-oom-messages drivers/rtc/rtc-lpc32xx.c
--- a/drivers/rtc/rtc-lpc32xx.c~rtc-rtc-lpc32xx-remove-unnecessary-oom-messages
+++ a/drivers/rtc/rtc-lpc32xx.c
@@ -211,10 +211,9 @@ static int lpc32xx_rtc_probe(struct plat
 	}
 
 	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
-	if (unlikely(!rtc)) {
-		dev_err(&pdev->dev, "Can't allocate memory\n");
+	if (unlikely(!rtc))
 		return -ENOMEM;
-	}
+
 	rtc->irq = rtcirq;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

