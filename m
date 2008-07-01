From: akpm@linux-foundation.org
Subject: + spi-fix-the-read-path-in-spidev.patch added to -mm tree
Date: Tue, 01 Jul 2008 13:07:28 -0700
Message-ID: <200807012007.m61K7SMO012227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752115AbYGAUIP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 16:08:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bigeasy@linutronix.de, dbrownell@users.sourceforge.net


The patch titled
     spi: fix the read path in spidev
has been added to the -mm tree.  Its filename is
     spi-fix-the-read-path-in-spidev.patch

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
Subject: spi: fix the read path in spidev
From: Sebastian Siewior <bigeasy@linutronix.de>

This got broken by the recent "fix rmmod $spi_driver while spidev-user is
active".  I tested the rmmod & write path but didn't check the read path. 
I am sorry.  The read logic changed and spidev_sync_read() +
spidev_sync_write() do not return zero on success anymore but the number
of bytes that has been transfered over the bus.  This patch changes the
logic and copy_to_user() gets called again.

The write path returns the number of bytes which are written to the
underlying device what may be less than the requested size.  This patch
makes the same change to the read path or else we request a read of 20
bytes, get 10, don't call copy to user and report to the user that we read
10 bytes.

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spidev.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN drivers/spi/spidev.c~spi-fix-the-read-path-in-spidev drivers/spi/spidev.c
--- a/drivers/spi/spidev.c~spi-fix-the-read-path-in-spidev
+++ a/drivers/spi/spidev.c
@@ -167,14 +167,14 @@ spidev_read(struct file *filp, char __us
 
 	mutex_lock(&spidev->buf_lock);
 	status = spidev_sync_read(spidev, count);
-	if (status == 0) {
+	if (status > 0) {
 		unsigned long	missing;
 
-		missing = copy_to_user(buf, spidev->buffer, count);
-		if (count && missing == count)
+		missing = copy_to_user(buf, spidev->buffer, status);
+		if (status && missing == status)
 			status = -EFAULT;
 		else
-			status = count - missing;
+			status = status - missing;
 	}
 	mutex_unlock(&spidev->buf_lock);
 
@@ -200,8 +200,6 @@ spidev_write(struct file *filp, const ch
 	missing = copy_from_user(spidev->buffer, buf, count);
 	if (missing == 0) {
 		status = spidev_sync_write(spidev, count);
-		if (status == 0)
-			status = count;
 	} else
 		status = -EFAULT;
 	mutex_unlock(&spidev->buf_lock);
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

spi-fix-the-read-path-in-spidev.patch
add-the-carmine-fb-driver.patch
add-the-carmine-fb-driver-update.patch

