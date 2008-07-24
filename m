From: akpm@linux-foundation.org
Subject: - spidev-bkl-removal.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:28:33 -0700
Message-ID: <200807242328.m6ONSX6v011274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756668AbYGXX3G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spidev: BKL removal
has been removed from the -mm tree.  Its filename was
     spidev-bkl-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -228,7 +228,6 @@ static int spidev_message(struct spidev_
 	 * We walk the array of user-provided transfers, using each one
 	 * to initialize a kernel version of the same transfer.
 	 */
-	mutex_lock(&spidev->buf_lock);
 	buf = spidev->buffer;
 	total = 0;
 	for (n = n_xfers, k_tmp = k_xfers, u_tmp = u_xfers;
@@ -296,14 +295,12 @@ static int spidev_message(struct spidev_
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
@@ -341,6 +338,14 @@ spidev_ioctl(struct inode *inode, struct
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
@@ -456,6 +461,8 @@ spidev_ioctl(struct inode *inode, struct
 		kfree(ioc);
 		break;
 	}
+
+	mutex_unlock(&spidev->buf_lock);
 	spi_dev_put(spi);
 	return retval;
 }
@@ -533,7 +540,7 @@ static struct file_operations spidev_fop
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

origin.patch
linux-next.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_viac-add-flag-for-vx800-and-add-a-function-for-fixing-internal-bugs-for-via-chipsets.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
coredump-format_corename-fix-the-core_uses_pid-logic.patch
efirtc-push-down-the-bkl.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
mwave-ioctl-bkl-pushdown.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ixj-push-bkl-into-driver-and-wrap-ioctls.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
ds1302-push-down-the-bkl-into-the-driver-ioctl-code.patch
dsp56k-bkl-pushdown.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch

