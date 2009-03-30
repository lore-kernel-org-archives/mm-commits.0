From: akpm@linux-foundation.org
Subject: [merged] mtd-we-dont-need-no-misc-devices.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:06:02 -0700
Message-ID: <200903301906.n2UJ62HW018925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759169AbZC3TKM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:10:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: we don't need no misc devices
has been removed from the -mm tree.  Its filename was
     mtd-we-dont-need-no-misc-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: we don't need no misc devices
From: David Brownell <dbrownell@users.sourceforge.net>

Remove <linux/miscdevice.h> from various drivers which don't actually use
any of its contents.  There are still a number of these left in
arch-specific bits of the tree.

(Found by diffing results of "grep -rl" for linux/miscdevice.h and for
misc_register, examining the differences, and verifying removals with a
build test.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/doc2000.c     |    1 -
 drivers/mtd/devices/doc2001.c     |    1 -
 drivers/mtd/devices/doc2001plus.c |    1 -
 drivers/mtd/devices/docecc.c      |    1 -
 drivers/mtd/inftlmount.c          |    1 -
 drivers/mtd/nftlcore.c            |    1 -
 6 files changed, 6 deletions(-)

diff -puN drivers/mtd/devices/doc2000.c~mtd-we-dont-need-no-misc-devices drivers/mtd/devices/doc2000.c
--- a/drivers/mtd/devices/doc2000.c~mtd-we-dont-need-no-misc-devices
+++ a/drivers/mtd/devices/doc2000.c
@@ -10,7 +10,6 @@
 #include <asm/errno.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <linux/miscdevice.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
diff -puN drivers/mtd/devices/doc2001.c~mtd-we-dont-need-no-misc-devices drivers/mtd/devices/doc2001.c
--- a/drivers/mtd/devices/doc2001.c~mtd-we-dont-need-no-misc-devices
+++ a/drivers/mtd/devices/doc2001.c
@@ -10,7 +10,6 @@
 #include <asm/errno.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <linux/miscdevice.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/init.h>
diff -puN drivers/mtd/devices/doc2001plus.c~mtd-we-dont-need-no-misc-devices drivers/mtd/devices/doc2001plus.c
--- a/drivers/mtd/devices/doc2001plus.c~mtd-we-dont-need-no-misc-devices
+++ a/drivers/mtd/devices/doc2001plus.c
@@ -14,7 +14,6 @@
 #include <asm/errno.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <linux/miscdevice.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/init.h>
diff -puN drivers/mtd/devices/docecc.c~mtd-we-dont-need-no-misc-devices drivers/mtd/devices/docecc.c
--- a/drivers/mtd/devices/docecc.c~mtd-we-dont-need-no-misc-devices
+++ a/drivers/mtd/devices/docecc.c
@@ -26,7 +26,6 @@
 #include <asm/errno.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <linux/miscdevice.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/init.h>
diff -puN drivers/mtd/inftlmount.c~mtd-we-dont-need-no-misc-devices drivers/mtd/inftlmount.c
--- a/drivers/mtd/inftlmount.c~mtd-we-dont-need-no-misc-devices
+++ a/drivers/mtd/inftlmount.c
@@ -28,7 +28,6 @@
 #include <asm/errno.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <linux/miscdevice.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/init.h>
diff -puN drivers/mtd/nftlcore.c~mtd-we-dont-need-no-misc-devices drivers/mtd/nftlcore.c
--- a/drivers/mtd/nftlcore.c~mtd-we-dont-need-no-misc-devices
+++ a/drivers/mtd/nftlcore.c
@@ -15,7 +15,6 @@
 #include <asm/errno.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <linux/miscdevice.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/init.h>
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
linux-next.patch
blackfin-spi-driver-fix-erroneous-spi-clock-divisor-calculation.patch
blackfin-spi-driver-remove-useless-asm-cplbinith.patch
blackfin-spi-driver-use-len_in_bytes-when-we-care-about-the-number-of-bytes-transferred.patch
blackfin-spi-driver-pass-dma-overflow-error-to-the-higher-level.patch
blackfin-spi-driver-unify-duplicated-code-in-dma-read-write-paths.patch
blackfin-spi-driver-drop-bogus-cast-and-touchup-dma-label.patch
blackfin-spi-driver-get-dma-working-for-spi-flashes.patch
blackfin-spi-driver-fix-bug-spi-controller-driver-does-not-assert-deassert-cs-correctly.patch
blackfin-spi-driver-fix-bug-correct-usage-of-struct-spi_transfercs_change.patch
spi-limit-reaches-1-tested-0.patch
rtc-ds1307-true-smbus-compatibility.patch
gpio-gpio_requestfree-now-required-feature-removal.patch

