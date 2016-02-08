From: akpm@linux-foundation.org
Subject: + rapidio-add-shutdown-notification-for-rapidio-devices.patch
 added to -mm tree
Date: Mon, 08 Feb 2016 13:22:10 -0800
Message-ID: <56b90702.bStdpDE/79tSwu58%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275AbcBHVWN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 16:22:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: add shutdown notification for RapidIO devices
has been added to the -mm tree.  Its filename is
     rapidio-add-shutdown-notification-for-rapidio-devices.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-add-shutdown-notification-for-rapidio-devices.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-add-shutdown-notification-for-rapidio-devices.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rapidio-tsi721-fix-hardcoded-mrrs-setting.patch
rapidio-tsi721-add-check-for-overlapped-ib-window-mappings.patch
rapidio-tsi721-add-option-to-configure-direct-mapping-of-ib-window.patch
rapidio-tsi721_dma-fix-pending-transaction-queue-handling.patch
rapidio-add-query_mport-operation.patch
rapidio-tsi721-add-query_mport-callback.patch
rapidio-add-shutdown-notification-for-rapidio-devices.patch
rapidio-tsi721-add-shutdown-notification-callback.patch
rapidio-rionet-add-shutdown-event-handling.patch
rapidio-rework-common-rio-device-add-delete-routines.patch
rapidio-move-net-allocation-into-core-code.patch
rapidio-add-core-mport-removal-support.patch
rapidio-tsi721-add-hw-specific-mport-removal.patch
powerpc-fsl_rio-changes-to-mport-registration.patch
rapidio-rionet-add-locking-into-add-remove-device.patch
rapidio-rionet-add-mport-removal-handling.patch
rapidio-add-lock-protection-for-doorbell-list.patch
rapidio-move-rio_local_set_device_id-function-to-the-common-core.patch
rapidio-move-rio_pw_enable-into-core-code.patch
rapidio-add-global-inbound-port-write-interfaces.patch
rapidio-tsi721-fix-locking-in-ob_msg-processing.patch
rapidio-add-outbound-window-support.patch
rapidio-tsi721-add-outbound-windows-mapping-support.patch
rapidio-tsi721-add-filtered-debug-output.patch
rapidio-tsi721_dma-update-error-reporting-from-prep_sg-callback.patch
rapidio-tsi721_dma-fix-synchronization-issues.patch
rapidio-tsi721_dma-fix-hardware-error-handling.patch
rapidio-add-mport-char-device-driver.patch

