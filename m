From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-at32ap700x-remove-unnecessary-oom-messages.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:34:44 -0700
Message-ID: <533f0954.qVM1YUPqY8tpCC1u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbaDDTeo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, egtvedt@samfundet.no, jg1.han@samsung.com

Subject: [merged] rtc-rtc-at32ap700x-remove-unnecessary-oom-messages.patch removed from -mm tree
To: jg1.han@samsung.com,egtvedt@samfundet.no,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:44 -0700


The patch titled
     Subject: rtc: rtc-at32ap700x: remove unnecessary OOM messages
has been removed from the -mm tree.  Its filename was
     rtc-rtc-at32ap700x-remove-unnecessary-oom-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-at32ap700x: remove unnecessary OOM messages

The site-specific OOM messages are unnecessary, because they duplicate the
MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at32ap700x.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-at32ap700x.c~rtc-rtc-at32ap700x-remove-unnecessary-oom-messages drivers/rtc/rtc-at32ap700x.c
--- a/drivers/rtc/rtc-at32ap700x.c~rtc-rtc-at32ap700x-remove-unnecessary-oom-messages
+++ a/drivers/rtc/rtc-at32ap700x.c
@@ -204,10 +204,8 @@ static int __init at32_rtc_probe(struct
 
 	rtc = devm_kzalloc(&pdev->dev, sizeof(struct rtc_at32ap700x),
 			   GFP_KERNEL);
-	if (!rtc) {
-		dev_dbg(&pdev->dev, "out of memory\n");
+	if (!rtc)
 		return -ENOMEM;
-	}
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!regs) {
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

