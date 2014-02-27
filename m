From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-as3722c-use-simple_dev_pm_ops-macro.patch added to -mm tree
Date: Thu, 27 Feb 2014 14:55:46 -0800
Message-ID: <530fc272.mAn7DTxPD96zuHc5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40235 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaB0Wzr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Feb 2014 17:55:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + drivers-rtc-rtc-as3722c-use-simple_dev_pm_ops-macro.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Thu, 27 Feb 2014 14:55:46 -0800


The patch titled
     Subject: drivers/rtc/rtc-as3722.c: use SIMPLE_DEV_PM_OPS macro
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-as3722c-use-simple_dev_pm_ops-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-as3722c-use-simple_dev_pm_ops-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-as3722c-use-simple_dev_pm_ops-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/rtc/rtc-as3722.c: use SIMPLE_DEV_PM_OPS macro

Use SIMPLE_DEV_PM_OPS macro in order to make the code simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-as3722.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-as3722.c~drivers-rtc-rtc-as3722c-use-simple_dev_pm_ops-macro drivers/rtc/rtc-as3722.c
--- a/drivers/rtc/rtc-as3722.c~drivers-rtc-rtc-as3722c-use-simple_dev_pm_ops-macro
+++ a/drivers/rtc/rtc-as3722.c
@@ -242,9 +242,8 @@ static int as3722_rtc_resume(struct devi
 }
 #endif
 
-static const struct dev_pm_ops as3722_rtc_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(as3722_rtc_suspend, as3722_rtc_resume)
-};
+static SIMPLE_DEV_PM_OPS(as3722_rtc_pm_ops, as3722_rtc_suspend,
+			 as3722_rtc_resume);
 
 static struct platform_driver as3722_rtc_driver = {
 	.probe = as3722_rtc_probe,
_

Patches currently in -mm which might be from jg1.han@samsung.com are

maintainers-add-backlight-co-maintainers.patch
backlight-update-bd-state-fb_blank-properties-when-necessary.patch
backlight-update-backlight-status-when-necessary.patch
backlight-aat2870-remove-unnecessary-oom-messages.patch
backlight-adp8860-remove-unnecessary-oom-messages.patch
backlight-adp8870-remove-unnecessary-oom-messages.patch
backlight-corgi_lcd-remove-unnecessary-oom-messages.patch
backlight-hx8357-remove-unnecessary-oom-messages.patch
backlight-ili922x-remove-unnecessary-oom-messages.patch
backlight-ili9320-remove-unnecessary-oom-messages.patch
backlight-l4f00242t03-remove-unnecessary-oom-messages.patch
backlight-lm3533_bl-remove-unnecessary-oom-messages.patch
backlight-lms283gf05-remove-unnecessary-oom-messages.patch
backlight-platform_lcd-remove-unnecessary-oom-messages.patch
backlight-tps65217_bl-remove-unnecessary-oom-messages.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
rtc-rtc-at32ap700x-remove-unnecessary-oom-messages.patch
rtc-rtc-davinci-remove-unnecessary-oom-messages.patch
rtc-rtc-ds1390-remove-unnecessary-oom-messages.patch
rtc-rtc-moxart-remove-unnecessary-oom-messages.patch
rtc-rtc-nuc900-remove-unnecessary-oom-messages.patch
rtc-rtc-pm8xxx-remove-unnecessary-oom-messages.patch
rtc-rtc-rx8025-remove-unnecessary-oom-messages.patch
rtc-rtc-sirfsoc-remove-unnecessary-oom-messages.patch
rtc-rtc-lpc32xx-remove-unnecessary-oom-messages.patch
rtc-rtc-spear-remove-unnecessary-oom-messages.patch
rtc-rtc-coh901331-use-devm_ioremap_resource.patch
rtc-rtc-davinci-use-devm_ioremap_resource.patch
rtc-rtc-vt8500-use-devm_ioremap_resource.patch
rtc-rtc-jz4740-use-devm_ioremap_resource.patch
drivers-rtc-rtc-as3722c-use-simple_dev_pm_ops-macro.patch
drivers-rtc-rtc-palmasc-use-simple_dev_pm_ops-macro.patch
linux-next.patch

