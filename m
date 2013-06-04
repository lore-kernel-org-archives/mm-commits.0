From: akpm@linux-foundation.org
Subject: + backlight-convert-from-legacy-pm-ops-to-dev_pm_ops.patch added
 to -mm tree
Date: Tue, 04 Jun 2013 13:17:45 -0700
Message-ID: <51ae4b69.2FmSvD6cNEO8hC7V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51066 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab3FDURq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jun 2013 16:17:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shuahkhan@gmail.com, jg1.han@samsung.com, shuah.kh@samsung.com

Subject: + backlight-convert-from-legacy-pm-ops-to-dev_pm_ops.patch added to -mm tree
To: shuah.kh@samsung.com,jg1.han@samsung.com,shuahkhan@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 04 Jun 2013 13:17:45 -0700


The patch titled
     Subject: backlight: convert from legacy pm ops to dev_pm_ops
has been added to the -mm tree.  Its filename is
     backlight-convert-from-legacy-pm-ops-to-dev_pm_ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shuah Khan <shuah.kh@samsung.com>
Subject: backlight: convert from legacy pm ops to dev_pm_ops

Convert drivers/video/backlight/class to use dev_pm_ops for power
management and remove Legacy PM ops hooks.  With this change, backlight
class registers suspend/resume callbacks via class->pm (dev_pm_ops)
instead of Legacy class->suspend/resume.  When __device_suspend() runs
call-backs, it will find class->pm ops for the backlight class.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Cc: Shuah Khan <shuahkhan@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/backlight.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/video/backlight/backlight.c~backlight-convert-from-legacy-pm-ops-to-dev_pm_ops drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~backlight-convert-from-legacy-pm-ops-to-dev_pm_ops
+++ a/drivers/video/backlight/backlight.c
@@ -208,7 +208,7 @@ static ssize_t backlight_show_actual_bri
 
 static struct class *backlight_class;
 
-static int backlight_suspend(struct device *dev, pm_message_t state)
+static int backlight_suspend(struct device *dev)
 {
 	struct backlight_device *bd = to_backlight_device(dev);
 
@@ -236,6 +236,9 @@ static int backlight_resume(struct devic
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(backlight_class_dev_pm_ops, backlight_suspend,
+			 backlight_resume);
+
 static void bl_device_release(struct device *dev)
 {
 	struct backlight_device *bd = to_backlight_device(dev);
@@ -489,8 +492,7 @@ static int __init backlight_class_init(v
 	}
 
 	backlight_class->dev_attrs = bl_device_attributes;
-	backlight_class->suspend = backlight_suspend;
-	backlight_class->resume = backlight_resume;
+	backlight_class->pm = &backlight_class_dev_pm_ops;
 	return 0;
 }
 
_

Patches currently in -mm which might be from shuah.kh@samsung.com are

linux-next.patch
backlight-convert-from-legacy-pm-ops-to-dev_pm_ops.patch
drivers-rtc-class-convert-from-legacy-pm-ops-to-dev_pm_ops.patch

