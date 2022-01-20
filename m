Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F257BC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377899AbiATV2x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377898AbiATV2w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:28:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A658BC061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:28:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4301E6188A
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95505C340E0;
        Thu, 20 Jan 2022 21:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714131;
        bh=oSmb4UhcME39UPdmKX5GZGpqLH8PZwJ2u97L9qquZDY=;
        h=Date:From:To:Subject:From;
        b=WeHclS3PvE8PjioAp/pHJ5OpvLO+bJaDJTzFe529NFWFfHN0OwiBukx6aYg8sJi4e
         0EB708rY5K2BMS3qWct2aD452MJaRGdpXEnCK+ieMavEFOEF23wFeBav5gjESVJWv8
         0JWsfIONQ/I33vxuixDpoKYA0/WVCqQhleVqdW/8=
Date:   Thu, 20 Jan 2022 13:28:51 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org
Subject:  [merged]
 mm-damon-reclaim-provide-reclamation-statistics.patch removed from -mm tree
Message-ID: <20220120212851.LJKbi6WSK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/reclaim: provide reclamation statistics
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-provide-reclamation-statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: provide reclamation statistics

This commit implements new DAMON_RECLAIM parameters for statistics
reporting.  Those can be used for understanding how DAMON_RECLAIM is
working, and for tuning the other parameters.

Link: https://lkml.kernel.org/r/20211210150016.35349-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   46 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-provide-reclamation-statistics
+++ a/mm/damon/reclaim.c
@@ -185,6 +185,36 @@ module_param(monitor_region_end, ulong,
 static int kdamond_pid __read_mostly = -1;
 module_param(kdamond_pid, int, 0400);
 
+/*
+ * Number of memory regions that tried to be reclaimed.
+ */
+static unsigned long nr_reclaim_tried_regions __read_mostly;
+module_param(nr_reclaim_tried_regions, ulong, 0400);
+
+/*
+ * Total bytes of memory regions that tried to be reclaimed.
+ */
+static unsigned long bytes_reclaim_tried_regions __read_mostly;
+module_param(bytes_reclaim_tried_regions, ulong, 0400);
+
+/*
+ * Number of memory regions that successfully be reclaimed.
+ */
+static unsigned long nr_reclaimed_regions __read_mostly;
+module_param(nr_reclaimed_regions, ulong, 0400);
+
+/*
+ * Total bytes of memory regions that successfully be reclaimed.
+ */
+static unsigned long bytes_reclaimed_regions __read_mostly;
+module_param(bytes_reclaimed_regions, ulong, 0400);
+
+/*
+ * Number of times that the time/space quota limits have exceeded
+ */
+static unsigned long nr_quota_exceeds __read_mostly;
+module_param(nr_quota_exceeds, ulong, 0400);
+
 static struct damon_ctx *ctx;
 static struct damon_target *target;
 
@@ -333,6 +363,21 @@ static void damon_reclaim_timer_fn(struc
 }
 static DECLARE_DELAYED_WORK(damon_reclaim_timer, damon_reclaim_timer_fn);
 
+static int damon_reclaim_after_aggregation(struct damon_ctx *c)
+{
+	struct damos *s;
+
+	/* update the stats parameter */
+	damon_for_each_scheme(s, c) {
+		nr_reclaim_tried_regions = s->stat.nr_tried;
+		bytes_reclaim_tried_regions = s->stat.sz_tried;
+		nr_reclaimed_regions = s->stat.nr_applied;
+		bytes_reclaimed_regions = s->stat.sz_applied;
+		nr_quota_exceeds = s->stat.qt_exceeds;
+	}
+	return 0;
+}
+
 static int __init damon_reclaim_init(void)
 {
 	ctx = damon_new_ctx();
@@ -340,6 +385,7 @@ static int __init damon_reclaim_init(voi
 		return -ENOMEM;
 
 	damon_pa_set_primitives(ctx);
+	ctx->callback.after_aggregation = damon_reclaim_after_aggregation;
 
 	/* 4242 means nothing but fun */
 	target = damon_new_target(4242);
_

Patches currently in -mm which might be from sj@kernel.org are


