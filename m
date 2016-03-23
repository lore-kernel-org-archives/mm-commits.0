From: akpm@linux-foundation.org
Subject: [merged]
 rapidio-add-shutdown-notification-for-rapidio-devices.patch removed from
 -mm tree
Date: Wed, 23 Mar 2016 10:41:27 -0700
Message-ID: <56f2d547.GGq41bMzpFUwhQ7o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645AbcCWRl2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:41:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: add shutdown notification for RapidIO devices
has been removed from the -mm tree.  Its filename was
     rapidio-add-shutdown-notification-for-rapidio-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: add shutdown notification for RapidIO devices

Add bus-specific callback to stop RapidIO devices during a system shutdown.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-driver.c |   12 ++++++++++++
 include/linux/rio.h          |    2 ++
 2 files changed, 14 insertions(+)

diff -puN drivers/rapidio/rio-driver.c~rapidio-add-shutdown-notification-for-rapidio-devices drivers/rapidio/rio-driver.c
--- a/drivers/rapidio/rio-driver.c~rapidio-add-shutdown-notification-for-rapidio-devices
+++ a/drivers/rapidio/rio-driver.c
@@ -131,6 +131,17 @@ static int rio_device_remove(struct devi
 	return 0;
 }
 
+static void rio_device_shutdown(struct device *dev)
+{
+	struct rio_dev *rdev = to_rio_dev(dev);
+	struct rio_driver *rdrv = rdev->driver;
+
+	dev_dbg(dev, "RIO: %s\n", __func__);
+
+	if (rdrv && rdrv->shutdown)
+		rdrv->shutdown(rdev);
+}
+
 /**
  *  rio_register_driver - register a new RIO driver
  *  @rdrv: the RIO driver structure to register
@@ -229,6 +240,7 @@ struct bus_type rio_bus_type = {
 	.bus_groups = rio_bus_groups,
 	.probe = rio_device_probe,
 	.remove = rio_device_remove,
+	.shutdown = rio_device_shutdown,
 	.uevent	= rio_uevent,
 };
 
diff -puN include/linux/rio.h~rapidio-add-shutdown-notification-for-rapidio-devices include/linux/rio.h
--- a/include/linux/rio.h~rapidio-add-shutdown-notification-for-rapidio-devices
+++ a/include/linux/rio.h
@@ -423,6 +423,7 @@ struct rio_ops {
  * @id_table: RIO device ids to be associated with this driver
  * @probe: RIO device inserted
  * @remove: RIO device removed
+ * @shutdown: shutdown notification callback
  * @suspend: RIO device suspended
  * @resume: RIO device awakened
  * @enable_wake: RIO device enable wake event
@@ -437,6 +438,7 @@ struct rio_driver {
 	const struct rio_device_id *id_table;
 	int (*probe) (struct rio_dev * dev, const struct rio_device_id * id);
 	void (*remove) (struct rio_dev * dev);
+	void (*shutdown)(struct rio_dev *dev);
 	int (*suspend) (struct rio_dev * dev, u32 state);
 	int (*resume) (struct rio_dev * dev);
 	int (*enable_wake) (struct rio_dev * dev, u32 state, int enable);
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are


