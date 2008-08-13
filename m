From: akpm@linux-foundation.org
Subject: - revert-rtc-cdev-lock_kernel-pushdown.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:52:19 -0700
Message-ID: <200808130852.m7D8qJoL008197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754315AbYHMIw5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 04:52:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, alessandro.zummo@towertech.it, corbet@lwn.net, mm-commits@vger.kernel.org


The patch titled
     revert "rtc: cdev lock_kernel() pushdown"
has been removed from the -mm tree.  Its filename was
     revert-rtc-cdev-lock_kernel-pushdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "rtc: cdev lock_kernel() pushdown"
From: David Brownell <dbrownell@users.sourceforge.net>

Revert "rtc: cdev lock_kernel() pushdown" patch
(51a776fa7a7997e726d4a478eda0854c6f9143bd).  The RTC framework does not
need BKL protection.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-dev.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/rtc-dev.c~revert-rtc-cdev-lock_kernel-pushdown drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~revert-rtc-cdev-lock_kernel-pushdown
+++ a/drivers/rtc/rtc-dev.c
@@ -13,7 +13,6 @@
 
 #include <linux/module.h>
 #include <linux/rtc.h>
-#include <linux/smp_lock.h>
 #include "rtc-core.h"
 
 static dev_t rtc_devt;
@@ -27,11 +26,8 @@ static int rtc_dev_open(struct inode *in
 					struct rtc_device, char_dev);
 	const struct rtc_class_ops *ops = rtc->ops;
 
-	lock_kernel();
-	if (test_and_set_bit_lock(RTC_DEV_BUSY, &rtc->flags)) {
-		err = -EBUSY;
-		goto out;
-	}
+	if (test_and_set_bit_lock(RTC_DEV_BUSY, &rtc->flags))
+		return -EBUSY;
 
 	file->private_data = rtc;
 
@@ -41,13 +37,11 @@ static int rtc_dev_open(struct inode *in
 		rtc->irq_data = 0;
 		spin_unlock_irq(&rtc->irq_lock);
 
-		goto out;
+		return 0;
 	}
 
 	/* something has gone wrong */
 	clear_bit_unlock(RTC_DEV_BUSY, &rtc->flags);
-out:
-	unlock_kernel();
 	return err;
 }
 
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

linux-next.patch
usb-hso-driver-fix-kconfig.patch
rtc-ds1307-alarm-support-for-ds1337-ds1339.patch
rtc-remove-some-nop-open-release-methods.patch
legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch
rtc-file-close-consistently-disables-repeating-irqs.patch
irq-warn-about-irqf_disabledirqf_shared.patch

