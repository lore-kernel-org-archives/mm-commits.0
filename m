Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71354C001DF
	for <mm-commits@archiver.kernel.org>; Fri, 20 Oct 2023 17:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377891AbjJTRS6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Oct 2023 13:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjJTRSv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Oct 2023 13:18:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A30A3;
        Fri, 20 Oct 2023 10:18:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AC2C433C8;
        Fri, 20 Oct 2023 17:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697822329;
        bh=7qJXBEALo09kOtNdlPNLYg88qi7oMmUv55iQ1IROUmc=;
        h=Date:To:From:Subject:From;
        b=S5jnZr726AKxwQyXnIpp7xS6GTj3VydwUMkoYBfjvZDhWdqfTnQgu+vAfrLecBKsV
         VXlZygx3HmdKIuViektxLr87fMLNIlfxUVLc6ypz40EHZYcbdtKT1gDuKWIuzkp3U2
         G3bE8XT+Pet4QzPUGbuvGrwRe5DAyM669ReOevI0=
Date:   Fri, 20 Oct 2023 10:18:48 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-avoid-divide-by-zero-during-monitoring-results-update.patch added to mm-hotfixes-unstable branch
Message-Id: <20231020171849.83AC2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: avoid divide-by-zero during monitoring results update
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-avoid-divide-by-zero-during-monitoring-results-update.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-avoid-divide-by-zero-during-monitoring-results-update.patch

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
Subject: mm/damon/core: avoid divide-by-zero during monitoring results update
Date: Thu, 19 Oct 2023 19:49:21 +0000

When monitoring attributes are changed, DAMON updates access rate of the
monitoring results accordingly.  For that, it divides some values by the
maximum nr_accesses.  However, due to the type of the related variables,
simple division-based calculation of the divisor can return zero.  As a
result, divide-by-zero is possible.  Fix it by using
damon_max_nr_accesses(), which handles the case.

Link: https://lkml.kernel.org/r/20231019194924.100347-3-sj@kernel.org
Fixes: 2f5bef5a590b ("mm/damon/core: update monitoring results for new monitoring attributes")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-avoid-divide-by-zero-during-monitoring-results-update
+++ a/mm/damon/core.c
@@ -476,20 +476,14 @@ static unsigned int damon_age_for_new_at
 static unsigned int damon_accesses_bp_to_nr_accesses(
 		unsigned int accesses_bp, struct damon_attrs *attrs)
 {
-	unsigned int max_nr_accesses =
-		attrs->aggr_interval / attrs->sample_interval;
-
-	return accesses_bp * max_nr_accesses / 10000;
+	return accesses_bp * damon_max_nr_accesses(attrs) / 10000;
 }
 
 /* convert nr_accesses to access ratio in bp (per 10,000) */
 static unsigned int damon_nr_accesses_to_accesses_bp(
 		unsigned int nr_accesses, struct damon_attrs *attrs)
 {
-	unsigned int max_nr_accesses =
-		attrs->aggr_interval / attrs->sample_interval;
-
-	return nr_accesses * 10000 / max_nr_accesses;
+	return nr_accesses * 10000 / damon_max_nr_accesses(attrs);
 }
 
 static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-implement-a-function-for-max-nr_accesses-safe-calculation.patch
mm-damon-core-avoid-divide-by-zero-during-monitoring-results-update.patch
mm-damon-ops-common-avoid-divide-by-zero-during-region-hotness-calculation.patch
mm-damon-lru_sort-avoid-divide-by-zero-in-hot-threshold-calculation.patch

