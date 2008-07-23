From: akpm@linux-foundation.org
Subject: - rtc-push-the-bkl-down-into-the-driver-ioctl-method-fix.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:34:57 -0700
Message-ID: <200807232347.m6NNlZRt018555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752759AbYGWXru (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:47:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     drivers/char/rtc.c: fix build failure
has been removed from the -mm tree.  Its filename was
     rtc-push-the-bkl-down-into-the-driver-ioctl-method-fix.patch

This patch was dropped because it was folded into rtc-push-the-bkl-down-into-the-driver-ioctl-method.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/rtc.c: fix build failure
From: Li Zefan <lizf@cn.fujitsu.com>

This patch caused build failure:
	rtc-push-the-bkl-down-into-the-driver-ioctl-method.patch

drivers/char/rtc.c:721: error: conflicting types for `rtc_ioctl'
drivers/char/rtc.c:146: error: previous declaration of `rtc_ioctl' was here

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rtc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/rtc.c~rtc-push-the-bkl-down-into-the-driver-ioctl-method-fix drivers/char/rtc.c
--- a/drivers/char/rtc.c~rtc-push-the-bkl-down-into-the-driver-ioctl-method-fix
+++ a/drivers/char/rtc.c
@@ -145,7 +145,7 @@ static DEFINE_TIMER(rtc_irq_timer, rtc_d
 static ssize_t rtc_read(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos);
 
-static int rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 
 #ifdef RTC_IRQ
 static unsigned int rtc_poll(struct file *file, poll_table *wait);
diff -puN /dev/null /dev/null
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
rtc-push-the-bkl-down-into-the-driver-ioctl-method.patch
rtc-push-the-bkl-down-into-the-driver-ioctl-method-fix.patch

