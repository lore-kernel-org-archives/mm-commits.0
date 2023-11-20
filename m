Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA3CC2BB3F
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 20:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjKTUMi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 15:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjKTUMh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 15:12:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15E7CB
        for <mm-commits@vger.kernel.org>; Mon, 20 Nov 2023 12:12:34 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BFABC433C8;
        Mon, 20 Nov 2023 20:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700511154;
        bh=mNDBY7lFW7Es7imgcDLtLHzZw1nM2eaIgPy7ehUcg5o=;
        h=Date:To:From:Subject:From;
        b=NIx3vjXoZvEeh/7UYCdWYW3uWWZPI83/kyCl09bknTmcuYRwr0m/bynCCZAuMY/uB
         BHlu6NMJVhJwQuGmbukEy9dcGsYjEVvk8pY5M6NW0LDqcyasiUwHIWNolireeQZSx2
         Y2tDE1sRS4hNvwmltGC07aYsRzk7tTwUbgnwMyok=
Date:   Mon, 20 Nov 2023 12:12:33 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-copy-nr_accesses-when-splitting-region.patch added to mm-hotfixes-unstable branch
Message-Id: <20231120201234.4BFABC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: copy nr_accesses when splitting region
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-copy-nr_accesses-when-splitting-region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-copy-nr_accesses-when-splitting-region.patch

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
Subject: mm/damon/core: copy nr_accesses when splitting region
Date: Sun, 19 Nov 2023 17:15:28 +0000

Regions split function ('damon_split_region_at()') is called at the
beginning of an aggregation interval, and when DAMOS applying the actions
and charging quota.  Because 'nr_accesses' fields of all regions are reset
at the beginning of each aggregation interval, and DAMOS was applying the
action at the end of each aggregation interval, there was no need to copy
the 'nr_accesses' field to the split-out region.

However, commit 42f994b71404 ("mm/damon/core: implement scheme-specific
apply interval") made DAMOS applies action on its own timing interval. 
Hence, 'nr_accesses' should also copied to split-out regions, but the
commit didn't.  Fix it by copying it.

Link: https://lkml.kernel.org/r/20231119171529.66863-1-sj@kernel.org
Fixes: 42f994b71404 ("mm/damon/core: implement scheme-specific apply interval")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c~mm-damon-core-copy-nr_accesses-when-splitting-region
+++ a/mm/damon/core.c
@@ -1225,6 +1225,7 @@ static void damon_split_region_at(struct
 	new->age = r->age;
 	new->last_nr_accesses = r->last_nr_accesses;
 	new->nr_accesses_bp = r->nr_accesses_bp;
+	new->nr_accesses = r->nr_accesses;
 
 	damon_insert_region(new, r, damon_next_region(r), t);
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-copy-nr_accesses-when-splitting-region.patch

