From: akpm@linux-foundation.org
Subject: + ucb1x00-do-not-access-input_dev-private-directly.patch added to -mm tree
Date: Wed, 09 May 2007 17:48:36 -0700
Message-ID: <200705100048.l4A0mawr008323@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856AbXEJAtR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 20:49:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dtor@insightbb.com, dtor@mail.ru, rmk@arm.linux.org.uk, rpurdie@rpsys.net


The patch titled
     ucb1x00: do not access input_dev->private directly
has been added to the -mm tree.  Its filename is
     ucb1x00-do-not-access-input_dev-private-directly.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ucb1x00: do not access input_dev->private directly
From: Dmitry Torokhov <dtor@insightbb.com>

Use input_get_drvdata() and input_set_drvdata() helpers to do that.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/ucb1x00-ts.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/mfd/ucb1x00-ts.c~ucb1x00-do-not-access-input_dev-private-directly drivers/mfd/ucb1x00-ts.c
--- a/drivers/mfd/ucb1x00-ts.c~ucb1x00-do-not-access-input_dev-private-directly
+++ a/drivers/mfd/ucb1x00-ts.c
@@ -300,7 +300,7 @@ static void ucb1x00_ts_irq(int idx, void
 
 static int ucb1x00_ts_open(struct input_dev *idev)
 {
-	struct ucb1x00_ts *ts = idev->private;
+	struct ucb1x00_ts *ts = input_get_drvdata(idev);
 	int ret = 0;
 
 	BUG_ON(ts->rtask);
@@ -337,7 +337,7 @@ static int ucb1x00_ts_open(struct input_
  */
 static void ucb1x00_ts_close(struct input_dev *idev)
 {
-	struct ucb1x00_ts *ts = idev->private;
+	struct ucb1x00_ts *ts = input_get_drvdata(idev);
 
 	if (ts->rtask)
 		kthread_stop(ts->rtask);
@@ -389,7 +389,6 @@ static int ucb1x00_ts_add(struct ucb1x00
 	ts->idev = idev;
 	ts->adcsync = adcsync ? UCB_SYNC : UCB_NOSYNC;
 
-	idev->private    = ts;
 	idev->name       = "Touchscreen panel";
 	idev->id.product = ts->ucb->id;
 	idev->open       = ucb1x00_ts_open;
@@ -400,6 +399,8 @@ static int ucb1x00_ts_add(struct ucb1x00
 	__set_bit(ABS_Y, idev->absbit);
 	__set_bit(ABS_PRESSURE, idev->absbit);
 
+	input_set_drvdata(idev, ts);
+
 	err = input_register_device(idev);
 	if (err)
 		goto fail;
_

Patches currently in -mm which might be from dtor@insightbb.com are

origin.patch
drivers-hwmon-switch-to-using-input_dev-devparent.patch
git-input.patch
ucb1x00-do-not-access-input_dev-private-directly.patch
