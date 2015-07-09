From: akpm@linux-foundation.org
Subject: + genalloc-add-support-of-multiple-gen_pools-per-device.patch
 added to -mm tree
Date: Thu, 09 Jul 2015 12:14:23 -0700
Message-ID: <559ec80f.IvxFTCfJLPoCuHut%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48156 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbbGITOY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 15:14:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir_zapolskiy@mentor.com, alexandre.belloni@free-electrons.com, arnd@arndb.de, gregkh@linuxfoundation.org, kernel@pengutronix.de, linux@arm.linux.org.uk, mchehab@osg.samsung.com, nicolas.ferre@atmel.com, p.zabel@pengutronix.de, plagnioj@jcrosoft.com, shawnguo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: genalloc: add support of multiple gen_pools per device
has been added to the -mm tree.  Its filename is
     genalloc-add-support-of-multiple-gen_pools-per-device.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/genalloc-add-support-of-multiple-gen_pools-per-device.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/genalloc-add-support-of-multiple-gen_pools-per-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Subject: genalloc: add support of multiple gen_pools per device

This change fills devm_gen_pool_create()/gen_pool_get() "name" argument
stub with contents and extends of_gen_pool_get() functionality on this
basis.

If there is no associated platform device with a device node passed to
of_gen_pool_get(), the function attempts to get a label property or device
node name (= repeats MTD OF partition standard) and seeks for a named
gen_pool registered by device of the parent device node.

The main idea of the change is to allow registration of independent
gen_pools under the same umbrella device, say "partitions" on "storage
device", the original functionality of one "partition" per "storage
device" is untouched.

Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genalloc.h |    2 +
 lib/genalloc.c           |   52 ++++++++++++++++++++++++++++++++-----
 2 files changed, 48 insertions(+), 6 deletions(-)

diff -puN include/linux/genalloc.h~genalloc-add-support-of-multiple-gen_pools-per-device include/linux/genalloc.h
--- a/include/linux/genalloc.h~genalloc-add-support-of-multiple-gen_pools-per-device
+++ a/include/linux/genalloc.h
@@ -59,6 +59,8 @@ struct gen_pool {
 
 	genpool_algo_t algo;		/* allocation function */
 	void *data;
+
+	const char *name;
 };
 
 /*
diff -puN lib/genalloc.c~genalloc-add-support-of-multiple-gen_pools-per-device lib/genalloc.c
--- a/lib/genalloc.c~genalloc-add-support-of-multiple-gen_pools-per-device
+++ a/lib/genalloc.c
@@ -160,6 +160,7 @@ struct gen_pool *gen_pool_create(int min
 		pool->min_alloc_order = min_alloc_order;
 		pool->algo = gen_pool_first_fit;
 		pool->data = NULL;
+		pool->name = NULL;
 	}
 	return pool;
 }
@@ -252,8 +253,8 @@ void gen_pool_destroy(struct gen_pool *p
 
 		kfree(chunk);
 	}
+	kfree(pool->name);
 	kfree(pool);
-	return;
 }
 EXPORT_SYMBOL(gen_pool_destroy);
 
@@ -570,6 +571,20 @@ static void devm_gen_pool_release(struct
 	gen_pool_destroy(*(struct gen_pool **)res);
 }
 
+static int devm_gen_pool_match(struct device *dev, void *res, void *data)
+{
+	struct gen_pool **p = res;
+
+	/* NULL data matches only a pool without an assigned name */
+	if (!data && !(*p)->name)
+		return 1;
+
+	if (!data || !(*p)->name)
+		return 0;
+
+	return !strcmp((*p)->name, data);
+}
+
 /**
  * gen_pool_get - Obtain the gen_pool (if any) for a device
  * @dev: device to retrieve the gen_pool from
@@ -603,21 +618,32 @@ struct gen_pool *devm_gen_pool_create(st
 				      int nid, const char *name)
 {
 	struct gen_pool **ptr, *pool;
+	const char *pool_name = NULL;
 
 	/* Check that genpool to be created is uniquely addressed on device */
 	if (gen_pool_get(dev, name))
 		return ERR_PTR(-EINVAL);
 
+	if (name) {
+		pool_name = kstrdup_const(name, GFP_KERNEL);
+		if (!pool_name)
+			return ERR_PTR(-ENOMEM);
+	}
+
 	ptr = devres_alloc(devm_gen_pool_release, sizeof(*ptr), GFP_KERNEL);
-	if (!ptr)
+	if (!ptr) {
+		kfree(pool_name);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	pool = gen_pool_create(min_alloc_order, nid);
 	if (pool) {
 		*ptr = pool;
+		pool->name = pool_name;
 		devres_add(dev, ptr);
 	} else {
 		devres_free(ptr);
+		kfree(pool_name);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -640,16 +666,30 @@ struct gen_pool *of_gen_pool_get(struct
 	const char *propname, int index)
 {
 	struct platform_device *pdev;
-	struct device_node *np_pool;
+	struct device_node *np_pool, *parent;
+	const char *name = NULL;
+	struct gen_pool *pool = NULL;
 
 	np_pool = of_parse_phandle(np, propname, index);
 	if (!np_pool)
 		return NULL;
+
 	pdev = of_find_device_by_node(np_pool);
+	if (!pdev) {
+		/* Check if named gen_pool is created by parent node device */
+		parent = of_get_parent(np_pool);
+		pdev = of_find_device_by_node(parent);
+		of_node_put(parent);
+
+		of_property_read_string(np_pool, "label", &name);
+		if (!name)
+			name = np_pool->name;
+	}
+	if (pdev)
+		pool = gen_pool_get(&pdev->dev, name);
 	of_node_put(np_pool);
-	if (!pdev)
-		return NULL;
-	return gen_pool_get(&pdev->dev, NULL);
+
+	return pool;
 }
 EXPORT_SYMBOL_GPL(of_gen_pool_get);
 #endif /* CONFIG_OF */
_

Patches currently in -mm which might be from vladimir_zapolskiy@mentor.com are

genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device.patch

