From: akpm@linux-foundation.org
Subject: + rtc-remove-some-nop-open-release-methods.patch added to -mm tree
Date: Tue, 29 Jul 2008 17:26:42 -0700
Message-ID: <200807300026.m6U0Qgtg030040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753182AbYG3A05 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 20:26:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, a.zummo@towertech.it


The patch titled
     rtc: remove some NOP open/release methods
has been added to the -mm tree.  Its filename is
     rtc-remove-some-nop-open-release-methods.patch

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
Subject: rtc: remove some NOP open/release methods
From: David Brownell <dbrownell@users.sourceforge.net>

Remove NOP methods from rtc-pl030 and rtc-pl031 drivers;
this is pure wasted code.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pl030.c |   11 -----------
 drivers/rtc/rtc-pl031.c |   14 --------------
 2 files changed, 25 deletions(-)

diff -puN drivers/rtc/rtc-pl030.c~rtc-remove-some-nop-open-release-methods drivers/rtc/rtc-pl030.c
--- a/drivers/rtc/rtc-pl030.c~rtc-remove-some-nop-open-release-methods
+++ a/drivers/rtc/rtc-pl030.c
@@ -34,15 +34,6 @@ static irqreturn_t pl030_interrupt(int i
 	return IRQ_HANDLED;
 }
 
-static int pl030_open(struct device *dev)
-{
-	return 0;
-}
-
-static void pl030_release(struct device *dev)
-{
-}
-
 static int pl030_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 {
 	return -ENOIOCTLCMD;
@@ -104,8 +95,6 @@ static int pl030_set_time(struct device 
 }
 
 static const struct rtc_class_ops pl030_ops = {
-	.open		= pl030_open,
-	.release	= pl030_release,
 	.ioctl		= pl030_ioctl,
 	.read_time	= pl030_read_time,
 	.set_time	= pl030_set_time,
diff -puN drivers/rtc/rtc-pl031.c~rtc-remove-some-nop-open-release-methods drivers/rtc/rtc-pl031.c
--- a/drivers/rtc/rtc-pl031.c~rtc-remove-some-nop-open-release-methods
+++ a/drivers/rtc/rtc-pl031.c
@@ -45,18 +45,6 @@ static irqreturn_t pl031_interrupt(int i
 	return IRQ_HANDLED;
 }
 
-static int pl031_open(struct device *dev)
-{
-	/*
-	 * We request IRQ in pl031_probe, so nothing to do here...
-	 */
-	return 0;
-}
-
-static void pl031_release(struct device *dev)
-{
-}
-
 static int pl031_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 {
 	struct pl031_local *ldata = dev_get_drvdata(dev);
@@ -118,8 +106,6 @@ static int pl031_set_alarm(struct device
 }
 
 static const struct rtc_class_ops pl031_ops = {
-	.open = pl031_open,
-	.release = pl031_release,
 	.ioctl = pl031_ioctl,
 	.read_time = pl031_read_time,
 	.set_time = pl031_set_time,
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

rtc-dont-return-ebusy-when-mutex_lock_interruptible-fails.patch
linux-next.patch
mtd-dataflash-bugfix-binary-page-sizes-now-handled-v3.patch
mtd-dataflash-otp-support.patch
spi-new-orion_spi-driver.patch
genirq-better-warning-on-irqchip-set_type-failure.patch
rtc-ds1307-alarm-support-for-ds1337-ds1339.patch
rtc-remove-some-nop-open-release-methods.patch
legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch

