From: akpm@linux-foundation.org
Subject: - rapidio-add-memory-mapping-driver-to-rapidio.patch removed from -mm tree
Date: Wed, 30 Apr 2008 15:25:22 -0700
Message-ID: <200804302225.m3UMPML6006683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759923AbYD3W0B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 18:26:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.zhang@freescale.com, galak@gate.crashing.org, mm-commits@vger.kernel.org


The patch titled
     rapidio: add memory mapping driver to RapidIO
has been removed from the -mm tree.  Its filename was
     rapidio-add-memory-mapping-driver-to-rapidio.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: add memory mapping driver to RapidIO
From: Zhang Wei <wei.zhang@freescale.com>

The memory mapping driver is used for mapping IO address and system memory
address space to RapidIO address space.  The driver support IO space
allocation, RapidIO space inbound window and outbound window creation.  The
system can access other RapidIO device by outbound window and can be accessed
by other RapidIO device through inbound window.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |    4 
 drivers/rapidio/rio.c         |  362 ++++++++++++++++++++++++++++++++
 include/linux/rio.h           |   39 +++
 include/linux/rio_drv.h       |   41 +++
 4 files changed, 440 insertions(+), 6 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-add-memory-mapping-driver-to-rapidio arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-add-memory-mapping-driver-to-rapidio
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -1058,6 +1058,7 @@ int fsl_rio_setup(struct of_device *dev)
 	port = kzalloc(sizeof(struct rio_mport), GFP_KERNEL);
 	port->id = 0;
 	port->index = 0;
+	port->dev = &dev->dev;
 
 	priv = kzalloc(sizeof(struct rio_priv), GFP_KERNEL);
 	if (!priv) {
@@ -1068,8 +1069,9 @@ int fsl_rio_setup(struct of_device *dev)
 
 	INIT_LIST_HEAD(&port->dbells);
 	port->iores.start = law_start;
-	port->iores.end = law_start + law_size;
+	port->iores.end = law_start + law_size - 1;
 	port->iores.flags = IORESOURCE_MEM;
+	port->iores.name = "rio_io_win";
 
 	priv->bellirq = irq_of_parse_and_map(dev->node, 2);
 	priv->txirq = irq_of_parse_and_map(dev->node, 3);
diff -puN drivers/rapidio/rio.c~rapidio-add-memory-mapping-driver-to-rapidio drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-add-memory-mapping-driver-to-rapidio
+++ a/drivers/rapidio/rio.c
@@ -2,9 +2,16 @@
  * RapidIO interconnect services
  * (RapidIO Interconnect Specification, http://www.rapidio.org)
  *
+ * Copyright (C) 2007 Freescale Semiconductor, Inc.
+ * Author: Zhang Wei, wei.zhang@freescale.com, Jun 2007
+ *
  * Copyright 2005 MontaVista Software, Inc.
  * Matt Porter <mporter@kernel.crashing.org>
  *
+ * Changelog:
+ * Jun 2007 Zhang Wei <wei.zhang@freescale.com>
+ * - Add memory mapping support.
+ *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
  * Free Software Foundation;  either version 2 of the  License, or (at your
@@ -24,10 +31,16 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
+#include <linux/hardirq.h>
 
 #include "rio.h"
 
 static LIST_HEAD(rio_mports);
+static LIST_HEAD(rio_inb_mems);
+static LIST_HEAD(rio_outb_mems);
+
+static DEFINE_SPINLOCK(rio_config_lock);
 
 /**
  * rio_local_get_device_id - Get the base/extended device id for a port
@@ -333,6 +346,355 @@ int rio_release_outb_dbell(struct rio_de
 }
 
 /**
+ * rio_request_io_region - request resource in RapidIO IO region
+ * @mport: Master port
+ * @res: Resource need be requested.
+ *
+ * Return: 0 - Successed.
+ */
+int rio_request_io_region(struct rio_mport *mport, struct resource *res)
+{
+	if (!res)
+		return -EINVAL;
+
+	return request_resource(&mport->iores, res);
+}
+EXPORT_SYMBOL_GPL(rio_request_io_region);
+
+/**
+ * rio_alloc_io - Allocat IO resource for RapidIO master port.
+ * @mport: Master port
+ * @size: IO resource size
+ * @name: Resource name
+ * @flag: Flag for resource
+ * @res: Return resource which has been allocated.
+ */
+int rio_alloc_io(struct rio_mport *mport, resource_size_t size,
+		const char *name, unsigned long flags, struct resource *res)
+{
+	if (!res)
+		return -EINVAL;
+
+	size = (size < 0x1000) ? 0x1000 : 1 << (__ilog2(size - 1) + 1);
+
+	if (allocate_resource(&mport->iores, res, size,	mport->iores.start,
+				mport->iores.end, size, NULL, NULL) < 0) {
+		dev_err(mport->dev, "allocte IO error, no enough space!\n");
+		return -ENOSPC;
+	}
+	res->name = name;
+	res->flags = flags;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rio_alloc_io);
+
+/**
+ * rio_map_inb_region -- Mapping inbound memory region.
+ * @mport: Master port.
+ * @mem: Memory struction for mapping.
+ * @rflags: Flags for mapping.
+ *
+ * Return: 0 -- Success.
+ *
+ * This function will create the mapping from the mem->riores to mem->iores.
+ */
+int rio_map_inb_region(struct rio_mport *mport, struct rio_mem *mem, u32 rflags)
+{
+	int rc = 0;
+	unsigned long flags;
+
+	if (!mport->mops)
+		return -1;
+	spin_lock_irqsave(&rio_config_lock, flags);
+	rc = mport->mops->map_inb(mport, mem->iores.start, mem->riores.start,
+					mem->size, rflags);
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
+ * This function will create the mapping from the mem->iores to mem->riores.
+ */
+int rio_map_outb_region(struct rio_mport *mport, u16 tid,
+		struct rio_mem *mem, u32 rflags)
+{
+	int rc = 0;
+	unsigned long flags;
+
+	if (!mport->mops)
+		return -1;
+	spin_lock_irqsave(&rio_config_lock, flags);
+	rc = mport->mops->map_outb(mport, mem->iores.start, mem->riores.start,
+					mem->size, tid, rflags);
+	spin_unlock_irqrestore(&rio_config_lock, flags);
+	return rc;
+}
+
+/**
+ * rio_unmap_inb_region -- Unmap the inbound memory region
+ * @mport: Master port
+ * @mem: Memory struction for unmapping.
+ */
+void rio_unmap_inb_region(struct rio_mport *mport, struct rio_mem *mem)
+{
+	unsigned long flags;
+	if (!mport->mops)
+		return;
+	spin_lock_irqsave(&rio_config_lock, flags);
+	mport->mops->unmap_inb(mport, mem->iores.start);
+	spin_unlock_irqrestore(&rio_config_lock, flags);
+}
+
+/**
+ * rio_unmap_outb_region -- Unmap the outbound memory region
+ * @mport: Master port
+ * @mem: Memory struction for unmapping.
+ */
+void rio_unmap_outb_region(struct rio_mport *mport, struct rio_mem *mem)
+{
+	unsigned long flags;
+	if (!mport->mops)
+		return;
+	spin_lock_irqsave(&rio_config_lock, flags);
+	mport->mops->unmap_outb(mport, mem->iores.start);
+	spin_unlock_irqrestore(&rio_config_lock, flags);
+}
+
+/**
+ * rio_release_inb_region -- Release the inbound region resource.
+ * @mport: Master port
+ * @mem: Inbound region descriptor
+ *
+ * Return 0 is successed.
+ */
+int rio_release_inb_region(struct rio_mport *mport, struct rio_mem *mem)
+{
+	int rc = 0;
+	if (!mem)
+		return rc;
+	rio_unmap_inb_region(mport, mem);
+	if (mem->virt)
+		dma_free_coherent(NULL, mem->size, mem->virt, mem->iores.start);
+
+	if (mem->iores.parent)
+		rc = release_resource(&mem->iores);
+	if (mem->riores.parent && !rc)
+		rc = release_resource(&mem->riores);
+
+	if (mem->node.prev)
+		list_del(&mem->node);
+
+	kfree(mem);
+
+	return rc;
+}
+
+/**
+ * rio_request_inb_region -- Request inbound memory region
+ * @mport: Master port
+ * @dev_id: Device specific pointer to pass
+ * @size: The request memory windows size
+ * @name: The region name
+ * @owner: The region owner driver id
+ *
+ * Retrun: The rio_mem struction for inbound memory descriptor.
+ *
+ * This function is used for request RapidIO space inbound region. If the size
+ * less than 4096 or not aligned to 2^N, it will be adjusted. The function will
+ * alloc a block of local DMA memory of the size for inbound region target and
+ * request a RapidIO region for inbound region source. Then the inbound region
+ * will be claimed in RapidIO space and the local DMA memory will be added to
+ * local inbound memory list. The rio_mem with the inbound relationship will
+ * be returned.
+ */
+struct rio_mem *rio_request_inb_region(struct rio_mport *mport, void *dev_id,
+		resource_size_t size, const char *name, u32 owner)
+{
+	struct rio_mem *rmem = NULL;
+	struct rio_dev *dev = dev_id;
+	int ret;
+
+	rmem = kzalloc(sizeof(struct rio_mem), GFP_KERNEL);
+	if (!rmem)
+		goto err;
+
+	/* Align the size to 2^N */
+	size = (size < 0x1000) ? 0x1000 : 1 << (__ilog2(size - 1) + 1);
+
+	/* Alloc the RapidIO space */
+	ret = rio_space_request(mport, size, &rmem->riores);
+	if (ret) {
+		dev_err(mport->dev, "RIO space request error! ret = %d\n", ret);
+		goto err;
+	}
+
+	rmem->dev = dev;
+	rmem->riores.name = name;
+	rmem->size = rmem->riores.end - rmem->riores.start + 1;
+
+	/* Initialize inbound memory */
+	rmem->virt = dma_alloc_coherent(NULL, rmem->size, &rmem->iores.start,
+					GFP_KERNEL);
+	if (!rmem->virt) {
+		dev_err(mport->dev, "Inbound memory alloc error\n");
+		goto err;
+	}
+	rmem->iores.end = rmem->iores.start + rmem->size - 1;
+	rmem->owner = owner;
+
+	/* Map RIO space to local DMA memory */
+	ret = rio_map_inb_region(mport, rmem, 0);
+	if (ret) {
+		dev_err(mport->dev, "RIO map inbound mem error, ret = %d\n",
+					ret);
+		goto err;
+	}
+
+	/* Claim the region */
+	ret = rio_space_claim(rmem);
+	if (ret) {
+		dev_err(mport->dev, "RIO inbound mem claim error, ret = %d\n",
+					ret);
+		goto err;
+	}
+	list_add(&rmem->node, &rio_inb_mems);
+
+	return rmem;
+
+err:
+	rio_release_inb_region(mport, rmem);
+	return NULL;
+}
+
+/**
+ * rio_release_outb_region -- Release the outbound region resource.
+ * @mport: Master port
+ * @mem: Outbound region descriptor
+ *
+ * Return 0 is successed.
+ */
+int rio_release_outb_region(struct rio_mport *mport, struct rio_mem *mem)
+{
+	int rc = 0;
+	if (!mem)
+		return rc;
+	rio_unmap_outb_region(mport, mem);
+	rio_space_release(mem);
+	if (mem->virt)
+		iounmap(mem->virt);
+
+	if (mem->iores.parent)
+		rc = release_resource(&mem->iores);
+	if (mem->riores.parent && !rc)
+		rc = release_resource(&mem->riores);
+
+	if (mem->node.prev)
+		list_del(&mem->node);
+
+	kfree(mem);
+
+	return rc;
+}
+
+/** rio_prepare_io_mem -- Prepare IO region for RapidIO outbound mapping
+ * @mport: Master port
+ * @dev: RIO device specific pointer to pass
+ * @size: Request IO size
+ * @name: The request IO resource name
+ *
+ * Return: The rio_mem descriptor with IO region resource.
+ *
+ * This function request IO region firstly and ioremap it for preparing
+ * outbound window mapping. The function do not map the outbound region
+ * because ioremap can not located at the interrupt action function.
+ * The function can be called in the initialization for just prepared.
+ */
+struct rio_mem *rio_prepare_io_mem(struct rio_mport *mport,
+		struct rio_dev *dev, resource_size_t size, const char *name)
+{
+	struct rio_mem *rmem = NULL;
+	int rc;
+
+	rmem = kzalloc(sizeof(struct rio_mem), GFP_KERNEL);
+	if (!rmem)
+		goto err;
+
+	/* Align the size to 2^N */
+	size = (size < 0x1000) ? 0x1000 : 1 << (__ilog2(size - 1) + 1);
+
+	/* Request RapidIO IO region */
+	rc = rio_alloc_io(mport, size, name, RIO_RESOURCE_MEM, &rmem->iores);
+	if (rc) {
+		dev_err(mport->dev,
+			"RIO io region request error with rc = %d!\n", rc);
+		goto err;
+	}
+
+	rmem->virt = ioremap((phys_addr_t)(rmem->iores.start), size);
+	rmem->size = size;
+	rmem->dev = dev;
+
+	list_add(&rmem->node, &rio_outb_mems);
+	return rmem;
+err:
+	rio_release_outb_region(mport, rmem);
+	return NULL;
+}
+
+/** rio_request_outb_region -- Request IO region and get outbound region
+ *                             for RapidIO outbound mapping
+ * @mport: Master port
+ * @dev_id: RIO device specific pointer to pass
+ * @size: Request IO size
+ * @name: The request IO resource name
+ * @owner: The outbound region owned driver
+ *
+ * Return: The rio_mem descriptor with IO region resource.
+ *
+ * This function request IO region firstly and ioremap it for preparing
+ * outbound window mapping. And it will find the RapidIO region owned by
+ * the driver id. Then map it. Be careful about that the ioremap can not
+ * be called in the interrupt event action function.
+ */
+struct rio_mem *rio_request_outb_region(struct rio_mport *mport, void *dev_id,
+			resource_size_t size, const char *name, u32 owner)
+{
+	struct rio_mem *rmem = NULL;
+	struct rio_dev *dev = dev_id;
+
+	if (!dev)
+		goto err;
+
+	rmem = rio_prepare_io_mem(mport, dev, size, name);
+	if (!rmem)
+		goto err;
+
+	if (rio_space_find_mem(mport, dev->destid, owner, &rmem->riores)) {
+		dev_err(mport->dev,
+			"Can not find RIO region meet the ownerid %x\n", owner);
+		goto err;
+	}
+
+	/* Map the rio space to local */
+	if (rio_map_outb_region(mport, dev->destid, rmem, 0)) {
+		dev_err(mport->dev, "RIO map outb error!\n");
+		goto err;
+	}
+	return rmem;
+err:
+	rio_release_outb_region(mport, rmem);
+	return NULL;
+}
+
+/**
  * rio_mport_get_feature - query for devices' extended features
  * @port: Master port to issue transaction
  * @local: Indicate a local master port or remote device access
diff -puN include/linux/rio.h~rapidio-add-memory-mapping-driver-to-rapidio include/linux/rio.h
--- a/include/linux/rio.h~rapidio-add-memory-mapping-driver-to-rapidio
+++ a/include/linux/rio.h
@@ -174,6 +174,7 @@ struct rio_mport {
 	struct rio_msg outb_msg[RIO_MAX_MBOX];
 	int host_deviceid;	/* Host device ID */
 	struct rio_ops *ops;	/* maintenance transaction functions */
+	struct rio_mem_ops *mops; /* Memory functions */
 	unsigned char id;	/* port ID, unique among all ports */
 	unsigned char index;	/* port index, unique among all port
 				   interfaces of the same type */
@@ -183,6 +184,7 @@ struct rio_mport {
 				 */
 	enum rio_phy_type phy_type;	/* RapidIO phy type */
 	unsigned char name[40];
+	struct device *dev;
 	void *priv;		/* Master port private data */
 };
 
@@ -317,6 +319,43 @@ struct rio_route_ops {
 			 u16 table, u16 route_destid, u8 * route_port);
 };
 
+/**
+ * Struct for RIO memory definition.
+ * @node: Node in list of memories
+ * @virt: The virtual address for mapped memory accessing.
+ * @owner: The owner id of this memory.
+ * @size: The size of memory space, it should same to iores and riores.
+ * @iores: The resource of local IO region for mapping.
+ * @riores: The resource of mapped RapidIO space region.
+ */
+struct rio_mem {
+	struct list_head node;
+	void *virt;
+	u32 owner;
+	struct rio_dev *dev;
+	resource_size_t size;
+	struct resource iores;
+	struct resource riores;
+};
+
+/**
+ * Struct for RIO memory definition.
+ * @map_inb: The function for mapping inbound memory window.
+ * @map_outb: The function for mapping outbound memory window.
+ * @unmap_inb: The function for unmapping inbound memory window.
+ * @unmap_outb: The function for unmapping outbound memory window.
+ */
+struct rio_mem_ops {
+	int (*map_inb) (struct rio_mport *, resource_size_t lstart,
+			resource_size_t rstart,
+			resource_size_t size, u32 flags);
+	int (*map_outb) (struct rio_mport *, resource_size_t lstart,
+			resource_size_t rstart,
+			resource_size_t size, u16 tid, u32 flags);
+	void (*unmap_inb) (struct rio_mport *, resource_size_t lstart);
+	void (*unmap_outb) (struct rio_mport *, resource_size_t lstart);
+};
+
 /* Architecture and hardware-specific functions */
 extern int rio_init_mports(void);
 extern void rio_register_mport(struct rio_mport *);
diff -puN include/linux/rio_drv.h~rapidio-add-memory-mapping-driver-to-rapidio include/linux/rio_drv.h
--- a/include/linux/rio_drv.h~rapidio-add-memory-mapping-driver-to-rapidio
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
@@ -406,13 +416,33 @@ extern int rio_request_inb_dbell(struct 
 extern int rio_release_inb_dbell(struct rio_mport *, u16, u16);
 extern struct resource *rio_request_outb_dbell(struct rio_dev *, u16, u16);
 extern int rio_release_outb_dbell(struct rio_dev *, struct resource *);
+extern int rio_request_io_region(struct rio_mport *, struct resource *);
+extern int rio_alloc_io(struct rio_mport *mport, resource_size_t size,
+		const char *name, unsigned long flags, struct resource *res);
+extern struct rio_mem *rio_prepare_io_mem(struct rio_mport *, struct rio_dev *,
+				resource_size_t, const char *);
 
 /* Memory region management */
-int rio_claim_resource(struct rio_dev *, int);
-int rio_request_regions(struct rio_dev *, char *);
-void rio_release_regions(struct rio_dev *);
-int rio_request_region(struct rio_dev *, int, char *);
-void rio_release_region(struct rio_dev *, int);
+extern struct rio_mem *rio_request_inb_region(struct rio_mport *, void *,
+				resource_size_t, const char *, u32);
+extern struct rio_mem *rio_request_outb_region(struct rio_mport *,
+		void *, resource_size_t, const char *, u32);
+extern int rio_release_inb_region(struct rio_mport *, struct rio_mem *);
+extern int rio_release_outb_region(struct rio_mport *, struct rio_mem *);
+
+/* Memory low-level mapping functions */
+extern int rio_map_inb_region(struct rio_mport *, struct rio_mem *, u32);
+extern int rio_map_outb_region(struct rio_mport *, u16, struct rio_mem *, u32);
+extern void rio_unmap_inb_region(struct rio_mport *, struct rio_mem *);
+extern void rio_unmap_outb_region(struct rio_mport *, struct rio_mem *);
+
+/* Memory Allocator */
+extern int rio_space_request(struct rio_mport *, resource_size_t,
+						struct resource *);
+extern int rio_space_find_mem(struct rio_mport *, u16, u32, struct resource *);
+extern int rio_space_init(struct rio_mport *);
+extern int rio_space_claim(struct rio_mem *);
+extern void rio_space_release(struct rio_mem *);
 
 /* LDM support */
 int rio_register_driver(struct rio_driver *);
@@ -462,5 +492,6 @@ extern u16 rio_local_get_device_id(struc
 extern struct rio_dev *rio_get_device(u16 vid, u16 did, struct rio_dev *from);
 extern struct rio_dev *rio_get_asm(u16 vid, u16 did, u16 asm_vid, u16 asm_did,
 				   struct rio_dev *from);
+extern u32 rio_get_mport_id(struct rio_mport *);
 
 #endif				/* LINUX_RIO_DRV_H */
_

Patches currently in -mm which might be from wei.zhang@freescale.com are

origin.patch
rapidio-add-memory-mapping-driver-to-rapidio.patch
rapidio-add-rapidio-space-allocation-bitmap-arithmetic.patch
rapidio-add-fsl-rapidio-controller-memory-ops-functions.patch
rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window-to-space-resources.patch
rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging.patch
rapidio-add-the-memory-mapping-support-in-rionet-driver.patch
rapidio-fix-docbook-references.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch

