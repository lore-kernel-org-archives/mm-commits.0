Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69500C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiJCVOX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJCVLt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742501A390
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D8AEBCE0E5D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F78C433D7;
        Mon,  3 Oct 2022 21:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831256;
        bh=4BgbDYF0o8uJNq4MsCQD6mgnqxUnyPZKVvXY4u4ForA=;
        h=Date:To:From:Subject:From;
        b=X32k34wpeQKemIP6gWUwkw+xYFEPjsP28QmV+tQjOoT6mqQIrZ6Bl/p/sQ95xKCWj
         MUxho+4cuWfSdsY1XEIHgP4TKFGCnC/gHm2tkYezch/z0QjZbpVZ7crqkXEmRCXxBo
         iaJzu0TYXjukvnhTA4qBN+7UnUBh3af05ttZDMBA=
Date:   Mon, 03 Oct 2022 14:07:35 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-deduplicate-hot-cold-schemes-generators.patch removed from -mm tree
Message-Id: <20221003210736.32F78C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/lru_sort: deduplicate hot/cold schemes generators
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-deduplicate-hot-cold-schemes-generators.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

