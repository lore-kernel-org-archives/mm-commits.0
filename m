Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A78BECAAD8
	for <mm-commits@archiver.kernel.org>; Fri, 16 Sep 2022 19:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiIPTkH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Sep 2022 15:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiIPTkH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2022 15:40:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859A83122F
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 12:40:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36E67B827CC
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 19:40:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8738C433D6;
        Fri, 16 Sep 2022 19:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663357202;
        bh=hzG/cAHmlmgis34MQS0tlKPrCk30i/76uvW5Ql1zrMg=;
        h=Date:To:From:Subject:From;
        b=nrgl/SDj89IW/anMtM9iepGaHk81YJsNb8k17cnje+XwYi0t3RmQzveOL5ypgs856
         wUJw5lze6idOGkb2NZLRLdbGxnmNPI54zCyedPmXp97BOo2RiOMZKrxjHyyXnHjccc
         dG11qP2J/V2eh9noLwjXb88pWmzYwLcZ/4Qcdz1g=
Date:   Fri, 16 Sep 2022 12:40:01 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-return-void-from-damon_set_schemes.patch added to mm-unstable branch
Message-Id: <20220916194002.C8738C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: return void from damon_set_schemes()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-return-void-from-damon_set_schemes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-return-void-from-damon_set_schemes.patch

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
Subject: mm/damon: return void from damon_set_schemes()
Date: Fri, 16 Sep 2022 23:20:35 +0800

There is no point in returning an int from damon_set_schemes().  It always
returns 0 which is meaningless for the caller, so change it to return void
directly.

Link: https://lkml.kernel.org/r/1663341635-12675-1-git-send-email-kaixuxia@tencent.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
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

mm-damon-sysfs-simplify-the-judgement-whether-kdamonds-are-busy.patch
mm-damon-core-iterate-the-regions-list-from-current-point-in-damon_set_regions.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme.patch
mm-damon-sysfs-use-the-wrapper-directly-to-check-if-the-kdamond-is-running.patch
mm-damon-simplify-the-parameter-passing-for-prepare_access_checks.patch
mm-damon-sysfs-simplify-the-variable-pid-assignment-operation.patch
mm-damon-core-simplify-the-kdamond-stop-mechanism-by-removing-done.patch
mm-damon-use-struct-damon_target-instead-of-void-in-target_valid.patch
mm-damon-return-void-from-damon_set_schemes.patch

