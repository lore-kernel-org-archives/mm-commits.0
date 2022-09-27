Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C06C6FA86
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiI0Czz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbiI0CzX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:55:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBE23A4BB
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 387C161552
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917BEC433C1;
        Tue, 27 Sep 2022 02:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664247014;
        bh=FRnfQKnXL0y7ynYpvWzwybrWMwSmsBIhzQYBPtHzslM=;
        h=Date:To:From:Subject:From;
        b=SSyfBbNASy8NxUoIrQvkx7kgmTf+6LSN+kSEixbQ//rDXVJk7GhxCsxGwWHNqccdG
         roHLjTpVeTQmZlg/n3z9H0AH8sz7bh93h8s8oMJPhgf2q4PxHtj9tNKAQraD6Aixgt
         vTcal+ObcRiT5nJIZW2No808NwkvfeN31OqM/dFM=
Date:   Mon, 26 Sep 2022 19:50:13 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, peterx@redhat.com,
        mgorman@suse.de, jhubbard@nvidia.com, jgg@nvidia.com,
        hughd@google.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-use-gup_can_follow_protnone-also-in-gup-fast.patch removed from -mm tree
Message-Id: <20220927025014.917BEC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: use gup_can_follow_protnone() also in GUP-fast
has been removed from the -mm tree.  Its filename was
     mm-gup-use-gup_can_follow_protnone-also-in-gup-fast.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/gup: use gup_can_follow_protnone() also in GUP-fast
Date: Thu, 25 Aug 2022 18:46:58 +0200

There seems to be no reason why FOLL_FORCE during GUP-fast would have to
fallback to the slow path when stumbling over a PROT_NONE mapped page.  We
only have to trigger hinting faults in case FOLL_FORCE is not set, and any
kind of fault handling naturally happens from the slow path -- where NUMA
hinting accounting/handling would be performed.

Note that the comment regarding THP migration is outdated: commit
2b4847e73004 ("mm: numa: serialise parallel get_user_page against THP
migration") described that this was required for THP due to lack of PMD
migration entries.  Nowadays, we do have proper PMD migration entries in
place -- see set_pmd_migration_entry(), which does a proper
pmdp_invalidate() when placing the migration entry.

So let's just reuse gup_can_follow_protnone() here to make it consistent
and drop the somewhat outdated comments.

Link: https://lkml.kernel.org/r/20220825164659.89824-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- a/mm/gup.c~mm-gup-use-gup_can_follow_protnone-also-in-gup-fast
+++ a/mm/gup.c
@@ -2432,11 +2432,7 @@ static int gup_pte_range(pmd_t pmd, pmd_
 		struct page *page;
 		struct folio *folio;
 
-		/*
-		 * Similar to the PMD case below, NUMA hinting must take slow
-		 * path using the pte_protnone check.
-		 */
-		if (pte_protnone(pte))
+		if (pte_protnone(pte) && !gup_can_follow_protnone(flags))
 			goto pte_unmap;
 
 		if (!pte_access_permitted(pte, flags & FOLL_WRITE))
@@ -2820,12 +2816,8 @@ static int gup_pmd_range(pud_t *pudp, pu
 
 		if (unlikely(pmd_trans_huge(pmd) || pmd_huge(pmd) ||
 			     pmd_devmap(pmd))) {
-			/*
-			 * NUMA hinting faults need to be handled in the GUP
-			 * slowpath for accounting purposes and so that they
-			 * can be serialised against THP migration.
-			 */
-			if (pmd_protnone(pmd))
+			if (pmd_protnone(pmd) &&
+			    !gup_can_follow_protnone(flags))
 				return 0;
 
 			if (!gup_huge_pmd(pmd, pmdp, addr, next, flags,
_

Patches currently in -mm which might be from david@redhat.com are


