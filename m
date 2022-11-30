Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9797C47088
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 23:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiK3XCX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 18:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiK3XCG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 18:02:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3934756EE2
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 15:02:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD97CB81D4B
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 23:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF46C43470;
        Wed, 30 Nov 2022 23:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669849322;
        bh=naeUfJUXxo7qsrY+i/P1hUqKjDLzFfhndStSaU6MIYY=;
        h=Date:To:From:Subject:From;
        b=L8q43uDEuzsMAE2doIXI1vfwDOMurmbMLDw64DAlVxrME+65XunCLC6Zsnr9QtL2h
         dWZxTgaAXIINNni0kb0RmRrpoFOxkQcr/ONV1SDAax1plgNT31O+g2abEBRyKJ323S
         RjRbwEhgZ4jU/N2qoDlchql0/OBCuD49ks3MrCjk=
Date:   Wed, 30 Nov 2022 15:02:01 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-move-unsigned-long-range-directory-to-common-module.patch removed from -mm tree
Message-Id: <20221130230202.6FF46C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: move unsigned long range directory to common module
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-move-unsigned-long-range-directory-to-common-module.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: move unsigned long range directory to common module
Date: Wed, 26 Oct 2022 22:59:39 +0000

The implementation of unsigned long type range directories can be reused
by multiple DAMON sysfs directories including those for DAMON-based
Operation Schemes and the range of number of monitoring regions.  Move the
code into the files for DAMON sysfs common logics.

Link: https://lkml.kernel.org/r/20221026225943.100429-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-common.c |   96 ++++++++++++++++++++++++++++++++++++
 mm/damon/sysfs-common.h |   13 ++++
 mm/damon/sysfs.c        |  100 --------------------------------------
 3 files changed, 109 insertions(+), 100 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-move-unsigned-long-range-directory-to-common-module
+++ a/mm/damon/sysfs.c
@@ -12,106 +12,6 @@
 #include "sysfs-common.h"
 
 /*
- * unsigned long range directory
- */
-
-struct damon_sysfs_ul_range {
-	struct kobject kobj;
-	unsigned long min;
-	unsigned long max;
-};
-
-static struct damon_sysfs_ul_range *damon_sysfs_ul_range_alloc(
-		unsigned long min,
-		unsigned long max)
-{
-	struct damon_sysfs_ul_range *range = kmalloc(sizeof(*range),
-			GFP_KERNEL);
-
-	if (!range)
-		return NULL;
-	range->kobj = (struct kobject){};
-	range->min = min;
-	range->max = max;
-
-	return range;
-}
-
-static ssize_t min_show(struct kobject *kobj, struct kobj_attribute *attr,
-		char *buf)
-{
-	struct damon_sysfs_ul_range *range = container_of(kobj,
-			struct damon_sysfs_ul_range, kobj);
-
-	return sysfs_emit(buf, "%lu\n", range->min);
-}
-
-static ssize_t min_store(struct kobject *kobj, struct kobj_attribute *attr,
-		const char *buf, size_t count)
-{
-	struct damon_sysfs_ul_range *range = container_of(kobj,
-			struct damon_sysfs_ul_range, kobj);
-	unsigned long min;
-	int err;
-
-	err = kstrtoul(buf, 0, &min);
-	if (err)
-		return err;
-
-	range->min = min;
-	return count;
-}
-
-static ssize_t max_show(struct kobject *kobj, struct kobj_attribute *attr,
-		char *buf)
-{
-	struct damon_sysfs_ul_range *range = container_of(kobj,
-			struct damon_sysfs_ul_range, kobj);
-
-	return sysfs_emit(buf, "%lu\n", range->max);
-}
-
-static ssize_t max_store(struct kobject *kobj, struct kobj_attribute *attr,
-		const char *buf, size_t count)
-{
-	struct damon_sysfs_ul_range *range = container_of(kobj,
-			struct damon_sysfs_ul_range, kobj);
-	unsigned long max;
-	int err;
-
-	err = kstrtoul(buf, 0, &max);
-	if (err)
-		return err;
-
-	range->max = max;
-	return count;
-}
-
-static void damon_sysfs_ul_range_release(struct kobject *kobj)
-{
-	kfree(container_of(kobj, struct damon_sysfs_ul_range, kobj));
-}
-
-static struct kobj_attribute damon_sysfs_ul_range_min_attr =
-		__ATTR_RW_MODE(min, 0600);
-
-static struct kobj_attribute damon_sysfs_ul_range_max_attr =
-		__ATTR_RW_MODE(max, 0600);
-
-static struct attribute *damon_sysfs_ul_range_attrs[] = {
-	&damon_sysfs_ul_range_min_attr.attr,
-	&damon_sysfs_ul_range_max_attr.attr,
-	NULL,
-};
-ATTRIBUTE_GROUPS(damon_sysfs_ul_range);
-
-static struct kobj_type damon_sysfs_ul_range_ktype = {
-	.release = damon_sysfs_ul_range_release,
-	.sysfs_ops = &kobj_sysfs_ops,
-	.default_groups = damon_sysfs_ul_range_groups,
-};
-
-/*
  * schemes/stats directory
  */
 
--- a/mm/damon/sysfs-common.c~mm-damon-sysfs-move-unsigned-long-range-directory-to-common-module
+++ a/mm/damon/sysfs-common.c
@@ -5,7 +5,103 @@
  * Author: SeongJae Park <sj@kernel.org>
  */
 
+#include <linux/slab.h>
+
 #include "sysfs-common.h"
 
 DEFINE_MUTEX(damon_sysfs_lock);
 
+/*
+ * unsigned long range directory
+ */
+
+struct damon_sysfs_ul_range *damon_sysfs_ul_range_alloc(
+		unsigned long min,
+		unsigned long max)
+{
+	struct damon_sysfs_ul_range *range = kmalloc(sizeof(*range),
+			GFP_KERNEL);
+
+	if (!range)
+		return NULL;
+	range->kobj = (struct kobject){};
+	range->min = min;
+	range->max = max;
+
+	return range;
+}
+
+static ssize_t min_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_ul_range *range = container_of(kobj,
+			struct damon_sysfs_ul_range, kobj);
+
+	return sysfs_emit(buf, "%lu\n", range->min);
+}
+
+static ssize_t min_store(struct kobject *kobj, struct kobj_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct damon_sysfs_ul_range *range = container_of(kobj,
+			struct damon_sysfs_ul_range, kobj);
+	unsigned long min;
+	int err;
+
+	err = kstrtoul(buf, 0, &min);
+	if (err)
+		return err;
+
+	range->min = min;
+	return count;
+}
+
+static ssize_t max_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_ul_range *range = container_of(kobj,
+			struct damon_sysfs_ul_range, kobj);
+
+	return sysfs_emit(buf, "%lu\n", range->max);
+}
+
+static ssize_t max_store(struct kobject *kobj, struct kobj_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct damon_sysfs_ul_range *range = container_of(kobj,
+			struct damon_sysfs_ul_range, kobj);
+	unsigned long max;
+	int err;
+
+	err = kstrtoul(buf, 0, &max);
+	if (err)
+		return err;
+
+	range->max = max;
+	return count;
+}
+
+void damon_sysfs_ul_range_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_ul_range, kobj));
+}
+
+static struct kobj_attribute damon_sysfs_ul_range_min_attr =
+		__ATTR_RW_MODE(min, 0600);
+
+static struct kobj_attribute damon_sysfs_ul_range_max_attr =
+		__ATTR_RW_MODE(max, 0600);
+
+static struct attribute *damon_sysfs_ul_range_attrs[] = {
+	&damon_sysfs_ul_range_min_attr.attr,
+	&damon_sysfs_ul_range_max_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_ul_range);
+
+struct kobj_type damon_sysfs_ul_range_ktype = {
+	.release = damon_sysfs_ul_range_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_ul_range_groups,
+};
+
--- a/mm/damon/sysfs-common.h~mm-damon-sysfs-move-unsigned-long-range-directory-to-common-module
+++ a/mm/damon/sysfs-common.h
@@ -9,3 +9,16 @@
 #include <linux/kobject.h>
 
 extern struct mutex damon_sysfs_lock;
+
+struct damon_sysfs_ul_range {
+	struct kobject kobj;
+	unsigned long min;
+	unsigned long max;
+};
+
+struct damon_sysfs_ul_range *damon_sysfs_ul_range_alloc(
+		unsigned long min,
+		unsigned long max);
+void damon_sysfs_ul_range_release(struct kobject *kobj);
+
+extern struct kobj_type damon_sysfs_ul_range_ktype;
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch
docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch
mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch
mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch
mm-damon-sysfs-schemes-implement-scheme-region-directory.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command-fix.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command-fix.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch
selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

