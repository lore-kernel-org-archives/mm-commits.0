Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3004C7EE23
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 23:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjBZXsn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 18:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjBZXsn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 18:48:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C66C8689
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 15:48:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33D1B60C7A
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 23:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81902C433EF;
        Sun, 26 Feb 2023 23:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677455320;
        bh=h5NJfewnaK+uV4TuwY/o7A34tdlqv68DUZ0kaPgMchc=;
        h=Date:To:From:Subject:From;
        b=o+8/Hj2xRqOhIbpinrAOqvC11zGfDqcodcuAaEnK7qEGmKxzycX5df6C3uuntRYqp
         1E0Vjk26C6SxQtq6nQOb5MxIH0UZgdWUu47P4wCu8RXO23DliZlRNrlQAR/+xR5ghp
         bWk4JJNoDLusDzpwP/09ajI+O7ovBmqepzC7ON5M=
Date:   Sun, 26 Feb 2023 15:48:39 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tonyb@cybernetics.com, hch@lst.de, kbusch@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dmapool-add-alloc-free-performance-test.patch removed from -mm tree
Message-Id: <20230226234840.81902C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: dmapool: add alloc/free performance test
has been removed from the -mm tree.  Its filename was
     dmapool-add-alloc-free-performance-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Keith Busch <kbusch@kernel.org>
Subject: dmapool: add alloc/free performance test
Date: Thu, 26 Jan 2023 13:51:14 -0800

Patch series "dmapool enhancements", v4.

Time spent in dma_pool alloc/free increases linearly with the number of
pages backing the pool.  We can reduce this to constant time with minor
changes to how free pages are tracked.


This patch (of 12):

Provide a module that allocates and frees many blocks of various sizes and
report how long it takes.  This is intended to provide a consistent way to
measure how changes to the dma_pool_alloc/free routines affect timing.

Link: https://lkml.kernel.org/r/20230126215125.4069751-1-kbusch@meta.com
Link: https://lkml.kernel.org/r/20230126215125.4069751-2-kbusch@meta.com
Signed-off-by: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- /dev/null
+++ a/mm/dmapool_test.c
@@ -0,0 +1,147 @@
+#include <linux/device.h>
+#include <linux/dma-map-ops.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmapool.h>
+#include <linux/kernel.h>
+#include <linux/ktime.h>
+#include <linux/module.h>
+
+#define NR_TESTS (100)
+
+struct dma_pool_pair {
+	dma_addr_t dma;
+	void *v;
+};
+
+struct dmapool_parms {
+	size_t size;
+	size_t align;
+	size_t boundary;
+};
+
+static const struct dmapool_parms pool_parms[] = {
+	{ .size = 16, .align = 16, .boundary = 0 },
+	{ .size = 64, .align = 64, .boundary = 0 },
+	{ .size = 256, .align = 256, .boundary = 0 },
+	{ .size = 1024, .align = 1024, .boundary = 0 },
+	{ .size = 4096, .align = 4096, .boundary = 0 },
+	{ .size = 68, .align = 32, .boundary = 4096 },
+};
+
+static struct dma_pool *pool;
+static struct device test_dev;
+static u64 dma_mask;
+
+static inline int nr_blocks(int size)
+{
+	return clamp_t(int, (PAGE_SIZE / size) * 512, 1024, 8192);
+}
+
+static int dmapool_test_alloc(struct dma_pool_pair *p, int blocks)
+{
+	int i;
+
+	for (i = 0; i < blocks; i++) {
+		p[i].v = dma_pool_alloc(pool, GFP_KERNEL,
+					&p[i].dma);
+		if (!p[i].v)
+			goto pool_fail;
+	}
+
+	for (i = 0; i < blocks; i++)
+		dma_pool_free(pool, p[i].v, p[i].dma);
+
+	return 0;
+
+pool_fail:
+	for (--i; i >= 0; i--)
+		dma_pool_free(pool, p[i].v, p[i].dma);
+	return -ENOMEM;
+}
+
+static int dmapool_test_block(const struct dmapool_parms *parms)
+{
+	int blocks = nr_blocks(parms->size);
+	ktime_t start_time, end_time;
+	struct dma_pool_pair *p;
+	int i, ret;
+
+	p = kcalloc(blocks, sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	pool = dma_pool_create("test pool", &test_dev, parms->size,
+			       parms->align, parms->boundary);
+	if (!pool) {
+		ret = -ENOMEM;
+		goto free_pairs;
+	}
+
+	start_time = ktime_get();
+	for (i = 0; i < NR_TESTS; i++) {
+		ret = dmapool_test_alloc(p, blocks);
+		if (ret)
+			goto free_pool;
+		if (need_resched())
+			cond_resched();
+	}
+	end_time = ktime_get();
+
+	printk("dmapool test: size:%-4zu align:%-4zu blocks:%-4d time:%llu\n",
+		parms->size, parms->align, blocks,
+		ktime_us_delta(end_time, start_time));
+
+free_pool:
+	dma_pool_destroy(pool);
+free_pairs:
+	kfree(p);
+	return ret;
+}
+
+static void dmapool_test_release(struct device *dev)
+{
+}
+
+static int dmapool_checks(void)
+{
+	int i, ret;
+
+	ret = dev_set_name(&test_dev, "dmapool-test");
+	if (ret)
+		return ret;
+
+	ret = device_register(&test_dev);
+	if (ret) {
+		printk("%s: register failed:%d\n", __func__, ret);
+		goto put_device;
+	}
+
+	test_dev.release = dmapool_test_release;
+	set_dma_ops(&test_dev, NULL);
+	test_dev.dma_mask = &dma_mask;
+	ret = dma_set_mask_and_coherent(&test_dev, DMA_BIT_MASK(64));
+	if (ret) {
+		printk("%s: mask failed:%d\n", __func__, ret);
+		goto del_device;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(pool_parms); i++) {
+		ret = dmapool_test_block(&pool_parms[i]);
+		if (ret)
+			break;
+	}
+
+del_device:
+	device_del(&test_dev);
+put_device:
+	put_device(&test_dev);
+	return ret;
+}
+
+static void dmapool_exit(void)
+{
+}
+
+module_init(dmapool_checks);
+module_exit(dmapool_exit);
+MODULE_LICENSE("GPL");
--- a/mm/Kconfig~dmapool-add-alloc-free-performance-test
+++ a/mm/Kconfig
@@ -1100,6 +1100,15 @@ comment "GUP_TEST needs to have DEBUG_FS
 config GUP_GET_PXX_LOW_HIGH
 	bool
 
+config DMAPOOL_TEST
+	tristate "Enable a module to run time tests on dma_pool"
+	depends on HAS_DMA
+	help
+	  Provides a test module that will allocate and free many blocks of
+	  various sizes and report how long it takes. This is intended to
+	  provide a consistent way to measure how changes to the
+	  dma_pool_alloc/free routines affect performance.
+
 config ARCH_HAS_PTE_SPECIAL
 	bool
 
--- a/mm/Makefile~dmapool-add-alloc-free-performance-test
+++ a/mm/Makefile
@@ -103,6 +103,7 @@ obj-$(CONFIG_MEMCG) += swap_cgroup.o
 endif
 obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
 obj-$(CONFIG_GUP_TEST) += gup_test.o
+obj-$(CONFIG_DMAPOOL_TEST) += dmapool_test.o
 obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
 obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
 obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
_

Patches currently in -mm which might be from kbusch@kernel.org are


