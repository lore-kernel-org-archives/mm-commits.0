Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BFF8C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbiJCVOK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiJCVLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B972E51A38
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5679E610D5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC7AC433C1;
        Mon,  3 Oct 2022 21:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831240;
        bh=tcEddTgzXzI7v3yHMjmBcE9cwUc0pMTs7t3MLQPkZXU=;
        h=Date:To:From:Subject:From;
        b=NtRU/c0s65vEuqSWU1whna23IUeG6+oj3Z9mA4+P1XpVgMd86NX2to4ONE+KPvq64
         7+1hjWmdJXXy1iMapC5zVZoRoRNsaahW9X9FTkPbjgN1+ElSbpGsN/fYAWOoPRoRqm
         eLMUAaFJUkYjJnQbFtfR84q8lUdQHUZY3+RHqqQI=
Date:   Mon, 03 Oct 2022 14:07:20 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-use-struct-damon_attrs-for-storing-parameters-for-it.patch removed from -mm tree
Message-Id: <20221003210720.AEC7AC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/lru_sort: use 'struct damon_attrs' for storing parameters for it
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-use-struct-damon_attrs-for-storing-parameters-for-it.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/lru_sort: use 'struct damon_attrs' for storing parameters for it
Date: Tue, 13 Sep 2022 17:44:35 +0000

DAMON_LRU_SORT receives monitoring attributes by parameters one by one to
separate variables, and then combines those into 'struct damon_attrs'. 
This commit makes the module directly stores the parameter values to a
static 'struct damon_attrs' variable and use it to simplify the code.

Link: https://lkml.kernel.org/r/20220913174449.50645-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |   40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-use-struct-damon_attrs-for-storing-parameters-for-it
+++ a/mm/damon/lru_sort.c
@@ -127,14 +127,22 @@ module_param(wmarks_mid, ulong, 0600);
 static unsigned long wmarks_low __read_mostly = 50;
 module_param(wmarks_low, ulong, 0600);
 
+static struct damon_attrs damon_lru_sort_mon_attrs = {
+	.sample_interval = 5000,
+	.aggr_interval = 100000,
+	.ops_update_interval = 0,
+	.min_nr_regions = 10,
+	.max_nr_regions = 1000,
+};
+
 /*
  * Sampling interval for the monitoring in microseconds.
  *
  * The sampling interval of DAMON for the hot/cold memory monitoring.  Please
  * refer to the DAMON documentation for more detail.  5 ms by default.
  */
-static unsigned long sample_interval __read_mostly = 5000;
-module_param(sample_interval, ulong, 0600);
+module_param_named(sample_interval, damon_lru_sort_mon_attrs.sample_interval,
+		ulong, 0600);
 
 /*
  * Aggregation interval for the monitoring in microseconds.
@@ -142,8 +150,8 @@ module_param(sample_interval, ulong, 060
  * The aggregation interval of DAMON for the hot/cold memory monitoring.
  * Please refer to the DAMON documentation for more detail.  100 ms by default.
  */
-static unsigned long aggr_interval __read_mostly = 100000;
-module_param(aggr_interval, ulong, 0600);
+module_param_named(aggr_interval, damon_lru_sort_mon_attrs.aggr_interval, ulong,
+		0600);
 
 /*
  * Minimum number of monitoring regions.
@@ -153,8 +161,8 @@ module_param(aggr_interval, ulong, 0600)
  * But, setting this too high could result in increased monitoring overhead.
  * Please refer to the DAMON documentation for more detail.  10 by default.
  */
-static unsigned long min_nr_regions __read_mostly = 10;
-module_param(min_nr_regions, ulong, 0600);
+module_param_named(min_nr_regions, damon_lru_sort_mon_attrs.min_nr_regions,
+		ulong, 0600);
 
 /*
  * Maximum number of monitoring regions.
@@ -164,8 +172,8 @@ module_param(min_nr_regions, ulong, 0600
  * However, setting this too low could result in bad monitoring quality.
  * Please refer to the DAMON documentation for more detail.  1000 by default.
  */
-static unsigned long max_nr_regions __read_mostly = 1000;
-module_param(max_nr_regions, ulong, 0600);
+module_param_named(max_nr_regions, damon_lru_sort_mon_attrs.max_nr_regions,
+		ulong, 0600);
 
 /*
  * Start of the target memory region in physical address.
@@ -350,25 +358,19 @@ static struct damos *damon_lru_sort_new_
 
 static int damon_lru_sort_apply_parameters(void)
 {
-	struct damon_attrs attrs = {
-		.sample_interval = sample_interval,
-		.aggr_interval = aggr_interval,
-		.ops_update_interval = 0,
-		.min_nr_regions = min_nr_regions,
-		.max_nr_regions = max_nr_regions,
-	};
 	struct damos *scheme;
 	struct damon_addr_range addr_range;
 	unsigned int hot_thres, cold_thres;
 	int err = 0;
 
-	err = damon_set_attrs(ctx, &attrs);
+	err = damon_set_attrs(ctx, &damon_lru_sort_mon_attrs);
 	if (err)
 		return err;
 
 	/* aggr_interval / sample_interval is the maximum nr_accesses */
-	hot_thres = aggr_interval / sample_interval * hot_thres_access_freq /
-		1000;
+	hot_thres = damon_lru_sort_mon_attrs.aggr_interval /
+		damon_lru_sort_mon_attrs.sample_interval *
+		hot_thres_access_freq / 1000;
 	scheme = damon_lru_sort_new_hot_scheme(hot_thres);
 	if (!scheme)
 		return -ENOMEM;
@@ -376,7 +378,7 @@ static int damon_lru_sort_apply_paramete
 	if (err)
 		return err;
 
-	cold_thres = cold_min_age / aggr_interval;
+	cold_thres = cold_min_age / damon_lru_sort_mon_attrs.aggr_interval;
 	scheme = damon_lru_sort_new_cold_scheme(cold_thres);
 	if (!scheme)
 		return -ENOMEM;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

