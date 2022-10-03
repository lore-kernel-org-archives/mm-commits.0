Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60BB3C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiJCVNO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiJCVLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CE951A33
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 432E9611F0
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93288C433C1;
        Mon,  3 Oct 2022 21:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831239;
        bh=/af12KyLa1lC2dfHoEPFAoOE9ef2jpd62qSfhK64kwQ=;
        h=Date:To:From:Subject:From;
        b=sbCn+TPT2hZg/1+8sZ3YUm/8F+ioGvlCefX1AfoE6o+21rsWsjZscLVfXn4Ep6YiA
         6hL0W1Ky1/IisBDxAQg/KXTvFYs4sRGVQGAWOyFDnKUUl8z3xrnybvwhxm92rAMe8A
         yPF/PobsY19YOSf8xrbOEfqOXif6lEozfqOrMb34=
Date:   Mon, 03 Oct 2022 14:07:18 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-use-struct-damon_attrs-for-storing-parameters-for-it.patch removed from -mm tree
Message-Id: <20221003210719.93288C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/reclaim: use 'struct damon_attrs' for storing parameters for it
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-use-struct-damon_attrs-for-storing-parameters-for-it.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: use 'struct damon_attrs' for storing parameters for it
Date: Tue, 13 Sep 2022 17:44:34 +0000

DAMON_RECLAIM receives monitoring attributes by parameters one by one to
separate variables, and then combine those into 'struct damon_attrs'. 
This commit makes the module directly stores the parameter values to a
static 'struct damon_attrs' variable and use it to simplify the code.

Link: https://lkml.kernel.org/r/20220913174449.50645-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-use-struct-damon_attrs-for-storing-parameters-for-it
+++ a/mm/damon/reclaim.c
@@ -129,14 +129,22 @@ module_param(wmarks_mid, ulong, 0600);
 static unsigned long wmarks_low __read_mostly = 200;
 module_param(wmarks_low, ulong, 0600);
 
+static struct damon_attrs damon_reclaim_mon_attrs = {
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
  * The sampling interval of DAMON for the cold memory monitoring.  Please refer
  * to the DAMON documentation for more detail.  5 ms by default.
  */
-static unsigned long sample_interval __read_mostly = 5000;
-module_param(sample_interval, ulong, 0600);
+module_param_named(sample_interval, damon_reclaim_mon_attrs.sample_interval,
+		ulong, 0600);
 
 /*
  * Aggregation interval for the monitoring in microseconds.
@@ -144,8 +152,8 @@ module_param(sample_interval, ulong, 060
  * The aggregation interval of DAMON for the cold memory monitoring.  Please
  * refer to the DAMON documentation for more detail.  100 ms by default.
  */
-static unsigned long aggr_interval __read_mostly = 100000;
-module_param(aggr_interval, ulong, 0600);
+module_param_named(aggr_interval, damon_reclaim_mon_attrs.aggr_interval, ulong,
+		0600);
 
 /*
  * Minimum number of monitoring regions.
@@ -155,8 +163,8 @@ module_param(aggr_interval, ulong, 0600)
  * But, setting this too high could result in increased monitoring overhead.
  * Please refer to the DAMON documentation for more detail.  10 by default.
  */
-static unsigned long min_nr_regions __read_mostly = 10;
-module_param(min_nr_regions, ulong, 0600);
+module_param_named(min_nr_regions, damon_reclaim_mon_attrs.min_nr_regions,
+		ulong, 0600);
 
 /*
  * Maximum number of monitoring regions.
@@ -166,8 +174,8 @@ module_param(min_nr_regions, ulong, 0600
  * However, setting this too low could result in bad monitoring quality.
  * Please refer to the DAMON documentation for more detail.  1000 by default.
  */
-static unsigned long max_nr_regions __read_mostly = 1000;
-module_param(max_nr_regions, ulong, 0600);
+module_param_named(max_nr_regions, damon_reclaim_mon_attrs.max_nr_regions,
+		ulong, 0600);
 
 /*
  * Start of the target memory region in physical address.
@@ -239,7 +247,8 @@ static struct damos *damon_reclaim_new_s
 		.min_nr_accesses = 0,
 		.max_nr_accesses = 0,
 		/* for min_age or more micro-seconds */
-		.min_age_region = min_age / aggr_interval,
+		.min_age_region = min_age /
+			damon_reclaim_mon_attrs.aggr_interval,
 		.max_age_region = UINT_MAX,
 	};
 	struct damos_watermarks wmarks = {
@@ -275,18 +284,11 @@ static struct damos *damon_reclaim_new_s
 
 static int damon_reclaim_apply_parameters(void)
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
 	int err = 0;
 
-	err = damon_set_attrs(ctx, &attrs);
+	err = damon_set_attrs(ctx, &damon_reclaim_mon_attrs);
 	if (err)
 		return err;
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

