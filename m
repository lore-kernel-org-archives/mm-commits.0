From: akpm@linux-foundation.org
Subject: [merged] genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:50:39 -0700
Message-ID: <20130430185039.A2A025A4088@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:50487 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932811Ab3D3Sul (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:50:41 -0400
Received: by mail-yh0-f73.google.com with SMTP id f35so86156yha.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:50:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: p.zabel@pengutronix.de, dong.aisheng@linaro.org, fabio.estevam@freescale.com, grant.likely@secretlab.ca, gregkh@linuxfoundation.org, javier.martin@vista-silicon.com, monstr@monstr.eu, mporter@ti.com, paul.gortmaker@windriver.com, rob.herring@calxeda.com, shijie8@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: genalloc: add devres support, allow to find a managed pool by device
has been removed from the -mm tree.  Its filename was
     genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Philipp Zabel <p.zabel@pengutronix.de>
Subject: genalloc: add devres support, allow to find a managed pool by device

This patch adds three exported functions to lib/genalloc.c:
devm_gen_pool_create, dev_get_gen_pool, and of_get_named_gen_pool.

devm_gen_pool_create is a managed version of gen_pool_create that keeps
track of the pool via devres and allows the management code to
automatically destroy it after device removal.

dev_get_gen_pool retrieves the gen_pool for a given device, if it was
created with devm_gen_pool_create, using devres_find.

of_get_named_gen_pool retrieves the gen_pool for a given device node and
property name, where the property must contain a phandle pointing to a
platform device node.  The corresponding platform device is then fed into
dev_get_gen_pool and the resulting gen_pool is returned.

[akpm@linux-foundation.org: make the of_get_named_gen_pool() stub static, fixing a zillion link errors]
[akpm@linux-foundation.org: squish "struct device declared inside parameter list" warning]
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Tested-by: Michal Simek <monstr@monstr.eu>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Matt Porter <mporter@ti.com>
Cc: Dong Aisheng <dong.aisheng@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Javier Martin <javier.martin@vista-silicon.com>
Cc: Huang Shijie <shijie8@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genalloc.h |   18 ++++++++
 lib/genalloc.c           |   81 +++++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+)

diff -puN include/linux/genalloc.h~genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device include/linux/genalloc.h
--- a/include/linux/genalloc.h~genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device
+++ a/include/linux/genalloc.h
@@ -29,6 +29,10 @@
 
 #ifndef __GENALLOC_H__
 #define __GENALLOC_H__
+
+struct device;
+struct device_node;
+
 /**
  * Allocation callback function type definition
  * @map: Pointer to bitmap
@@ -105,4 +109,18 @@ extern unsigned long gen_pool_first_fit(
 extern unsigned long gen_pool_best_fit(unsigned long *map, unsigned long size,
 		unsigned long start, unsigned int nr, void *data);
 
+extern struct gen_pool *devm_gen_pool_create(struct device *dev,
+		int min_alloc_order, int nid);
+extern struct gen_pool *dev_get_gen_pool(struct device *dev);
+
+#ifdef CONFIG_OF
+extern struct gen_pool *of_get_named_gen_pool(struct device_node *np,
+	const char *propname, int index);
+#else
+static inline struct gen_pool *of_get_named_gen_pool(struct device_node *np,
+	const char *propname, int index)
+{
+	return NULL;
+}
+#endif
 #endif /* __GENALLOC_H__ */
diff -puN lib/genalloc.c~genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device lib/genalloc.c
--- a/lib/genalloc.c~genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device
+++ a/lib/genalloc.c
@@ -34,6 +34,8 @@
 #include <linux/rculist.h>
 #include <linux/interrupt.h>
 #include <linux/genalloc.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
 
 static int set_bits_ll(unsigned long *addr, unsigned long mask_to_set)
 {
@@ -480,3 +482,82 @@ unsigned long gen_pool_best_fit(unsigned
 	return start_bit;
 }
 EXPORT_SYMBOL(gen_pool_best_fit);
+
+static void devm_gen_pool_release(struct device *dev, void *res)
+{
+	gen_pool_destroy(*(struct gen_pool **)res);
+}
+
+/**
+ * devm_gen_pool_create - managed gen_pool_create
+ * @dev: device that provides the gen_pool
+ * @min_alloc_order: log base 2 of number of bytes each bitmap bit represents
+ * @nid: node id of the node the pool structure should be allocated on, or -1
+ *
+ * Create a new special memory pool that can be used to manage special purpose
+ * memory not managed by the regular kmalloc/kfree interface. The pool will be
+ * automatically destroyed by the device management code.
+ */
+struct gen_pool *devm_gen_pool_create(struct device *dev, int min_alloc_order,
+		int nid)
+{
+	struct gen_pool **ptr, *pool;
+
+	ptr = devres_alloc(devm_gen_pool_release, sizeof(*ptr), GFP_KERNEL);
+
+	pool = gen_pool_create(min_alloc_order, nid);
+	if (pool) {
+		*ptr = pool;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return pool;
+}
+
+/**
+ * dev_get_gen_pool - Obtain the gen_pool (if any) for a device
+ * @dev: device to retrieve the gen_pool from
+ * @name: Optional name for the gen_pool, usually NULL
+ *
+ * Returns the gen_pool for the device if one is present, or NULL.
+ */
+struct gen_pool *dev_get_gen_pool(struct device *dev)
+{
+	struct gen_pool **p = devres_find(dev, devm_gen_pool_release, NULL,
+					NULL);
+
+	if (!p)
+		return NULL;
+	return *p;
+}
+EXPORT_SYMBOL_GPL(dev_get_gen_pool);
+
+#ifdef CONFIG_OF
+/**
+ * of_get_named_gen_pool - find a pool by phandle property
+ * @np: device node
+ * @propname: property name containing phandle(s)
+ * @index: index into the phandle array
+ *
+ * Returns the pool that contains the chunk starting at the physical
+ * address of the device tree node pointed at by the phandle property,
+ * or NULL if not found.
+ */
+struct gen_pool *of_get_named_gen_pool(struct device_node *np,
+	const char *propname, int index)
+{
+	struct platform_device *pdev;
+	struct device_node *np_pool;
+
+	np_pool = of_parse_phandle(np, propname, index);
+	if (!np_pool)
+		return NULL;
+	pdev = of_find_device_by_node(np_pool);
+	if (!pdev)
+		return NULL;
+	return dev_get_gen_pool(&pdev->dev);
+}
+EXPORT_SYMBOL_GPL(of_get_named_gen_pool);
+#endif /* CONFIG_OF */
_

Patches currently in -mm which might be from p.zabel@pengutronix.de are

origin.patch
linux-next.patch

