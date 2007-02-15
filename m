From: akpm@linux-foundation.org
Subject: - scsi-megaraid_sas-added-bios_param-in.patch removed from -mm tree
Date: Wed, 14 Feb 2007 20:10:29 -0800
Message-ID: <200702150410.l1F4AT3l019368@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33389 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964896AbXBOEKc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 23:10:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sumantp@lsil.com, sumant.patro@lsi.com, mm-commits@vger.kernel.org


The patch titled
     scsi: megaraid_sas - added bios_param in scsi_host_template
has been removed from the -mm tree.  Its filename was
     scsi-megaraid_sas-added-bios_param-in.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: scsi: megaraid_sas - added bios_param in scsi_host_template
From: Sumant Patro <sumantp@lsil.com>

Added bios_param in scsi_host_template to return disk geometry.

Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_sas.c |   45 +++++++++++++++++++++++++
 1 files changed, 45 insertions(+)

diff -puN drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-added-bios_param-in drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-added-bios_param-in
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -35,6 +35,7 @@
 #include <asm/uaccess.h>
 #include <linux/fs.h>
 #include <linux/compat.h>
+#include <linux/blkdev.h>
 #include <linux/mutex.h>
 
 #include <scsi/scsi.h>
@@ -1015,6 +1016,49 @@ static int megasas_reset_bus_host(struct
 }
 
 /**
+ * megasas_bios_param - Returns disk geometry for a disk
+ * @sdev: 		device handle
+ * @bdev:		block device
+ * @capacity:		drive capacity
+ * @geom:		geometry parameters
+ */
+static int
+megasas_bios_param(struct scsi_device *sdev, struct block_device *bdev,
+		 sector_t capacity, int geom[])
+{
+	int 		heads;
+	int 		sectors;
+	sector_t	cylinders;
+	ulong		dummy;
+	/* Default heads (64) & sectors (32) */
+	heads 		= 64;
+	sectors 	= 32;
+
+	dummy		= heads * sectors;
+	cylinders	=  capacity;
+
+	sector_div(cylinders, dummy);
+
+	/*
+	 * Handle extended translation size for logical drives > 1Gb
+	 */
+
+	if ((ulong)capacity >= 0x200000) {
+		heads = 255;
+		sectors = 63;
+		dummy = heads*sectors;
+		cylinders = capacity;
+		sector_div(cylinders, dummy);
+	}
+
+	geom[0] = heads;
+	geom[1] = sectors;
+	geom[2] = cylinders;
+
+	return 0;
+}
+
+/**
  * megasas_service_aen -	Processes an event notification
  * @instance:			Adapter soft state
  * @cmd:			AEN command completed by the ISR
@@ -1054,6 +1098,7 @@ static struct scsi_host_template megasas
 	.eh_device_reset_handler = megasas_reset_device,
 	.eh_bus_reset_handler = megasas_reset_bus_host,
 	.eh_host_reset_handler = megasas_reset_bus_host,
+	.bios_param = megasas_bios_param,
 	.use_clustering = ENABLE_CLUSTERING,
 };
 
_

Patches currently in -mm which might be from sumantp@lsil.com are

origin.patch
scsi-megaraid_sas-added-bios_param-in.patch
scsi-megaraid_sas-throttle-io-if-fw-is-busy.patch
scsi-megaraid_sas-update-version-and-author-info.patch
