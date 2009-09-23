From: akpm@linux-foundation.org
Subject: [merged] spitz-fix-touchscreen-max-presure.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:04:02 -0700
Message-ID: <200909232004.n8NK42k0020412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753686AbZIWUEg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:04:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, eric.y.miao@gmail.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     spitz: fix touchscreen max presure
has been removed from the -mm tree.  Its filename was
     spitz-fix-touchscreen-max-presure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -423,6 +423,7 @@ static struct ads7846_platform_data spit
 	.vref_delay_usecs	= 100,
 	.x_plate_ohms		= 419,
 	.y_plate_ohms		= 486,
+	.pressure_max		= 1024,
 	.gpio_pendown		= SPITZ_GPIO_TP_INT,
 	.wait_for_sync		= spitz_wait_for_hsync,
 };
_

Patches currently in -mm which might be from pavel@ucw.cz are

origin.patch
linux-next.patch
synaptics-touchscreen-for-htc-dream-check-that-smbus-is-available.patch
time-add-function-to-convert-between-calendar-time-and-broken-down-time-for-universal-use.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch
fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size.patch

