Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F39D3C67871
	for <mm-commits@archiver.kernel.org>; Mon, 24 Oct 2022 22:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiJXWEo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 18:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbiJXWEI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 18:04:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1484D16B
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 13:18:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73611B81252
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 20:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D9AC433D6;
        Mon, 24 Oct 2022 20:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666642053;
        bh=Gl23//nghrf9cU05ZqamS1Xk7XmLHoP77oD3gNACQcI=;
        h=Date:To:From:Subject:From;
        b=KlsCKORdJfWagzhvObKMpyLmuNoHlNCkHGOZr27LhtPvHVpzfH1s0C3IKyv0wPj0j
         Hb3c1dRqXPjnExFPKyLhTfN+JASm6/pbN9dgRXe8nOS4yWuEZMTa90byWHtRqE6Erk
         2Yfins1iKbz0YCmxCuKgwyiF3gwDL2L9yoo1zuVU=
Date:   Mon, 24 Oct 2022 13:07:32 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in.patch added to mm-unstable branch
Message-Id: <20221024200733.18D9AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm/uffd: fix warning without PTE_MARKER_UFFD_WP compiled in"
has been added to the -mm mm-unstable branch.  Its filename is
     revert-mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in.patch

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
Subject: Revert "mm/uffd: fix warning without PTE_MARKER_UFFD_WP compiled in"
Date: Mon, 24 Oct 2022 15:33:36 -0400

With " mm/uffd: Fix vma check on userfault for wp" to fix the
registration, we'll be safe to remove the macro hacks now.

Link: https://lkml.kernel.org/r/20221024193336.1233616-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c  |    4 ----
 mm/memory.c   |    2 --
 mm/mprotect.c |    2 --
 3 files changed, 8 deletions(-)

--- a/mm/hugetlb.c~revert-mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in
+++ a/mm/hugetlb.c
@@ -5123,7 +5123,6 @@ static void __unmap_hugepage_range(struc
 		 * unmapped and its refcount is dropped, so just clear pte here.
 		 */
 		if (unlikely(!pte_present(pte))) {
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
 			/*
 			 * If the pte was wr-protected by uffd-wp in any of the
 			 * swap forms, meanwhile the caller does not want to
@@ -5135,7 +5134,6 @@ static void __unmap_hugepage_range(struc
 				set_huge_pte_at(mm, address, ptep,
 						make_pte_marker(PTE_MARKER_UFFD_WP));
 			else
-#endif
 				huge_pte_clear(mm, address, ptep, sz);
 			spin_unlock(ptl);
 			continue;
@@ -5164,13 +5162,11 @@ static void __unmap_hugepage_range(struc
 		tlb_remove_huge_tlb_entry(h, tlb, ptep, address);
 		if (huge_pte_dirty(pte))
 			set_page_dirty(page);
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
 		/* Leave a uffd-wp pte marker if needed */
 		if (huge_pte_uffd_wp(pte) &&
 		    !(zap_flags & ZAP_FLAG_DROP_MARKER))
 			set_huge_pte_at(mm, address, ptep,
 					make_pte_marker(PTE_MARKER_UFFD_WP));
-#endif
 		hugetlb_count_sub(pages_per_huge_page(h), mm);
 		page_remove_rmap(page, vma, true);
 
--- a/mm/memory.c~revert-mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in
+++ a/mm/memory.c
@@ -1393,12 +1393,10 @@ zap_install_uffd_wp_if_needed(struct vm_
 			      unsigned long addr, pte_t *pte,
 			      struct zap_details *details, pte_t pteval)
 {
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
 	if (zap_drop_file_uffd_wp(details))
 		return;
 
 	pte_install_uffd_wp_if_needed(vma, addr, pte, pteval);
-#endif
 }
 
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
--- a/mm/mprotect.c~revert-mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in
+++ a/mm/mprotect.c
@@ -267,7 +267,6 @@ static unsigned long change_pte_range(st
 		} else {
 			/* It must be an none page, or what else?.. */
 			WARN_ON_ONCE(!pte_none(oldpte));
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
 			if (unlikely(uffd_wp && !vma_is_anonymous(vma))) {
 				/*
 				 * For file-backed mem, we need to be able to
@@ -279,7 +278,6 @@ static unsigned long change_pte_range(st
 					   make_pte_marker(PTE_MARKER_UFFD_WP));
 				pages++;
 			}
-#endif
 		}
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	arch_leave_lazy_mmu_mode();
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-uffd-fix-vma-check-on-userfault-for-wp.patch
selftests-vm-use-memfd-for-uffd-hugetlb-tests.patch
selftests-vm-use-memfd-for-hugetlb-madvise-test.patch
selftests-vm-use-memfd-for-hugepage-mremap-test.patch
selftests-vm-drop-mnt-point-for-hugetlb-in-run_vmtestssh.patch
mm-hugetlb-unify-clearing-of-restorereserve-for-private-pages.patch
revert-mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in.patch

