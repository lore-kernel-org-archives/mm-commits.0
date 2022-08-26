Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A986FECAAA2
	for <mm-commits@archiver.kernel.org>; Fri, 26 Aug 2022 01:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244360AbiHZBZe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Aug 2022 21:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244358AbiHZBZ1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2022 21:25:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F8926ADB
        for <mm-commits@vger.kernel.org>; Thu, 25 Aug 2022 18:25:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C119B82F5C
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 01:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2E4C433D6;
        Fri, 26 Aug 2022 01:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661477119;
        bh=TVApH9rlT/U1tmI22FrPBVe821xxrZsbkK7JXrG9q6M=;
        h=Date:To:From:Subject:From;
        b=0CP6SyWY1hCLh/sOIzHa6Myn5GtfiVxP3BF2gk4/i+LkeTKyWqb6CnUymUYi8JXb0
         7knmHoH4xbJx3V1u8sWhq5lXuiYA5JAUS0Xj6qltLWatWZhewPxh4XcL2X/2dKD14Z
         H0tIiZrKM+3CWe8aIIQIRkY1shXy/v3S56iQmyqo=
Date:   Thu, 25 Aug 2022 18:25:18 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, peterx@redhat.com,
        mgorman@suse.de, jhubbard@nvidia.com, jgg@nvidia.com,
        hughd@google.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-use-gup_can_follow_protnone-also-in-gup-fast.patch added to mm-unstable branch
Message-Id: <20220826012518.DC2E4C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: use gup_can_follow_protnone() also in GUP-fast
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-use-gup_can_follow_protnone-also-in-gup-fast.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-use-gup_can_follow_protnone-also-in-gup-fast.patch

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
@@ -2367,11 +2367,7 @@ static int gup_pte_range(pmd_t pmd, unsi
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
@@ -2753,12 +2749,8 @@ static int gup_pmd_range(pud_t *pudp, pu
 
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

mm-gup-replace-foll_numa-by-gup_can_follow_protnone.patch
mm-gup-use-gup_can_follow_protnone-also-in-gup-fast.patch
mm-fixup-documentation-regarding-pte_numa-and-prot_numa.patch

