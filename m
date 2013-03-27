From: akpm@linux-foundation.org
Subject: + genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device.patch added to -mm tree
Date: Wed, 27 Mar 2013 15:29:51 -0700
Message-ID: <20130327222951.C492A5A428F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:46385 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab3C0W3x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Mar 2013 18:29:53 -0400
Received: by mail-qa0-f74.google.com with SMTP id k4so202861qaq.3
        for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2013 15:29:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: p.zabel@pengutronix.de, dong.aisheng@linaro.org, fabio.estevam@freescale.com, grant.likely@secretlab.ca, gregkh@linuxfoundation.org, javier.martin@vista-silicon.com, monstr@monstr.eu, mporter@ti.com, paul.gortmaker@windriver.com, rob.herring@calxeda.com, shijie8@gmail.com


The patch titled
     Subject: genalloc: add devres support, allow to find a managed pool by device
has been added to the -mm tree.  Its filename is
     genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 include/linux/genalloc.h |   15 ++++++
 lib/genalloc.c           |   81 +++++++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+)

diff -puN include/linux/genalloc.h~genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device include/linux/genalloc.h
--- a/include/linux/genalloc.h~genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device
+++ a/include/linux/genalloc.h
@@ -105,4 +105,19 @@ extern unsigned long gen_pool_first_fit(
 extern unsigned long gen_pool_best_fit(unsigned long *map, unsigned long size,
 		unsigned long start, unsigned int nr, void *data);
 
+extern struct gen_pool *devm_gen_pool_create(struct device *dev,
+		int min_alloc_order, int nid);
+extern struct gen_pool *dev_get_gen_pool(struct device *dev);
+
+struct device_node;
+#ifdef CONFIG_OF
+extern struct gen_pool *of_get_named_gen_pool(struct device_node *np,
+	const char *propname, int index);
+#else
+inline struct gen_pool *of_get_named_gen_pool(struct device_node *np,
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

genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device.patch
misc-generic-on-chip-sram-allocation-driver.patch
misc-generic-on-chip-sram-allocation-driver-fix.patch
media-coda-use-genalloc-api.patch

