Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2CFBC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 16 Feb 2022 00:31:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245107AbiBPAbP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 19:31:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244268AbiBPAay (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 19:30:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD44DF70E1
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 16:30:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6061CB81C01
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 00:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BAAC340EB;
        Wed, 16 Feb 2022 00:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644971440;
        bh=wvP+IBhZd6rNcM9mivIWfmycXq81Nu0sbIEXnEIbbRs=;
        h=Date:To:From:Subject:From;
        b=kUKOg1upBQrfpSCDYsF1oS3DdBzxYGdKWNffJP0YRxS6ui9sBP0pxeH4Ik9qRrowB
         Vejuw9fz2ZnYuJJ01h+D+69+fTUNc5ULfmBHKXpCuISzKhJCdNVsp5UHXkVZFN+2CN
         LTQcsMm2oB00wnDzpR6fPNb6W7N+U3+fwlzVFS4E=
Date:   Tue, 15 Feb 2022 16:30:39 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, surenb@google.com, shakeelb@google.com,
        riel@surriel.com, mhocko@suse.com, kirill@shutemov.name,
        hannes@cmpxchg.org, gthelen@google.com, david@redhat.com,
        apopple@nvidia.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-shrink_page_list-avoid-splitting-vm_locked-thp.patch added to -mm tree
Message-Id: <20220216003040.01BAAC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: shrink_page_list() avoid splitting VM_LOCKED THP
has been added to the -mm tree.  Its filename is
     mm-thp-shrink_page_list-avoid-splitting-vm_locked-thp.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-shrink_page_list-avoid-splitting-vm_locked-thp.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-shrink_page_list-avoid-splitting-vm_locked-thp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/thp: shrink_page_list() avoid splitting VM_LOCKED THP

4.8 commit 7751b2da6be0 ("vmscan: split file huge pages before paging them
out") inserted a split_huge_page_to_list() into shrink_page_list() without
considering the mlock case: no problem if the page has already been marked
as Mlocked (the !page_evictable check much higher up will have skipped all
this), but it has always been the case that races or omissions in setting
Mlocked can rely on page reclaim to detect this and correct it before
actually reclaiming - and that remains so, but what a shame if a hugepage
is needlessly split before discovering it.

It is surprising that page_check_references() returns PAGEREF_RECLAIM when
VM_LOCKED, but there was a good reason for that: try_to_unmap_one() is
where the condition is detected and corrected; and until now it could not
be done in page_referenced_one(), because that does not always have the
page locked.  Now that mlock's requirement for page lock has gone, copy
try_to_unmap_one()'s mlock restoration into page_referenced_one(), and let
page_check_references() return PAGEREF_ACTIVATE in this case.

But page_referenced_one() may find a pte mapping one part of a hugepage:
what hold should a pte mapped in a VM_LOCKED area exert over the entire
huge page?  That's debatable.  The approach taken here is to treat that
pte mapping in page_referenced_one() as if not VM_LOCKED, and if no
VM_LOCKED pmd mapping is found later in the walk, and lack of reference
permits, then PAGEREF_RECLAIM take it to attempted splitting as before.

Link: https://lkml.kernel.org/r/531d13ee-bc7d-329a-9748-5e272f699d78@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c   |    7 +++++--
 mm/vmscan.c |    6 +++---
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/mm/rmap.c~mm-thp-shrink_page_list-avoid-splitting-vm_locked-thp
+++ a/mm/rmap.c
@@ -814,7 +814,10 @@ static bool page_referenced_one(struct p
 	while (page_vma_mapped_walk(&pvmw)) {
 		address = pvmw.address;
 
-		if (vma->vm_flags & VM_LOCKED) {
+		if ((vma->vm_flags & VM_LOCKED) &&
+		    (!PageTransCompound(page) || !pvmw.pte)) {
+			/* Restore the mlock which got missed */
+			mlock_vma_page(page, vma, !pvmw.pte);
 			page_vma_mapped_walk_done(&pvmw);
 			pra->vm_flags |= VM_LOCKED;
 			return false; /* To break the loop */
@@ -853,7 +856,7 @@ static bool page_referenced_one(struct p
 
 	if (referenced) {
 		pra->referenced++;
-		pra->vm_flags |= vma->vm_flags;
+		pra->vm_flags |= vma->vm_flags & ~VM_LOCKED;
 	}
 
 	if (!pra->mapcount)
--- a/mm/vmscan.c~mm-thp-shrink_page_list-avoid-splitting-vm_locked-thp
+++ a/mm/vmscan.c
@@ -1376,11 +1376,11 @@ static enum page_references page_check_r
 	referenced_page = TestClearPageReferenced(page);
 
 	/*
-	 * Mlock lost the isolation race with us.  Let try_to_unmap()
-	 * move the page to the unevictable list.
+	 * The supposedly reclaimable page was found to be in a VM_LOCKED vma.
+	 * Let the page, now marked Mlocked, be moved to the unevictable list.
 	 */
 	if (vm_flags & VM_LOCKED)
-		return PAGEREF_RECLAIM;
+		return PAGEREF_ACTIVATE;
 
 	if (referenced_ptes) {
 		/*
_

Patches currently in -mm which might be from hughd@google.com are

mm-munlock-delete-page_mlock-and-all-its-works.patch
mm-munlock-delete-foll_mlock-and-foll_populate.patch
mm-munlock-delete-munlock_vma_pages_all-allow-oomreap.patch
mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page.patch
mm-munlock-replace-clear_page_mlock-by-final-clearance.patch
mm-munlock-maintain-page-mlock_count-while-unevictable.patch
mm-munlock-mlock_pte_range-when-mlocking-or-munlocking.patch
mm-migrate-__unmap_and_move-push-good-newpage-to-lru.patch
mm-munlock-delete-smp_mb-from-__pagevec_lru_add_fn.patch
mm-munlock-mlock_page-munlock_page-batch-by-pagevec.patch
mm-munlock-page-migration-needs-mlock-pagevec-drained.patch
mm-thp-collapse_file-do-try_to_unmapttu_batch_flush.patch
mm-thp-shrink_page_list-avoid-splitting-vm_locked-thp.patch

