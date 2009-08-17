From: akpm@linux-foundation.org
Subject: + spitz-fix-touchscreen-max-presure.patch added to -mm tree
Date: Mon, 17 Aug 2009 15:51:05 -0700
Message-ID: <200908172251.n7HMp5Jh015705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412AbZHQWvU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 18:51:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@ucw.cz, eric.y.miao@gmail.com, rmk@arm.linux.org.uk


The patch titled
     spitz: fix touchscreen max presure
has been added to the -mm tree.  Its filename is
     spitz-fix-touchscreen-max-presure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spitz: fix touchscreen max presure
From: Pavel Machek <pavel@ucw.cz>

This fixes max_pressure for spitz's touchscreen, and is requirement
for getting reasonable pressure numbers from touchscreen driver.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Cc: Russell King <rmk@arm.linux.org.uk>                                        
Cc: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-pxa/spitz.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm/mach-pxa/spitz.c~spitz-fix-touchscreen-max-presure arch/arm/mach-pxa/spitz.c
--- a/arch/arm/mach-pxa/spitz.c~spitz-fix-touchscreen-max-presure
+++ a/arch/arm/mach-pxa/spitz.c
@@ -296,6 +296,7 @@ static struct ads7846_platform_data spit
 	.vref_delay_usecs	= 100,
 	.x_plate_ohms		= 419,
 	.y_plate_ohms		= 486,
+	.pressure_max		= 1024,
 	.gpio_pendown		= SPITZ_GPIO_TP_INT,
 	.wait_for_sync		= spitz_wait_for_hsync,
 };
_

Patches currently in -mm which might be from pavel@ucw.cz are

linux-next.patch
spitz-fix-touchscreen-max-presure.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch
lis3-fix-typo.patch
lis3-add-free-fall-wakeup-function-via-platform_data.patch
lis3-add-power-management-functions.patch
lis3-add-power-management-functions-fix.patch
lis3_spi-code-cleanups.patch
framebuffer-support-for-htc-dream.patch
framebuffer-support-for-htc-dream-checkpatch-fixes.patch
time-add-function-to-convert-between-calendar-time-and-broken-down-time-for-universal-use.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch
fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size.patch

