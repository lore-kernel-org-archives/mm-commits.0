From: akpm@linux-foundation.org
Subject: [folded-merged] drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch removed from -mm tree
Date: Mon, 17 Dec 2012 15:42:39 -0800
Message-ID: <20121217234240.F249E200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f201.google.com ([209.85.217.201]:49772 "EHLO
	mail-lb0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab2LQXtL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 18:49:11 -0500
Received: by mail-lb0-f201.google.com with SMTP id m4so6140lbo.4
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 15:49:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Milo.Kim@ti.com, bryan.wu@canonical.com, milo.kim@ti.com, rpurdie@rpsys.net, thierry.reding@avionic-design.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch

This patch was dropped because it was folded into drivers-video-backlight-lp855x_blc-use-generic-pwm-functions.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix

coding-style simplification, per Thierry

Cc: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Bryan Wu <bryan.wu@canonical.com>
Cc: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp855x_bl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/video/backlight/lp855x_bl.c~drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -139,7 +139,10 @@ static void lp855x_pwm_ctrl(struct lp855
 	}
 
 	pwm_config(lp->pwm, duty, period);
-	duty == 0 ? pwm_disable(lp->pwm) : pwm_enable(lp->pwm);
+	if (duty)
+		pwm_enable(lp->pwm);
+	else
+		pwm_disable(lp->pwm);
 }
 
 static int lp855x_bl_update_status(struct backlight_device *bl)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
create-non-empty-arch-x86-include-uapi-asm-files.patch
mm-memoryc-suppress-warning.patch
lseek-the-whence-argument-is-called-whence.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions.patch
backlight-add-of_find_backlight_by_node-function-fix.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch

