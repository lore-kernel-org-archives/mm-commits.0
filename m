Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F19C001DF
	for <mm-commits@archiver.kernel.org>; Fri, 20 Oct 2023 17:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjJTRUN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Oct 2023 13:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjJTRUM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Oct 2023 13:20:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C91411B
        for <mm-commits@vger.kernel.org>; Fri, 20 Oct 2023 10:20:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBC6C433C8;
        Fri, 20 Oct 2023 17:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697822409;
        bh=0Jl5TG7tOzbMBGPygq3s9lxzCb8SDE2g8mqcax8QtI0=;
        h=Date:To:From:Subject:From;
        b=cp0Z5XdYClMeXVRdV5As6UlveIbyIOFOMFhMWWIcDwpgAknTz9u5iNrC8GyHaDqC4
         n8yQlcSxFtzXYQhbUsp66H4AMC8pfQ5bZ4vt8hvHvrvP716Bu2S1sKMOP2c6cEOeDu
         vk3lj6mfkYIIMmpQbb+REgI5uL/2O9XRqMCU6Fx0=
Date:   Fri, 20 Oct 2023 10:20:09 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-avoid-divide-by-zero-from-pseudo-moving-window-length-calculation.patch added to mm-unstable branch
Message-Id: <20231020172009.9CBC6C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: avoid divide-by-zero from pseudo-moving window length calculation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-avoid-divide-by-zero-from-pseudo-moving-window-length-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-avoid-divide-by-zero-from-pseudo-moving-window-length-calculation.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: avoid divide-by-zero from pseudo-moving window length calculation
Date: Thu, 19 Oct 2023 19:49:24 +0000

When calculating the pseudo-moving access rate, DAMON divides some values
by the maximum nr_accesses.  However, due to the type of the related
variables, simple division-based calculation of the divisor can return
zero.  As a result, divide-by-zero is possible.  Fix it by using
damon_max_nr_accesses(), which handles the case.

Note that this is a fix for a commit that not in the mainline but mm
tree.

Link: https://lkml.kernel.org/r/20231019194924.100347-6-sj@kernel.org
Fixes: ace30fb21af5 ("mm/damon/core: use pseudo-moving sum for nr_accesses_bp")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-avoid-divide-by-zero-from-pseudo-moving-window-length-calculation
+++ a/mm/damon/core.c
@@ -1665,7 +1665,7 @@ void damon_update_region_access_rate(str
 	 * aggr_interval, owing to validation of damon_set_attrs().
 	 */
 	if (attrs->sample_interval)
-		len_window = attrs->aggr_interval / attrs->sample_interval;
+		len_window = damon_max_nr_accesses(attrs);
 	r->nr_accesses_bp = damon_moving_sum(r->nr_accesses_bp,
 			r->last_nr_accesses * 10000, len_window,
 			accessed ? 10000 : 0);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-implement-a-function-for-max-nr_accesses-safe-calculation.patch
mm-damon-core-avoid-divide-by-zero-during-monitoring-results-update.patch
mm-damon-ops-common-avoid-divide-by-zero-during-region-hotness-calculation.patch
mm-damon-lru_sort-avoid-divide-by-zero-in-hot-threshold-calculation.patch
mm-damon-core-avoid-divide-by-zero-from-pseudo-moving-window-length-calculation.patch

