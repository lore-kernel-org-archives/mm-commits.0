Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A37A3C54EE9
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 21:54:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiIMVyE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 17:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiIMVxy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 17:53:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA666DFAC
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 14:53:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24989B810EE
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 21:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD226C433D6;
        Tue, 13 Sep 2022 21:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663106029;
        bh=eugLu5dnCSvAc748XvzsJUxQuVMlr1cAVrZq41j0yvk=;
        h=Date:To:From:Subject:From;
        b=CvIBh2hF7tEHva6a12NKG4weplYhYQZ+OAyr/+lvcerEaSyZd9cFjGEb8Sr2cZIfh
         +9/FX9mZMHLL+A6OMYKkM305nbZkqHe/8qYoab+dd9RZytHjECgOt1lGyEgBKAfCkE
         YOPuTlahfGj6p5r6UzoibC6pA5P/mdt9sa61foWg=
Date:   Tue, 13 Sep 2022 14:53:49 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-use-monitoring-attributes-parameters-generator-macro.patch added to mm-unstable branch
Message-Id: <20220913215349.BD226C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/reclaim: use monitoring attributes parameters generator macro
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-reclaim-use-monitoring-attributes-parameters-generator-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-use-monitoring-attributes-parameters-generator-macro.patch

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
Subject: mm/damon/reclaim: use monitoring attributes parameters generator macro
Date: Tue, 13 Sep 2022 17:44:38 +0000

This commit makes DAMON_RECLAIM to generate the module parameters for
DAMON monitoring attributes using the generator macro to simplify the code
and reduce duplicates.

Link: https://lkml.kernel.org/r/20220913174449.50645-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   47 ++++---------------------------------------
 1 file changed, 5 insertions(+), 42 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-use-monitoring-attributes-parameters-generator-macro
+++ a/mm/damon/reclaim.c
@@ -13,6 +13,8 @@
 #include <linux/sched.h>
 #include <linux/workqueue.h>
 
+#include "modules-common.h"
+
 #ifdef MODULE_PARAM_PREFIX
 #undef MODULE_PARAM_PREFIX
 #endif
@@ -130,52 +132,13 @@ static unsigned long wmarks_low __read_m
 module_param(wmarks_low, ulong, 0600);
 
 static struct damon_attrs damon_reclaim_mon_attrs = {
-	.sample_interval = 5000,
-	.aggr_interval = 100000,
+	.sample_interval = 5000,	/* 5 ms */
+	.aggr_interval = 100000,	/* 100 ms */
 	.ops_update_interval = 0,
 	.min_nr_regions = 10,
 	.max_nr_regions = 1000,
 };
-
-/*
- * Sampling interval for the monitoring in microseconds.
- *
- * The sampling interval of DAMON for the cold memory monitoring.  Please refer
- * to the DAMON documentation for more detail.  5 ms by default.
- */
-module_param_named(sample_interval, damon_reclaim_mon_attrs.sample_interval,
-		ulong, 0600);
-
-/*
- * Aggregation interval for the monitoring in microseconds.
- *
- * The aggregation interval of DAMON for the cold memory monitoring.  Please
- * refer to the DAMON documentation for more detail.  100 ms by default.
- */
-module_param_named(aggr_interval, damon_reclaim_mon_attrs.aggr_interval, ulong,
-		0600);
-
-/*
- * Minimum number of monitoring regions.
- *
- * The minimal number of monitoring regions of DAMON for the cold memory
- * monitoring.  This can be used to set lower-bound of the monitoring quality.
- * But, setting this too high could result in increased monitoring overhead.
- * Please refer to the DAMON documentation for more detail.  10 by default.
- */
-module_param_named(min_nr_regions, damon_reclaim_mon_attrs.min_nr_regions,
-		ulong, 0600);
-
-/*
- * Maximum number of monitoring regions.
- *
- * The maximum number of monitoring regions of DAMON for the cold memory
- * monitoring.  This can be used to set upper-bound of the monitoring overhead.
- * However, setting this too low could result in bad monitoring quality.
- * Please refer to the DAMON documentation for more detail.  1000 by default.
- */
-module_param_named(max_nr_regions, damon_reclaim_mon_attrs.max_nr_regions,
-		ulong, 0600);
+DEFINE_DAMON_MODULES_MON_ATTRS_PARAMS(damon_reclaim_mon_attrs);
 
 /*
  * Start of the target memory region in physical address.
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

