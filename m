Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ADFEC6FA89
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 21:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiIMVye (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 17:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiIMVyP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 17:54:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3348A6DFB5
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 14:54:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CADFEB810F4
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 21:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72797C433C1;
        Tue, 13 Sep 2022 21:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663106052;
        bh=AvBigfDq8m+aYwzQHmV9jiyBM/Fj014dx7kPVO7kCyk=;
        h=Date:To:From:Subject:From;
        b=12uUNWa1dfejL3SIaDBkFka4VSLeN/qY89G4o2g9YTHXyxnJVhZTlygYuOkBg4jHm
         OmU6VnZ+bPEc96qrX3fetARLVGG42EG1LAAR7taxhU8gT9PBLM60pSe/ir4+uK3Gfo
         r04BU1HhBB4WiGiPwpP8oFr4lftJCsA+vU31SWqY=
Date:   Tue, 13 Sep 2022 14:54:11 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-deduplicate-hot-cold-schemes-generators.patch added to mm-unstable branch
Message-Id: <20220913215412.72797C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/lru_sort: deduplicate hot/cold schemes generators
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-lru_sort-deduplicate-hot-cold-schemes-generators.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-deduplicate-hot-cold-schemes-generators.patch

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
Subject: mm/damon/lru_sort: deduplicate hot/cold schemes generators
Date: Tue, 13 Sep 2022 17:44:49 +0000

damon_lru_sort_new_{hot,cold}_scheme() have quite a lot of duplicates. 
This commit factors out the duplicate to a separate function and use it
for reducing the duplicate.

Link: https://lkml.kernel.org/r/20220913174449.50645-23-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |   45 +++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 24 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-deduplicate-hot-cold-schemes-generators
+++ a/mm/damon/lru_sort.c
@@ -135,6 +135,25 @@ DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(
 static struct damon_ctx *ctx;
 static struct damon_target *target;
 
+static struct damos *damon_lru_sort_new_scheme(
+		struct damos_access_pattern *pattern, enum damos_action action)
+{
+	struct damos_quota quota = damon_lru_sort_quota;
+
+	/* Use half of total quota for hot/cold pages sorting */
+	quota.ms = quota.ms / 2;
+
+	return damon_new_scheme(
+			/* find the pattern, and */
+			pattern,
+			/* (de)prioritize on LRU-lists */
+			action,
+			/* under the quota. */
+			&quota,
+			/* (De)activate this according to the watermarks. */
+			&damon_lru_sort_wmarks);
+}
+
 /* Create a DAMON-based operation scheme for hot memory regions */
 static struct damos *damon_lru_sort_new_hot_scheme(unsigned int hot_thres)
 {
@@ -149,19 +168,8 @@ static struct damos *damon_lru_sort_new_
 		.min_age_region = 0,
 		.max_age_region = UINT_MAX,
 	};
-	struct damos_quota quota = damon_lru_sort_quota;
-
-	/* Use half of total quota for hot pages sorting */
-	quota.ms = quota.ms / 2;
 
-	return damon_new_scheme(
-			&pattern,
-			/* prioritize those on LRU lists, as soon as found */
-			DAMOS_LRU_PRIO,
-			/* under the quota. */
-			&quota,
-			/* (De)activate this according to the watermarks. */
-			&damon_lru_sort_wmarks);
+	return damon_lru_sort_new_scheme(&pattern, DAMOS_LRU_PRIO);
 }
 
 /* Create a DAMON-based operation scheme for cold memory regions */
@@ -178,19 +186,8 @@ static struct damos *damon_lru_sort_new_
 		.min_age_region = cold_thres,
 		.max_age_region = UINT_MAX,
 	};
-	struct damos_quota quota = damon_lru_sort_quota;
 
-	/* Use half of total quota for cold pages sorting */
-	quota.ms = quota.ms / 2;
-
-	return damon_new_scheme(
-			&pattern,
-			/* mark those as not accessed, as soon as found */
-			DAMOS_LRU_DEPRIO,
-			/* under the quota. */
-			&quota,
-			/* (De)activate this according to the watermarks. */
-			&damon_lru_sort_wmarks);
+	return damon_lru_sort_new_scheme(&pattern, DAMOS_LRU_DEPRIO);
 }
 
 static int damon_lru_sort_apply_parameters(void)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix.patch
selftest-damon-add-a-test-for-duplicate-context-dirs-creation.patch
mm-damon-core-avoid-holes-in-newly-set-monitoring-target-ranges.patch
mm-damon-core-test-test-damon_set_regions.patch
docs-admin-guide-mm-damon-rename-the-title-of-the-document.patch
mm-damon-kconfig-notify-debugfs-deprecation-plan.patch
docs-admin-guide-mm-damon-start-mention-the-dependency-as-sysfs-instead-of-debugfs.patch
docs-admin-guide-mm-damon-usage-note-damon-debugfs-interface-deprecation-plan.patch
mm-damon-paddr-make-supported-damos-actions-of-paddr-clear.patch
mm-damon-paddr-deduplicate-damon_pa_mark_accesseddeactivate_pages.patch
mm-damon-core-copy-struct-to-struct-instead-of-field-to-field-in-damon_new_scheme.patch
mm-damon-core-factor-out-damos_quota-private-fileds-initialization.patch
mm-damon-core-use-a-dedicated-struct-for-monitoring-attributes.patch
mm-damon-core-reduce-parameters-for-damon_set_attrs.patch
mm-damon-reclaim-use-struct-damon_attrs-for-storing-parameters-for-it.patch
mm-damon-lru_sort-use-struct-damon_attrs-for-storing-parameters-for-it.patch
mm-damon-implement-a-monitoring-attributes-module-parameters-generator-macro.patch
mm-damon-lru_sort-use-monitoring-attributes-parameters-generaotr-macro.patch
mm-damon-reclaim-use-monitoring-attributes-parameters-generator-macro.patch
mm-damon-modules-common-implement-a-watermarks-module-parameters-generator-macro.patch
mm-damon-lru_sort-use-watermarks-parameters-generator-macro.patch
mm-damon-reclaim-use-watermarks-parameters-generator-macro.patch
mm-damon-modules-common-implement-a-stats-parameters-generator-macro.patch
mm-damon-reclaim-use-stat-parameters-generator.patch
mm-damon-lru_sort-use-stat-generator.patch
mm-damon-modules-common-implement-a-damos-quota-params-generator.patch
mm-damon-modules-common-implement-damos-time-quota-params-generator.patch
mm-damon-reclaim-use-the-quota-params-generator-macro.patch
mm-damon-lru_sort-use-quotas-param-generator.patch
mm-damon-lru_sort-deduplicate-hot-cold-schemes-generators.patch

