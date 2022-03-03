Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3585FC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  3 Mar 2022 22:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237088AbiCCWsP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Mar 2022 17:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbiCCWsO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Mar 2022 17:48:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B012DBCBB
        for <mm-commits@vger.kernel.org>; Thu,  3 Mar 2022 14:47:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40621611BE
        for <mm-commits@vger.kernel.org>; Thu,  3 Mar 2022 22:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99952C340EC;
        Thu,  3 Mar 2022 22:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646347645;
        bh=ojfnwj+F/K9qYaNjlMi2DG09U5azwReu14rnBYqx/d0=;
        h=Date:To:From:Subject:From;
        b=SX8JjJLd+1TdG0GALUIFngS4GgMc5gY8qnIzuylecuKF1y1/qO0JeMUKsJXn/qPsS
         iAeXmwrSzrTYUlGlWnRby7r8CKZ1KG6o7LM2ydGlHN20GlJMlwQGv96s5RkclPrXB0
         BG62tbln2agxbj+lkf3fe54flFj3l5LAoBvx0Tek=
Date:   Thu, 03 Mar 2022 14:47:24 -0800
To:     mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com,
        hughd@google.com, david@redhat.com, aarcange@redhat.com,
        shy828301@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-dont-have-to-lock-page-anymore-when-splitting-pmd.patch added to -mm tree
Message-Id: <20220303224725.99952C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: don't have to lock page anymore when splitting PMD
has been added to the -mm tree.  Its filename is
     mm-thp-dont-have-to-lock-page-anymore-when-splitting-pmd.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-dont-have-to-lock-page-anymore-when-splitting-pmd.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-dont-have-to-lock-page-anymore-when-splitting-pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: thp: don't have to lock page anymore when splitting PMD

commit c444eb564fb1 ("mm: thp: make the THP mapcount atomic against
__split_huge_pmd_locked()") locked the page for PMD split to make mapcount
stable for reuse_swap_page(), then commit 1c2f67308af4 ("mm: thp: fix
MADV_REMOVE deadlock on shmem THP") reduce the scope to anonymous page
only.

However COW has not used mapcount to determine if the page is shared or
not anymore due to the COW fixes [1] from David Hildenbrand and the
reuse_swap_page() was removed as well.  So PMD split doesn't have to lock
the page anymore.  This patch basically reverted the above two commits.

[1] https://lore.kernel.org/linux-mm/20220131162940.210846-1-david@redhat.com/

Link: https://lkml.kernel.org/r/20220303222014.517033-1-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   44 +++++---------------------------------------
 1 file changed, 5 insertions(+), 39 deletions(-)

--- a/mm/huge_memory.c~mm-thp-dont-have-to-lock-page-anymore-when-splitting-pmd
+++ a/mm/huge_memory.c
@@ -2126,8 +2126,6 @@ void __split_huge_pmd(struct vm_area_str
 {
 	spinlock_t *ptl;
 	struct mmu_notifier_range range;
-	bool do_unlock_folio = false;
-	pmd_t _pmd;
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
 				address & HPAGE_PMD_MASK,
@@ -2140,48 +2138,16 @@ void __split_huge_pmd(struct vm_area_str
 	 * pmd against. Otherwise we can end up replacing wrong folio.
 	 */
 	VM_BUG_ON(freeze && !folio);
-	if (folio) {
-		VM_WARN_ON_ONCE(!folio_test_locked(folio));
-		if (folio != page_folio(pmd_page(*pmd)))
-			goto out;
-	}
+	if (folio && folio != page_folio(pmd_page(*pmd)))
+		goto out;
 
-repeat:
-	if (pmd_trans_huge(*pmd)) {
-		if (!folio) {
-			folio = page_folio(pmd_page(*pmd));
-			/*
-			 * An anonymous page must be locked, to ensure that a
-			 * concurrent reuse_swap_page() sees stable mapcount;
-			 * but reuse_swap_page() is not used on shmem or file,
-			 * and page lock must not be taken when zap_pmd_range()
-			 * calls __split_huge_pmd() while i_mmap_lock is held.
-			 */
-			if (folio_test_anon(folio)) {
-				if (unlikely(!folio_trylock(folio))) {
-					folio_get(folio);
-					_pmd = *pmd;
-					spin_unlock(ptl);
-					folio_lock(folio);
-					spin_lock(ptl);
-					if (unlikely(!pmd_same(*pmd, _pmd))) {
-						folio_unlock(folio);
-						folio_put(folio);
-						folio = NULL;
-						goto repeat;
-					}
-					folio_put(folio);
-				}
-				do_unlock_folio = true;
-			}
-		}
-	} else if (!(pmd_devmap(*pmd) || is_pmd_migration_entry(*pmd)))
+	if (!(pmd_devmap(*pmd) || is_pmd_migration_entry(*pmd)))
 		goto out;
+
 	__split_huge_pmd_locked(vma, pmd, range.start, freeze);
 out:
 	spin_unlock(ptl);
-	if (do_unlock_folio)
-		folio_unlock(folio);
+
 	/*
 	 * No need to double call mmu_notifier->invalidate_range() callback.
 	 * They are 3 cases to consider inside __split_huge_pmd_locked():
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-thp-dont-have-to-lock-page-anymore-when-splitting-pmd.patch

