Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC9E7C636D3
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbjBJA6U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbjBJA4Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:56:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5437096C
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20055B82396
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE655C4339B;
        Fri, 10 Feb 2023 00:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990487;
        bh=QM3HB99oxECU/wsf+2h43WzbmCFUmeLt1ugKCLOFTHY=;
        h=Date:To:From:Subject:From;
        b=KLaOKc5wP39qw4yT9ZxpGISGUXNcuqNfbQ3+EDO5kA9xYvTiDgnWW+329eYHk310V
         CdgjwRTKZZ8MnAngFit3TBICBoOInWdBkzsjIpG29FBJoPc1aQ0feiDIlRy2am3FWQ
         Z6VKNhUPHFGWypyF6uSQ9K4WgPhDwOBDMRI4kft8=
Date:   Thu, 09 Feb 2023 16:54:47 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org, linux@weissschuh.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-make-kobj_type-structures-constant.patch removed from -mm tree
Message-Id: <20230210005447.BE655C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: make kobj_type structures constant
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-make-kobj_type-structures-constant.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thomas Weißschuh <linux@weissschuh.net>
Subject: mm/damon/sysfs: make kobj_type structures constant
Date: Tue, 07 Feb 2023 19:21:15 +0000

Since commit ee6d3dd4ed48 ("driver core: make kobj_type constant.") the
driver core allows the usage of const struct kobj_type.

Take advantage of this to constify the structure definitions to prevent
modification at runtime.

Link: https://lkml.kernel.org/r/20230207-kobj_type-damon-v1-1-9d4fea6a465b@weissschuh.net
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-common.c  |    2 +-
 mm/damon/sysfs-common.h  |    4 ++--
 mm/damon/sysfs-schemes.c |   18 +++++++++---------
 mm/damon/sysfs.c         |   22 +++++++++++-----------
 4 files changed, 23 insertions(+), 23 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-make-kobj_type-structures-constant
+++ a/mm/damon/sysfs.c
@@ -81,7 +81,7 @@ static struct attribute *damon_sysfs_reg
 };
 ATTRIBUTE_GROUPS(damon_sysfs_region);
 
-static struct kobj_type damon_sysfs_region_ktype = {
+static const struct kobj_type damon_sysfs_region_ktype = {
 	.release = damon_sysfs_region_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_region_groups,
@@ -198,7 +198,7 @@ static struct attribute *damon_sysfs_reg
 };
 ATTRIBUTE_GROUPS(damon_sysfs_regions);
 
-static struct kobj_type damon_sysfs_regions_ktype = {
+static const struct kobj_type damon_sysfs_regions_ktype = {
 	.release = damon_sysfs_regions_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_regions_groups,
@@ -277,7 +277,7 @@ static struct attribute *damon_sysfs_tar
 };
 ATTRIBUTE_GROUPS(damon_sysfs_target);
 
-static struct kobj_type damon_sysfs_target_ktype = {
+static const struct kobj_type damon_sysfs_target_ktype = {
 	.release = damon_sysfs_target_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_target_groups,
@@ -402,7 +402,7 @@ static struct attribute *damon_sysfs_tar
 };
 ATTRIBUTE_GROUPS(damon_sysfs_targets);
 
-static struct kobj_type damon_sysfs_targets_ktype = {
+static const struct kobj_type damon_sysfs_targets_ktype = {
 	.release = damon_sysfs_targets_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_targets_groups,
@@ -530,7 +530,7 @@ static struct attribute *damon_sysfs_int
 };
 ATTRIBUTE_GROUPS(damon_sysfs_intervals);
 
-static struct kobj_type damon_sysfs_intervals_ktype = {
+static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.release = damon_sysfs_intervals_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_intervals_groups,
@@ -612,7 +612,7 @@ static struct attribute *damon_sysfs_att
 };
 ATTRIBUTE_GROUPS(damon_sysfs_attrs);
 
-static struct kobj_type damon_sysfs_attrs_ktype = {
+static const struct kobj_type damon_sysfs_attrs_ktype = {
 	.release = damon_sysfs_attrs_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_attrs_groups,
@@ -800,7 +800,7 @@ static struct attribute *damon_sysfs_con
 };
 ATTRIBUTE_GROUPS(damon_sysfs_context);
 
-static struct kobj_type damon_sysfs_context_ktype = {
+static const struct kobj_type damon_sysfs_context_ktype = {
 	.release = damon_sysfs_context_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_context_groups,
@@ -926,7 +926,7 @@ static struct attribute *damon_sysfs_con
 };
 ATTRIBUTE_GROUPS(damon_sysfs_contexts);
 
-static struct kobj_type damon_sysfs_contexts_ktype = {
+static const struct kobj_type damon_sysfs_contexts_ktype = {
 	.release = damon_sysfs_contexts_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_contexts_groups,
@@ -1564,7 +1564,7 @@ static struct attribute *damon_sysfs_kda
 };
 ATTRIBUTE_GROUPS(damon_sysfs_kdamond);
 
-static struct kobj_type damon_sysfs_kdamond_ktype = {
+static const struct kobj_type damon_sysfs_kdamond_ktype = {
 	.release = damon_sysfs_kdamond_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_kdamond_groups,
@@ -1707,7 +1707,7 @@ static struct attribute *damon_sysfs_kda
 };
 ATTRIBUTE_GROUPS(damon_sysfs_kdamonds);
 
-static struct kobj_type damon_sysfs_kdamonds_ktype = {
+static const struct kobj_type damon_sysfs_kdamonds_ktype = {
 	.release = damon_sysfs_kdamonds_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_kdamonds_groups,
@@ -1757,7 +1757,7 @@ static struct attribute *damon_sysfs_ui_
 };
 ATTRIBUTE_GROUPS(damon_sysfs_ui_dir);
 
-static struct kobj_type damon_sysfs_ui_dir_ktype = {
+static const struct kobj_type damon_sysfs_ui_dir_ktype = {
 	.release = damon_sysfs_ui_dir_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_ui_dir_groups,
--- a/mm/damon/sysfs-common.c~mm-damon-sysfs-make-kobj_type-structures-constant
+++ a/mm/damon/sysfs-common.c
@@ -99,7 +99,7 @@ static struct attribute *damon_sysfs_ul_
 };
 ATTRIBUTE_GROUPS(damon_sysfs_ul_range);
 
-struct kobj_type damon_sysfs_ul_range_ktype = {
+const struct kobj_type damon_sysfs_ul_range_ktype = {
 	.release = damon_sysfs_ul_range_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_ul_range_groups,
--- a/mm/damon/sysfs-common.h~mm-damon-sysfs-make-kobj_type-structures-constant
+++ a/mm/damon/sysfs-common.h
@@ -21,7 +21,7 @@ struct damon_sysfs_ul_range *damon_sysfs
 		unsigned long max);
 void damon_sysfs_ul_range_release(struct kobject *kobj);
 
-extern struct kobj_type damon_sysfs_ul_range_ktype;
+extern const struct kobj_type damon_sysfs_ul_range_ktype;
 
 /*
  * schemes directory
@@ -36,7 +36,7 @@ struct damon_sysfs_schemes {
 struct damon_sysfs_schemes *damon_sysfs_schemes_alloc(void);
 void damon_sysfs_schemes_rm_dirs(struct damon_sysfs_schemes *schemes);
 
-extern struct kobj_type damon_sysfs_schemes_ktype;
+extern const struct kobj_type damon_sysfs_schemes_ktype;
 
 int damon_sysfs_set_schemes(struct damon_ctx *ctx,
 		struct damon_sysfs_schemes *sysfs_schemes);
--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-make-kobj_type-structures-constant
+++ a/mm/damon/sysfs-schemes.c
@@ -103,7 +103,7 @@ static struct attribute *damon_sysfs_sch
 };
 ATTRIBUTE_GROUPS(damon_sysfs_scheme_region);
 
-static struct kobj_type damon_sysfs_scheme_region_ktype = {
+static const struct kobj_type damon_sysfs_scheme_region_ktype = {
 	.release = damon_sysfs_scheme_region_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_scheme_region_groups,
@@ -153,7 +153,7 @@ static struct attribute *damon_sysfs_sch
 };
 ATTRIBUTE_GROUPS(damon_sysfs_scheme_regions);
 
-static struct kobj_type damon_sysfs_scheme_regions_ktype = {
+static const struct kobj_type damon_sysfs_scheme_regions_ktype = {
 	.release = damon_sysfs_scheme_regions_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_scheme_regions_groups,
@@ -252,7 +252,7 @@ static struct attribute *damon_sysfs_sta
 };
 ATTRIBUTE_GROUPS(damon_sysfs_stats);
 
-static struct kobj_type damon_sysfs_stats_ktype = {
+static const struct kobj_type damon_sysfs_stats_ktype = {
 	.release = damon_sysfs_stats_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_stats_groups,
@@ -678,7 +678,7 @@ static struct attribute *damon_sysfs_wat
 };
 ATTRIBUTE_GROUPS(damon_sysfs_watermarks);
 
-static struct kobj_type damon_sysfs_watermarks_ktype = {
+static const struct kobj_type damon_sysfs_watermarks_ktype = {
 	.release = damon_sysfs_watermarks_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_watermarks_groups,
@@ -789,7 +789,7 @@ static struct attribute *damon_sysfs_wei
 };
 ATTRIBUTE_GROUPS(damon_sysfs_weights);
 
-static struct kobj_type damon_sysfs_weights_ktype = {
+static const struct kobj_type damon_sysfs_weights_ktype = {
 	.release = damon_sysfs_weights_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_weights_groups,
@@ -920,7 +920,7 @@ static struct attribute *damon_sysfs_quo
 };
 ATTRIBUTE_GROUPS(damon_sysfs_quotas);
 
-static struct kobj_type damon_sysfs_quotas_ktype = {
+static const struct kobj_type damon_sysfs_quotas_ktype = {
 	.release = damon_sysfs_quotas_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_quotas_groups,
@@ -1019,7 +1019,7 @@ static struct attribute *damon_sysfs_acc
 };
 ATTRIBUTE_GROUPS(damon_sysfs_access_pattern);
 
-static struct kobj_type damon_sysfs_access_pattern_ktype = {
+static const struct kobj_type damon_sysfs_access_pattern_ktype = {
 	.release = damon_sysfs_access_pattern_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_access_pattern_groups,
@@ -1279,7 +1279,7 @@ static struct attribute *damon_sysfs_sch
 };
 ATTRIBUTE_GROUPS(damon_sysfs_scheme);
 
-static struct kobj_type damon_sysfs_scheme_ktype = {
+static const struct kobj_type damon_sysfs_scheme_ktype = {
 	.release = damon_sysfs_scheme_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_scheme_groups,
@@ -1396,7 +1396,7 @@ static struct attribute *damon_sysfs_sch
 };
 ATTRIBUTE_GROUPS(damon_sysfs_schemes);
 
-struct kobj_type damon_sysfs_schemes_ktype = {
+const struct kobj_type damon_sysfs_schemes_ktype = {
 	.release = damon_sysfs_schemes_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = damon_sysfs_schemes_groups,
_

Patches currently in -mm which might be from linux@weissschuh.net are


