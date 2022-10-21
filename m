Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E419DC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 00:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiJUAmJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Oct 2022 20:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiJUAl4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2022 20:41:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659121DE3CA
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 17:41:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AED32B82A05
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 00:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB0FC433C1;
        Fri, 21 Oct 2022 00:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666312909;
        bh=4g3DckWRB+f6qkpz3qmTLlEgv58fSzH2sxLYhNXTDFk=;
        h=Date:To:From:Subject:From;
        b=HYq+WsCGqc6gFrQF5Y69V6O876D+9aV5DKG0vXH5dNDwGkZaT6n684gO1ZqaBaESY
         oxFjjzP+m1tvZw/P2UNoNEI97yWnP4uPjwEM85nYxO1tf0w90iet2LxfaLjyUp1yff
         yjfBcjQiA6U4vGBOSsIZiw7dgqnVHd5rQRSI0olQ=
Date:   Thu, 20 Oct 2022 17:41:48 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-unify-clearing-of-restorereserve-for-private-pages.patch added to mm-unstable branch
Message-Id: <20221021004149.4DB0FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: unify clearing of RestoreReserve for private pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-unify-clearing-of-restorereserve-for-private-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-unify-clearing-of-restorereserve-for-private-pages.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: unify clearing of RestoreReserve for private pages
Date: Thu, 20 Oct 2022 15:38:32 -0400

A trivial cleanup to move clearing of RestoreReserve into adding anon rmap
of private hugetlb mappings.  It matches with the shared mappings where we
only clear the bit when adding into page cache, rather than spreading it
around the code paths.

Link: https://lkml.kernel.org/r/20221020193832.776173-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   14 ++++----------
 mm/rmap.c    |    2 +-
 2 files changed, 5 insertions(+), 11 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-unify-clearing-of-restorereserve-for-private-pages
+++ a/mm/hugetlb.c
@@ -4784,7 +4784,6 @@ hugetlb_install_page(struct vm_area_stru
 	hugepage_add_new_anon_rmap(new_page, vma, addr);
 	set_huge_pte_at(vma->vm_mm, addr, ptep, make_huge_pte(vma, new_page, 1));
 	hugetlb_count_add(pages_per_huge_page(hstate_vma(vma)), vma->vm_mm);
-	ClearHPageRestoreReserve(new_page);
 	SetHPageMigratable(new_page);
 }
 
@@ -5447,8 +5446,6 @@ retry_avoidcopy:
 	spin_lock(ptl);
 	ptep = huge_pte_offset(mm, haddr, huge_page_size(h));
 	if (likely(ptep && pte_same(huge_ptep_get(ptep), pte))) {
-		ClearHPageRestoreReserve(new_page);
-
 		/* Break COW or unshare */
 		huge_ptep_clear_flush(vma, haddr, ptep);
 		mmu_notifier_invalidate_range(mm, range.start, range.end);
@@ -5743,10 +5740,9 @@ static vm_fault_t hugetlb_no_page(struct
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
@@ -6133,12 +6129,10 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
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

selftests-vm-use-memfd-for-uffd-hugetlb-tests.patch
selftests-vm-use-memfd-for-hugetlb-madvise-test.patch
selftests-vm-use-memfd-for-hugepage-mremap-test.patch
selftests-vm-drop-mnt-point-for-hugetlb-in-run_vmtestssh.patch
mm-hugetlb-unify-clearing-of-restorereserve-for-private-pages.patch

