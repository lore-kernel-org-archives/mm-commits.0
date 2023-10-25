Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B3EDC25B71
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbjJYXvF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234811AbjJYXte (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:49:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446251BE
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:49:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7866C433C8;
        Wed, 25 Oct 2023 23:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277757;
        bh=Q16Uhzk3ugDhxvj9bIMvmAnqn5Z0JbYff2X9HNb0cqA=;
        h=Date:To:From:Subject:From;
        b=eotz4q/7llGM04qAU0fUIwW4/ZmWxf5Wy89KD/6vCKH1r+n+WoeTxjzej1AIr1sXS
         SuZ/oPeSiAyZRME+5Yl1mehhyv2BBaMu5IfIi5kr2JC9Lqpbhc1Go9Au4wlqCq8fMo
         336fhRz5tCQec7USiBHu8pwczV3vraIZkqPm+8+w=
Date:   Wed, 25 Oct 2023 16:49:17 -0700
To:     mm-commits@vger.kernel.org, acsjakub@amazon.de, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-avoid-divide-by-zero-from-pseudo-moving-window-length-calculation.patch removed from -mm tree
Message-Id: <20231025234917.D7866C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: avoid divide-by-zero from pseudo-moving window length calculation
has been removed from the -mm tree.  Its filename was
     mm-damon-core-avoid-divide-by-zero-from-pseudo-moving-window-length-calculation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reported-by: Jakub Acs <acsjakub@amazon.de>
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

mm-damon-sysfs-remove-requested-targets-when-online-commit-inputs.patch

