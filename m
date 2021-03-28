Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A9A1C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 21:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C44A66193F
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 21:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhC1VGJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 17:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231342AbhC1VFh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 17:05:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2FDA61481;
        Sun, 28 Mar 2021 21:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616965537;
        bh=OlVj9tWb/Q8tloJqElusWsUo33OpA9pgYdwdnt7f1Wo=;
        h=Date:From:To:Subject:From;
        b=eAMB6PdxK4HquwczdTOlRb+0L6sAqEKIegdFWUe3RBzgnglawSDA3ciKQKJN9W89T
         vkvvV4JISGzcY6FFyulJlnVKOtdT651zzLPkTaPxf/q0DYYNaK3ejTcPAD5d9iMO5U
         9eKW+EOlnqc9rBh5MXoCGKkE6K4Y1iPDNwAyeueY=
Date:   Sun, 28 Mar 2021 14:05:36 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, digetx@gmail.com, gregkh@linuxfoundation.org,
        jhubbard@nvidia.com, joaodias@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, surenb@google.com, willy@infradead.org
Subject:  [to-be-updated] mm-cma-support-sysfs.patch removed from
 -mm tree
Message-ID: <20210328210536.aCv6rV-cY%akpm@linux-foundation.org>
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

Since CMA is getting used more widely, it's more important to keep
monitoring CMA statistics for system health since it's directly related to
user experience.

This patch introduces sysfs statistics for CMA, in order to provide some
basic monitoring of the CMA allocator.

 * the number of CMA page successful allocations
 * the number of CMA page allocation failures

These two values allow the user to calcuate the allocation
failure rate for each CMA area.

e.g.)
  /sys/kernel/mm/cma/WIFI/alloc_pages_[success|fail]
  /sys/kernel/mm/cma/SENSOR/alloc_pages_[success|fail]
  /sys/kernel/mm/cma/BLUETOOTH/alloc_pages_[success|fail]

The cma_stat was intentionally allocated by dynamic allocation to
harmonize with kobject lifetime management. 
https://lore.kernel.org/linux-mm/YCOAmXqt6dZkCQYs@kroah.com/

Link: https://lkml.kernel.org/r/20210309062333.3216138-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: John Dias <joaodias@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-cma |   25 +++
 mm/Kconfig                                    |    7 +
 mm/Makefile                                   |    1 
 mm/cma.c                                      |    7 -
 mm/cma.h                                      |   20 ++
 mm/cma_sysfs.c                                |  110 ++++++++++++++++
 6 files changed, 168 insertions(+), 2 deletions(-)

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
+			alloc_pages_success
+			alloc_pages_fail
+
+What:		/sys/kernel/mm/cma/<cma-heap-name>/alloc_pages_success
+Date:		Feb 2021
+Contact:	Minchan Kim <minchan@kernel.org>
+Description:
+		the number of pages CMA API succeeded to allocate
+
+What:		/sys/kernel/mm/cma/<cma-heap-name>/alloc_pages_fail
+Date:		Feb 2021
+Contact:	Minchan Kim <minchan@kernel.org>
+Description:
+		the number of pages CMA API failed to allocate
--- a/mm/cma.c~mm-cma-support-sysfs
+++ a/mm/cma.c
@@ -507,10 +507,13 @@ struct page *cma_alloc(struct cma *cma,
 
 	pr_debug("%s(): returned %p\n", __func__, page);
 out:
-	if (page)
+	if (page) {
 		count_vm_event(CMA_ALLOC_SUCCESS);
-	else
+		cma_sysfs_alloc_pages_count(cma, count);
+	} else {
 		count_vm_event(CMA_ALLOC_FAIL);
+		cma_sysfs_fail_pages_count(cma, count);
+	}
 
 	return page;
 }
--- a/mm/cma.h~mm-cma-support-sysfs
+++ a/mm/cma.h
@@ -3,6 +3,16 @@
 #define __MM_CMA_H__
 
 #include <linux/debugfs.h>
+#include <linux/kobject.h>
+
+struct cma_stat {
+	spinlock_t lock;
+	/* the number of CMA page successful allocations */
+	unsigned long nr_pages_succeeded;
+	/* the number of CMA page allocation failures */
+	unsigned long nr_pages_failed;
+	struct kobject kobj;
+};
 
 struct cma {
 	unsigned long   base_pfn;
@@ -16,6 +26,9 @@ struct cma {
 	struct debugfs_u32_array dfs_bitmap;
 #endif
 	char name[CMA_MAX_NAME];
+#ifdef CONFIG_CMA_SYSFS
+	struct cma_stat	*stat;
+#endif
 };
 
 extern struct cma cma_areas[MAX_CMA_AREAS];
@@ -26,4 +39,11 @@ static inline unsigned long cma_bitmap_m
 	return cma->count >> cma->order_per_bit;
 }
 
+#ifdef CONFIG_CMA_SYSFS
+void cma_sysfs_alloc_pages_count(struct cma *cma, size_t count);
+void cma_sysfs_fail_pages_count(struct cma *cma, size_t count);
+#else
+static inline void cma_sysfs_alloc_pages_count(struct cma *cma, size_t count) {};
+static inline void cma_sysfs_fail_pages_count(struct cma *cma, size_t count) {};
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
+void cma_sysfs_alloc_pages_count(struct cma *cma, size_t count)
+{
+	spin_lock(&cma->stat->lock);
+	cma->stat->nr_pages_succeeded += count;
+	spin_unlock(&cma->stat->lock);
+}
+
+void cma_sysfs_fail_pages_count(struct cma *cma, size_t count)
+{
+	spin_lock(&cma->stat->lock);
+	cma->stat->nr_pages_failed += count;
+	spin_unlock(&cma->stat->lock);
+}
+
+#define CMA_ATTR_RO(_name) \
+	static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
+
+static struct kobject *cma_kobj;
+
+static ssize_t alloc_pages_success_show(struct kobject *kobj,
+			struct kobj_attribute *attr, char *buf)
+{
+	struct cma_stat *stat = container_of(kobj, struct cma_stat, kobj);
+
+	return sysfs_emit(buf, "%lu\n", stat->nr_pages_succeeded);
+}
+CMA_ATTR_RO(alloc_pages_success);
+
+static ssize_t alloc_pages_fail_show(struct kobject *kobj,
+			struct kobj_attribute *attr, char *buf)
+{
+	struct cma_stat *stat = container_of(kobj, struct cma_stat, kobj);
+
+	return sysfs_emit(buf, "%lu\n", stat->nr_pages_failed);
+}
+CMA_ATTR_RO(alloc_pages_fail);
+
+static void cma_kobj_release(struct kobject *kobj)
+{
+	struct cma_stat *stat = container_of(kobj, struct cma_stat, kobj);
+
+	kfree(stat);
+}
+
+static struct attribute *cma_attrs[] = {
+	&alloc_pages_success_attr.attr,
+	&alloc_pages_fail_attr.attr,
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
+	if (ZERO_OR_NULL_PTR(cma_stats))
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
@@ -519,6 +519,13 @@ config CMA_DEBUGFS
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
@@ -109,6 +109,7 @@ obj-$(CONFIG_CMA)	+= cma.o
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
mm-page_alloc-dump-migrate-failed-pages.patch
mm-disable-lru-pagevec-during-the-migration-temporarily.patch
mm-replace-migrate_-with-lru_cache_.patch
mm-fs-invalidate-bh-lru-during-page-migration.patch
mm-vmstat-add-cma-statistics.patch

