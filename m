Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3DEEC678D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjASBU0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjASBS5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:18:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C3C6C56C
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E211861A53
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C94C433F2;
        Thu, 19 Jan 2023 01:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090965;
        bh=qSsa3vMzeDkFzLBgwwhy61Xvz1LVeosq5dCs1GWaV2k=;
        h=Date:To:From:Subject:From;
        b=lDfgMZ4Q4Unzcv12nza/QIOpdvJ1ffac/poO1spR2ypE3hna04uNwTOIGt1f/3cAQ
         q4Z3FPbFCekmXY7c/2FskiD1zHYAGW7hg+jfZKPWATiClDyZEgqn8vrlOWJTEvTQbO
         czsTKKNkVTo5/r06+i3iVo0zO1Sebk+6OM06FLJE=
Date:   Wed, 18 Jan 2023 17:16:04 -0800
To:     mm-commits@vger.kernel.org, nphamcs@gmail.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] workingset-fix-confusion-around-eviction-vs-refault-container.patch removed from -mm tree
Message-Id: <20230119011605.49C94C433F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: workingset: fix confusion around eviction vs refault container
has been removed from the -mm tree.  Its filename was
     workingset-fix-confusion-around-eviction-vs-refault-container.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


