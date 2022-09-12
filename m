Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A5D2C6FA89
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiILDeH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiILDch (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:32:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FF628734
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D79FA61169
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C3EC433C1;
        Mon, 12 Sep 2022 03:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953417;
        bh=N0atVup6mPrDTzcT9YLpGN2TJ60FiJo2+fGfctYzfLM=;
        h=Date:To:From:Subject:From;
        b=w/8Rrkj1q3wWP+R+bIi7m3Sxyczr0XRsPC0FD62/LhxJ8eEyv8X41IDfYVgYP1rx2
         F58AHLAiWKWN4NIinka0eQh7Tj2jpMzSe6DsaTEAvt4QAYf6pV2X1qNrwma3CeRiWf
         M2UDghM2dCT+r1V2VnHyitNOU/bqEvOer/Ar/ZTw=
Date:   Sun, 11 Sep 2022 20:30:15 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-get-the-hotness-from-damon_hot_score-in-damon_pageout_score.patch removed from -mm tree
Message-Id: <20220912033017.38C3EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: get the hotness from damon_hot_score() in damon_pageout_score()
has been removed from the -mm tree.  Its filename was
     mm-damon-get-the-hotness-from-damon_hot_score-in-damon_pageout_score.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaixu Xia <kaixuxia@tencent.com>
Subject: mm/damon: get the hotness from damon_hot_score() in damon_pageout_score()
Date: Mon, 29 Aug 2022 17:46:06 +0800

We can get the hotness value from damon_hot_score() directly in
damon_pageout_score() function and improve the code readability.

Link: https://lkml.kernel.org/r/1661766366-20998-1-git-send-email-kaixuxia@tencent.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |   46 +++++-----------------------------------
 1 file changed, 6 insertions(+), 40 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-get-the-hotness-from-damon_hot_score-in-damon_pageout_score
+++ a/mm/damon/ops-common.c
@@ -88,7 +88,7 @@ void damon_pmdp_mkold(pmd_t *pmd, struct
 #define DAMON_MAX_SUBSCORE	(100)
 #define DAMON_MAX_AGE_IN_LOG	(32)
 
-int damon_pageout_score(struct damon_ctx *c, struct damon_region *r,
+int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 			struct damos *s)
 {
 	unsigned int max_nr_accesses;
@@ -127,48 +127,14 @@ int damon_pageout_score(struct damon_ctx
 	 */
 	hotness = hotness * DAMOS_MAX_SCORE / DAMON_MAX_SUBSCORE;
 
-	/* Return coldness of the region */
-	return DAMOS_MAX_SCORE - hotness;
+	return hotness;
 }
 
-int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
+int damon_pageout_score(struct damon_ctx *c, struct damon_region *r,
 			struct damos *s)
 {
-	unsigned int max_nr_accesses;
-	int freq_subscore;
-	unsigned int age_in_sec;
-	int age_in_log, age_subscore;
-	unsigned int freq_weight = s->quota.weight_nr_accesses;
-	unsigned int age_weight = s->quota.weight_age;
-	int hotness;
-
-	max_nr_accesses = c->aggr_interval / c->sample_interval;
-	freq_subscore = r->nr_accesses * DAMON_MAX_SUBSCORE / max_nr_accesses;
+	int hotness = damon_hot_score(c, r, s);
 
-	age_in_sec = (unsigned long)r->age * c->aggr_interval / 1000000;
-	for (age_in_log = 0; age_in_log < DAMON_MAX_AGE_IN_LOG && age_in_sec;
-			age_in_log++, age_in_sec >>= 1)
-		;
-
-	/* If frequency is 0, higher age means it's colder */
-	if (freq_subscore == 0)
-		age_in_log *= -1;
-
-	/*
-	 * Now age_in_log is in [-DAMON_MAX_AGE_IN_LOG, DAMON_MAX_AGE_IN_LOG].
-	 * Scale it to be in [0, 100] and set it as age subscore.
-	 */
-	age_in_log += DAMON_MAX_AGE_IN_LOG;
-	age_subscore = age_in_log * DAMON_MAX_SUBSCORE /
-		DAMON_MAX_AGE_IN_LOG / 2;
-
-	hotness = (freq_weight * freq_subscore + age_weight * age_subscore);
-	if (freq_weight + age_weight)
-		hotness /= freq_weight + age_weight;
-	/*
-	 * Transform it to fit in [0, DAMOS_MAX_SCORE]
-	 */
-	hotness = hotness * DAMOS_MAX_SCORE / DAMON_MAX_SUBSCORE;
-
-	return hotness;
+	/* Return coldness of the region */
+	return DAMOS_MAX_SCORE - hotness;
 }
_

Patches currently in -mm which might be from kaixuxia@tencent.com are

mm-damon-sysfs-simplify-the-judgement-whether-kdamonds-are-busy.patch
mm-damon-core-iterate-the-regions-list-from-current-point-in-damon_set_regions.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme.patch

