From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-pcf8523-add-low-battery-voltage-support-fix.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:27:36 -0800
Message-ID: <20130221232737.265B65A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:58089 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3BUX1i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:27:38 -0500
Received: by mail-qe0-f74.google.com with SMTP id a11so11259qen.3
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:27:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jesper.nilsson@axis.com, thierry.reding@avionic-design.de, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-pcf8523-add-low-battery-voltage-support-fix
has been removed from the -mm tree.  Its filename was
     rtc-pcf8523-add-low-battery-voltage-support-fix.patch

This patch was dropped because it was folded into rtc-pcf8523-add-low-battery-voltage-support.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-pcf8523-add-low-battery-voltage-support-fix

omit pcf8563_rtc_ioctl() if CONFIG_RTC_INTF_DEV=n

Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8523.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/rtc/rtc-pcf8523.c~rtc-pcf8523-add-low-battery-voltage-support-fix drivers/rtc/rtc-pcf8523.c
--- a/drivers/rtc/rtc-pcf8523.c~rtc-pcf8523-add-low-battery-voltage-support-fix
+++ a/drivers/rtc/rtc-pcf8523.c
@@ -251,6 +251,7 @@ static int pcf8523_rtc_set_time(struct d
 	return pcf8523_start_rtc(client);
 }
 
+#ifdef CONFIG_RTC_INTF_DEV
 static int pcf8523_rtc_ioctl(struct device *dev, unsigned int cmd,
 			     unsigned long arg)
 {
@@ -275,6 +276,9 @@ static int pcf8523_rtc_ioctl(struct devi
 		return -ENOIOCTLCMD;
 	}
 }
+#else
+#define pcf8523_rtc_ioctl NULL
+#endif
 
 static const struct rtc_class_ops pcf8523_rtc_ops = {
 	.read_time = pcf8523_rtc_read_time,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
goldfish-framebuffer-driver-fix.patch
ocfs2-remove-kfree-redundant-null-checks.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
sys_prctl-coding-style-cleanup.patch
backlight-add-lms501kf03-lcd-driver.patch
drivers-video-backlight-makefile-cleanup.patch
checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch
rtc-max77686-add-maxim-77686-driver.patch
rtc-pcf8523-add-low-battery-voltage-support.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch

