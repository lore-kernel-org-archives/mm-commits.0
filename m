Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47A32C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjASBDD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjASBC4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:02:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347D8683D1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:02:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 065B0B81D7E
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB22C433EF;
        Thu, 19 Jan 2023 01:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090168;
        bh=NjBttO3O7yP8zznZW5SOsbgwJUsjscYlIynRvyNJL3E=;
        h=Date:To:From:Subject:From;
        b=DPEUzvUB6gRmbC9zSwdOTgwPqoFYaIvaf5JJrAWK/tYgXFWsBkWebn/N0ucmiGG42
         7fliNxEwLnMS2oF4RdO3zHBie1FxNyqSNGdAoQbSlUipMEBlJYA04pRInNCSF10fiF
         yJwvZJH2owjwXujgWqwXaFgjMorG5Ywb3KklVvCU=
Date:   Wed, 18 Jan 2023 17:02:47 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        pengfei.xu@intel.com, nadav.amit@gmail.com, linmiaohe@huawei.com,
        david@redhat.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-a-few-rare-cases-of-using-swapin-error-pte-marker.patch removed from -mm tree
Message-Id: <20230119010248.7FB22C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix a few rare cases of using swapin error pte marker
has been removed from the -mm tree.  Its filename was
     mm-fix-a-few-rare-cases-of-using-swapin-error-pte-marker.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: fix a few rare cases of using swapin error pte marker
Date: Wed, 14 Dec 2022 15:04:53 -0500

This patch should harden commit 15520a3f0469 ("mm: use pte markers for
swap errors") on using pte markers for swapin errors on a few corner
cases.

1. Propagate swapin errors across fork()s: if there're swapin errors in
   the parent mm, after fork()s the child should sigbus too when an error
   page is accessed.

2. Fix a rare condition race in pte_marker_clear() where a uffd-wp pte
   marker can be quickly switched to a swapin error.

3. Explicitly ignore swapin error pte markers in change_protection().

I mostly don't worry on (2) or (3) at all, but we should still have them. 
Case (1) is special because it can potentially cause silent data corrupt
on child when parent has swapin error triggered with swapoff, but since
swapin error is rare itself already it's probably not easy to trigger
either.

Currently there is a priority difference between the uffd-wp bit and the
swapin error entry, in which the swapin error always has higher priority
(e.g.  we don't need to wr-protect a swapin error pte marker).

If there will be a 3rd bit introduced, we'll probably need to consider a
more involved approach so we may need to start operate on the bits.  Let's
leave that for later.

This patch is tested with case (1) explicitly where we'll get corrupted
data before in the child if there's existing swapin error pte markers, and
after patch applied the child can be rightfully killed.

We don't need to copy stable for this one since 15520a3f0469 just landed
as part of v6.2-rc1, only "Fixes" applied.

Link: https://lkml.kernel.org/r/20221214200453.1772655-3-peterx@redhat.com
Fixes: 15520a3f0469 ("mm: use pte markers for swap errors")
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c  |    3 +++
 mm/memory.c   |    8 ++++++--
 mm/mprotect.c |    8 +++++++-
 3 files changed, 16 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-fix-a-few-rare-cases-of-using-swapin-error-pte-marker
+++ a/mm/hugetlb.c
@@ -5051,6 +5051,9 @@ again:
 				entry = huge_pte_clear_uffd_wp(entry);
 			set_huge_pte_at(dst, addr, dst_pte, entry);
 		} else if (unlikely(is_pte_marker(entry))) {
+			/* No swap on hugetlb */
+			WARN_ON_ONCE(
+			    is_swapin_error_entry(pte_to_swp_entry(entry)));
 			/*
 			 * We copy the pte marker only if the dst vma has
 			 * uffd-wp enabled.
--- a/mm/memory.c~mm-fix-a-few-rare-cases-of-using-swapin-error-pte-marker
+++ a/mm/memory.c
@@ -828,7 +828,7 @@ copy_nonpresent_pte(struct mm_struct *ds
 			return -EBUSY;
 		return -ENOENT;
 	} else if (is_pte_marker_entry(entry)) {
-		if (userfaultfd_wp(dst_vma))
+		if (is_swapin_error_entry(entry) || userfaultfd_wp(dst_vma))
 			set_pte_at(dst_mm, addr, dst_pte, pte);
 		return 0;
 	}
@@ -3625,8 +3625,12 @@ static vm_fault_t pte_marker_clear(struc
 	/*
 	 * Be careful so that we will only recover a special uffd-wp pte into a
 	 * none pte.  Otherwise it means the pte could have changed, so retry.
+	 *
+	 * This should also cover the case where e.g. the pte changed
+	 * quickly from a PTE_MARKER_UFFD_WP into PTE_MARKER_SWAPIN_ERROR.
+	 * So is_pte_marker() check is not enough to safely drop the pte.
 	 */
-	if (is_pte_marker(*vmf->pte))
+	if (pte_same(vmf->orig_pte, *vmf->pte))
 		pte_clear(vmf->vma->vm_mm, vmf->address, vmf->pte);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	return 0;
--- a/mm/mprotect.c~mm-fix-a-few-rare-cases-of-using-swapin-error-pte-marker
+++ a/mm/mprotect.c
@@ -245,7 +245,13 @@ static unsigned long change_pte_range(st
 					newpte = pte_swp_mksoft_dirty(newpte);
 				if (pte_swp_uffd_wp(oldpte))
 					newpte = pte_swp_mkuffd_wp(newpte);
-			} else if (pte_marker_entry_uffd_wp(entry)) {
+			} else if (is_pte_marker_entry(entry)) {
+				/*
+				 * Ignore swapin errors unconditionally,
+				 * because any access should sigbus anyway.
+				 */
+				if (is_swapin_error_entry(entry))
+					continue;
 				/*
 				 * If this is uffd-wp pte marker and we'd like
 				 * to unprotect it, drop it; the next page
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-vm-remove-__use_gnu-in-hugetlb-madvisec.patch
mm-uffd-always-wr-protect-pte-in-ptepmd_mkuffd_wp.patch
mm-mprotect-use-long-for-page-accountings-and-retval.patch
mm-uffd-detect-pgtable-allocation-failures.patch
mm-hugetlb-let-vma_offset_start-to-return-start.patch
mm-hugetlb-dont-wait-for-migration-entry-during-follow-page.patch
mm-hugetlb-document-huge_pte_offset-usage.patch
mm-hugetlb-move-swap-entry-handling-into-vma-lock-when-faulted.patch
mm-hugetlb-make-userfaultfd_huge_must_wait-safe-to-pmd-unshare.patch
mm-hugetlb-make-hugetlb_follow_page_mask-safe-to-pmd-unshare.patch
mm-hugetlb-make-follow_hugetlb_page-safe-to-pmd-unshare.patch
mm-hugetlb-make-walk_hugetlb_range-safe-to-pmd-unshare.patch
mm-hugetlb-introduce-hugetlb_walk.patch

