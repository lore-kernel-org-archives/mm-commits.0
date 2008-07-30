From: akpm@linux-foundation.org
Subject: - rtc-dont-return-ebusy-when-mutex_lock_interruptible-fails.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:14:40 -0700
Message-ID: <200807301914.m6UJEeoe010925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496AbYG3TPa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:15:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     rtc: don't return -EBUSY when mutex_lock_interruptible() fails
has been removed from the -mm tree.  Its filename was
     rtc-dont-return-ebusy-when-mutex_lock_interruptible-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: don't return -EBUSY when mutex_lock_interruptible() fails
From: David Brownell <dbrownell@users.sourceforge.net>

It was pointed out that the RTC framework handles its mutex locks oddly
...  returning -EBUSY when interrupted.  This fixes that by returning the
value of mutex_lock_interruptible() (i.e.  -EINTR).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |   10 +++++-----
 drivers/rtc/rtc-dev.c   |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/interface.c~rtc-dont-return-ebusy-when-mutex_lock_interruptible-fails drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-dont-return-ebusy-when-mutex_lock_interruptible-fails
+++ a/drivers/rtc/interface.c
@@ -20,7 +20,7 @@ int rtc_read_time(struct rtc_device *rtc
 
 	err = mutex_lock_interruptible(&rtc->ops_lock);
 	if (err)
-		return -EBUSY;
+		return err;
 
 	if (!rtc->ops)
 		err = -ENODEV;
@@ -46,7 +46,7 @@ int rtc_set_time(struct rtc_device *rtc,
 
 	err = mutex_lock_interruptible(&rtc->ops_lock);
 	if (err)
-		return -EBUSY;
+		return err;
 
 	if (!rtc->ops)
 		err = -ENODEV;
@@ -66,7 +66,7 @@ int rtc_set_mmss(struct rtc_device *rtc,
 
 	err = mutex_lock_interruptible(&rtc->ops_lock);
 	if (err)
-		return -EBUSY;
+		return err;
 
 	if (!rtc->ops)
 		err = -ENODEV;
@@ -106,7 +106,7 @@ static int rtc_read_alarm_internal(struc
 
 	err = mutex_lock_interruptible(&rtc->ops_lock);
 	if (err)
-		return -EBUSY;
+		return err;
 
 	if (rtc->ops == NULL)
 		err = -ENODEV;
@@ -293,7 +293,7 @@ int rtc_set_alarm(struct rtc_device *rtc
 
 	err = mutex_lock_interruptible(&rtc->ops_lock);
 	if (err)
-		return -EBUSY;
+		return err;
 
 	if (!rtc->ops)
 		err = -ENODEV;
diff -puN drivers/rtc/rtc-dev.c~rtc-dont-return-ebusy-when-mutex_lock_interruptible-fails drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-dont-return-ebusy-when-mutex_lock_interruptible-fails
+++ a/drivers/rtc/rtc-dev.c
@@ -221,7 +221,7 @@ static long rtc_dev_ioctl(struct file *f
 
 	err = mutex_lock_interruptible(&rtc->ops_lock);
 	if (err)
-		return -EBUSY;
+		return err;
 
 	/* check that the calling task has appropriate permissions
 	 * for certain ioctls. doing this check here is useful
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
linux-next.patch
git-mtd.patch
mtd-dataflash-otp-support.patch
spi-new-orion_spi-driver.patch
spi-new-orion_spi-driver-fixes.patch
genirq-better-warning-on-irqchip-set_type-failure.patch
rtc-ds1307-alarm-support-for-ds1337-ds1339.patch
rtc-remove-some-nop-open-release-methods.patch
legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch

