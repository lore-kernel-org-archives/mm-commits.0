Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EB7CC00A98
	for <mm-commits@archiver.kernel.org>; Fri, 20 Oct 2023 17:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjJTRS6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Oct 2023 13:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjJTRSz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Oct 2023 13:18:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788BD13E;
        Fri, 20 Oct 2023 10:18:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127E5C433C8;
        Fri, 20 Oct 2023 17:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697822333;
        bh=9OYVShPRSQVVFBfdVQCEJSwJVreEwqTHLOyJV55tUO4=;
        h=Date:To:From:Subject:From;
        b=E1RMwPTlMhdqWeSE6SzcXWG6WEtKnZpEqwmcGwXf/QJAxQNfskp0v/z51L9znMghI
         R9SdzW7LDWRtv7wpD6z4tuxroGrst0KH6/sou3a69gZ2oLcbNOaGR9FYnA1kbPD3bC
         HXhcV9Bnl3F1nycy0Uj+QwL2CC+Wbq1uUuHRn6Gs=
Date:   Fri, 20 Oct 2023 10:18:52 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-avoid-divide-by-zero-in-hot-threshold-calculation.patch added to mm-hotfixes-unstable branch
Message-Id: <20231020171853.127E5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/lru_sort: avoid divide-by-zero in hot threshold calculation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-lru_sort-avoid-divide-by-zero-in-hot-threshold-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-avoid-divide-by-zero-in-hot-threshold-calculation.patch

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
Subject: mm/damon/lru_sort: avoid divide-by-zero in hot threshold calculation
Date: Thu, 19 Oct 2023 19:49:23 +0000

When calculating the hotness threshold for lru_prio scheme of
DAMON_LRU_SORT, the module divides some values by the maximum nr_accesses.
However, due to the type of the related variables, simple division-based
calculation of the divisor can return zero.  As a result, divide-by-zero
is possible.  Fix it by using damon_max_nr_accesses(), which handles the
case.

Link: https://lkml.kernel.org/r/20231019194924.100347-5-sj@kernel.org
Fixes: 40e983cca927 ("mm/damon: introduce DAMON-based LRU-lists Sorting")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-avoid-divide-by-zero-in-hot-threshold-calculation
+++ a/mm/damon/lru_sort.c
@@ -193,9 +193,7 @@ static int damon_lru_sort_apply_paramete
 	if (err)
 		return err;
 
-	/* aggr_interval / sample_interval is the maximum nr_accesses */
-	hot_thres = damon_lru_sort_mon_attrs.aggr_interval /
-		damon_lru_sort_mon_attrs.sample_interval *
+	hot_thres = damon_max_nr_accesses(&damon_lru_sort_mon_attrs) *
 		hot_thres_access_freq / 1000;
 	scheme = damon_lru_sort_new_hot_scheme(hot_thres);
 	if (!scheme)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-implement-a-function-for-max-nr_accesses-safe-calculation.patch
mm-damon-core-avoid-divide-by-zero-during-monitoring-results-update.patch
mm-damon-ops-common-avoid-divide-by-zero-during-region-hotness-calculation.patch
mm-damon-lru_sort-avoid-divide-by-zero-in-hot-threshold-calculation.patch

