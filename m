From: akpm@linux-foundation.org
Subject: + asm-generic-gpioh-pull-in-linux-kernelh-for-might_sleep.patch added to -mm tree
Date: Wed, 30 Sep 2009 12:24:04 -0700
Message-ID: <200909301924.n8UJO40p021176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751629AbZI3TYu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 15:24:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org


The patch titled
     asm-generic/gpio.h: pull in linux/kernel.h for might_sleep()
has been added to the -mm tree.  Its filename is
     asm-generic-gpioh-pull-in-linux-kernelh-for-might_sleep.patch

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

const-constify-remaining-file_operations.patch
asm-generic-gpioh-pull-in-linux-kernelh-for-might_sleep.patch
linux-next.patch
mfd-adp5520-multifunction-lcd-backlight-and-keypad-input-device-driver.patch
fbdev-bfin-lq035q1-fb-new-blackfin-landscape-lcd-ez-extender-driver.patch
fbdev-bfin-t350mcqb-fb-handle-all-resources-in-suspend-resume.patch
fbdev-bfin-t350mcqb-fb-fix-lcd-dimensions.patch

