Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FCB7C4332F
	for <mm-commits@archiver.kernel.org>; Tue,  1 Nov 2022 22:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbiKAW6h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Nov 2022 18:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiKAW6f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2022 18:58:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A17FFE0
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 15:58:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27E6761772
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 22:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D3CC433D7;
        Tue,  1 Nov 2022 22:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667343511;
        bh=doArZJzWc2nr2tegIBh5hO7lR43+JWTzGIMYQwaKqFk=;
        h=Date:To:From:Subject:From;
        b=t5M9Y7IDNkCkN1O+1sbdoT4fXGymZOfxUcJGKJGwBWRCg+qbDH3tRRHfUENtdmQ8j
         TPG5pea58Bkso6Lu5u2gXQot6sk1o5r38Qfy22ONmcBVZjmSn++cCYPEW45ApF956W
         VNRn+Sebf9qHeHGrMUH8P7CDmITfIzi5lD4gNtYM=
Date:   Tue, 01 Nov 2022 15:58:31 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-implement-scheme-region-directory.patch added to mm-unstable branch
Message-Id: <20221101225831.81D3CC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs-schemes: implement scheme region directory
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-implement-scheme-region-directory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-implement-scheme-region-directory.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: implement scheme region directory
Date: Tue, 1 Nov 2022 22:03:23 +0000

Implement region directories under 'tried_regions' directory of each
scheme DAMON sysfs directory.  This directory will provide the address
range, the monitored access frequency ('nr_accesses'), and the age of each
DAMON region that corresponding DAMON-based operation scheme has tried to
be applied.  Note that this commit doesn't implement the code for filling
the data but only the sysfs directory.

Link: https://lkml.kernel.org/r/20221101220328.95765-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |  123 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 122 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-scheme-region-directory
+++ a/mm/damon/sysfs-schemes.c
@@ -10,17 +10,137 @@
 #include "sysfs-common.h"
 
 /*
+ * scheme region directory
+ */
+
+struct damon_sysfs_scheme_region {
+	struct kobject kobj;
+	struct damon_addr_range ar;
+	unsigned int nr_accesses;
+	unsigned int age;
+	struct list_head list;
+};
+
+static struct damon_sysfs_scheme_region *damon_sysfs_scheme_region_alloc(
+		struct damon_region *region)
+{
+	struct damon_sysfs_scheme_region *sysfs_region = kmalloc(
+			sizeof(*sysfs_region), GFP_KERNEL);
+
+	if (!sysfs_region)
+		return NULL;
+	sysfs_region->kobj = (struct kobject){};
+	sysfs_region->ar = region->ar;
+	sysfs_region->nr_accesses = region->nr_accesses;
+	sysfs_region->age = region->age;
+	INIT_LIST_HEAD(&sysfs_region->list);
+	return sysfs_region;
+}
+
+static ssize_t start_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_scheme_region *region = container_of(kobj,
+			struct damon_sysfs_scheme_region, kobj);
+
+	return sysfs_emit(buf, "%lu\n", region->ar.start);
+}
+
+static ssize_t end_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_scheme_region *region = container_of(kobj,
+			struct damon_sysfs_scheme_region, kobj);
+
+	return sysfs_emit(buf, "%lu\n", region->ar.end);
+}
+
+static ssize_t nr_accesses_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_scheme_region *region = container_of(kobj,
+			struct damon_sysfs_scheme_region, kobj);
+
+	return sysfs_emit(buf, "%u\n", region->nr_accesses);
+}
+
+static ssize_t age_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_scheme_region *region = container_of(kobj,
+			struct damon_sysfs_scheme_region, kobj);
+
+	return sysfs_emit(buf, "%u\n", region->age);
+}
+
+static void damon_sysfs_scheme_region_release(struct kobject *kobj)
+{
+	struct damon_sysfs_scheme_region *region = container_of(kobj,
+			struct damon_sysfs_scheme_region, kobj);
+
+	list_del(&region->list);
+	kfree(region);
+}
+
+static struct kobj_attribute damon_sysfs_scheme_region_start_attr =
+		__ATTR_RO_MODE(start, 0400);
+
+static struct kobj_attribute damon_sysfs_scheme_region_end_attr =
+		__ATTR_RO_MODE(end, 0400);
+
+static struct kobj_attribute damon_sysfs_scheme_region_nr_accesses_attr =
+		__ATTR_RO_MODE(nr_accesses, 0400);
+
+static struct kobj_attribute damon_sysfs_scheme_region_age_attr =
+		__ATTR_RO_MODE(age, 0400);
+
+static struct attribute *damon_sysfs_scheme_region_attrs[] = {
+	&damon_sysfs_scheme_region_start_attr.attr,
+	&damon_sysfs_scheme_region_end_attr.attr,
+	&damon_sysfs_scheme_region_nr_accesses_attr.attr,
+	&damon_sysfs_scheme_region_age_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_scheme_region);
+
+static struct kobj_type damon_sysfs_scheme_region_ktype = {
+	.release = damon_sysfs_scheme_region_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_scheme_region_groups,
+};
+
+/*
  * scheme regions directory
  */
 
 struct damon_sysfs_scheme_regions {
 	struct kobject kobj;
+	struct list_head regions_list;
+	int nr_regions;
 };
 
 static struct damon_sysfs_scheme_regions *
 damon_sysfs_scheme_regions_alloc(void)
 {
-	return kzalloc(sizeof(struct damon_sysfs_scheme_regions), GFP_KERNEL);
+	struct damon_sysfs_scheme_regions *regions = kmalloc(sizeof(*regions),
+			GFP_KERNEL);
+
+	regions->kobj = (struct kobject){};
+	INIT_LIST_HEAD(&regions->regions_list);
+	regions->nr_regions = 0;
+	return regions;
+}
+
+static void damon_sysfs_scheme_regions_rm_dirs(
+		struct damon_sysfs_scheme_regions *regions)
+{
+	struct damon_sysfs_scheme_region *r, *next;
+
+	list_for_each_entry_safe(r, next, &regions->regions_list, list) {
+		/* release function deletes it from the list */
+		kobject_put(&r->kobj);
+		regions->nr_regions--;
+	}
 }
 
 static void damon_sysfs_scheme_regions_release(struct kobject *kobj)
@@ -837,6 +957,7 @@ static void damon_sysfs_scheme_rm_dirs(s
 	kobject_put(&scheme->quotas->kobj);
 	kobject_put(&scheme->watermarks->kobj);
 	kobject_put(&scheme->stats->kobj);
+	damon_sysfs_scheme_regions_rm_dirs(scheme->tried_regions);
 	kobject_put(&scheme->tried_regions->kobj);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-split-out-damos-charged-region-skip-logic-into-a-new-function.patch
mm-damon-core-split-damos-application-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-stat-update-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-quota-adjustment-logic-into-a-new-function.patch
mm-damon-sysfs-use-damon_addr_range-for-regions-start-and-end-values.patch
mm-damon-sysfs-remove-parameters-of-damon_sysfs_region_alloc.patch
mm-damon-sysfs-move-sysfs_lock-to-common-module.patch
mm-damon-sysfs-move-unsigned-long-range-directory-to-common-module.patch
mm-damon-sysfs-split-out-kdamond-independent-schemes-stats-update-logic-into-a-new-function.patch
mm-damon-sysfs-split-out-schemes-directory-implementation-to-separate-file.patch
mm-damon-modules-deduplicate-init-steps-for-damon-context-setup.patch
mm-damon-reclaimlru_sort-remove-unnecessarily-included-headers.patch
mm-damon-reclaim-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_reclaims-enabled-parameter.patch
mm-damon-lru_sort-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_lru_sorts-enabled-parameter.patch
docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch
docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch
mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch
mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch
mm-damon-sysfs-schemes-implement-scheme-region-directory.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch

