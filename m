Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CBE0C0032E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234772AbjJYXvB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234787AbjJYXtd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:49:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA221B8;
        Wed, 25 Oct 2023 16:49:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078E6C433C7;
        Wed, 25 Oct 2023 23:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277755;
        bh=uwEqjDeZslb4pwttEzD1ryg4WIyAATkqqeIPxVQBPYA=;
        h=Date:To:From:Subject:From;
        b=ALbkHAJ6ZbNggnL8LQnYYOlfocag2p0dw9itiihM/vy33rqY5V9RArFMswaUbeKY1
         qP8psc2BgmC4g64wmaFSqOMiO6fCJLzyxpL2mQkFXpf+67LuP4/aflfNmeV2NVJTMH
         gHCaUz4ONaYt/Mp+ZzsgpPnrWTEKE4j0t+iFpjEM=
Date:   Wed, 25 Oct 2023 16:49:14 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        acsjakub@amazon.de, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-avoid-divide-by-zero-during-monitoring-results-update.patch removed from -mm tree
Message-Id: <20231025234915.078E6C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: avoid divide-by-zero during monitoring results update
has been removed from the -mm tree.  Its filename was
     mm-damon-core-avoid-divide-by-zero-during-monitoring-results-update.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reported-by: Jakub Acs <acsjakub@amazon.de>
Cc: <stable@vger.kernel.org>	[6.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-avoid-divide-by-zero-during-monitoring-results-update
+++ a/mm/damon/core.c
@@ -500,20 +500,14 @@ static unsigned int damon_age_for_new_at
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

mm-damon-sysfs-remove-requested-targets-when-online-commit-inputs.patch

