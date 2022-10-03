Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D10C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiJCVPb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiJCVN6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:13:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073EE4DF31
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B16B4B811BF
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA1FC433D7;
        Mon,  3 Oct 2022 21:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831364;
        bh=4bNYK+k9J9AtN6uQk5X/Qq7zNpRI8EnKPqxvhcxtkS4=;
        h=Date:To:From:Subject:From;
        b=FvXgqzu47UwGmX/I7GA60/pY9U568RaqjQWJLlb6k4emEU1CHOLnsvURcD9TGRK/d
         HZigfOxo0Bu3KpdiELGVWi8H4thDAk/FW9oFUWH2qjfpGCOm8Il8u8RcGYj5s5qPnn
         UYcvj6SXjza96af3QwZSVV6wwOGJHo6X6pDNqukQ=
Date:   Mon, 03 Oct 2022 14:09:23 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        sj@kernel.org, kaixuxia@tencent.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-return-void-from-damon_set_schemes.patch removed from -mm tree
Message-Id: <20221003210924.6BA1FC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: return void from damon_set_schemes()
has been removed from the -mm tree.  Its filename was
     mm-damon-return-void-from-damon_set_schemes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaixu Xia <kaixuxia@tencent.com>
Subject: mm/damon: return void from damon_set_schemes()
Date: Fri, 16 Sep 2022 23:20:35 +0800

There is no point in returning an int from damon_set_schemes().  It always
returns 0 which is meaningless for the caller, so change it to return void
directly.

Link: https://lkml.kernel.org/r/1663341635-12675-1-git-send-email-kaixuxia@tencent.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 +-
 mm/damon/core.c       |    5 +----
 mm/damon/dbgfs.c      |    8 +++-----
 mm/damon/lru_sort.c   |    4 +---
 mm/damon/reclaim.c    |    4 +---
 5 files changed, 7 insertions(+), 16 deletions(-)

--- a/include/linux/damon.h~mm-damon-return-void-from-damon_set_schemes
+++ a/include/linux/damon.h
@@ -541,7 +541,7 @@ unsigned int damon_nr_regions(struct dam
 struct damon_ctx *damon_new_ctx(void);
 void damon_destroy_ctx(struct damon_ctx *ctx);
 int damon_set_attrs(struct damon_ctx *ctx, struct damon_attrs *attrs);
-int damon_set_schemes(struct damon_ctx *ctx,
+void damon_set_schemes(struct damon_ctx *ctx,
 			struct damos **schemes, ssize_t nr_schemes);
 int damon_nr_running_ctxs(void);
 bool damon_is_registered_ops(enum damon_ops_id id);
--- a/mm/damon/core.c~mm-damon-return-void-from-damon_set_schemes
+++ a/mm/damon/core.c
@@ -454,10 +454,8 @@ int damon_set_attrs(struct damon_ctx *ct
  *
  * This function should not be called while the kdamond of the context is
  * running.
- *
- * Return: 0 if success, or negative error code otherwise.
  */
-int damon_set_schemes(struct damon_ctx *ctx, struct damos **schemes,
+void damon_set_schemes(struct damon_ctx *ctx, struct damos **schemes,
 			ssize_t nr_schemes)
 {
 	struct damos *s, *next;
@@ -467,7 +465,6 @@ int damon_set_schemes(struct damon_ctx *
 		damon_destroy_scheme(s);
 	for (i = 0; i < nr_schemes; i++)
 		damon_add_scheme(ctx, schemes[i]);
-	return 0;
 }
 
 /**
--- a/mm/damon/dbgfs.c~mm-damon-return-void-from-damon_set_schemes
+++ a/mm/damon/dbgfs.c
@@ -307,11 +307,9 @@ static ssize_t dbgfs_schemes_write(struc
 		goto unlock_out;
 	}
 
-	ret = damon_set_schemes(ctx, schemes, nr_schemes);
-	if (!ret) {
-		ret = count;
-		nr_schemes = 0;
-	}
+	damon_set_schemes(ctx, schemes, nr_schemes);
+	ret = count;
+	nr_schemes = 0;
 
 unlock_out:
 	mutex_unlock(&ctx->kdamond_lock);
--- a/mm/damon/lru_sort.c~mm-damon-return-void-from-damon_set_schemes
+++ a/mm/damon/lru_sort.c
@@ -203,9 +203,7 @@ static int damon_lru_sort_apply_paramete
 	scheme = damon_lru_sort_new_hot_scheme(hot_thres);
 	if (!scheme)
 		return -ENOMEM;
-	err = damon_set_schemes(ctx, &scheme, 1);
-	if (err)
-		return err;
+	damon_set_schemes(ctx, &scheme, 1);
 
 	cold_thres = cold_min_age / damon_lru_sort_mon_attrs.aggr_interval;
 	scheme = damon_lru_sort_new_cold_scheme(cold_thres);
--- a/mm/damon/reclaim.c~mm-damon-return-void-from-damon_set_schemes
+++ a/mm/damon/reclaim.c
@@ -155,9 +155,7 @@ static int damon_reclaim_apply_parameter
 	scheme = damon_reclaim_new_scheme();
 	if (!scheme)
 		return -ENOMEM;
-	err = damon_set_schemes(ctx, &scheme, 1);
-	if (err)
-		return err;
+	damon_set_schemes(ctx, &scheme, 1);
 
 	if (monitor_region_start > monitor_region_end)
 		return -EINVAL;
_

Patches currently in -mm which might be from kaixuxia@tencent.com are


