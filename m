Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A44CC433E0
	for <mm-commits@archiver.kernel.org>; Tue,  9 Mar 2021 04:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 432C665092
	for <mm-commits@archiver.kernel.org>; Tue,  9 Mar 2021 04:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhCIE5N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 23:57:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:34218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhCIE4t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 23:56:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C821365244;
        Tue,  9 Mar 2021 04:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615265809;
        bh=Zee+UiM6cSkKKUqSn34Ot8JbYXZmuI9XwzXmx9oQLfg=;
        h=Date:From:To:Subject:From;
        b=ydBhrfm5HhhJY0sZp5uLg1tGj6eApgts04UJQ+RDTqAqI5Up/YgaYZC9qlCLnKS+R
         dMyLOMLXw7fYxjLPAcORbpki3arn3mlDMn+1KZ5znNPlUYcBgI59PIhuGsPkDVDXtd
         8XDMjLjT8JtxgXqgJoeGyezX8WXFbCWbnj3IMDD4=
Date:   Mon, 08 Mar 2021 20:56:48 -0800
From:   akpm@linux-foundation.org
To:     gregkh@linuxfoundation.org, jhubbard@nvidia.com,
        joaodias@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, surenb@google.com, willy@infradead.org
Subject:  [to-be-updated] mm-cma-support-sysfs.patch removed from
 -mm tree
Message-ID: <20210309045648.vT-ol2x5Z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: support sysfs
has been removed from the -mm tree.  Its filename was
     mm-cma-support-sysfs.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: cma: support sysfs

Since CMA is getting used more widely, it's more important to
keep monitoring CMA statistics for system health since it's
directly related to user experience.

This patch introduces sysfs statistics for CMA, in order to provide
some basic monitoring of the CMA allocator.

 * the number of CMA page allocation attempts
 * the number of CMA page allocation failures

These two values allow the user to calcuate the allocation
failure rate for each CMA area.

e.g.)
  /sys/kernel/mm/cma/WIFI/cma_alloc_pages_[attempts|fails]
  /sys/kernel/mm/cma/SENSOR/cma_alloc_pages_[attempts|fails]
  /sys/kernel/mm/cma/BLUETOOTH/cma_alloc_pages_[attempts|fails]

The cma_stat was intentionally allocated by dynamic allocation
to harmonize with kobject lifetime management.
https://lore.kernel.org/linux-mm/YCOAmXqt6dZkCQYs@kroah.com/

Link: https://lkml.kernel.org/r/20210304161704.3056806-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: John Dias <joaodias@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-cma |   25 +++
 mm/Kconfig                                    |    7 +
 mm/Makefile                                   |    1 
 mm/cma.c                                      |    8 -
 mm/cma.h                                      |   18 ++
 mm/cma_sysfs.c                                |  110 ++++++++++++++++
 6 files changed, 167 insertions(+), 2 deletions(-)

--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-cma
@@ -0,0 +1,25 @@
+What:		/sys/kernel/mm/cma/
+Date:		Feb 2021
+Contact:	Minchan Kim <minchan@kernel.org>
+Description:
+		/sys/kernel/mm/cma/ contains a subdirectory for each CMA
+		heap name (also sometimes called CMA areas).
+
+		Each CMA heap subdirectory (that is, each
+		/sys/kernel/mm/cma/<cma-heap-name> directory) contains the
+		following items:
+
+			cma_alloc_pages_attempts
+			cma_alloc_pages_fails
+
+What:		/sys/kernel/mm/cma/<cma-heap-name>/cma_alloc_pages_attempts
+Date:		Feb 2021
+Contact:	Minchan Kim <minchan@kernel.org>
+Description:
+		the number of pages CMA API tried to allocate
+
+What:		/sys/kernel/mm/cma/<cma-heap-name>/cma_alloc_pages_fails
+Date:		Feb 2021
+Contact:	Minchan Kim <minchan@kernel.org>
+Description:
+		the number of pages CMA API failed to allocate
--- a/mm/cma.c~mm-cma-support-sysfs
+++ a/mm/cma.c
@@ -435,18 +435,19 @@ struct page *cma_alloc(struct cma *cma,
 	int ret = -ENOMEM;
 
 	if (!cma || !cma->count || !cma->bitmap)
-		goto out;
+		goto out_fail;
 
 	pr_debug("%s(cma %p, count %zu, align %d)\n", __func__, (void *)cma,
 		 count, align);
 
 	if (!count)
-		goto out;
+		goto out_fail;
 
 	mask = cma_bitmap_aligned_mask(cma, align);
 	offset = cma_bitmap_aligned_offset(cma, align);
 	bitmap_maxno = cma_bitmap_maxno(cma);
 	bitmap_count = cma_bitmap_pages_to_bits(cma, count);
+	cma_sysfs_alloc_count(cma, count);
 
 	if (bitmap_count > bitmap_maxno)
 		goto out;
@@ -504,6 +505,9 @@ struct page *cma_alloc(struct cma *cma,
 		       __func__, cma->name, count, ret);
 		cma_debug_show_areas(cma);
 	}
+out_fail:
+	if (!page)
+		cma_sysfs_fail_count(cma, count);
 
 	pr_debug("%s(): returned %p\n", __func__, page);
 out:
--- a/mm/cma.h~mm-cma-support-sysfs
+++ a/mm/cma.h
@@ -3,6 +3,14 @@
 #define __MM_CMA_H__
 
 #include <linux/debugfs.h>
+#include <linux/kobject.h>
+
+struct cma_stat {
+	spinlock_t lock;
+	unsigned long pages_attempts;	/* the number of CMA page allocation attempts */
+	unsigned long pages_fails;	/* the number of CMA page allocation failures */
+	struct kobject kobj;
+};
 
 struct cma {
 	unsigned long   base_pfn;
@@ -16,6 +24,9 @@ struct cma {
 	struct debugfs_u32_array dfs_bitmap;
 #endif
 	char name[CMA_MAX_NAME];
+#ifdef CONFIG_CMA_SYSFS
+	struct cma_stat	*stat;
+#endif
 };
 
 extern struct cma cma_areas[MAX_CMA_AREAS];
@@ -26,4 +37,11 @@ static inline unsigned long cma_bitmap_m
 	return cma->count >> cma->order_per_bit;
 }
 
+#ifdef CONFIG_CMA_SYSFS
+void cma_sysfs_alloc_count(struct cma *cma, size_t count);
+void cma_sysfs_fail_count(struct cma *cma, size_t count);
+#else
+static inline void cma_sysfs_alloc_count(struct cma *cma, size_t count) {};
+static inline void cma_sysfs_fail_count(struct cma *cma, size_t count) {};
+#endif
 #endif
--- /dev/null
+++ a/mm/cma_sysfs.c
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * CMA SysFS Interface
+ *
+ * Copyright (c) 2021 Minchan Kim <minchan@kernel.org>
+ */
+
+#include <linux/cma.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+
+#include "cma.h"
+
+static struct cma_stat *cma_stats;
+
+void cma_sysfs_alloc_count(struct cma *cma, size_t count)
+{
+	spin_lock(&cma->stat->lock);
+	cma->stat->pages_attempts += count;
+	spin_unlock(&cma->stat->lock);
+}
+
+void cma_sysfs_fail_count(struct cma *cma, size_t count)
+{
+	spin_lock(&cma->stat->lock);
+	cma->stat->pages_fails += count;
+	spin_unlock(&cma->stat->lock);
+}
+
+#define CMA_ATTR_RO(_name) \
+	static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
+
+static struct kobject *cma_kobj;
+
+static ssize_t cma_alloc_pages_attempts_show(struct kobject *kobj,
+			struct kobj_attribute *attr, char *buf)
+{
+	struct cma_stat *stat = container_of(kobj, struct cma_stat, kobj);
+
+	return sysfs_emit(buf, "%lu\n", stat->pages_attempts);
+}
+CMA_ATTR_RO(cma_alloc_pages_attempts);
+
+static ssize_t cma_alloc_pages_fails_show(struct kobject *kobj,
+			struct kobj_attribute *attr, char *buf)
+{
+	struct cma_stat *stat = container_of(kobj, struct cma_stat, kobj);
+
+	return sysfs_emit(buf, "%lu\n", stat->pages_fails);
+}
+CMA_ATTR_RO(cma_alloc_pages_fails);
+
+static void cma_kobj_release(struct kobject *kobj)
+{
+	struct cma_stat *stat = container_of(kobj, struct cma_stat, kobj);
+
+	kfree(stat);
+}
+
+static struct attribute *cma_attrs[] = {
+	&cma_alloc_pages_attempts_attr.attr,
+	&cma_alloc_pages_fails_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(cma);
+
+static struct kobj_type cma_ktype = {
+	.release = cma_kobj_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = cma_groups
+};
+
+static int __init cma_sysfs_init(void)
+{
+	int i = 0;
+	struct cma *cma;
+
+	cma_kobj = kobject_create_and_add("cma", mm_kobj);
+	if (!cma_kobj)
+		return -ENOMEM;
+
+	cma_stats = kmalloc_array(cma_area_count, sizeof(struct cma_stat),
+				GFP_KERNEL|__GFP_ZERO);
+	if (!cma_stats)
+		goto out;
+
+	do {
+		cma = &cma_areas[i];
+		cma->stat = &cma_stats[i];
+		spin_lock_init(&cma->stat->lock);
+		if (kobject_init_and_add(&cma->stat->kobj, &cma_ktype,
+					cma_kobj, "%s", cma->name)) {
+			kobject_put(&cma->stat->kobj);
+			goto out;
+		}
+	} while (++i < cma_area_count);
+
+	return 0;
+out:
+	while (--i >= 0) {
+		cma = &cma_areas[i];
+		kobject_put(&cma->stat->kobj);
+	}
+
+	kfree(cma_stats);
+	kobject_put(cma_kobj);
+
+	return -ENOMEM;
+}
+subsys_initcall(cma_sysfs_init);
--- a/mm/Kconfig~mm-cma-support-sysfs
+++ a/mm/Kconfig
@@ -520,6 +520,13 @@ config CMA_DEBUGFS
 	help
 	  Turns on the DebugFS interface for CMA.
 
+config CMA_SYSFS
+	bool "CMA information through sysfs interface"
+	depends on CMA && SYSFS
+	help
+	  This option exposes some sysfs attributes to get information
+	  from CMA.
+
 config CMA_AREAS
 	int "Maximum count of the CMA areas"
 	depends on CMA
--- a/mm/Makefile~mm-cma-support-sysfs
+++ a/mm/Makefile
@@ -111,6 +111,7 @@ obj-$(CONFIG_CMA)	+= cma.o
 obj-$(CONFIG_MEMORY_BALLOON) += balloon_compaction.o
 obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
 obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
+obj-$(CONFIG_CMA_SYSFS) += cma_sysfs.o
 obj-$(CONFIG_USERFAULTFD) += userfaultfd.o
 obj-$(CONFIG_IDLE_PAGE_TRACKING) += page_idle.o
 obj-$(CONFIG_DEBUG_PAGE_REF) += debug_page_ref.o
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-remove-lru_add_drain_all-in-alloc_contig_range.patch
mm-vmstat-add-cma-statistics.patch

