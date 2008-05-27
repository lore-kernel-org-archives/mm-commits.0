From: akpm@linux-foundation.org
Subject: - spi-remove-some-spidev-oops-on-rmmod-paths.patch removed from -mm tree
Date: Tue, 27 May 2008 00:28:20 -0700
Message-ID: <200805270728.m4R7SK3v014934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756464AbYE0Hg3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:36:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, bigeasy@tglx.de, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: remove some spidev oops-on-rmmod paths
has been removed from the -mm tree.  Its filename was
     spi-remove-some-spidev-oops-on-rmmod-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: remove some spidev oops-on-rmmod paths
From: David Brownell <david-b@pacbell.net>

Somehow the spidev code forgot to include a critical mechanism: when the
underlying device is removed (e.g.  spi_master rmmod), open file
descriptors must be prevented from issuing new I/O requests to that
device.  On penalty of the oopsing reported by Sebastian Siewior
<bigeasy@tglx.de> ...

This is a partial fix, adding handshaking between the lower level (SPI
messaging) and the file operations using the spi_dev.  (It also fixes an
issue where reads and writes didn't return the number of bytes sent or
received.)

There's still a refcounting issue to be addressed (separately).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Reported-by: Sebastian Siewior <bigeasy@tglx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spidev.c |  102 +++++++++++++++++++++++++++++++++++------
 1 file changed, 89 insertions(+), 13 deletions(-)

diff -puN drivers/spi/spidev.c~spi-remove-some-spidev-oops-on-rmmod-paths drivers/spi/spidev.c
--- a/drivers/spi/spidev.c~spi-remove-some-spidev-oops-on-rmmod-paths
+++ a/drivers/spi/spidev.c
@@ -68,6 +68,7 @@ static unsigned long	minors[N_SPI_MINORS
 
 struct spidev_data {
 	struct device		dev;
+	spinlock_t		spi_lock;
 	struct spi_device	*spi;
 	struct list_head	device_entry;
 
@@ -85,12 +86,75 @@ MODULE_PARM_DESC(bufsiz, "data bytes in 
 
 /*-------------------------------------------------------------------------*/
 
+/*
+ * We can't use the standard synchronous wrappers for file I/O; we
+ * need to protect against async removal of the underlying spi_device.
+ */
+static void spidev_complete(void *arg)
+{
+	complete(arg);
+}
+
+static ssize_t
+spidev_sync(struct spidev_data *spidev, struct spi_message *message)
+{
+	DECLARE_COMPLETION_ONSTACK(done);
+	int status;
+
+	message->complete = spidev_complete;
+	message->context = &done;
+
+	spin_lock_irq(&spidev->spi_lock);
+	if (spidev->spi == NULL)
+		status = -ESHUTDOWN;
+	else
+		status = spi_async(spidev->spi, message);
+	spin_unlock_irq(&spidev->spi_lock);
+
+	if (status == 0) {
+		wait_for_completion(&done);
+		status = message->status;
+		if (status == 0)
+			status = message->actual_length;
+	}
+	return status;
+}
+
+static inline ssize_t
+spidev_sync_write(struct spidev_data *spidev, size_t len)
+{
+	struct spi_transfer	t = {
+			.tx_buf		= spidev->buffer,
+			.len		= len,
+		};
+	struct spi_message	m;
+
+	spi_message_init(&m);
+	spi_message_add_tail(&t, &m);
+	return spidev_sync(spidev, &m);
+}
+
+static inline ssize_t
+spidev_sync_read(struct spidev_data *spidev, size_t len)
+{
+	struct spi_transfer	t = {
+			.rx_buf		= spidev->buffer,
+			.len		= len,
+		};
+	struct spi_message	m;
+
+	spi_message_init(&m);
+	spi_message_add_tail(&t, &m);
+	return spidev_sync(spidev, &m);
+}
+
+/*-------------------------------------------------------------------------*/
+
 /* Read-only message with current device setup */
 static ssize_t
 spidev_read(struct file *filp, char __user *buf, size_t count, loff_t *f_pos)
 {
 	struct spidev_data	*spidev;
-	struct spi_device	*spi;
 	ssize_t			status = 0;
 
 	/* chipselect only toggles at start or end of operation */
@@ -98,10 +162,9 @@ spidev_read(struct file *filp, char __us
 		return -EMSGSIZE;
 
 	spidev = filp->private_data;
-	spi = spidev->spi;
 
 	mutex_lock(&spidev->buf_lock);
-	status = spi_read(spi, spidev->buffer, count);
+	status = spidev_sync_read(spidev, count);
 	if (status == 0) {
 		unsigned long	missing;
 
@@ -122,7 +185,6 @@ spidev_write(struct file *filp, const ch
 		size_t count, loff_t *f_pos)
 {
 	struct spidev_data	*spidev;
-	struct spi_device	*spi;
 	ssize_t			status = 0;
 	unsigned long		missing;
 
@@ -131,12 +193,11 @@ spidev_write(struct file *filp, const ch
 		return -EMSGSIZE;
 
 	spidev = filp->private_data;
-	spi = spidev->spi;
 
 	mutex_lock(&spidev->buf_lock);
 	missing = copy_from_user(spidev->buffer, buf, count);
 	if (missing == 0) {
-		status = spi_write(spi, spidev->buffer, count);
+		status = spidev_sync_write(spidev, count);
 		if (status == 0)
 			status = count;
 	} else
@@ -153,7 +214,6 @@ static int spidev_message(struct spidev_
 	struct spi_transfer	*k_xfers;
 	struct spi_transfer	*k_tmp;
 	struct spi_ioc_transfer *u_tmp;
-	struct spi_device	*spi = spidev->spi;
 	unsigned		n, total;
 	u8			*buf;
 	int			status = -EFAULT;
@@ -215,7 +275,7 @@ static int spidev_message(struct spidev_
 		spi_message_add_tail(k_tmp, &msg);
 	}
 
-	status = spi_sync(spi, &msg);
+	status = spidev_sync(spidev, &msg);
 	if (status < 0)
 		goto done;
 
@@ -269,8 +329,16 @@ spidev_ioctl(struct inode *inode, struct
 	if (err)
 		return -EFAULT;
 
+	/* guard against device removal before, or while,
+	 * we issue this ioctl.
+	 */
 	spidev = filp->private_data;
-	spi = spidev->spi;
+	spin_lock_irq(&spidev->spi_lock);
+	spi = spi_dev_get(spidev->spi);
+	spin_unlock_irq(&spidev->spi_lock);
+
+	if (spi == NULL)
+		return -ESHUTDOWN;
 
 	switch (cmd) {
 	/* read requests */
@@ -356,8 +424,10 @@ spidev_ioctl(struct inode *inode, struct
 	default:
 		/* segmented and/or full-duplex I/O request */
 		if (_IOC_NR(cmd) != _IOC_NR(SPI_IOC_MESSAGE(0))
-				|| _IOC_DIR(cmd) != _IOC_WRITE)
-			return -ENOTTY;
+				|| _IOC_DIR(cmd) != _IOC_WRITE) {
+			retval = -ENOTTY;
+			break;
+		}
 
 		tmp = _IOC_SIZE(cmd);
 		if ((tmp % sizeof(struct spi_ioc_transfer)) != 0) {
@@ -385,6 +455,7 @@ spidev_ioctl(struct inode *inode, struct
 		kfree(ioc);
 		break;
 	}
+	spi_dev_put(spi);
 	return retval;
 }
 
@@ -488,6 +559,7 @@ static int spidev_probe(struct spi_devic
 
 	/* Initialize the driver data */
 	spidev->spi = spi;
+	spin_lock_init(&spidev->spi_lock);
 	mutex_init(&spidev->buf_lock);
 
 	INIT_LIST_HEAD(&spidev->device_entry);
@@ -526,13 +598,17 @@ static int spidev_remove(struct spi_devi
 {
 	struct spidev_data	*spidev = dev_get_drvdata(&spi->dev);
 
-	mutex_lock(&device_list_lock);
+	/* make sure ops on existing fds can abort cleanly */
+	spin_lock_irq(&spidev->spi_lock);
+	spidev->spi = NULL;
+	spin_unlock_irq(&spidev->spi_lock);
 
+	/* prevent new opens */
+	mutex_lock(&device_list_lock);
 	list_del(&spidev->device_entry);
 	dev_set_drvdata(&spi->dev, NULL);
 	clear_bit(MINOR(spidev->dev.devt), minors);
 	device_unregister(&spidev->dev);
