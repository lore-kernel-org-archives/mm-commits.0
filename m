Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E49C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiJCVMs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiJCVLf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9EA51A0F
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FFE2B815F2
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C53C433C1;
        Mon,  3 Oct 2022 21:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831226;
        bh=lBRMklCfv6gTYhMD9tXkQMv+al/R++uZQzflgicDIew=;
        h=Date:To:From:Subject:From;
        b=PD6T98cCzDPqJUi1+MI05LCCBTb1ri655aMPU9zp3/tCcEcaqjGarXEs8XyeuNSJV
         vkQgkE06FoDffnb4DV8iN8R2oKKJy2YYcYcMR+ORqnXGE6kzm1S0JqgYs+OeGN2mqh
         teIomuhsMbY8e+IjtirEbgbOSG6hkWA3wZK1Ev9c=
Date:   Mon, 03 Oct 2022 14:07:05 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-change-few-functions-execute-order.patch removed from -mm tree
Message-Id: <20221003210706.27C53C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: change few functions execute order
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-change-few-functions-execute-order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon/sysfs: change few functions execute order
Date: Thu, 8 Sep 2022 16:19:32 +0800

There's no need to run container_of() as early as we do.

The compiler figures this out, but the resulting code is more readable.

Link: https://lkml.kernel.org/r/20220908081932.77370-1-xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-change-few-functions-execute-order
+++ a/mm/damon/sysfs.c
@@ -1031,8 +1031,7 @@ static ssize_t nr_schemes_show(struct ko
 static ssize_t nr_schemes_store(struct kobject *kobj,
 		struct kobj_attribute *attr, const char *buf, size_t count)
 {
-	struct damon_sysfs_schemes *schemes = container_of(kobj,
-			struct damon_sysfs_schemes, kobj);
+	struct damon_sysfs_schemes *schemes;
 	int nr, err = kstrtoint(buf, 0, &nr);
 
 	if (err)
@@ -1040,6 +1039,8 @@ static ssize_t nr_schemes_store(struct k
 	if (nr < 0)
 		return -EINVAL;
 
+	schemes = container_of(kobj, struct damon_sysfs_schemes, kobj);
+
 	if (!mutex_trylock(&damon_sysfs_lock))
 		return -EBUSY;
 	err = damon_sysfs_schemes_add_dirs(schemes, nr);
@@ -1237,8 +1238,7 @@ static ssize_t nr_regions_show(struct ko
 static ssize_t nr_regions_store(struct kobject *kobj,
 		struct kobj_attribute *attr, const char *buf, size_t count)
 {
-	struct damon_sysfs_regions *regions = container_of(kobj,
-			struct damon_sysfs_regions, kobj);
+	struct damon_sysfs_regions *regions;
 	int nr, err = kstrtoint(buf, 0, &nr);
 
 	if (err)
@@ -1246,6 +1246,8 @@ static ssize_t nr_regions_store(struct k
 	if (nr < 0)
 		return -EINVAL;
 
+	regions = container_of(kobj, struct damon_sysfs_regions, kobj);
+
 	if (!mutex_trylock(&damon_sysfs_lock))
 		return -EBUSY;
 	err = damon_sysfs_regions_add_dirs(regions, nr);
@@ -1440,8 +1442,7 @@ static ssize_t nr_targets_show(struct ko
 static ssize_t nr_targets_store(struct kobject *kobj,
 		struct kobj_attribute *attr, const char *buf, size_t count)
 {
-	struct damon_sysfs_targets *targets = container_of(kobj,
-			struct damon_sysfs_targets, kobj);
+	struct damon_sysfs_targets *targets;
 	int nr, err = kstrtoint(buf, 0, &nr);
 
 	if (err)
@@ -1449,6 +1450,8 @@ static ssize_t nr_targets_store(struct k
 	if (nr < 0)
 		return -EINVAL;
 
+	targets = container_of(kobj, struct damon_sysfs_targets, kobj);
+
 	if (!mutex_trylock(&damon_sysfs_lock))
 		return -EBUSY;
 	err = damon_sysfs_targets_add_dirs(targets, nr);
@@ -1962,8 +1965,7 @@ static ssize_t nr_contexts_show(struct k
 static ssize_t nr_contexts_store(struct kobject *kobj,
 		struct kobj_attribute *attr, const char *buf, size_t count)
 {
-	struct damon_sysfs_contexts *contexts = container_of(kobj,
-			struct damon_sysfs_contexts, kobj);
+	struct damon_sysfs_contexts *contexts;
 	int nr, err;
 
 	err = kstrtoint(buf, 0, &nr);
@@ -1973,6 +1975,7 @@ static ssize_t nr_contexts_store(struct
 	if (nr < 0 || 1 < nr)
 		return -EINVAL;
 
+	contexts = container_of(kobj, struct damon_sysfs_contexts, kobj);
 	if (!mutex_trylock(&damon_sysfs_lock))
 		return -EBUSY;
 	err = damon_sysfs_contexts_add_dirs(contexts, nr);
@@ -2737,8 +2740,7 @@ static ssize_t nr_kdamonds_show(struct k
 static ssize_t nr_kdamonds_store(struct kobject *kobj,
 		struct kobj_attribute *attr, const char *buf, size_t count)
 {
-	struct damon_sysfs_kdamonds *kdamonds = container_of(kobj,
-			struct damon_sysfs_kdamonds, kobj);
+	struct damon_sysfs_kdamonds *kdamonds;
 	int nr, err;
 
 	err = kstrtoint(buf, 0, &nr);
@@ -2747,6 +2749,8 @@ static ssize_t nr_kdamonds_store(struct
 	if (nr < 0)
 		return -EINVAL;
 
+	kdamonds = container_of(kobj, struct damon_sysfs_kdamonds, kobj);
+
 	if (!mutex_trylock(&damon_sysfs_lock))
 		return -EBUSY;
 	err = damon_sysfs_kdamonds_add_dirs(kdamonds, nr);
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are

mm-damon-move-sz_damon_region-to-damon_sz_region.patch
mm-damon-use-damon_sz_region-in-appropriate-place.patch

