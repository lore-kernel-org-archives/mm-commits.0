From: akpm@linux-foundation.org
Subject: [merged]
 rapidio-move-rio_local_set_device_id-function-to-the-common-core.patch
 removed from -mm tree
Date: Wed, 23 Mar 2016 10:41:50 -0700
Message-ID: <56f2d55e.FM7TiA1ZU4dHiIEz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59250 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494AbcCWRl4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:41:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: move rio_local_set_device_id function to the common core
has been removed from the -mm tree.  Its filename was
     rapidio-move-rio_local_set_device_id-function-to-the-common-core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: move rio_local_set_device_id function to the common core

Make function rio_local_set_device_id() common for all components of
RapidIO subsystem.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |   13 -------------
 drivers/rapidio/rio.c      |   14 ++++++++++++++
 include/linux/rio_drv.h    |    1 +
 3 files changed, 15 insertions(+), 13 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-move-rio_local_set_device_id-function-to-the-common-core drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-move-rio_local_set_device_id-function-to-the-common-core
+++ a/drivers/rapidio/rio-scan.c
@@ -194,19 +194,6 @@ static void rio_set_device_id(struct rio
 }
 
 /**
- * rio_local_set_device_id - Set the base/extended device id for a port
- * @port: RIO master port
- * @did: Device ID value to be written
- *
- * Writes the base/extended device id from a device.
- */
-static void rio_local_set_device_id(struct rio_mport *port, u16 did)
-{
-	rio_local_write_config_32(port, RIO_DID_CSR, RIO_SET_DID(port->sys_size,
-				did));
-}
-
-/**
  * rio_clear_locks- Release all host locks and signal enumeration complete
  * @net: RIO network to run on
  *
diff -puN drivers/rapidio/rio.c~rapidio-move-rio_local_set_device_id-function-to-the-common-core drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-move-rio_local_set_device_id-function-to-the-common-core
+++ a/drivers/rapidio/rio.c
@@ -138,6 +138,20 @@ void rio_free_net(struct rio_net *net)
 EXPORT_SYMBOL_GPL(rio_free_net);
 
 /**
+ * rio_local_set_device_id - Set the base/extended device id for a port
+ * @port: RIO master port
+ * @did: Device ID value to be written
+ *
+ * Writes the base/extended device id from a device.
+ */
+void rio_local_set_device_id(struct rio_mport *port, u16 did)
+{
+	rio_local_write_config_32(port, RIO_DID_CSR,
+				  RIO_SET_DID(port->sys_size, did));
+}
+EXPORT_SYMBOL_GPL(rio_local_set_device_id);
+
+/**
  * rio_add_device- Adds a RIO device to the device model
  * @rdev: RIO device
  *
diff -puN include/linux/rio_drv.h~rapidio-move-rio_local_set_device_id-function-to-the-common-core include/linux/rio_drv.h
--- a/include/linux/rio_drv.h~rapidio-move-rio_local_set_device_id-function-to-the-common-core
+++ a/include/linux/rio_drv.h
@@ -435,6 +435,7 @@ static inline void rio_set_drvdata(struc
 
 /* Misc driver helpers */
 extern u16 rio_local_get_device_id(struct rio_mport *port);
+extern void rio_local_set_device_id(struct rio_mport *port, u16 did);
 extern struct rio_dev *rio_get_device(u16 vid, u16 did, struct rio_dev *from);
 extern struct rio_dev *rio_get_asm(u16 vid, u16 did, u16 asm_vid, u16 asm_did,
 				   struct rio_dev *from);
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are


