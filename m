Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12460C6FA89
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 21:54:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiIMVyO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 17:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiIMVyD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 17:54:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792566E2CB
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 14:54:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14FAA6158C
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 21:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64ECBC433D6;
        Tue, 13 Sep 2022 21:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663106040;
        bh=uJTjV3xK1ivmBZlIoB8cGe4QLTcGl4RA4rCYTnbdSmw=;
        h=Date:To:From:Subject:From;
        b=dKwNq4EqS0vZ8I1MceGEK/TwoYeJ0UxCkEdlFVEiOoD14C1EJ5AZz6+k2tycUCkyN
         aUd5WDD3fuzI9MUBqx9LxNevn3+eR6zp6kFQCN24hXKqA+6uJZu8qIPvL0bayLGt6s
         q2zr2tpESl9mYWwZ4giGCUeqYoWrUlY5EE14KP34=
Date:   Tue, 13 Sep 2022 14:53:59 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-use-stat-parameters-generator.patch added to mm-unstable branch
Message-Id: <20220913215400.64ECBC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/reclaim: use stat parameters generator
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-reclaim-use-stat-parameters-generator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-use-stat-parameters-generator.patch

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
Subject: mm/damon/reclaim: use stat parameters generator
Date: Tue, 13 Sep 2022 17:44:43 +0000

This commit makes DAMON_RECLAIM to generate the module parameters for
DAMOS statistics using the generator macro to simplify the code and
reduce duplicates.

Link: https://lkml.kernel.org/r/20220913174449.50645-17-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   41 +++++------------------------------------
 1 file changed, 5 insertions(+), 36 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-use-stat-parameters-generator
+++ a/mm/damon/reclaim.c
@@ -136,35 +136,9 @@ module_param(monitor_region_end, ulong,
 static int kdamond_pid __read_mostly = -1;
 module_param(kdamond_pid, int, 0400);
 
-/*
- * Number of memory regions that tried to be reclaimed.
- */
-static unsigned long nr_reclaim_tried_regions __read_mostly;
-module_param(nr_reclaim_tried_regions, ulong, 0400);
-
-/*
- * Total bytes of memory regions that tried to be reclaimed.
- */
-static unsigned long bytes_reclaim_tried_regions __read_mostly;
-module_param(bytes_reclaim_tried_regions, ulong, 0400);
-
-/*
- * Number of memory regions that successfully be reclaimed.
- */
-static unsigned long nr_reclaimed_regions __read_mostly;
-module_param(nr_reclaimed_regions, ulong, 0400);
-
-/*
- * Total bytes of memory regions that successfully be reclaimed.
- */
-static unsigned long bytes_reclaimed_regions __read_mostly;
-module_param(bytes_reclaimed_regions, ulong, 0400);
-
-/*
- * Number of times that the time/space quota limits have exceeded
- */
-static unsigned long nr_quota_exceeds __read_mostly;
-module_param(nr_quota_exceeds, ulong, 0400);
+static struct damos_stat damon_reclaim_stat;
+DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(damon_reclaim_stat,
+		reclaim_tried_regions, reclaimed_regions, quota_exceeds);
 
 static struct damon_ctx *ctx;
 static struct damon_target *target;
@@ -318,13 +292,8 @@ static int damon_reclaim_after_aggregati
 	struct damos *s;
 
 	/* update the stats parameter */
-	damon_for_each_scheme(s, c) {
-		nr_reclaim_tried_regions = s->stat.nr_tried;
-		bytes_reclaim_tried_regions = s->stat.sz_tried;
-		nr_reclaimed_regions = s->stat.nr_applied;
-		bytes_reclaimed_regions = s->stat.sz_applied;
-		nr_quota_exceeds = s->stat.qt_exceeds;
-	}
+	damon_for_each_scheme(s, c)
+		damon_reclaim_stat = s->stat;
 
 	return damon_reclaim_handle_commit_inputs();
 }
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

