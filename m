From: akpm@linux-foundation.org
Subject: - rtc-remove-some-nop-open-release-methods.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:15:20 -0700
Message-ID: <200810182315.m9INFKPX028599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751785AbYJRXPr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:15:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     rtc: remove some NOP open/release methods
has been removed from the -mm tree.  Its filename was
     rtc-remove-some-nop-open-release-methods.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
