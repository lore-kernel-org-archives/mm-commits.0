From: akpm@linux-foundation.org
Subject: - spi-fix-the-read-path-in-spidev.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:05:03 -0700
Message-ID: <200807070305.m67353Eo004788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753247AbYGGDF1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:05:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@linutronix.de, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: fix the read path in spidev
has been removed from the -mm tree.  Its filename was
     spi-fix-the-read-path-in-spidev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: remove test of known-to-be-zero local]
Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
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
+		if (missing == status)
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

linux-next.patch
add-the-carmine-fb-driver.patch
add-the-carmine-fb-driver-update.patch

