From: akpm@linux-foundation.org
Subject: + gpio-fix-build-on-config_gpio_sysfs=n.patch added to -mm tree
Date: Mon, 28 Jul 2008 13:22:14 -0700
Message-ID: <200807282022.m6SKME4S025391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752024AbYG1UW7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 16:22:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, dbrownell@users.sourceforge.net


The patch titled
     gpio: fix build on CONFIG_GPIO_SYSFS=n
has been added to the -mm tree.  Its filename is
     gpio-fix-build-on-config_gpio_sysfs=n.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: fix build on CONFIG_GPIO_SYSFS=n
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

If CONFIG_GENERIC_GPIO=y && CONFIG_GPIO_SYSFS=n, gpio_export() in
asm-generic/gpio.h refers -ENOSYS and causes build error.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/gpio.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-generic/gpio.h~gpio-fix-build-on-config_gpio_sysfs=n include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~gpio-fix-build-on-config_gpio_sysfs=n
+++ a/include/asm-generic/gpio.h
@@ -2,6 +2,7 @@
 #define _ASM_GENERIC_GPIO_H
 
 #include <linux/types.h>
+#include <linux/errno.h>
 
 #ifdef CONFIG_GPIOLIB
 
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
gpio-fix-build-on-config_gpio_sysfs=n.patch
mtd-jedec_probe-fix-sst-16-bit-chip-detection.patch
mtdpart-separate-main-loop-from-per-partition-code-in-add_mtd_partition.patch
mtdpart-handle-most-checkpatch-findings.patch
mtdpart-cleanup-and-document-the-erase-region-handling.patch
mtdpart-fix-a-division-by-zero-bug.patch
mtdpart-handle-remaining-checkpatch-findings.patch

