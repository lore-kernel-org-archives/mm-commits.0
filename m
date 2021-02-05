Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9219FC433E6
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 03:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6940E64EEC
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 03:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhBFDXD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Feb 2021 22:23:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:43264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231180AbhBFDQ5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Feb 2021 22:16:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA27664FDC;
        Fri,  5 Feb 2021 22:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612564146;
        bh=WOHILNKF6LkU4lMDQ6ezoa5tq2sN7T1zXtsFWbe1K0k=;
        h=Date:From:To:Subject:From;
        b=V1jW4QRjBBLVA9Cg9wZvlxpJCdOo8ZU/TCAElOUcChiWSn6A85b94ADiqVFt4z7BX
         5wTM0ZYtflbjBG/XCwIAvEEtPgBNllz6XtsTZyf4/HXfwU6jjzNWFpPnn+d0zNQgwh
         CzkrPXYPO95m6S3VVOcyZ4TtvKJHXAFqXLgippY4=
Date:   Fri, 05 Feb 2021 14:29:05 -0800
From:   akpm@linux-foundation.org
To:     gregkh@linuxfoundation.org, joaodias@google.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, surenb@google.com
Subject:  [to-be-updated] mm-cma-support-sysfs.patch removed from
 -mm tree
Message-ID: <20210205222905.CPJDsMgHt%akpm@linux-foundation.org>
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

This patch introduces sysfs for the CMA and exposes stats below
to keep monitor for telemetric in the system.

 * the number of CMA allocation attempts
 * the number of CMA allocation failures
 * the number of CMA page allocation attempts
 * the number of CMA page allocation failures

Link: https://lkml.kernel.org/r/20210203155001.4121868-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: John Dias <joaodias@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-cma |   39 ++++
 include/linux/cma.h                           |    1 
 mm/Makefile                                   |    1 
 mm/cma.c                                      |    6 
 mm/cma.h                                      |   20 ++
 mm/cma_sysfs.c                                |  143 ++++++++++++++++
 6 files changed, 209 insertions(+), 1 deletion(-)

--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-cma
@@ -0,0 +1,39 @@
+What:		/sys/kernel/mm/cma/
+Date:		Feb 2021
+Contact:	Minchan Kim <minchan@kernel.org>
+Description:
+		/sys/kernel/mm/cma/ contains a number of subdirectories by
+		cma-heap name. The subdirectory contains a number of files
+		to represent cma allocation statistics.
+
+		There are number of files under
+				/sys/kernel/mm/cma/<cma-heap-name> directory
+
+			- cma_alloc_attempt
+			- cma_alloc_fail
+			- alloc_pages_attempt
+			- alloc_pages_fail
+
+What:		/sys/kernel/mm/cma/<cma-heap-name>/cma_alloc_attempt
+Date:		Feb 2021
+Contact:	Minchan Kim <minchan@kernel.org>
+Description:
+		the number of cma_alloc API attempted
+
+What:		/sys/kernel/mm/cma/<cma-heap-name>/cma_alloc_fail
+Date:		Feb 2021
+Contact:	Minchan Kim <minchan@kernel.org>
+Description:
+		the number of CMA_alloc API failed
+
+What:		/sys/kernel/mm/cma/<cma-heap-name>/alloc_pages_attempt
+Date:		Feb 2021
+Contact:	Minchan Kim <minchan@kernel.org>
+Description:
+		the number of pages CMA API tried to allocate
+
+What:		/sys/kernel/mm/cma/<cma-heap-name>/alloc_pages_fail
+Date:		Feb 2021
+Contact:	Minchan Kim <minchan@kernel.org>
+Description:
+		the number of pages CMA API failed to allocate
--- a/include/linux/cma.h~mm-cma-support-sysfs
+++ a/include/linux/cma.h
@@ -49,4 +49,5 @@ extern struct page *cma_alloc(struct cma
 extern bool cma_release(struct cma *cma, const struct page *pages, unsigned int count);
 
 extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data);
+
 #endif
--- a/mm/cma.c~mm-cma-support-sysfs
+++ a/mm/cma.c
@@ -447,9 +447,10 @@ struct page *cma_alloc(struct cma *cma,
 	offset = cma_bitmap_aligned_offset(cma, align);
 	bitmap_maxno = cma_bitmap_maxno(cma);
 	bitmap_count = cma_bitmap_pages_to_bits(cma, count);
+	cma_sysfs_alloc_count(cma, count);
 
 	if (bitmap_count > bitmap_maxno)
-		return NULL;
+		goto out;
 
 	for (;;) {
 		mutex_lock(&cma->lock);
@@ -504,6 +505,9 @@ struct page *cma_alloc(struct cma *cma,
 			__func__, count, ret);
 		cma_debug_show_areas(cma);
 	}
+out:
+	if (!page)
+		cma_sysfs_fail(cma, count);
 
 	pr_debug("%s(): returned %p\n", __func__, page);
 	return page;
--- a/mm/cma.h~mm-cma-support-sysfs
+++ a/mm/cma.h
@@ -3,6 +3,16 @@
 #define __MM_CMA_H__
 
 #include <linux/debugfs.h>
+#include <linux/kobject.h>
+
+struct cma_stat {
+	spinlock_t lock;
+	unsigned long alloc_attempt;	/* the number of CMA allocation attempts */
+	unsigned long alloc_fail;	/* the number of CMA allocation failures */
+	unsigned long pages_attempt;	/* the number of CMA page allocation attempts */
+	unsigned long pages_fail;	/* the number of CMA page allocation failures */
+	struct kobject kobj;
+};
 
 struct cma {
 	unsigned long   base_pfn;
@@ -16,6 +26,9 @@ struct cma {
 	struct debugfs_u32_array dfs_bitmap;
 #endif
 	char name[CMA_MAX_NAME];
+#ifdef CONFIG_SYSFS
+	struct cma_stat	*stat;
+#endif
 };
 
 extern struct cma cma_areas[MAX_CMA_AREAS];
@@ -26,4 +39,11 @@ static inline unsigned long cma_bitmap_m
 	return cma->count >> cma->order_per_bit;
 }
 
+#ifdef CONFIG_SYSFS
+void cma_sysfs_alloc_count(struct cma *cma, size_t count);
+void cma_sysfs_fail(struct cma *cma, size_t count);
+#else
+static void cma_sysfs_alloc_count(struct cma *cma, size_t count) {};
+static void cma_sysfs_fail(struct cma *cma, size_t count) {};
+#endif
 #endif
--- /dev/null
+++ a/mm/cma_sysfs.c
@@ -0,0 +1,143 @@
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
+void cma_sysfs_alloc_count(struct cma *cma, size_t count)
+{
+	spin_lock(&cma->stat->lock);
+	cma->stat->alloc_attempt++;
+	cma->stat->pages_attempt += count;
+	spin_unlock(&cma->stat->lock);
+}
+
+void cma_sysfs_fail(struct cma *cma, size_t count)
+{
+	spin_lock(&cma->stat->lock);
+	cma->stat->alloc_fail++;
+	cma->stat->pages_fail += count;
+	spin_unlock(&cma->stat->lock);
+}
+
+#define CMA_ATTR_RO(_name) \
+	static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
+
+static struct kobject *cma_kobj;
+
+static ssize_t cma_alloc_attempt_show(struct kobject *kobj,
+			struct kobj_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct cma_stat *stat = container_of(kobj, struct cma_stat, kobj);
+
+	val = stat->alloc_attempt;
+
+	return sysfs_emit(buf, "%lu\n", val);
+}
+CMA_ATTR_RO(cma_alloc_attempt);
+
+static ssize_t cma_alloc_fail_show(struct kobject *kobj,
+			struct kobj_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct cma_stat *stat = container_of(kobj, struct cma_stat, kobj);
+
+	val = stat->alloc_fail;
+
+	return sysfs_emit(buf, "%lu\n", val);
+}
+CMA_ATTR_RO(cma_alloc_fail);
+
+static ssize_t alloc_pages_attempt_show(struct kobject *kobj,
+			struct kobj_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct cma_stat *stat = container_of(kobj, struct cma_stat, kobj);
+
+	val = stat->pages_attempt;
+
+	return sysfs_emit(buf, "%lu\n", val);
+}
+CMA_ATTR_RO(alloc_pages_attempt);
+
+static ssize_t alloc_pages_fail_show(struct kobject *kobj,
+			struct kobj_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct cma_stat *stat = container_of(kobj, struct cma_stat, kobj);
+
+	val = stat->pages_fail;
+
+	return sysfs_emit(buf, "%lu\n", val);
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
+	&cma_alloc_attempt_attr.attr,
+	&cma_alloc_fail_attr.attr,
+	&alloc_pages_attempt_attr.attr,
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
+	int i;
+	struct cma *cma;
+	struct cma_stat *stat;
+
+	cma_kobj = kobject_create_and_add("cma", mm_kobj);
+	if (!cma_kobj) {
+		pr_err("failed to create cma kobject\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < cma_area_count; i++) {
+		cma = &cma_areas[i];
+		stat = kzalloc(sizeof(*stat), GFP_KERNEL);
+		if (!stat)
+			goto out;
+
+		cma->stat = stat;
+		spin_lock_init(&stat->lock);
+		if (kobject_init_and_add(&stat->kobj, &cma_ktype,
+					cma_kobj, "%s", cma->name)) {
+			kobject_put(&stat->kobj);
+			goto out;
+		}
+	}
+
+	return 0;
+out:
+	while (--i >= 0) {
+		cma = &cma_areas[i];
+		kobject_put(&cma->stat->kobj);
+	}
+
+	kobject_put(cma_kobj);
+
+	return -ENOMEM;
+}
+subsys_initcall(cma_sysfs_init);
--- a/mm/Makefile~mm-cma-support-sysfs
+++ a/mm/Makefile
@@ -105,6 +105,7 @@ obj-$(CONFIG_ZSMALLOC)	+= zsmalloc.o
 obj-$(CONFIG_Z3FOLD)	+= z3fold.o
 obj-$(CONFIG_GENERIC_EARLY_IOREMAP) += early_ioremap.o
 obj-$(CONFIG_CMA)	+= cma.o
+obj-$(CONFIG_SYSFS)     += cma_sysfs.o
 obj-$(CONFIG_MEMORY_BALLOON) += balloon_compaction.o
 obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
 obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
_

Patches currently in -mm which might be from minchan@kernel.org are


