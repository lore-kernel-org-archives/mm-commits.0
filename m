From: akpm@linux-foundation.org
Subject: - gpio-fix-build-on-config_gpio_sysfs=n.patch removed from -mm tree
Date: Tue, 29 Jul 2008 13:30:10 -0700
Message-ID: <200807292030.m6TKUA7F019797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752618AbYG2UaU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 16:30:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     gpio: fix build on CONFIG_GPIO_SYSFS=n
has been removed from the -mm tree.  Its filename was
     gpio-fix-build-on-config_gpio_sysfs=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

initrd-cast-initrd_start-to-void.patch
linux-next.patch
mtdpart-handle-remaining-checkpatch-findings.patch

