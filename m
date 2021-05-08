Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FE46C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6791D6101D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhEHWu3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:50:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhEHWu2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:50:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C32D6100C;
        Sat,  8 May 2021 22:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514166;
        bh=LK3YFvXBj9lGhFat3uqOvqjIUHwwvv9uPEwqPe0Lg6U=;
        h=Date:From:To:Subject:From;
        b=Hf5TXYf+j2DRa1OJs+7MtfSXs4/hsTLUBBdMRq2+nLqd5i0C64Ym5+ryDsKAvCYuD
         soVYxZeB1BC9cP6PAXbl0whGVblgiL8ED5WZLWOjTvkprkIqRErbfyLG1T9Grprpmz
         yxsLZplfsINgJXd6d5Z8YW8Hj2lV/F/NNyTt7FLA=
Date:   Sat, 08 May 2021 15:49:26 -0700
From:   akpm@linux-foundation.org
To:     anders.roxell@linaro.org, colin.king@canonical.com,
        digetx@gmail.com, gregkh@linuxfoundation.org, jhubbard@nvidia.com,
        joaodias@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, surenb@google.com, willy@infradead.org
Subject:  [merged] mm-cma-support-sysfs.patch removed from -mm tree
Message-ID: <20210508224926.eVPiOY02h%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: support sysfs
has been removed from the -mm tree.  Its filename was
     mm-cma-support-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

The cma_stat was intentionally allocated by dynamic allocation
to harmonize with kobject lifetime management.
https://lore.kernel.org/linux-mm/YCOAmXqt6dZkCQYs@kroah.com/

Link: https://lkml.kernel.org/r/20210324230759.2213957-1-minchan@kernel.org
Link: https://lore.kernel.org/linux-mm/20210316100433.17665-1-colin.king@canonical.com/
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Colin Ian King <colin.king@canonical.com>

Tested-by: Dmitry Osipenko <digetx@gmail.com>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: John Dias <joaodias@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-cma |   25 +++
 mm/Kconfig                                    |    7 +
 mm/Makefile                                   |    1 
 mm/cma.c                                      |    8 -
 mm/cma.h                                      |   23 +++
 mm/cma_sysfs.c                                |  112 ++++++++++++++++
 6 files changed, 174 insertions(+), 2 deletions(-)

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
@@ -511,10 +511,14 @@ struct page *cma_alloc(struct cma *cma,
 
 	pr_debug("%s(): returned %p\n", __func__, page);
 out:
-	if (page)
+	if (page) {
 		count_vm_event(CMA_ALLOC_SUCCESS);
-	else
+		cma_sysfs_account_success_pages(cma, count);
+	} else {
 		count_vm_event(CMA_ALLOC_FAIL);
+		if (cma)
+			cma_sysfs_account_fail_pages(cma, count);
+	}
 
 	return page;
 }
--- a/mm/cma.h~mm-cma-support-sysfs
+++ a/mm/cma.h
@@ -3,6 +3,12 @@
 #define __MM_CMA_H__
 
 #include <linux/debugfs.h>
+#include <linux/kobject.h>
+
+struct cma_kobject {
+	struct kobject kobj;
+	struct cma *cma;
+};
 
 struct cma {
 	unsigned long   base_pfn;
@@ -16,6 +22,14 @@ struct cma {
 	struct debugfs_u32_array dfs_bitmap;
 #endif
 	char name[CMA_MAX_NAME];
+#ifdef CONFIG_CMA_SYSFS
+	/* the number of CMA page successful allocations */
+	atomic64_t nr_pages_succeeded;
+	/* the number of CMA page allocation failures */
+	atomic64_t nr_pages_failed;
+	/* kobject requires dynamic object */
+	struct cma_kobject *cma_kobj;
+#endif
 };
 
 extern struct cma cma_areas[MAX_CMA_AREAS];
@@ -26,4 +40,13 @@ static inline unsigned long cma_bitmap_m
 	return cma->count >> cma->order_per_bit;
 }
 
+#ifdef CONFIG_CMA_SYSFS
+void cma_sysfs_account_success_pages(struct cma *cma, unsigned long nr_pages);
+void cma_sysfs_account_fail_pages(struct cma *cma, unsigned long nr_pages);
+#else
+static inline void cma_sysfs_account_success_pages(struct cma *cma,
+						   unsigned long nr_pages) {};
+static inline void cma_sysfs_account_fail_pages(struct cma *cma,
+						unsigned long nr_pages) {};
+#endif
 #endif
--- /dev/null
+++ a/mm/cma_sysfs.c
@@ -0,0 +1,112 @@
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
+#define CMA_ATTR_RO(_name) \
+	static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
+
+void cma_sysfs_account_success_pages(struct cma *cma, unsigned long nr_pages)
+{
+	atomic64_add(nr_pages, &cma->nr_pages_succeeded);
+}
+
+void cma_sysfs_account_fail_pages(struct cma *cma, unsigned long nr_pages)
+{
+	atomic64_add(nr_pages, &cma->nr_pages_failed);
+}
+
+static inline struct cma *cma_from_kobj(struct kobject *kobj)
+{
+	return container_of(kobj, struct cma_kobject, kobj)->cma;
+}
+
+static ssize_t alloc_pages_success_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	struct cma *cma = cma_from_kobj(kobj);
+
+	return sysfs_emit(buf, "%llu\n",
+			  atomic64_read(&cma->nr_pages_succeeded));
+}
+CMA_ATTR_RO(alloc_pages_success);
+
+static ssize_t alloc_pages_fail_show(struct kobject *kobj,
+				     struct kobj_attribute *attr, char *buf)
+{
+	struct cma *cma = cma_from_kobj(kobj);
+
+	return sysfs_emit(buf, "%llu\n", atomic64_read(&cma->nr_pages_failed));
+}
+CMA_ATTR_RO(alloc_pages_fail);
+
+static void cma_kobj_release(struct kobject *kobj)
+{
+	struct cma *cma = cma_from_kobj(kobj);
+	struct cma_kobject *cma_kobj = cma->cma_kobj;
+
+	kfree(cma_kobj);
+	cma->cma_kobj = NULL;
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
+	.default_groups = cma_groups,
+};
+
+static int __init cma_sysfs_init(void)
+{
+	struct kobject *cma_kobj_root;
+	struct cma_kobject *cma_kobj;
+	struct cma *cma;
+	int i, err;
+
+	cma_kobj_root = kobject_create_and_add("cma", mm_kobj);
+	if (!cma_kobj_root)
+		return -ENOMEM;
+
+	for (i = 0; i < cma_area_count; i++) {
+		cma_kobj = kzalloc(sizeof(*cma_kobj), GFP_KERNEL);
+		if (!cma_kobj) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		cma = &cma_areas[i];
+		cma->cma_kobj = cma_kobj;
+		cma_kobj->cma = cma;
+		err = kobject_init_and_add(&cma_kobj->kobj, &cma_ktype,
+					   cma_kobj_root, "%s", cma->name);
+		if (err) {
+			kobject_put(&cma_kobj->kobj);
+			goto out;
+		}
+	}
+
+	return 0;
+out:
+	while (--i >= 0) {
+		cma = &cma_areas[i];
+		kobject_put(&cma->cma_kobj->kobj);
+	}
+	kobject_put(cma_kobj_root);
+
+	return err;
+}
+subsys_initcall(cma_sysfs_init);
--- a/mm/Kconfig~mm-cma-support-sysfs
+++ a/mm/Kconfig
@@ -518,6 +518,13 @@ config CMA_DEBUGFS
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


