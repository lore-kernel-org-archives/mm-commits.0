From: akpm@linux-foundation.org
Subject: + spidev-bkl-removal.patch added to -mm tree
Date: Tue, 27 May 2008 16:07:08 -0700
Message-ID: <200805272307.m4RN78Nv017727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919AbYE0XHm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 19:07:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, dbrownell@users.sourceforge.net


The patch titled
     spidev: BKL removal
has been added to the -mm tree.  Its filename is
     spidev-bkl-removal.patch

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
Subject: spidev: BKL removal
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Another step to removing ->ioctl and to removing the BKL

[dbrownell@users.sourceforge.net: take final step; BKL not needed]
Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spidev.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff -puN drivers/spi/spidev.c~spidev-bkl-removal drivers/spi/spidev.c
--- a/drivers/spi/spidev.c~spidev-bkl-removal
+++ a/drivers/spi/spidev.c
@@ -230,7 +230,6 @@ static int spidev_message(struct spidev_
 	 * We walk the array of user-provided transfers, using each one
 	 * to initialize a kernel version of the same transfer.
 	 */
-	mutex_lock(&spidev->buf_lock);
 	buf = spidev->buffer;
 	total = 0;
 	for (n = n_xfers, k_tmp = k_xfers, u_tmp = u_xfers;
@@ -298,14 +297,12 @@ static int spidev_message(struct spidev_
 	status = total;
 
 done:
-	mutex_unlock(&spidev->buf_lock);
 	kfree(k_xfers);
 	return status;
 }
 
-static int
-spidev_ioctl(struct inode *inode, struct file *filp,
-		unsigned int cmd, unsigned long arg)
+static long
+spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	int			err = 0;
 	int			retval = 0;
@@ -343,6 +340,14 @@ spidev_ioctl(struct inode *inode, struct
 	if (spi == NULL)
 		return -ESHUTDOWN;
 
+	/* use the buffer lock here for triple duty:
+	 *  - prevent I/O (from us) so calling spi_setup() is safe;
+	 *  - prevent concurrent SPI_IOC_WR_* from morphing
+	 *    data fields while SPI_IOC_RD_* reads them;
+	 *  - SPI_IOC_MESSAGE needs the buffer locked "normally".
+	 */
+	mutex_lock(&spidev->buf_lock);
+
 	switch (cmd) {
 	/* read requests */
 	case SPI_IOC_RD_MODE:
@@ -458,6 +463,8 @@ spidev_ioctl(struct inode *inode, struct
 		kfree(ioc);
 		break;
 	}
+
+	mutex_unlock(&spidev->buf_lock);
 	spi_dev_put(spi);
 	return retval;
 }
@@ -535,7 +542,7 @@ static struct file_operations spidev_fop
 	 */
 	.write =	spidev_write,
 	.read =		spidev_read,
-	.ioctl =	spidev_ioctl,
+	.unlocked_ioctl = spidev_ioctl,
 	.open =		spidev_open,
 	.release =	spidev_release,
 };
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

linux-next.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
paride-push-ioctl-down-into-driver.patch
pktcdvd-push-bkl-down-into-driver.patch
pktcdvd-push-bkl-down-into-driver-fix.patch
dac960-push-down-bkl.patch
pcwd-a-couple-of-watchdogs-escaped-conversion.patch
libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl.patch
libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl-fix.patch
ata-acpi-hotplug-handle-bay-devices-in-dock-stations.patch
ata-acpi-hotplug-handle-bay-devices-in-dock-stations-cleanup.patch
cm4000_cs-switch-to-unlocked_ioctl.patch
snapshot-push-bkl-down-into-ioctl-handlers.patch
spidev-bkl-removal.patch
rtc-push-the-bkl-down-into-the-driver-ioctl-method.patch
efirtc-push-down-the-bkl.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
mwave-ioctl-bkl-pushdown.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ixj-push-bkl-into-driver-and-wrap-ioctls.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
ds1302-push-down-the-bkl-into-the-driver-ioctl-code.patch
dsp56k-bkl-pushdown.patch

