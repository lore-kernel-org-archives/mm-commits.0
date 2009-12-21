From: akpm@linux-foundation.org
Subject: [to-be-updated] acpi-reintroduce-acpi_device_ops-shutdown-method.patch removed from -mm tree
Date: Mon, 21 Dec 2009 15:54:03 -0800
Message-ID: <200912212354.nBLNs36C003555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875AbZLUXz3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 18:55:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@hardeman.nu, bjorn.helgaas@hp.com, jbarnes@virtuousgeek.org, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: reintroduce acpi_device_ops .shutdown method
has been removed from the -mm tree.  Its filename was
     acpi-reintroduce-acpi_device_ops-shutdown-method.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: reintroduce acpi_device_ops .shutdown method
From: David Hardeman <david@hardeman.nu>

Reintroduce the .shutdown method which is used by the winbond-cir driver. 

I didn't want to call wbcir_shutdown from wbcir_remove since wbcir_remove
is called on rmmod and the wbcir_shutdown method programs the chip so that
wake-on-a-specific-ir-command is enabled (and I imagine that people would
expect rmmod to disable the hardware completely).

I think this single user does have a real dependency because of its
wake-from-poweroff and wake-from-suspend capability.

Signed-off-by: David Hardeman <david@hardeman.nu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/scan.c     |   12 ++++++++++++
 include/acpi/acpi_bus.h |    2 ++
 2 files changed, 14 insertions(+)

diff -puN drivers/acpi/scan.c~acpi-reintroduce-acpi_device_ops-shutdown-method drivers/acpi/scan.c
--- a/drivers/acpi/scan.c~acpi-reintroduce-acpi_device_ops-shutdown-method
+++ a/drivers/acpi/scan.c
@@ -427,10 +427,22 @@ static int acpi_device_remove(struct dev
 	return 0;
 }
 
+static void acpi_device_shutdown(struct device *dev)
+{
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+	struct acpi_driver *acpi_drv = acpi_dev->driver;
+
+	if (acpi_drv && acpi_drv->ops.shutdown)
+		acpi_drv->ops.shutdown(acpi_dev);
+
+	return ;
+}
+
 struct bus_type acpi_bus_type = {
 	.name		= "acpi",
 	.suspend	= acpi_device_suspend,
 	.resume		= acpi_device_resume,
+	.shutdown	= acpi_device_shutdown,
 	.match		= acpi_bus_match,
 	.probe		= acpi_device_probe,
 	.remove		= acpi_device_remove,
diff -puN include/acpi/acpi_bus.h~acpi-reintroduce-acpi_device_ops-shutdown-method include/acpi/acpi_bus.h
--- a/include/acpi/acpi_bus.h~acpi-reintroduce-acpi_device_ops-shutdown-method
+++ a/include/acpi/acpi_bus.h
@@ -92,6 +92,7 @@ typedef int (*acpi_op_resume) (struct ac
 typedef int (*acpi_op_bind) (struct acpi_device * device);
 typedef int (*acpi_op_unbind) (struct acpi_device * device);
 typedef void (*acpi_op_notify) (struct acpi_device * device, u32 event);
+typedef int (*acpi_op_shutdown) (struct acpi_device *device);
 
 struct acpi_bus_ops {
 	u32 acpi_op_add:1;
@@ -107,6 +108,7 @@ struct acpi_device_ops {
 	acpi_op_bind bind;
 	acpi_op_unbind unbind;
 	acpi_op_notify notify;
+	acpi_op_shutdown shutdown;
 };
 
 #define ACPI_DRIVER_ALL_NOTIFY_EVENTS	0x1	/* system AND device events */
_

Patches currently in -mm which might be from david@hardeman.nu are

acpi-reintroduce-acpi_device_ops-shutdown-method.patch

