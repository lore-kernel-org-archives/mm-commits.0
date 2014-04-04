From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-pm8xxx-remove-unnecessary-oom-messages.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:34:54 -0700
Message-ID: <533f095e.8XIM+ygknSk/gMLA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43493 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbaDDTey (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] rtc-rtc-pm8xxx-remove-unnecessary-oom-messages.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:54 -0700


The patch titled
     Subject: rtc: rtc-pm8xxx: remove unnecessary OOM messages
has been removed from the -mm tree.  Its filename was
     rtc-rtc-pm8xxx-remove-unnecessary-oom-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-pm8xxx: remove unnecessary OOM messages

The site-specific OOM messages are unnecessary, because they duplicate the
MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pm8xxx.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-pm8xxx.c~rtc-rtc-pm8xxx-remove-unnecessary-oom-messages drivers/rtc/rtc-pm8xxx.c
--- a/drivers/rtc/rtc-pm8xxx.c~rtc-rtc-pm8xxx-remove-unnecessary-oom-messages
+++ a/drivers/rtc/rtc-pm8xxx.c
@@ -396,10 +396,8 @@ static int pm8xxx_rtc_probe(struct platf
 		rtc_write_enable = pdata->rtc_write_enable;
 
 	rtc_dd = devm_kzalloc(&pdev->dev, sizeof(*rtc_dd), GFP_KERNEL);
-	if (rtc_dd == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate memory!\n");
+	if (rtc_dd == NULL)
 		return -ENOMEM;
-	}
 
 	/* Initialise spinlock to protect RTC control register */
 	spin_lock_init(&rtc_dd->ctrl_reg_lock);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

