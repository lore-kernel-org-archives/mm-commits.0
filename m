From: akpm@linux-foundation.org
Subject: - rtc-assure-proper-memory-ordering-with-respect-to-rtc_dev_busy-flag.patch removed from -mm tree
Date: Fri, 07 Dec 2007 17:28:37 -0800
Message-ID: <200712080128.lB81SbJU013344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44249 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753880AbXLHB3Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 20:29:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, a.zummo@towertech.it, david-b@pacbell.net, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     RTC: assure proper memory ordering with respect to RTC_DEV_BUSY flag
has been removed from the -mm tree.  Its filename was
     rtc-assure-proper-memory-ordering-with-respect-to-rtc_dev_busy-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
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
git-hid.patch
hid-the-bit-in-hidinput_mapping_quirks-is-an-out-parameter.patch
fujitsu-application-panel-driver.patch
apanel-free-input-device-on-close.patch
apanel-change-name-of-led.patch
apanel-detach-on-shutdown.patch
apanel-use-generic-keycode-routines.patch
elantech-touchpad-driver.patch
git-ipwireless_cs.patch
git-x86.patch
