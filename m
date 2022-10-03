Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAEC3C43219
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiJCVOO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiJCVLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E8B51A30
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24546610D5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7694DC433C1;
        Mon,  3 Oct 2022 21:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831238;
        bh=ZATHzR4ZhyYIasuqc+q132uu9FSVuBPYNij2CSMs2G0=;
        h=Date:To:From:Subject:From;
        b=yKb0YC+yT1gAAr5gf9UbCF8v42b+QiddOS1XjFbVnPHP9DKTOXMzv+l7Goa8PTA2r
         qeqH/Bloeh25GCAyreCXxRKiDv6Aoy8fZ26st0qRcFmZPBd7DQ0Omie1Lg/aGKQ2My
         ONZX56Em6fe8xazabYVzxO+bELOtZ2ekiopl38KY=
Date:   Mon, 03 Oct 2022 14:07:17 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-reduce-parameters-for-damon_set_attrs.patch removed from -mm tree
Message-Id: <20221003210718.7694DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: reduce parameters for damon_set_attrs()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-reduce-parameters-for-damon_set_attrs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: reduce parameters for damon_set_attrs()
Date: Tue, 13 Sep 2022 17:44:33 +0000

Number of parameters for 'damon_set_attrs()' is six.  As it could be
confusing and verbose, this commit reduces the number by receiving single
pointer to a 'struct damon_attrs'.

Link: https://lkml.kernel.org/r/20220913174449.50645-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    4 +---
 mm/damon/core.c       |   21 +++++----------------
 mm/damon/dbgfs.c      |    9 ++++++---
 mm/damon/lru_sort.c   |   10 ++++++++--
 mm/damon/reclaim.c    |   10 ++++++++--
 mm/damon/sysfs.c      |   12 ++++++++----
 6 files changed, 36 insertions(+), 30 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-reduce-parameters-for-damon_set_attrs
+++ a/include/linux/damon.h
@@ -540,9 +540,7 @@ unsigned int damon_nr_regions(struct dam
 
 struct damon_ctx *damon_new_ctx(void);
 void damon_destroy_ctx(struct damon_ctx *ctx);
-int damon_set_attrs(struct damon_ctx *ctx, unsigned long sample_int,
-		unsigned long aggr_int, unsigned long ops_upd_int,
-		unsigned long min_nr_reg, unsigned long max_nr_reg);
+int damon_set_attrs(struct damon_ctx *ctx, struct damon_attrs *attrs);
 int damon_set_schemes(struct damon_ctx *ctx,
 			struct damos **schemes, ssize_t nr_schemes);
 int damon_nr_running_ctxs(void);
--- a/mm/damon/core.c~mm-damon-core-reduce-parameters-for-damon_set_attrs
+++ a/mm/damon/core.c
@@ -428,32 +428,21 @@ void damon_destroy_ctx(struct damon_ctx
 /**
  * damon_set_attrs() - Set attributes for the monitoring.
  * @ctx:		monitoring context
- * @sample_int:		time interval between samplings
- * @aggr_int:		time interval between aggregations
- * @ops_upd_int:	time interval between monitoring operations updates
- * @min_nr_reg:		minimal number of regions
- * @max_nr_reg:		maximum number of regions
+ * @attrs:		monitoring attributes
  *
  * This function should not be called while the kdamond is running.
  * Every time interval is in micro-seconds.
  *
  * Return: 0 on success, negative error code otherwise.
  */
-int damon_set_attrs(struct damon_ctx *ctx, unsigned long sample_int,
-		    unsigned long aggr_int, unsigned long ops_upd_int,
-		    unsigned long min_nr_reg, unsigned long max_nr_reg)
+int damon_set_attrs(struct damon_ctx *ctx, struct damon_attrs *attrs)
 {
-	if (min_nr_reg < 3)
+	if (attrs->min_nr_regions < 3)
 		return -EINVAL;
-	if (min_nr_reg > max_nr_reg)
+	if (attrs->min_nr_regions > attrs->max_nr_regions)
 		return -EINVAL;
 
-	ctx->attrs.sample_interval = sample_int;
-	ctx->attrs.aggr_interval = aggr_int;
-	ctx->attrs.ops_update_interval = ops_upd_int;
-	ctx->attrs.min_nr_regions = min_nr_reg;
-	ctx->attrs.max_nr_regions = max_nr_reg;
-
+	ctx->attrs = *attrs;
 	return 0;
 }
 
--- a/mm/damon/dbgfs.c~mm-damon-core-reduce-parameters-for-damon_set_attrs
+++ a/mm/damon/dbgfs.c
@@ -67,7 +67,7 @@ static ssize_t dbgfs_attrs_write(struct
 		const char __user *buf, size_t count, loff_t *ppos)
 {
 	struct damon_ctx *ctx = file->private_data;
-	unsigned long s, a, r, minr, maxr;
+	struct damon_attrs attrs;
 	char *kbuf;
 	ssize_t ret;
 
@@ -76,7 +76,10 @@ static ssize_t dbgfs_attrs_write(struct
 		return PTR_ERR(kbuf);
 
 	if (sscanf(kbuf, "%lu %lu %lu %lu %lu",
-				&s, &a, &r, &minr, &maxr) != 5) {
+				&attrs.sample_interval, &attrs.aggr_interval,
+				&attrs.ops_update_interval,
+				&attrs.min_nr_regions,
+				&attrs.max_nr_regions) != 5) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -87,7 +90,7 @@ static ssize_t dbgfs_attrs_write(struct
 		goto unlock_out;
 	}
 
-	ret = damon_set_attrs(ctx, s, a, r, minr, maxr);
+	ret = damon_set_attrs(ctx, &attrs);
 	if (!ret)
 		ret = count;
 unlock_out:
--- a/mm/damon/lru_sort.c~mm-damon-core-reduce-parameters-for-damon_set_attrs
+++ a/mm/damon/lru_sort.c
@@ -350,13 +350,19 @@ static struct damos *damon_lru_sort_new_
 
 static int damon_lru_sort_apply_parameters(void)
 {
+	struct damon_attrs attrs = {
+		.sample_interval = sample_interval,
+		.aggr_interval = aggr_interval,
+		.ops_update_interval = 0,
+		.min_nr_regions = min_nr_regions,
+		.max_nr_regions = max_nr_regions,
+	};
 	struct damos *scheme;
 	struct damon_addr_range addr_range;
 	unsigned int hot_thres, cold_thres;
 	int err = 0;
 
-	err = damon_set_attrs(ctx, sample_interval, aggr_interval, 0,
-			min_nr_regions, max_nr_regions);
+	err = damon_set_attrs(ctx, &attrs);
 	if (err)
 		return err;
 
--- a/mm/damon/reclaim.c~mm-damon-core-reduce-parameters-for-damon_set_attrs
+++ a/mm/damon/reclaim.c
@@ -275,12 +275,18 @@ static struct damos *damon_reclaim_new_s
 
 static int damon_reclaim_apply_parameters(void)
 {
+	struct damon_attrs attrs = {
+		.sample_interval = sample_interval,
+		.aggr_interval = aggr_interval,
+		.ops_update_interval = 0,
+		.min_nr_regions = min_nr_regions,
+		.max_nr_regions = max_nr_regions,
+	};
 	struct damos *scheme;
 	struct damon_addr_range addr_range;
 	int err = 0;
 
-	err = damon_set_attrs(ctx, sample_interval, aggr_interval, 0,
-			min_nr_regions, max_nr_regions);
+	err = damon_set_attrs(ctx, &attrs);
 	if (err)
 		return err;
 
--- a/mm/damon/sysfs.c~mm-damon-core-reduce-parameters-for-damon_set_attrs
+++ a/mm/damon/sysfs.c
@@ -2130,10 +2130,14 @@ static int damon_sysfs_set_attrs(struct
 	struct damon_sysfs_intervals *sys_intervals = sys_attrs->intervals;
 	struct damon_sysfs_ul_range *sys_nr_regions =
 		sys_attrs->nr_regions_range;
-
-	return damon_set_attrs(ctx, sys_intervals->sample_us,
-			sys_intervals->aggr_us, sys_intervals->update_us,
-			sys_nr_regions->min, sys_nr_regions->max);
+	struct damon_attrs attrs = {
+		.sample_interval = sys_intervals->sample_us,
+		.aggr_interval = sys_intervals->aggr_us,
+		.ops_update_interval = sys_intervals->update_us,
+		.min_nr_regions = sys_nr_regions->min,
+		.max_nr_regions = sys_nr_regions->max,
+	};
+	return damon_set_attrs(ctx, &attrs);
 }
 
 static void damon_sysfs_destroy_targets(struct damon_ctx *ctx)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

