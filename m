Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE9DC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiJCVNP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiJCVLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1350651A3B
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97D34610D5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC49CC433D6;
        Mon,  3 Oct 2022 21:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831243;
        bh=gJs1NLXAGkRDzzCHays7RKrTvnJJ+MewkwA6pICiYiA=;
        h=Date:To:From:Subject:From;
        b=OrJz8WmHhv5AOitl9iJib2vtDhQG5VulyciSiEDvYqs0ad+ixXbV/zPXmy2pESt1j
         rK5ce3FeizxQ3pPLA5X1+K4QJWtG7Cdh+/EGMvZAYoljRWiSUSyQ49Ev0QP8J6fa7l
         DBKRdcJPLsBeJj0cVxEzuhjS2YxWjzFXvqLbI/tM=
Date:   Mon, 03 Oct 2022 14:07:22 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-use-monitoring-attributes-parameters-generaotr-macro.patch removed from -mm tree
Message-Id: <20221003210722.EC49CC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/lru_sort: use monitoring attributes parameters generaotr macro
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-use-monitoring-attributes-parameters-generaotr-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/lru_sort: use monitoring attributes parameters generaotr macro
Date: Tue, 13 Sep 2022 17:44:37 +0000

This commit makes DAMON_LRU_SORT to generate the module parameters for
DAMON monitoring attributes using the generator macro to simplify the code
and reduce duplicates.

Link: https://lkml.kernel.org/r/20220913174449.50645-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |   47 ++++--------------------------------------
 1 file changed, 5 insertions(+), 42 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-use-monitoring-attributes-parameters-generaotr-macro
+++ a/mm/damon/lru_sort.c
@@ -13,6 +13,8 @@
 #include <linux/sched.h>
 #include <linux/workqueue.h>
 
+#include "modules-common.h"
+
 #ifdef MODULE_PARAM_PREFIX
 #undef MODULE_PARAM_PREFIX
 #endif
@@ -128,52 +130,13 @@ static unsigned long wmarks_low __read_m
 module_param(wmarks_low, ulong, 0600);
 
 static struct damon_attrs damon_lru_sort_mon_attrs = {
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
- * The sampling interval of DAMON for the hot/cold memory monitoring.  Please
- * refer to the DAMON documentation for more detail.  5 ms by default.
- */
-module_param_named(sample_interval, damon_lru_sort_mon_attrs.sample_interval,
-		ulong, 0600);
-
-/*
- * Aggregation interval for the monitoring in microseconds.
- *
- * The aggregation interval of DAMON for the hot/cold memory monitoring.
- * Please refer to the DAMON documentation for more detail.  100 ms by default.
- */
-module_param_named(aggr_interval, damon_lru_sort_mon_attrs.aggr_interval, ulong,
-		0600);
-
-/*
- * Minimum number of monitoring regions.
- *
- * The minimal number of monitoring regions of DAMON for the hot/cold memory
- * monitoring.  This can be used to set lower-bound of the monitoring quality.
- * But, setting this too high could result in increased monitoring overhead.
- * Please refer to the DAMON documentation for more detail.  10 by default.
- */
-module_param_named(min_nr_regions, damon_lru_sort_mon_attrs.min_nr_regions,
-		ulong, 0600);
-
-/*
- * Maximum number of monitoring regions.
- *
- * The maximum number of monitoring regions of DAMON for the hot/cold memory
- * monitoring.  This can be used to set upper-bound of the monitoring overhead.
- * However, setting this too low could result in bad monitoring quality.
- * Please refer to the DAMON documentation for more detail.  1000 by default.
- */
-module_param_named(max_nr_regions, damon_lru_sort_mon_attrs.max_nr_regions,
-		ulong, 0600);
+DEFINE_DAMON_MODULES_MON_ATTRS_PARAMS(damon_lru_sort_mon_attrs);
 
 /*
  * Start of the target memory region in physical address.
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

