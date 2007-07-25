From: akpm@linux-foundation.org
Subject: + no-need-to-convert-file-private_data-to-rtc-device.patch added to -mm tree
Date: Tue, 24 Jul 2007 19:34:59 -0700
Message-ID: <200707250234.l6P2YxNY012986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45040 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759365AbXGYCfJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 22:35:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rongkai.zhan@windriver.com, a.zummo@towertech.it


The patch titled
     rtc-dev: no need to convert file->private_data to rtc device
has been added to the -mm tree.  Its filename is
     no-need-to-convert-file-private_data-to-rtc-device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc-dev: no need to convert file->private_data to rtc device
From: Mark Zhan <rongkai.zhan@windriver.com>

In rtc-dev.c, when a rtc device is opened, file->private_data is already
attached with the rtc device pointer, so there is no need to call
to_rtc_device() to convert file->private_data to a rtc device pointer.

Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-dev.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-dev.c~no-need-to-convert-file-private_data-to-rtc-device drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~no-need-to-convert-file-private_data-to-rtc-device
+++ a/drivers/rtc/rtc-dev.c
@@ -142,7 +142,7 @@ static int set_uie(struct rtc_device *rt
 static ssize_t
 rtc_dev_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
-	struct rtc_device *rtc = to_rtc_device(file->private_data);
+	struct rtc_device *rtc = file->private_data;
 
 	DECLARE_WAITQUEUE(wait, current);
 	unsigned long data;
@@ -196,7 +196,7 @@ rtc_dev_read(struct file *file, char __u
 
 static unsigned int rtc_dev_poll(struct file *file, poll_table *wait)
 {
-	struct rtc_device *rtc = to_rtc_device(file->private_data);
+	struct rtc_device *rtc = file->private_data;
 	unsigned long data;
 
 	poll_wait(file, &rtc->irq_queue, wait);
@@ -403,7 +403,7 @@ static int rtc_dev_ioctl(struct inode *i
 
 static int rtc_dev_release(struct inode *inode, struct file *file)
 {
-	struct rtc_device *rtc = to_rtc_device(file->private_data);
+	struct rtc_device *rtc = file->private_data;
 
 #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
 	clear_uie(rtc);
@@ -417,7 +417,7 @@ static int rtc_dev_release(struct inode 
 
 static int rtc_dev_fasync(int fd, struct file *file, int on)
 {
-	struct rtc_device *rtc = to_rtc_device(file->private_data);
+	struct rtc_device *rtc = file->private_data;
 	return fasync_helper(fd, file, on, &rtc->async_queue);
 }
 
_

Patches currently in -mm which might be from rongkai.zhan@windriver.com are

no-need-to-convert-file-private_data-to-rtc-device.patch
