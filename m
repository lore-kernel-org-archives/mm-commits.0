From: akpm@linux-foundation.org
Subject: - driver-ip27-rtc-convert-ioctl-to-unlocked_ioctl-v2.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:27:37 -0800
Message-ID: <200802070027.m170RI89007012@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35851 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933312AbYBGAok (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ip27-rtc: convert ioctl to unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     driver-ip27-rtc-convert-ioctl-to-unlocked_ioctl-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ip27-rtc: convert ioctl to unlocked_ioctl
From: Cyrill Gorcunov <gorcunov@gmail.com>

Convert ioctl call to unlocked_ioctl form.  It is possible (in that simple
way) due to a spinlock protection.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip27-rtc.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/char/ip27-rtc.c~driver-ip27-rtc-convert-ioctl-to-unlocked_ioctl-v2 drivers/char/ip27-rtc.c
--- a/drivers/char/ip27-rtc.c~driver-ip27-rtc-convert-ioctl-to-unlocked_ioctl-v2
+++ a/drivers/char/ip27-rtc.c
@@ -46,8 +46,8 @@
 #include <asm/sn/sn0/hub.h>
 #include <asm/sn/sn_private.h>
 
-static int rtc_ioctl(struct inode *inode, struct file *file,
-		     unsigned int cmd, unsigned long arg);
+static long rtc_ioctl(struct file *filp, unsigned int cmd,
+			unsigned long arg);
 
 static int rtc_read_proc(char *page, char **start, off_t off,
                          int count, int *eof, void *data);
@@ -75,8 +75,7 @@ static unsigned long epoch = 1970;	/* ye
 static const unsigned char days_in_mo[] =
 {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
 
-static int rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		     unsigned long arg)
+static long rtc_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 
 	struct rtc_time wtime;
@@ -197,7 +196,7 @@ static int rtc_release(struct inode *ino
 
 static const struct file_operations rtc_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= rtc_ioctl,
+	.unlocked_ioctl	= rtc_ioctl,
 	.open		= rtc_open,
 	.release	= rtc_release,
 };
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
git-avr32.patch
git-dvb.patch
mount-options-fix-udf.patch
