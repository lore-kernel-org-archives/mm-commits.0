Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91142C636CC
	for <mm-commits@archiver.kernel.org>; Tue,  7 Feb 2023 22:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjBGWeM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Feb 2023 17:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjBGWeM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Feb 2023 17:34:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8DE38B53
        for <mm-commits@vger.kernel.org>; Tue,  7 Feb 2023 14:34:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45F98B81AB8
        for <mm-commits@vger.kernel.org>; Tue,  7 Feb 2023 22:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84F1C433D2;
        Tue,  7 Feb 2023 22:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675809248;
        bh=5qU2njw0axwJefOj5Yuas2VF/RImAjXZmwijBxF7Sbc=;
        h=Date:To:From:Subject:From;
        b=TTdw72BD6r/BmfEwh8YMFMVLx3gOb1DH/id95rEamMXNyTgAQunYmlAMeqRnfacO9
         rYo8TwhxBDBqzBa0MJb1G65gMi4Un9GtK1xwb416TXp9WQWVIm/c96YlnJeLqs+erj
         T80g/85sYrxOFCU0LZU8eG9R9R9lBAdMqF9tGSrY=
Date:   Tue, 07 Feb 2023 14:34:07 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org, linux@weissschuh.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-make-kobj_type-structures-constant.patch added to mm-unstable branch
Message-Id: <20230207223407.E84F1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: make kobj_type structures constant
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-make-kobj_type-structures-constant.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-make-kobj_type-structures-constant.patch

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

mm-damon-sysfs-make-kobj_type-structures-constant.patch

