Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E728C67871
	for <mm-commits@archiver.kernel.org>; Tue, 25 Oct 2022 00:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiJYAIG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 20:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiJYAHa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 20:07:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0972A262
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 15:25:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E4789CE1AB8
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 22:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBC4C433D6;
        Mon, 24 Oct 2022 22:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666650343;
        bh=e1ECelVCFSAc87jmP1oL+5Jcsyg+Al1Z6p3JunkBMoE=;
        h=Date:To:From:Subject:From;
        b=0RX1cXe9WgGjxw3BodCdFxNBlziwUWjOfH3n4uYO4X1NZ7Futs9u5mOi/946BNmn6
         08T0ocOV4/3z+xv/0q7iLU9wzF4RyJO9ZF0MMCc2YkfYDoveKw3Y/WKO44WqyddsKt
         QfMrwdPFC/xQ1ciw+yfho7TWhXs9uf7Mk8FHa4Mc=
Date:   Mon, 24 Oct 2022 15:25:42 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-use-damon_addr_range-for-regions-start-and-end-values.patch added to mm-unstable branch
Message-Id: <20221024222542.EBBC4C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: use damon_addr_range for regions' start and end values
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-use-damon_addr_range-for-regions-start-and-end-values.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-use-damon_addr_range-for-regions-start-and-end-values.patch

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
Subject: mm/damon/sysfs: use damon_addr_range for regions' start and end values
Date: Mon, 24 Oct 2022 20:49:13 +0000

DAMON has a struct for each address range but DAMON sysfs interface is
using the low type (unsigned long) for storing the start and end addresses
of regions.  Use the dedicated struct for better type safety.

Link: https://lkml.kernel.org/r/20221024204919.18524-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-use-damon_addr_range-for-regions-start-and-end-values
+++ a/mm/damon/sysfs.c
@@ -1062,13 +1062,11 @@ static struct kobj_type damon_sysfs_sche
 
 struct damon_sysfs_region {
 	struct kobject kobj;
-	unsigned long start;
-	unsigned long end;
+	struct damon_addr_range ar;
 };
 
 static struct damon_sysfs_region *damon_sysfs_region_alloc(
-		unsigned long start,
-		unsigned long end)
+		struct damon_addr_range ar)
 {
 	struct damon_sysfs_region *region = kmalloc(sizeof(*region),
 			GFP_KERNEL);
@@ -1076,8 +1074,7 @@ static struct damon_sysfs_region *damon_
 	if (!region)
 		return NULL;
 	region->kobj = (struct kobject){};
-	region->start = start;
-	region->end = end;
+	region->ar = ar;
 	return region;
 }
 
@@ -1087,7 +1084,7 @@ static ssize_t start_show(struct kobject
 	struct damon_sysfs_region *region = container_of(kobj,
 			struct damon_sysfs_region, kobj);
 
-	return sysfs_emit(buf, "%lu\n", region->start);
+	return sysfs_emit(buf, "%lu\n", region->ar.start);
 }
 
 static ssize_t start_store(struct kobject *kobj, struct kobj_attribute *attr,
@@ -1095,7 +1092,7 @@ static ssize_t start_store(struct kobjec
 {
 	struct damon_sysfs_region *region = container_of(kobj,
 			struct damon_sysfs_region, kobj);
-	int err = kstrtoul(buf, 0, &region->start);
+	int err = kstrtoul(buf, 0, &region->ar.start);
 
 	return err ? err : count;
 }
@@ -1106,7 +1103,7 @@ static ssize_t end_show(struct kobject *
 	struct damon_sysfs_region *region = container_of(kobj,
 			struct damon_sysfs_region, kobj);
 
-	return sysfs_emit(buf, "%lu\n", region->end);
+	return sysfs_emit(buf, "%lu\n", region->ar.end);
 }
 
 static ssize_t end_store(struct kobject *kobj, struct kobj_attribute *attr,
@@ -1114,7 +1111,7 @@ static ssize_t end_store(struct kobject
 {
 	struct damon_sysfs_region *region = container_of(kobj,
 			struct damon_sysfs_region, kobj);
-	int err = kstrtoul(buf, 0, &region->end);
+	int err = kstrtoul(buf, 0, &region->ar.end);
 
 	return err ? err : count;
 }
@@ -1187,7 +1184,7 @@ static int damon_sysfs_regions_add_dirs(
 	regions->regions_arr = regions_arr;
 
 	for (i = 0; i < nr_regions; i++) {
-		region = damon_sysfs_region_alloc(0, 0);
+		region = damon_sysfs_region_alloc((struct damon_addr_range){});
 		if (!region) {
 			damon_sysfs_regions_rm_dirs(regions);
 			return -ENOMEM;
@@ -2147,11 +2144,11 @@ static int damon_sysfs_set_regions(struc
 		struct damon_sysfs_region *sys_region =
 			sysfs_regions->regions_arr[i];
 
-		if (sys_region->start > sys_region->end)
+		if (sys_region->ar.start > sys_region->ar.end)
 			goto out;
 
-		ranges[i].start = sys_region->start;
-		ranges[i].end = sys_region->end;
+		ranges[i].start = sys_region->ar.start;
+		ranges[i].end = sys_region->ar.end;
 		if (i == 0)
 			continue;
 		if (ranges[i - 1].end > ranges[i].start)
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
mm-damon-modules-deduplicate-init-steps-for-damon-context-setup.patch
mm-damon-reclaimlru_sort-remove-unnecessarily-included-headers.patch

