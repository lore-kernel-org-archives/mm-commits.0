Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3BBFECAAD8
	for <mm-commits@archiver.kernel.org>; Wed, 21 Sep 2022 19:54:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiIUTyk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Sep 2022 15:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiIUTyk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Sep 2022 15:54:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD87201AF
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 12:54:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA4D063259
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 19:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD5CC433B5;
        Wed, 21 Sep 2022 19:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663790077;
        bh=9IvDEL1jiPSss9IfayNlgBv+/Sr0d2UiKWBMJ4WU/B4=;
        h=Date:To:From:Subject:From;
        b=bML855gQM/mbbO/hOVYw9HWE67th2BqVqkGXpUFfXIkVPL5EUxCcE9ECLRLc3f4DQ
         edhU1NtnxPTCu2vbKkgePwoUgwQXt1ByZ08ctCkt9/v5K8ToBG9nsYERon5uo02xJ1
         KwpXujQSFM/3OzszhXRSTLFYxu9mvhQL41RACG58=
Date:   Wed, 21 Sep 2022 12:54:35 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-deduplicate-damon_reclaimlru_sort_apply_parameters.patch added to mm-unstable branch
Message-Id: <20220921195437.2AD5CC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: deduplicate damon_{reclaim,lru_sort}_apply_parameters()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-deduplicate-damon_reclaimlru_sort_apply_parameters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-deduplicate-damon_reclaimlru_sort_apply_parameters.patch

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
From: Kaixu Xia <kaixuxia@tencent.com>
Subject: mm/damon: deduplicate damon_{reclaim,lru_sort}_apply_parameters()
Date: Tue, 20 Sep 2022 16:53:22 +0000

The bodies of damon_{reclaim,lru_sort}_apply_parameters() contain
duplicates.  This commit adds a common function
damon_set_region_biggest_system_ram_default() to remove the duplicates.

Link: https://lkml.kernel.org/r/6329f00d.a70a0220.9bb29.3678SMTPIN_ADDED_BROKEN@mx.google.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Suggested-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/damon.h~mm-damon-deduplicate-damon_reclaimlru_sort_apply_parameters
+++ a/include/linux/damon.h
@@ -557,7 +557,8 @@ static inline bool damon_target_has_pid(
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive);
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
 
-bool damon_find_biggest_system_ram(unsigned long *start, unsigned long *end);
+int damon_set_region_biggest_system_ram_default(struct damon_target *t,
+				unsigned long *start, unsigned long *end);
 
 #endif	/* CONFIG_DAMON */
 
--- a/mm/damon/core.c~mm-damon-deduplicate-damon_reclaimlru_sort_apply_parameters
+++ a/mm/damon/core.c
@@ -1245,7 +1245,8 @@ static int walk_system_ram(struct resour
  * Find biggest 'System RAM' resource and store its start and end address in
  * @start and @end, respectively.  If no System RAM is found, returns false.
  */
-bool damon_find_biggest_system_ram(unsigned long *start, unsigned long *end)
+static bool damon_find_biggest_system_ram(unsigned long *start,
+						unsigned long *end)
 
 {
 	struct damon_system_ram_region arg = {};
@@ -1259,6 +1260,38 @@ bool damon_find_biggest_system_ram(unsig
 	return true;
 }
 
+/**
+ * damon_set_region_biggest_system_ram_default() - Set the region of the given
+ * monitoring target as requested, or biggest 'System RAM'.
+ * @t:		The monitoring target to set the region.
+ * @start:	The pointer to the start address of the region.
+ * @end:	The pointer to the end address of the region.
+ *
+ * This function sets the region of @t as requested by @start and @end.  If the
+ * values of @start and @end are zero, however, this function finds the biggest
+ * 'System RAM' resource and sets the region to cover the resource.  In the
+ * latter case, this function saves the start and end addresses of the resource
+ * in @start and @end, respectively.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+int damon_set_region_biggest_system_ram_default(struct damon_target *t,
+			unsigned long *start, unsigned long *end)
+{
+	struct damon_addr_range addr_range;
+
+	if (*start > *end)
+		return -EINVAL;
+
+	if (!*start && !*end &&
+		!damon_find_biggest_system_ram(start, end))
+		return -EINVAL;
+
+	addr_range.start = *start;
+	addr_range.end = *end;
+	return damon_set_regions(t, &addr_range, 1);
+}
+
 static int __init damon_init(void)
 {
 	damon_region_cache = KMEM_CACHE(damon_region, 0);
--- a/mm/damon/lru_sort.c~mm-damon-deduplicate-damon_reclaimlru_sort_apply_parameters
+++ a/mm/damon/lru_sort.c
@@ -188,7 +188,6 @@ static struct damos *damon_lru_sort_new_
 static int damon_lru_sort_apply_parameters(void)
 {
 	struct damos *scheme;
-	struct damon_addr_range addr_range;
 	unsigned int hot_thres, cold_thres;
 	int err = 0;
 
@@ -211,15 +210,9 @@ static int damon_lru_sort_apply_paramete
 		return -ENOMEM;
 	damon_add_scheme(ctx, scheme);
 
-	if (monitor_region_start > monitor_region_end)
-		return -EINVAL;
-	if (!monitor_region_start && !monitor_region_end &&
-	    !damon_find_biggest_system_ram(&monitor_region_start,
-					   &monitor_region_end))
-		return -EINVAL;
-	addr_range.start = monitor_region_start;
-	addr_range.end = monitor_region_end;
-	return damon_set_regions(target, &addr_range, 1);
+	return damon_set_region_biggest_system_ram_default(target,
+					&monitor_region_start,
+					&monitor_region_end);
 }
 
 static int damon_lru_sort_turn(bool on)
--- a/mm/damon/reclaim.c~mm-damon-deduplicate-damon_reclaimlru_sort_apply_parameters
+++ a/mm/damon/reclaim.c
@@ -144,7 +144,6 @@ static struct damos *damon_reclaim_new_s
 static int damon_reclaim_apply_parameters(void)
 {
 	struct damos *scheme;
-	struct damon_addr_range addr_range;
 	int err = 0;
 
 	err = damon_set_attrs(ctx, &damon_reclaim_mon_attrs);
@@ -157,15 +156,9 @@ static int damon_reclaim_apply_parameter
 		return -ENOMEM;
 	damon_set_schemes(ctx, &scheme, 1);
 
-	if (monitor_region_start > monitor_region_end)
-		return -EINVAL;
-	if (!monitor_region_start && !monitor_region_end &&
-	    !damon_find_biggest_system_ram(&monitor_region_start,
-					   &monitor_region_end))
-		return -EINVAL;
-	addr_range.start = monitor_region_start;
-	addr_range.end = monitor_region_end;
-	return damon_set_regions(target, &addr_range, 1);
+	return damon_set_region_biggest_system_ram_default(target,
+					&monitor_region_start,
+					&monitor_region_end);
 }
 
 static int damon_reclaim_turn(bool on)
_

Patches currently in -mm which might be from kaixuxia@tencent.com are

mm-damon-sysfs-simplify-the-judgement-whether-kdamonds-are-busy.patch
mm-damon-core-iterate-the-regions-list-from-current-point-in-damon_set_regions.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme.patch
mm-damon-sysfs-use-the-wrapper-directly-to-check-if-the-kdamond-is-running.patch
mm-damon-simplify-the-parameter-passing-for-prepare_access_checks.patch
mm-damon-sysfs-simplify-the-variable-pid-assignment-operation.patch
mm-damon-core-simplify-the-kdamond-stop-mechanism-by-removing-done.patch
mm-damon-use-struct-damon_target-instead-of-void-in-target_valid.patch
mm-damon-return-void-from-damon_set_schemes.patch
mm-damon-rename-damon_pageout_score-to-damon_cold_score.patch
mm-damon-deduplicate-damon_reclaimlru_sort_apply_parameters.patch

