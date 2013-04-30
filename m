From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-atmel-pwm-blc-use-module_platform_driver_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:51:18 -0700
Message-ID: <20130430185118.729E831C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:35105 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab3D3SvT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:51:19 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so86277qcr.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:51:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/atmel-pwm-bl.c: use module_platform_driver_probe()
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-atmel-pwm-blc-use-module_platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/atmel-pwm-bl.c: use module_platform_driver_probe()

Use the module_platform_driver_probe() macro which makes the code smaller
and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/atmel-pwm-bl.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN drivers/video/backlight/atmel-pwm-bl.c~drivers-video-backlight-atmel-pwm-blc-use-module_platform_driver_probe drivers/video/backlight/atmel-pwm-bl.c
--- a/drivers/video/backlight/atmel-pwm-bl.c~drivers-video-backlight-atmel-pwm-blc-use-module_platform_driver_probe
+++ a/drivers/video/backlight/atmel-pwm-bl.c
@@ -225,17 +225,7 @@ static struct platform_driver atmel_pwm_
 	.remove = __exit_p(atmel_pwm_bl_remove),
 };
 
-static int __init atmel_pwm_bl_init(void)
-{
-	return platform_driver_probe(&atmel_pwm_bl_driver, atmel_pwm_bl_probe);
-}
-module_init(atmel_pwm_bl_init);
