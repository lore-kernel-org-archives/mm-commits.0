From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-sirfsoc-remove-unnecessary-oom-messages.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:34:58 -0700
Message-ID: <533f0962.y9vTBVVLqB9+hrD6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbaDDTe7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, Baohua.Song@csr.com, jg1.han@samsung.com

Subject: [merged] rtc-rtc-sirfsoc-remove-unnecessary-oom-messages.patch removed from -mm tree
To: jg1.han@samsung.com,Baohua.Song@csr.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:58 -0700


The patch titled
     Subject: rtc: rtc-sirfsoc: remove unnecessary OOM messages
has been removed from the -mm tree.  Its filename was
     rtc-rtc-sirfsoc-remove-unnecessary-oom-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-sirfsoc: remove unnecessary OOM messages

The site-specific OOM messages are unnecessary, because they duplicate the
MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Barry Song <Baohua.Song@csr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sirfsoc.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-sirfsoc.c~rtc-rtc-sirfsoc-remove-unnecessary-oom-messages drivers/rtc/rtc-sirfsoc.c
--- a/drivers/rtc/rtc-sirfsoc.c~rtc-rtc-sirfsoc-remove-unnecessary-oom-messages
+++ a/drivers/rtc/rtc-sirfsoc.c
@@ -264,12 +264,8 @@ static int sirfsoc_rtc_probe(struct plat
 
 	rtcdrv = devm_kzalloc(&pdev->dev,
 		sizeof(struct sirfsoc_rtc_drv), GFP_KERNEL);
-	if (rtcdrv == NULL) {
-		dev_err(&pdev->dev,
-			"%s: can't alloc mem for drv struct\n",
-			pdev->name);
+	if (rtcdrv == NULL)
 		return -ENOMEM;
-	}
 
 	err = of_property_read_u32(np, "reg", &rtcdrv->rtc_base);
 	if (err) {
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

