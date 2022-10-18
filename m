Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4D5BC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 00:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiJRAqt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 20:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiJRAqq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 20:46:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD441E702
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 17:46:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B404B819D9
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 00:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2269C433D6;
        Tue, 18 Oct 2022 00:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666053991;
        bh=LVKhy/elsuaC206GZjFfmBNR5X6GmozhTgGObehSeeA=;
        h=Date:To:From:Subject:From;
        b=zVlDQS95TNUYg6kxjBl2fRigELwcQ665r0N06ncDD+p7eodV9s6WulaCvfCAtoyr6
         9R9mdPNcWtW+ouh2GJKp+j8eoXTE4koTog0u/t4oEMDB6CgbVgzXkYyat3lf70eoTt
         OMam6oag5NFENZQ/PdEWrWPu0a9OrNkwIhF0STcM=
Date:   Mon, 17 Oct 2022 17:46:31 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shuah@kernel.org, peterx@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, hughd@google.com, aarcange@redhat.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-remove-foll_migration.patch added to mm-unstable branch
Message-Id: <20221018004631.D2269C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: remove FOLL_MIGRATION
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-remove-foll_migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-remove-foll_migration.patch

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
Subject: mm/gup: remove FOLL_MIGRATION
Date: Fri, 30 Sep 2022 16:19:31 +0200

Fortunately, the last user (KSM) is gone, so let's just remove this rather
special code from generic GUP handling -- especially because KSM never
required the PMD handling as KSM only deals with individual base pages.

Link: https://lkml.kernel.org/r/20220930141931.174362-8-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 
 mm/gup.c           |   55 +++----------------------------------------
 2 files changed, 5 insertions(+), 51 deletions(-)

--- a/include/linux/mm.h~mm-gup-remove-foll_migration
+++ a/include/linux/mm.h
@@ -2920,7 +2920,6 @@ struct page *follow_page(struct vm_area_
 				 * and return without waiting upon it */
 #define FOLL_NOFAULT	0x80	/* do not fault in pages */
 #define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
-#define FOLL_MIGRATION	0x400	/* wait for page to replace migration entry */
 #define FOLL_TRIED	0x800	/* a retry, previous pass started an IO */
 #define FOLL_REMOTE	0x2000	/* we are working on non-current tsk/mm */
 #define FOLL_ANON	0x8000	/* don't do file mappings */
--- a/mm/gup.c~mm-gup-remove-foll_migration
+++ a/mm/gup.c
@@ -533,30 +533,13 @@ static struct page *follow_page_pte(stru
 	if (WARN_ON_ONCE((flags & (FOLL_PIN | FOLL_GET)) ==
 			 (FOLL_PIN | FOLL_GET)))
 		return ERR_PTR(-EINVAL);
-retry:
 	if (unlikely(pmd_bad(*pmd)))
 		return no_page_table(vma, flags);
 
 	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
 	pte = *ptep;
-	if (!pte_present(pte)) {
-		swp_entry_t entry;
-		/*
-		 * KSM's break_ksm() relies upon recognizing a ksm page
-		 * even while it is being migrated, so for that case we
-		 * need migration_entry_wait().
-		 */
-		if (likely(!(flags & FOLL_MIGRATION)))
-			goto no_page;
-		if (pte_none(pte))
-			goto no_page;
-		entry = pte_to_swp_entry(pte);
-		if (!is_migration_entry(entry))
-			goto no_page;
-		pte_unmap_unlock(ptep, ptl);
-		migration_entry_wait(mm, pmd, address);
-		goto retry;
-	}
+	if (!pte_present(pte))
+		goto no_page;
 	if (pte_protnone(pte) && !gup_can_follow_protnone(flags))
 		goto no_page;
 
@@ -660,46 +643,18 @@ static struct page *follow_pmd_mask(stru
 	pmdval = READ_ONCE(*pmd);
 	if (pmd_none(pmdval))
 		return no_page_table(vma, flags);
-retry:
-	if (!pmd_present(pmdval)) {
-		/*
-		 * Should never reach here, if thp migration is not supported;
-		 * Otherwise, it must be a thp migration entry.
-		 */
-		VM_BUG_ON(!thp_migration_supported() ||
-				  !is_pmd_migration_entry(pmdval));
-
-		if (likely(!(flags & FOLL_MIGRATION)))
-			return no_page_table(vma, flags);
-
-		pmd_migration_entry_wait(mm, pmd);
-		pmdval = READ_ONCE(*pmd);
-		/*
-		 * MADV_DONTNEED may convert the pmd to null because
-		 * mmap_lock is held in read mode
-		 */
-		if (pmd_none(pmdval))
-			return no_page_table(vma, flags);
-		goto retry;
-	}
+	if (!pmd_present(pmdval))
+		return no_page_table(vma, flags);
 	if (likely(!(pmd_trans_huge(pmdval) || pmd_devmap(pmdval))))
 		return follow_page_pte(vma, address, pmd, flags);
 
 	if (pmd_protnone(pmdval) && !gup_can_follow_protnone(flags))
 		return no_page_table(vma, flags);
 
-retry_locked:
 	ptl = pmd_lock(mm, pmd);
-	if (unlikely(pmd_none(*pmd))) {
-		spin_unlock(ptl);
-		return no_page_table(vma, flags);
-	}
 	if (unlikely(!pmd_present(*pmd))) {
 		spin_unlock(ptl);
-		if (likely(!(flags & FOLL_MIGRATION)))
-			return no_page_table(vma, flags);
-		pmd_migration_entry_wait(mm, pmd);
-		goto retry_locked;
+		return no_page_table(vma, flags);
 	}
 	if (unlikely(!(pmd_trans_huge(*pmd) || pmd_devmap(pmdval)))) {
 		spin_unlock(ptl);
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch

