From: akpm@linux-foundation.org
Subject: [merged] asm-generic-gpioh-pull-in-linux-kernelh-for-might_sleep.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:38:03 -0700
Message-ID: <200910051838.n95Ic35m016191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754521AbZJESjK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:39:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     asm-generic/gpio.h: pull in linux/kernel.h for might_sleep()
has been removed from the -mm tree.  Its filename was
     asm-generic-gpioh-pull-in-linux-kernelh-for-might_sleep.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm-generic/gpio.h: pull in linux/kernel.h for might_sleep()
From: Mike Frysinger <vapier@gentoo.org>

The asm-generic/gpio.h header uses the might_sleep() macro but doesn't
include the header for it, so any source code that might include
linux/gpio.h before linux/kernel.h can easily lead to a build failure.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/gpio.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-generic/gpio.h~asm-generic-gpioh-pull-in-linux-kernelh-for-might_sleep include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~asm-generic-gpioh-pull-in-linux-kernelh-for-might_sleep
+++ a/include/asm-generic/gpio.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_GENERIC_GPIO_H
 #define _ASM_GENERIC_GPIO_H
 
+#include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-next.patch
mfd-adp5520-multifunction-lcd-backlight-and-keypad-input-device-driver.patch
serial-fit-blackfin-uart-over-sport-driver-into-common-uart-infrastructure.patch
fbdev-bfin-lq035q1-fb-new-blackfin-landscape-lcd-ez-extender-driver.patch
fbdev-bfin-t350mcqb-fb-handle-all-resources-in-suspend-resume.patch
fbdev-bfin-t350mcqb-fb-fix-lcd-dimensions.patch

