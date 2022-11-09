Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91003C43219
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiKIBkz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiKIBkC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBC467F4E
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A32361811
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8161AC433D6;
        Wed,  9 Nov 2022 01:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957953;
        bh=2C3dGs3560wArWOnq2PJzcK2+DbHL0557FNYPGYyOwE=;
        h=Date:To:From:Subject:From;
        b=2wY/OJcjCXok4C5WVNyud75NyY2zJLDsqj77HbW2IzQ6p3NFU4c4uyuDrc6A/waIA
         zRF7PnI3Qo4jiIPyppvMjr/Y9VKjU5pAFryIPJTYdUcu/JJ6HnkrVc5lPDa26KWIxL
         baWSugyqsJFPla2DOHaBUmolwBpl4yZGp35HEwP4=
Date:   Tue, 08 Nov 2022 17:39:13 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-unify-clearing-of-restorereserve-for-private-pages.patch removed from -mm tree
Message-Id: <20221109013913.8161AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: unify clearing of RestoreReserve for private pages
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-unify-clearing-of-restorereserve-for-private-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: unify clearing of RestoreReserve for private pages
Date: Thu, 20 Oct 2022 15:38:32 -0400

A trivial cleanup to move clearing of RestoreReserve into adding anon rmap
of private hugetlb mappings.  It matches with the shared mappings where we
only clear the bit when adding into page cache, rather than spreading it
around the code paths.

Link: https://lkml.kernel.org/r/20221020193832.776173-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   14 ++++----------
 mm/rmap.c    |    2 +-
 2 files changed, 5 insertions(+), 11 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-unify-clearing-of-restorereserve-for-private-pages
+++ a/mm/hugetlb.c
@@ -4775,7 +4775,6 @@ hugetlb_install_page(struct vm_area_stru
 	hugepage_add_new_anon_rmap(new_page, vma, addr);
 	set_huge_pte_at(vma->vm_mm, addr, ptep, make_huge_pte(vma, new_page, 1));
 	hugetlb_count_add(pages_per_huge_page(hstate_vma(vma)), vma->vm_mm);
-	ClearHPageRestoreReserve(new_page);
 	SetHPageMigratable(new_page);
 }
 
@@ -5438,8 +5437,6 @@ retry_avoidcopy:
 	spin_lock(ptl);
 	ptep = huge_pte_offset(mm, haddr, huge_page_size(h));
 	if (likely(ptep && pte_same(huge_ptep_get(ptep), pte))) {
-		ClearHPageRestoreReserve(new_page);
-
 		/* Break COW or unshare */
 		huge_ptep_clear_flush(vma, haddr, ptep);
 		mmu_notifier_invalidate_range(mm, range.start, range.end);
@@ -5734,10 +5731,9 @@ static vm_fault_t hugetlb_no_page(struct
 	if (!pte_same(huge_ptep_get(ptep), old_pte))
 		goto backout;
 
-	if (anon_rmap) {
-		ClearHPageRestoreReserve(page);
+	if (anon_rmap)
 		hugepage_add_new_anon_rmap(page, vma, haddr);
-	} else
+	else
 		page_dup_file_rmap(page, true);
 	new_pte = make_huge_pte(vma, page, ((vma->vm_flags & VM_WRITE)
 				&& (vma->vm_flags & VM_SHARED)));
@@ -6120,12 +6116,10 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	if (!huge_pte_none_mostly(huge_ptep_get(dst_pte)))
 		goto out_release_unlock;
 
-	if (page_in_pagecache) {
+	if (page_in_pagecache)
 		page_dup_file_rmap(page, true);
-	} else {
-		ClearHPageRestoreReserve(page);
+	else
 		hugepage_add_new_anon_rmap(page, dst_vma, dst_addr);
-	}
 
 	/*
 	 * For either: (1) CONTINUE on a non-shared VMA, or (2) UFFDIO_COPY
--- a/mm/rmap.c~mm-hugetlb-unify-clearing-of-restorereserve-for-private-pages
+++ a/mm/rmap.c
@@ -2571,7 +2571,7 @@ void hugepage_add_new_anon_rmap(struct p
 	BUG_ON(address < vma->vm_start || address >= vma->vm_end);
 	atomic_set(compound_mapcount_ptr(page), 0);
 	atomic_set(compound_pincount_ptr(page), 0);
-
+	ClearHPageRestoreReserve(page);
 	__page_set_anon_rmap(page, vma, address, 1);
 }
 #endif /* CONFIG_HUGETLB_PAGE */
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-always-compile-in-pte-markers.patch
mm-use-pte-markers-for-swap-errors.patch

