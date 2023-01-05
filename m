Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF9BC46467
	for <mm-commits@archiver.kernel.org>; Thu,  5 Jan 2023 01:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjAEB5Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Jan 2023 20:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjAEB5Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2023 20:57:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024EC2F798
        for <mm-commits@vger.kernel.org>; Wed,  4 Jan 2023 17:57:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A891AB81716
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 01:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D92C433D2;
        Thu,  5 Jan 2023 01:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672883840;
        bh=MrNOyYCmWeCqFnp3hL0na3aX5yPAcbHVigAeIKJ5fEY=;
        h=Date:To:From:Subject:From;
        b=t3E2LkHgNEWfLmbu50iLSyqVzxqePpD9O+EFgPkXIsUQOQxFDplt95i0ii3bembI4
         ES2cOrWSA3//Cyz0sqTVOIbb3i/gHwnRt+IIJa5ia9R57gK0GC8fx+bzyXO75bH6Ve
         y2VYg21LEn5BQtvp1TNLMA9dqiKmo+RbjPc78QHQ=
Date:   Wed, 04 Jan 2023 17:57:19 -0800
To:     mm-commits@vger.kernel.org, nphamcs@gmail.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + workingset-fix-confusion-around-eviction-vs-refault-container.patch added to mm-unstable branch
Message-Id: <20230105015720.63D92C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: workingset: fix confusion around eviction vs refault container
has been added to the -mm mm-unstable branch.  Its filename is
     workingset-fix-confusion-around-eviction-vs-refault-container.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/workingset-fix-confusion-around-eviction-vs-refault-container.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: workingset: fix confusion around eviction vs refault container
Date: Wed, 4 Jan 2023 14:29:44 -0800

Refault decisions are made based on the lruvec where the page was evicted,
as that determined its LRU order while it was alive.  Stats and workingset
aging must then occur on the lruvec of the new page, as that's the node
and cgroup that experience the refault and that's the lruvec whose
nonresident info ages out by a new resident page.  Those lruvecs could be
different when a page is shared between cgroups, or the refaulting page is
allocated on a different node.

There are currently two mix-ups:

1. When swap is available, the resident anon set must be considered
   when comparing the refault distance. The comparison is made against
   the right anon set, but the check for swap is not. When pages get
   evicted from a cgroup with swap, and refault in one without, this
   can incorrectly consider a hot refault as cold - and vice
   versa. Fix that by using the eviction cgroup for the swap check.

2. The stats and workingset age are updated against the wrong lruvec
   altogether: the right cgroup but the wrong NUMA node. When a page
   refaults on a different NUMA node, this will have confusing stats
   and distort the workingset age on a different lruvec - again
   possibly resulting in hot/cold misclassifications down the line.

Fix the swap check and the refault pgdat to address both concerns.

This was found during code review.  It hasn't caused notable issues in
production, suggesting that those refault-migrations are relatively rare
in practice.

Link: https://lkml.kernel.org/r/20230104222944.2380117-1-nphamcs@gmail.com
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Co-developed-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/workingset.c~workingset-fix-confusion-around-eviction-vs-refault-container
+++ a/mm/workingset.c
@@ -457,6 +457,7 @@ void workingset_refault(struct folio *fo
 	 */
 	nr = folio_nr_pages(folio);
 	memcg = folio_memcg(folio);
+	pgdat = folio_pgdat(folio);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
@@ -474,7 +475,7 @@ void workingset_refault(struct folio *fo
 		workingset_size += lruvec_page_state(eviction_lruvec,
 						     NR_INACTIVE_FILE);
 	}
-	if (mem_cgroup_get_nr_swap_pages(memcg) > 0) {
+	if (mem_cgroup_get_nr_swap_pages(eviction_memcg) > 0) {
 		workingset_size += lruvec_page_state(eviction_lruvec,
 						     NR_ACTIVE_ANON);
 		if (file) {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-skip-moving-non-present-pages-that-are-mapped-elsewhere.patch
mm-rmap-remove-lock_page_memcg.patch
mm-memcontrol-deprecate-charge-moving.patch
workingset-fix-confusion-around-eviction-vs-refault-container.patch

