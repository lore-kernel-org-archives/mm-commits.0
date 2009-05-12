From: akpm@linux-foundation.org
Subject: + rapidio-add-common-mapping-apis-for-rapidio-memory-access.patch added to -mm tree
Date: Tue, 12 May 2009 15:11:24 -0700
Message-ID: <200905122211.n4CMBOwJ020141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753144AbZELWPJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 May 2009 18:15:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: leoli@freescale.com, benh@kernel.crashing.org, galak@gate.crashing.org, mporter@kernel.crashing.org, zw@zh-kernel.org


The patch titled
     rapidio: add common mapping APIs for RapidIO memory access
has been added to the -mm tree.  Its filename is
     rapidio-add-common-mapping-apis-for-rapidio-memory-access.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: add common mapping APIs for RapidIO memory access
From: Li Yang <leoli@freescale.com>

Add the mapping functions used to support direct IO memory access of
rapidIO.

Signed-off-by: Zhang Wei <zw@zh-kernel.org>
Signed-off-by: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c   |   95 ++++++++++++++++++++++++++++++++++++++
 include/linux/rio.h     |   25 ++++++++++
 include/linux/rio_drv.h |   24 +++++++--
 3 files changed, 138 insertions(+), 6 deletions(-)

diff -puN drivers/rapidio/rio.c~rapidio-add-common-mapping-apis-for-rapidio-memory-access drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-add-common-mapping-apis-for-rapidio-memory-access
+++ a/drivers/rapidio/rio.c
@@ -2,6 +2,8 @@
  * RapidIO interconnect services
  * (RapidIO Interconnect Specification, http://www.rapidio.org)
  *
+ * Copyright (C) 2007-2009 Freescale Semiconductor, Inc.
+ *
  * Copyright 2005 MontaVista Software, Inc.
  * Matt Porter <mporter@kernel.crashing.org>
  *
@@ -24,11 +26,23 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
+#include <linux/hardirq.h>
 
 #include "rio.h"
 
 static LIST_HEAD(rio_mports);
 
+static DEFINE_SPINLOCK(rio_config_lock);
+
+struct resource rio_resource = {
+	.name	= "RapidIO GSM",
+	.start	= 0,
+	.end	= -1,
+	.flags	= IORESOURCE_MEM,
+};
+EXPORT_SYMBOL(rio_resource);
+
 /**
  * rio_local_get_device_id - Get the base/extended device id for a port
  * @port: RIO master port from which to get the deviceid
@@ -333,6 +347,87 @@ int rio_release_outb_dbell(struct rio_de
 }
 
 /**
+ * rio_map_inb_region -- Mapping inbound memory region.
+ * @mport: Master port.
+ * @mem: Memory struction for mapping.
+ * @rflags: Flags for mapping.
+ *
+ * Return: 0 -- Success.
+ *
+ * This function will create the mapping from rio space to local mem.
+ */
+int rio_map_inb_region(struct rio_mport *mport, struct resource *rio_res,
+			dma_addr_t local, u32 rflags)
+{
+	int rc = 0;
+	unsigned long flags;
+
+	if (!mport->mops)
+		return -1;
+	spin_lock_irqsave(&rio_config_lock, flags);
+	rc = mport->mops->map_inb(mport, local, rio_res->start,
+				resource_size(rio_res), rflags);
+	spin_unlock_irqrestore(&rio_config_lock, flags);
+	return rc;
+}
+
+/**
+ * rio_map_outb_region -- Mapping outbound memory region.
+ * @mport: Master port.
+ * @tid: Target RapidIO device id.
+ * @mem: Memory struction for mapping.
+ * @rflags: Flags for mapping.
+ *
+ * Return: 0 -- Success.
+ *
+ * This function will create the mapping from local iomem to rio space.
+ */
+int rio_map_outb_region(struct rio_mport *mport, u16 tid,
+		struct resource *rio_res, phys_addr_t lstart, u32 rflags)
+{
+	int rc = 0;
+	unsigned long flags;
+
+	if (!mport->mops)
+		return -1;
+	spin_lock_irqsave(&rio_config_lock, flags);
+	rc = mport->mops->map_outb(mport, lstart, rio_res->start,
+				resource_size(rio_res), tid, rflags);
+	spin_unlock_irqrestore(&rio_config_lock, flags);
+	return rc;
+}
+
+/**
+ * rio_unmap_inb_region -- Unmap the inbound memory region
+ * @mport: Master port
+ * @mem: Memory struction for unmapping.
+ */
+void rio_unmap_inb_region(struct rio_mport *mport, dma_addr_t lstart)
+{
+	unsigned long flags;
+	if (!mport->mops)
+		return;
+	spin_lock_irqsave(&rio_config_lock, flags);
+	mport->mops->unmap_inb(mport, lstart);
+	spin_unlock_irqrestore(&rio_config_lock, flags);
+}
+
+/**
+ * rio_unmap_outb_region -- Unmap the outbound memory region
+ * @mport: Master port
+ * @mem: Memory struction for unmapping.
+ */
+void rio_unmap_outb_region(struct rio_mport *mport, phys_addr_t lstart)
+{
+	unsigned long flags;
+	if (!mport->mops)
+		return;
+	spin_lock_irqsave(&rio_config_lock, flags);
+	mport->mops->unmap_outb(mport, lstart);
+	spin_unlock_irqrestore(&rio_config_lock, flags);
+}
+
+/**
  * rio_mport_get_feature - query for devices' extended features
  * @port: Master port to issue transaction
  * @local: Indicate a local master port or remote device access
diff -puN include/linux/rio.h~rapidio-add-common-mapping-apis-for-rapidio-memory-access include/linux/rio.h
--- a/include/linux/rio.h~rapidio-add-common-mapping-apis-for-rapidio-memory-access
+++ a/include/linux/rio.h
@@ -176,6 +176,7 @@ struct rio_mport {
 	struct rio_msg outb_msg[RIO_MAX_MBOX];
 	int host_deviceid;	/* Host device ID */
 	struct rio_ops *ops;	/* maintenance transaction functions */
+	struct rio_mem_ops *mops; /* Memory functions */
 	unsigned char id;	/* port ID, unique among all ports */
 	unsigned char index;	/* port index, unique among all port
 				   interfaces of the same type */
@@ -185,6 +186,7 @@ struct rio_mport {
 				 */
 	enum rio_phy_type phy_type;	/* RapidIO phy type */
 	unsigned char name[40];
+	struct device *dev;
 	void *priv;		/* Master port private data */
 };
 
@@ -319,6 +321,29 @@ struct rio_route_ops {
 			 u16 table, u16 route_destid, u8 * route_port);
 };
 
+extern struct resource rio_resource;
+#define request_rio_region(start, n, name, flag) \
+		__request_region(&rio_resource, (start), (n), (name), (flag))
+#define release_rio_region(start, n) __release_region(&rio_resource, (start), (n))
+
+/**
+ * Struct for RIO memory definition.
+ * @map_inb: The function for mapping inbound memory window.
+ * @map_outb: The function for mapping outbound memory window.
+ * @unmap_inb: The function for unmapping inbound memory window.
+ * @unmap_outb: The function for unmapping outbound memory window.
+ */
+struct rio_mem_ops {
+	int (*map_inb) (struct rio_mport *, dma_addr_t lstart,
+			resource_size_t rstart,
+			resource_size_t size, u32 flags);
+	int (*map_outb) (struct rio_mport *, phys_addr_t lstart,
+			resource_size_t rstart,
+			resource_size_t size, u16 tid, u32 flags);
+	void (*unmap_inb) (struct rio_mport *, dma_addr_t lstart);
+	void (*unmap_outb) (struct rio_mport *, phys_addr_t lstart);
+};
+
 /* Architecture and hardware-specific functions */
 extern int rio_init_mports(void);
 extern void rio_register_mport(struct rio_mport *);
diff -puN include/linux/rio_drv.h~rapidio-add-common-mapping-apis-for-rapidio-memory-access include/linux/rio_drv.h
--- a/include/linux/rio_drv.h~rapidio-add-common-mapping-apis-for-rapidio-memory-access
+++ a/include/linux/rio_drv.h
@@ -332,6 +332,16 @@ static inline void rio_init_dbell_res(st
 	res->flags = RIO_RESOURCE_DOORBELL;
 }
 
+static inline void rio_init_io_res(struct resource *res, resource_size_t start,
+		resource_size_t size, const char *name, unsigned long flag)
+{
+	memset(res, 0, sizeof(struct resource));
+	res->start = start;
+	res->end = start + size - 1;
+	res->name = name;
+	res->flags = flag;
+}
+
 /**
  * RIO_DEVICE - macro used to describe a specific RIO device
  * @dev: the 16 bit RIO device ID
@@ -406,12 +416,13 @@ extern int rio_release_inb_dbell(struct 
 extern struct resource *rio_request_outb_dbell(struct rio_dev *, u16, u16);
 extern int rio_release_outb_dbell(struct rio_dev *, struct resource *);
 
-/* Memory region management */
-int rio_claim_resource(struct rio_dev *, int);
-int rio_request_regions(struct rio_dev *, char *);
-void rio_release_regions(struct rio_dev *);
-int rio_request_region(struct rio_dev *, int, char *);
-void rio_release_region(struct rio_dev *, int);
+/* Memory low-level mapping functions */
+extern int rio_map_inb_region(struct rio_mport *, struct resource *,
+				dma_addr_t, u32);
+extern int rio_map_outb_region(struct rio_mport *, u16, struct resource *,
+				phys_addr_t, u32);
+extern void rio_unmap_inb_region(struct rio_mport *, dma_addr_t);
+extern void rio_unmap_outb_region(struct rio_mport *, phys_addr_t);
 
 /* LDM support */
 int rio_register_driver(struct rio_driver *);
@@ -461,5 +472,6 @@ extern u16 rio_local_get_device_id(struc
 extern struct rio_dev *rio_get_device(u16 vid, u16 did, struct rio_dev *from);
 extern struct rio_dev *rio_get_asm(u16 vid, u16 did, u16 asm_vid, u16 asm_did,
 				   struct rio_dev *from);
+extern u32 rio_get_mport_id(struct rio_mport *);
 
 #endif				/* LINUX_RIO_DRV_H */
_

Patches currently in -mm which might be from leoli@freescale.com are

rapidio-add-common-mapping-apis-for-rapidio-memory-access.patch
powerpc-fsl_rio-use-law-address-from-device-tree.patch
powerpc-add-memory-map-support-to-freescale-rapidio-block.patch
rionet-add-memory-access-to-simulated-ethernet-over-rapidio.patch
rio-warn_unused_result-warnings-fix.patch
rio-fix-section-mismatch.patch

