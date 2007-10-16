From: akpm@linux-foundation.org
Subject: - spi-doesnt-need-class_device.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:39:52 -0700
Message-ID: <200710162039.l9GKdq9f015598@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57444 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760301AbXJPVaj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:30:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tonyj@suse.de, dbrownell@users.sourceforge.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     spi doesn't need class_device
has been removed from the -mm tree.  Its filename was
     spi-doesnt-need-class_device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi doesn't need class_device
From: Tony Jones <tonyj@suse.de>

Make the SPI framework and drivers stop using class_device.  Update docs
accordingly ...  highlighting just which sysfs paths should be
"safe"/stable.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/spi/spi-summary |   25 +++++++++++++++-------
 drivers/mmc/host/mmc_spi.c    |    4 +--
 drivers/spi/atmel_spi.c       |   14 ++++++------
 drivers/spi/mpc52xx_psc_spi.c |    2 -
 drivers/spi/pxa2xx_spi.c      |    2 -
 drivers/spi/spi.c             |   36 ++++++++++++++++----------------
 drivers/spi/spi_bfin5xx.c     |    2 -
 drivers/spi/spi_bitbang.c     |    2 -
 drivers/spi/spi_imx.c         |    2 -
 drivers/spi/spi_lm70llp.c     |    2 -
 drivers/spi/spi_txx9.c        |    2 -
 include/linux/spi/spi.h       |   12 +++++-----
 12 files changed, 57 insertions(+), 48 deletions(-)

diff -puN Documentation/spi/spi-summary~spi-doesnt-need-class_device Documentation/spi/spi-summary
--- a/Documentation/spi/spi-summary~spi-doesnt-need-class_device
+++ a/Documentation/spi/spi-summary
@@ -156,21 +156,29 @@ using the driver model to connect contro
 device tables provided by board specific initialization code.  SPI
 shows up in sysfs in several locations:
 
+   /sys/devices/.../CTLR ... physical node for a given SPI controller
+
    /sys/devices/.../CTLR/spiB.C ... spi_device on bus "B",
 	chipselect C, accessed through CTLR.
 
+   /sys/bus/spi/devices/spiB.C ... symlink to that physical
+   	.../CTLR/spiB.C device
+
    /sys/devices/.../CTLR/spiB.C/modalias ... identifies the driver
 	that should be used with this device (for hotplug/coldplug)
 
-   /sys/bus/spi/devices/spiB.C ... symlink to the physical
-   	spiB.C device
-
    /sys/bus/spi/drivers/D ... driver for one or more spi*.* devices
 
-   /sys/class/spi_master/spiB ... class device for the controller
-	managing bus "B".  All the spiB.* devices share the same
+   /sys/class/spi_master/spiB ... symlink (or actual device node) to
+	a logical node which could hold class related state for the
+	controller managing bus "B".  All spiB.* devices share one
 	physical SPI bus segment, with SCLK, MOSI, and MISO.
 
+Note that the actual location of the controller's class state depends
+on whether you enabled CONFIG_SYSFS_DEPRECATED or not.  At this time,
+the only class-specific state is the bus number ("B" in "spiB"), so
+those /sys/class entries are only useful to quickly identify busses.
+
 
 How does board-specific init code declare SPI devices?
 ------------------------------------------------------
@@ -337,7 +345,8 @@ SPI protocol drivers somewhat resemble p
 
 The driver core will autmatically attempt to bind this driver to any SPI
 device whose board_info gave a modalias of "CHIP".  Your probe() code
-might look like this unless you're creating a class_device:
+might look like this unless you're creating a device which is managing
+a bus (appearing under /sys/class/spi_master).
 
 	static int __devinit CHIP_probe(struct spi_device *spi)
 	{
@@ -442,7 +451,7 @@ An SPI controller will probably be regis
 a driver to bind to the device, whichever bus is involved.
 
 The main task of this type of driver is to provide an "spi_master".
-Use spi_alloc_master() to allocate the master, and class_get_devdata()
+Use spi_alloc_master() to allocate the master, and spi_master_get_devdata()
 to get the driver-private data allocated for that device.
 
 	struct spi_master	*master;
@@ -452,7 +461,7 @@ to get the driver-private data allocated
 	if (!master)
 		return -ENODEV;
 
-	c = class_get_devdata(&master->cdev);
+	c = spi_master_get_devdata(master);
 
 The driver will initialize the fields of that spi_master, including the
 bus number (maybe the same as the platform device ID) and three methods
diff -puN drivers/mmc/host/mmc_spi.c~spi-doesnt-need-class_device drivers/mmc/host/mmc_spi.c
--- a/drivers/mmc/host/mmc_spi.c~spi-doesnt-need-class_device
+++ a/drivers/mmc/host/mmc_spi.c
@@ -1280,8 +1280,8 @@ static int mmc_spi_probe(struct spi_devi
 	if (!host->data)
 		goto fail_nobuf1;
 
-	if (spi->master->cdev.dev->dma_mask) {
-		struct device	*dev = spi->master->cdev.dev;
+	if (spi->master->dev.parent->dma_mask) {
+		struct device	*dev = spi->master->dev.parent;
 
 		host->dma_dev = dev;
 		host->ones_dma = dma_map_single(dev, ones,
diff -puN drivers/spi/atmel_spi.c~spi-doesnt-need-class_device drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~spi-doesnt-need-class_device
+++ a/drivers/spi/atmel_spi.c
@@ -211,7 +211,7 @@ static void atmel_spi_next_message(struc
 	msg = list_entry(as->queue.next, struct spi_message, queue);
 	spi = msg->spi;
 
-	dev_dbg(master->cdev.dev, "start message %p for %s\n",
+	dev_dbg(master->dev.parent, "start message %p for %s\n",
 			msg, spi->dev.bus_id);
 
 	/* select chip if it's not still active */
@@ -266,10 +266,10 @@ static void atmel_spi_dma_unmap_xfer(str
 				     struct spi_transfer *xfer)
 {
 	if (xfer->tx_dma != INVALID_DMA_ADDRESS)
-		dma_unmap_single(master->cdev.dev, xfer->tx_dma,
+		dma_unmap_single(master->dev.parent, xfer->tx_dma,
 				 xfer->len, DMA_TO_DEVICE);
 	if (xfer->rx_dma != INVALID_DMA_ADDRESS)
-		dma_unmap_single(master->cdev.dev, xfer->rx_dma,
+		dma_unmap_single(master->dev.parent, xfer->rx_dma,
 				 xfer->len, DMA_FROM_DEVICE);
 }
 
@@ -285,7 +285,7 @@ atmel_spi_msg_done(struct spi_master *ma
 	list_del(&msg->queue);
 	msg->status = status;
 
-	dev_dbg(master->cdev.dev,
+	dev_dbg(master->dev.parent,
 		"xfer complete: %u bytes transferred\n",
 		msg->actual_length);
 
@@ -348,7 +348,7 @@ atmel_spi_interrupt(int irq, void *dev_i
 		if (xfer->delay_usecs)
 			udelay(xfer->delay_usecs);
 
-		dev_warn(master->cdev.dev, "fifo overrun (%u/%u remaining)\n",
+		dev_warn(master->dev.parent, "fifo overrun (%u/%u remaining)\n",
 			 spi_readl(as, TCR), spi_readl(as, RCR));
 
 		/*
@@ -363,7 +363,7 @@ atmel_spi_interrupt(int irq, void *dev_i
 			if (spi_readl(as, SR) & SPI_BIT(TXEMPTY))
 				break;
 		if (!timeout)
-			dev_warn(master->cdev.dev,
+			dev_warn(master->dev.parent,
 				 "timeout waiting for TXEMPTY");
 		while (spi_readl(as, SR) & SPI_BIT(RDRF))
 			spi_readl(as, RDR);
@@ -526,7 +526,7 @@ static int atmel_spi_transfer(struct spi
 	struct atmel_spi	*as;
 	struct spi_transfer	*xfer;
 	unsigned long		flags;
-	struct device		*controller = spi->master->cdev.dev;
+	struct device		*controller = spi->master->dev.parent;
 
 	as = spi_master_get_devdata(spi->master);
 
diff -puN drivers/spi/mpc52xx_psc_spi.c~spi-doesnt-need-class_device drivers/spi/mpc52xx_psc_spi.c
--- a/drivers/spi/mpc52xx_psc_spi.c~spi-doesnt-need-class_device
+++ a/drivers/spi/mpc52xx_psc_spi.c
@@ -503,7 +503,7 @@ static int __init mpc52xx_psc_spi_do_pro
 	INIT_LIST_HEAD(&mps->queue);
 
 	mps->workqueue = create_singlethread_workqueue(
-		master->cdev.dev->bus_id);
+		master->dev.parent->bus_id);
 	if (mps->workqueue == NULL) {
 		ret = -EBUSY;
 		goto free_irq;
diff -puN drivers/spi/pxa2xx_spi.c~spi-doesnt-need-class_device drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~spi-doesnt-need-class_device
+++ a/drivers/spi/pxa2xx_spi.c
@@ -1242,7 +1242,7 @@ static int __init init_queue(struct driv
 
 	INIT_WORK(&drv_data->pump_messages, pump_messages);
 	drv_data->workqueue = create_singlethread_workqueue(
-					drv_data->master->cdev.dev->bus_id);
+					drv_data->master->dev.parent->bus_id);
 	if (drv_data->workqueue == NULL)
 		return -EBUSY;
 
diff -puN drivers/spi/spi.c~spi-doesnt-need-class_device drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-doesnt-need-class_device
+++ a/drivers/spi/spi.c
@@ -204,7 +204,7 @@ struct spi_device *spi_new_device(struct
 				  struct spi_board_info *chip)
 {
 	struct spi_device	*proxy;
-	struct device		*dev = master->cdev.dev;
+	struct device		*dev = master->dev.parent;
 	int			status;
 
 	/* NOTE:  caller did any chip->bus_num checks necessary.
@@ -239,7 +239,7 @@ struct spi_device *spi_new_device(struct
 	proxy->modalias = chip->modalias;
 
 	snprintf(proxy->dev.bus_id, sizeof proxy->dev.bus_id,
-			"%s.%u", master->cdev.class_id,
+			"%s.%u", master->dev.bus_id,
 			chip->chip_select);
 	proxy->dev.parent = dev;
 	proxy->dev.bus = &spi_bus_type;
@@ -338,18 +338,18 @@ static void scan_boardinfo(struct spi_ma
 
 /*-------------------------------------------------------------------------*/
 
-static void spi_master_release(struct class_device *cdev)
+static void spi_master_release(struct device *dev)
 {
 	struct spi_master *master;
 
-	master = container_of(cdev, struct spi_master, cdev);
+	master = container_of(dev, struct spi_master, dev);
 	kfree(master);
 }
 
 static struct class spi_master_class = {
 	.name		= "spi_master",
 	.owner		= THIS_MODULE,
-	.release	= spi_master_release,
+	.dev_release	= spi_master_release,
 };
 
 
@@ -357,7 +357,7 @@ static struct class spi_master_class = {
  * spi_alloc_master - allocate SPI master controller
  * @dev: the controller, possibly using the platform_bus
  * @size: how much zeroed driver-private data to allocate; the pointer to this
- *	memory is in the class_data field of the returned class_device,
+ *	memory is in the driver_data field of the returned device,
  *	accessible with spi_master_get_devdata().
  * Context: can sleep
  *
@@ -383,9 +383,9 @@ struct spi_master *spi_alloc_master(stru
 	if (!master)
 		return NULL;
 
-	class_device_initialize(&master->cdev);
-	master->cdev.class = &spi_master_class;
-	master->cdev.dev = get_device(dev);
+	device_initialize(&master->dev);
+	master->dev.class = &spi_master_class;
+	master->dev.parent = get_device(dev);
 	spi_master_set_devdata(master, &master[1]);
 
 	return master;
@@ -415,7 +415,7 @@ EXPORT_SYMBOL_GPL(spi_alloc_master);
 int spi_register_master(struct spi_master *master)
 {
 	static atomic_t		dyn_bus_id = ATOMIC_INIT((1<<15) - 1);
-	struct device		*dev = master->cdev.dev;
+	struct device		*dev = master->dev.parent;
 	int			status = -ENODEV;
 	int			dynamic = 0;
 
@@ -440,12 +440,12 @@ int spi_register_master(struct spi_maste
 	/* register the device, then userspace will see it.
 	 * registration fails if the bus ID is in use.
 	 */
-	snprintf(master->cdev.class_id, sizeof master->cdev.class_id,
+	snprintf(master->dev.bus_id, sizeof master->dev.bus_id,
 		"spi%u", master->bus_num);
-	status = class_device_add(&master->cdev);
+	status = device_add(&master->dev);
 	if (status < 0)
 		goto done;
-	dev_dbg(dev, "registered master %s%s\n", master->cdev.class_id,
+	dev_dbg(dev, "registered master %s%s\n", master->dev.bus_id,
 			dynamic ? " (dynamic)" : "");
 
 	/* populate children from any spi device tables */
@@ -478,8 +478,8 @@ void spi_unregister_master(struct spi_ma
 {
 	int dummy;
 
-	dummy = device_for_each_child(master->cdev.dev, NULL, __unregister);
-	class_device_unregister(&master->cdev);
+	dummy = device_for_each_child(master->dev.parent, NULL, __unregister);
+	device_unregister(&master->dev);
 }
 EXPORT_SYMBOL_GPL(spi_unregister_master);
 
@@ -495,13 +495,13 @@ EXPORT_SYMBOL_GPL(spi_unregister_master)
  */
 struct spi_master *spi_busnum_to_master(u16 bus_num)
 {
-	struct class_device	*cdev;
+	struct device		*dev;
 	struct spi_master	*master = NULL;
 	struct spi_master	*m;
 
 	down(&spi_master_class.sem);
-	list_for_each_entry(cdev, &spi_master_class.children, node) {
-		m = container_of(cdev, struct spi_master, cdev);
+	list_for_each_entry(dev, &spi_master_class.children, node) {
+		m = container_of(dev, struct spi_master, dev);
 		if (m->bus_num == bus_num) {
 			master = spi_master_get(m);
 			break;
diff -puN drivers/spi/spi_bfin5xx.c~spi-doesnt-need-class_device drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi-doesnt-need-class_device
+++ a/drivers/spi/spi_bfin5xx.c
@@ -1106,7 +1106,7 @@ static inline int init_queue(struct driv
 	/* init messages workqueue */
 	INIT_WORK(&drv_data->pump_messages, pump_messages);
 	drv_data->workqueue =
-	    create_singlethread_workqueue(drv_data->master->cdev.dev->bus_id);
+	    create_singlethread_workqueue(drv_data->master->dev.parent->bus_id);
 	if (drv_data->workqueue == NULL)
 		return -EBUSY;
 
diff -puN drivers/spi/spi_bitbang.c~spi-doesnt-need-class_device drivers/spi/spi_bitbang.c
--- a/drivers/spi/spi_bitbang.c~spi-doesnt-need-class_device
+++ a/drivers/spi/spi_bitbang.c
@@ -472,7 +472,7 @@ int spi_bitbang_start(struct spi_bitbang
 	/* this task is the only thing to touch the SPI bits */
 	bitbang->busy = 0;
 	bitbang->workqueue = create_singlethread_workqueue(
-			bitbang->master->cdev.dev->bus_id);
+			bitbang->master->dev.parent->bus_id);
 	if (bitbang->workqueue == NULL) {
 		status = -EBUSY;
 		goto err1;
diff -puN drivers/spi/spi_imx.c~spi-doesnt-need-class_device drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-doesnt-need-class_device
+++ a/drivers/spi/spi_imx.c
@@ -1374,7 +1374,7 @@ static int __init init_queue(struct driv
 
 	INIT_WORK(&drv_data->work, pump_messages);
 	drv_data->workqueue = create_singlethread_workqueue(
-					drv_data->master->cdev.dev->bus_id);
+					drv_data->master->dev.parent->bus_id);
 	if (drv_data->workqueue == NULL)
 		return -EBUSY;
 
diff -puN drivers/spi/spi_lm70llp.c~spi-doesnt-need-class_device drivers/spi/spi_lm70llp.c
--- a/drivers/spi/spi_lm70llp.c~spi-doesnt-need-class_device
+++ a/drivers/spi/spi_lm70llp.c
@@ -82,7 +82,7 @@ struct spi_lm70llp {
 	struct pardevice	*pd;
 	struct spi_device	*spidev_lm70;
 	struct spi_board_info	info;
-	struct class_device	*cdev;
+	//struct device		*dev;
 };
 
 /* REVISIT : ugly global ; provides "exclusive open" facility */
diff -puN drivers/spi/spi_txx9.c~spi-doesnt-need-class_device drivers/spi/spi_txx9.c
--- a/drivers/spi/spi_txx9.c~spi-doesnt-need-class_device
+++ a/drivers/spi/spi_txx9.c
@@ -400,7 +400,7 @@ static int __init txx9spi_probe(struct p
 		goto exit;
 	}
 
-	c->workqueue = create_singlethread_workqueue(master->cdev.dev->bus_id);
+	c->workqueue = create_singlethread_workqueue(master->dev.parent->bus_id);
 	if (!c->workqueue)
 		goto exit;
 	c->last_chipselect = -1;
diff -puN include/linux/spi/spi.h~spi-doesnt-need-class_device include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spi-doesnt-need-class_device
+++ a/include/linux/spi/spi.h
@@ -195,7 +195,7 @@ static inline void spi_unregister_driver
 
 /**
  * struct spi_master - interface to SPI master controller
- * @cdev: class interface to this driver
+ * @dev: device interface to this driver
  * @bus_num: board-specific (and often SOC-specific) identifier for a
  *	given SPI controller.
  * @num_chipselect: chipselects are used to distinguish individual
@@ -222,7 +222,7 @@ static inline void spi_unregister_driver
  * message's completion function when the transaction completes.
  */
 struct spi_master {
-	struct class_device	cdev;
+	struct device	dev;
 
 	/* other than negative (== assign one dynamically), bus_num is fully
 	 * board-specific.  usually that simplifies to being SOC-specific.
@@ -268,17 +268,17 @@ struct spi_master {
 
 static inline void *spi_master_get_devdata(struct spi_master *master)
 {
-	return class_get_devdata(&master->cdev);
+	return dev_get_drvdata(&master->dev);
 }
 
 static inline void spi_master_set_devdata(struct spi_master *master, void *data)
 {
-	class_set_devdata(&master->cdev, data);
+	dev_set_drvdata(&master->dev, data);
 }
 
 static inline struct spi_master *spi_master_get(struct spi_master *master)
 {
-	if (!master || !class_device_get(&master->cdev))
+	if (!master || !get_device(&master->dev))
 		return NULL;
 	return master;
 }
@@ -286,7 +286,7 @@ static inline struct spi_master *spi_mas
 static inline void spi_master_put(struct spi_master *master)
 {
 	if (master)
-		class_device_put(&master->cdev);
+		put_device(&master->dev);
 }
 
 
_

Patches currently in -mm which might be from tonyj@suse.de are

origin.patch
