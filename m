From: akpm@linux-foundation.org
Subject: [merged] rapidio-move-rio_pw_enable-into-core-code.patch removed
 from -mm tree
Date: Wed, 23 Mar 2016 10:41:52 -0700
Message-ID: <56f2d560./+jXQlxtYFmJJW0j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418AbcCWRlx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:41:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: move rio_pw_enable into core code
has been removed from the -mm tree.  Its filename was
     rapidio-move-rio_pw_enable-into-core-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: move rio_pw_enable into core code

Make rio_pw_enable() routine available to other RapidIO drivers.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |   11 -----------
 drivers/rapidio/rio.c      |   19 +++++++++++++++++++
 include/linux/rio.h        |    2 ++
 include/linux/rio_drv.h    |    1 +
 4 files changed, 22 insertions(+), 11 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-move-rio_pw_enable-into-core-code drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-move-rio_pw_enable-into-core-code
+++ a/drivers/rapidio/rio-scan.c
@@ -974,17 +974,6 @@ static void rio_init_em(struct rio_dev *
 }
 
 /**
- * rio_pw_enable - Enables/disables port-write handling by a master port
- * @port: Master port associated with port-write handling
- * @enable:  1=enable,  0=disable
- */
-static void rio_pw_enable(struct rio_mport *port, int enable)
-{
-	if (port->ops->pwenable)
-		port->ops->pwenable(port, enable);
-}
-
-/**
  * rio_enum_mport- Start enumeration through a master port
  * @mport: Master port to send transactions
  * @flags: Enumeration control flags
diff -puN drivers/rapidio/rio.c~rapidio-move-rio_pw_enable-into-core-code drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-move-rio_pw_enable-into-core-code
+++ a/drivers/rapidio/rio.c
@@ -560,6 +560,24 @@ int rio_release_inb_pwrite(struct rio_de
 EXPORT_SYMBOL_GPL(rio_release_inb_pwrite);
 
 /**
+ * rio_pw_enable - Enables/disables port-write handling by a master port
+ * @mport: Master port associated with port-write handling
+ * @enable:  1=enable,  0=disable
+ */
+void rio_pw_enable(struct rio_mport *mport, int enable)
+{
+	if (mport->ops->pwenable) {
+		mutex_lock(&mport->lock);
+
+		if ((enable && ++mport->pwe_refcnt == 1) ||
+		    (!enable && mport->pwe_refcnt && --mport->pwe_refcnt == 0))
+			mport->ops->pwenable(mport, enable);
+		mutex_unlock(&mport->lock);
+	}
+}
+EXPORT_SYMBOL_GPL(rio_pw_enable);
+
+/**
  * rio_map_inb_region -- Map inbound memory region.
  * @mport: Master port.
  * @local: physical address of memory region to be mapped
@@ -2041,6 +2059,7 @@ int rio_mport_initialize(struct rio_mpor
 	mport->host_deviceid = rio_get_hdid(mport->id);
 	mport->nscan = NULL;
 	mutex_init(&mport->lock);
+	mport->pwe_refcnt = 0;
 
 	return 0;
 }
diff -puN include/linux/rio.h~rapidio-move-rio_pw_enable-into-core-code include/linux/rio.h
--- a/include/linux/rio.h~rapidio-move-rio_pw_enable-into-core-code
+++ a/include/linux/rio.h
@@ -266,6 +266,7 @@ enum rio_phy_type {
  * @dma: DMA device associated with mport
  * @nscan: RapidIO network enumeration/discovery operations
  * @state: mport device state
+ * @pwe_refcnt: port-write enable ref counter to track enable/disable requests
  */
 struct rio_mport {
 	struct list_head dbells;	/* list of doorbell events */
@@ -296,6 +297,7 @@ struct rio_mport {
 #endif
 	struct rio_scan *nscan;
 	atomic_t state;
+	unsigned int pwe_refcnt;
 };
 
 static inline int rio_mport_is_running(struct rio_mport *mport)
diff -puN include/linux/rio_drv.h~rapidio-move-rio_pw_enable-into-core-code include/linux/rio_drv.h
--- a/include/linux/rio_drv.h~rapidio-move-rio_pw_enable-into-core-code
+++ a/include/linux/rio_drv.h
@@ -375,6 +375,7 @@ extern int rio_request_inb_pwrite(struct
 			int (*)(struct rio_dev *, union rio_pw_msg*, int));
 extern int rio_release_inb_pwrite(struct rio_dev *);
 extern int rio_inb_pwrite_handler(union rio_pw_msg *pw_msg);
+extern void rio_pw_enable(struct rio_mport *mport, int enable);
 
 /* LDM support */
 int rio_register_driver(struct rio_driver *);
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are


