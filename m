From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch removed from -mm tree
Date: Mon, 17 Dec 2012 15:46:02 -0800
Message-ID: <20121217234603.8CE6620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:37724 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab2LQXqG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 18:46:06 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so354736wey.3
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 15:46:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, yongjun_wei@trendmicro.com.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-avoid-calling-platform_device_put-twice-in-test_init-fix
has been removed from the -mm tree.  Its filename was
     rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch

This patch was dropped because it was folded into rtc-avoid-calling-platform_device_put-twice-in-test_init.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-avoid-calling-platform_device_put-twice-in-test_init-fix

improve label naming

Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-test.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-test.c~rtc-avoid-calling-platform_device_put-twice-in-test_init-fix drivers/rtc/rtc-test.c
--- a/drivers/rtc/rtc-test.c~rtc-avoid-calling-platform_device_put-twice-in-test_init-fix
+++ a/drivers/rtc/rtc-test.c
@@ -152,24 +152,24 @@ static int __init test_init(void)
 
 	if ((test1 = platform_device_alloc("rtc-test", 1)) == NULL) {
 		err = -ENOMEM;
-		goto exit_free_test0;
+		goto exit_put_test0;
 	}
 
 	if ((err = platform_device_add(test0)))
-		goto exit_free_test1;
+		goto exit_put_test1;
 
 	if ((err = platform_device_add(test1)))
-		goto exit_device_unregister;
+		goto exit_del_test0;
 
 	return 0;
 
-exit_device_unregister:
+exit_del_test0:
 	platform_device_del(test0);
 
-exit_free_test1:
+exit_put_test1:
 	platform_device_put(test1);
 
-exit_free_test0:
+exit_put_test0:
 	platform_device_put(test0);
 
 exit_driver_unregister:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
create-non-empty-arch-x86-include-uapi-asm-files.patch
mm-memoryc-suppress-warning.patch
lseek-the-whence-argument-is-called-whence.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions.patch
backlight-add-of_find_backlight_by_node-function.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch

