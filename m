From: akpm@linux-foundation.org
Subject: + revert-rtc-cdev-lock_kernel-pushdown.patch added to -mm tree
Date: Wed, 06 Aug 2008 21:18:32 -0700
Message-ID: <200808070418.m774IW46031217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751513AbYHGETR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2008 00:19:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, alessandro.zummo@towertech.it, corbet@lwn.net


The patch titled
     revert "rtc: cdev lock_kernel() pushdown"
has been added to the -mm tree.  Its filename is
     revert-rtc-cdev-lock_kernel-pushdown.patch

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
Subject: revert "rtc: cdev lock_kernel() pushdown"
From: David Brownell <dbrownell@users.sourceforge.net>

Revert needless "rtc: cdev lock_kernel() pushdown" patch
(51a776fa7a7997e726d4a478eda0854c6f9143bd).  That patch added some
explicit references to the BKL, which the RTC framework does not need
to use.

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

revert-rtc-cdev-lock_kernel-pushdown.patch
linux-next.patch
rtc-ds1307-alarm-support-for-ds1337-ds1339.patch
rtc-remove-some-nop-open-release-methods.patch
legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch

