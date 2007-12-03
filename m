From: akpm@linux-foundation.org
Subject: + rtc-assure-proper-memory-ordering-with-respect-to-rtc_dev_busy-flag.patch added to -mm tree
Date: Mon, 03 Dec 2007 13:17:34 -0800
Message-ID: <200712032117.lB3LHYjr018074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59361 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806AbXLCVR5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2007 16:17:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz, a.zummo@towertech.it, david-b@pacbell.net, nickpiggin@yahoo.com.au


The patch titled
     RTC: assure proper memory ordering with respect to RTC_DEV_BUSY flag
has been added to the -mm tree.  Its filename is
     rtc-assure-proper-memory-ordering-with-respect-to-rtc_dev_busy-flag.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: RTC: assure proper memory ordering with respect to RTC_DEV_BUSY flag
From: Jiri Kosina <jkosina@suse.cz>

We must make sure that the RTC_DEV_BUSY flag has proper lock semantics,
i.e.  that the RTC_DEV_BUSY stores clearing the flag don't get reordered
before the preceeding stores and loads and vice versa.

Spotted by Nick Piggin.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |    4 ++--
 drivers/rtc/rtc-dev.c   |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/interface.c~rtc-assure-proper-memory-ordering-with-respect-to-rtc_dev_busy-flag drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-assure-proper-memory-ordering-with-respect-to-rtc_dev_busy-flag
+++ a/drivers/rtc/interface.c
@@ -293,7 +293,7 @@ int rtc_irq_register(struct rtc_device *
 		return -EINVAL;
 
 	/* Cannot register while the char dev is in use */
-	if (test_and_set_bit(RTC_DEV_BUSY, &rtc->flags))
+	if (test_and_set_bit_lock(RTC_DEV_BUSY, &rtc->flags))
 		return -EBUSY;
 
 	spin_lock_irq(&rtc->irq_task_lock);
@@ -303,7 +303,7 @@ int rtc_irq_register(struct rtc_device *
 	}
 	spin_unlock_irq(&rtc->irq_task_lock);
 
-	clear_bit(RTC_DEV_BUSY, &rtc->flags);
+	clear_bit_unlock(RTC_DEV_BUSY, &rtc->flags);
 
 	return retval;
 }
diff -puN drivers/rtc/rtc-dev.c~rtc-assure-proper-memory-ordering-with-respect-to-rtc_dev_busy-flag drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-assure-proper-memory-ordering-with-respect-to-rtc_dev_busy-flag
+++ a/drivers/rtc/rtc-dev.c
@@ -26,7 +26,7 @@ static int rtc_dev_open(struct inode *in
 					struct rtc_device, char_dev);
 	const struct rtc_class_ops *ops = rtc->ops;
 
-	if (test_and_set_bit(RTC_DEV_BUSY, &rtc->flags))
+	if (test_and_set_bit_lock(RTC_DEV_BUSY, &rtc->flags))
 		return -EBUSY;
 
 	file->private_data = rtc;
@@ -41,7 +41,7 @@ static int rtc_dev_open(struct inode *in
 	}
 
 	/* something has gone wrong */
-	clear_bit(RTC_DEV_BUSY, &rtc->flags);
+	clear_bit_unlock(RTC_DEV_BUSY, &rtc->flags);
 	return err;
 }
 
@@ -402,7 +402,7 @@ static int rtc_dev_release(struct inode 
 	if (rtc->ops->release)
 		rtc->ops->release(rtc->dev.parent);
 
-	clear_bit(RTC_DEV_BUSY, &rtc->flags);
+	clear_bit_unlock(RTC_DEV_BUSY, &rtc->flags);
 	return 0;
 }
 
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
rtc-assure-proper-memory-ordering-with-respect-to-rtc_dev_busy-flag.patch
git-hid.patch
fujitsu-application-panel-driver.patch
elantech-touchpad-driver.patch
git-ipwireless_cs.patch
git-x86.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch
