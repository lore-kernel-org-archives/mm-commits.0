Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB89DC25B42
	for <mm-commits@archiver.kernel.org>; Fri, 20 Oct 2023 17:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377706AbjJTRS7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Oct 2023 13:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjJTRSx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Oct 2023 13:18:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63C211B;
        Fri, 20 Oct 2023 10:18:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4959FC433C8;
        Fri, 20 Oct 2023 17:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697822331;
        bh=Bh90cxE3cX1hRY4vCEHOMSDVYcOoYqEIzibsCyHxXTU=;
        h=Date:To:From:Subject:From;
        b=UGvlf9jwYqu5WMjRS+9b7UGG8w4vRXRA2j00mhmOHfNqeUmozRtDLGt3noTpZxfWw
         tChrcvwXtZe3hA2LOZ9DB5G6N4jcLUQajQE2vPiRvdG24rwI2/NGYkWlGN4MOWha5z
         Tn0QOdze1CAzQ31jPbQhDKnYOfUiP3LQ65YsZKHY=
Date:   Fri, 20 Oct 2023 10:18:50 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-ops-common-avoid-divide-by-zero-during-region-hotness-calculation.patch added to mm-hotfixes-unstable branch
Message-Id: <20231020171851.4959FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/ops-common: avoid divide-by-zero during region hotness calculation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-ops-common-avoid-divide-by-zero-during-region-hotness-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-ops-common-avoid-divide-by-zero-during-region-hotness-calculation.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/damon/ops-common: avoid divide-by-zero during region hotness calculation
Date: Thu, 19 Oct 2023 19:49:22 +0000

When calculating the hotness of each region for the under-quota regions
prioritization, DAMON divides some values by the maximum nr_accesses. 
However, due to the type of the related variables, simple division-based
calculation of the divisor can return zero.  As a result, divide-by-zero
is possible.  Fix it by using damon_max_nr_accesses(), which handles the
case.

Link: https://lkml.kernel.org/r/20231019194924.100347-4-sj@kernel.org
Fixes: 198f0f4c58b9 ("mm/damon/vaddr,paddr: support pageout prioritization")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.16+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-ops-common-avoid-divide-by-zero-during-region-hotness-calculation
+++ a/mm/damon/ops-common.c
@@ -73,7 +73,6 @@ void damon_pmdp_mkold(pmd_t *pmd, struct
 int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 			struct damos *s)
 {
-	unsigned int max_nr_accesses;
 	int freq_subscore;
 	unsigned int age_in_sec;
 	int age_in_log, age_subscore;
@@ -81,8 +80,8 @@ int damon_hot_score(struct damon_ctx *c,
 	unsigned int age_weight = s->quota.weight_age;
 	int hotness;
 
-	max_nr_accesses = c->attrs.aggr_interval / c->attrs.sample_interval;
-	freq_subscore = r->nr_accesses * DAMON_MAX_SUBSCORE / max_nr_accesses;
+	freq_subscore = r->nr_accesses * DAMON_MAX_SUBSCORE /
+		damon_max_nr_accesses(&c->attrs);
 
 	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
 	for (age_in_log = 0; age_in_log < DAMON_MAX_AGE_IN_LOG && age_in_sec;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-implement-a-function-for-max-nr_accesses-safe-calculation.patch
mm-damon-core-avoid-divide-by-zero-during-monitoring-results-update.patch
mm-damon-ops-common-avoid-divide-by-zero-during-region-hotness-calculation.patch
mm-damon-lru_sort-avoid-divide-by-zero-in-hot-threshold-calculation.patch

