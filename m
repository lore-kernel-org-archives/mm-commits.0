Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAEABC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 20:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiJUUCk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 16:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbiJUUCE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 16:02:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA807263081
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 13:01:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98C4861F6F
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 20:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E23C433D6;
        Fri, 21 Oct 2022 20:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666382517;
        bh=JxZcoAZTHmEr4k31b/HFhohSDFzPovA89MbaLUFuB8g=;
        h=Date:To:From:Subject:From;
        b=aEFcwyy4F02d/rco347aZpxAi1EuacO956lHu0Rc4iux9jVOQzYzuCXmFBhuqaU5l
         HZw5YNzUK7T4S1O+n11S7f7byu7oKHjJXJWUqtH294TRlPXhibIHBjoTMkTGwfT1Cp
         dISlm0xhV9rDUqk8usxyrRRovP4wuaklLlZbyRyo=
Date:   Fri, 21 Oct 2022 13:01:56 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shuah@kernel.org, peterx@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, hughd@google.com, aarcange@redhat.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-remove-foll_migration.patch added to mm-unstable branch
Message-Id: <20221021200156.F0E23C433D6@smtp.kernel.org>
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
Date: Fri, 21 Oct 2022 12:11:41 +0200

Fortunately, the last user (KSM) is gone, so let's just remove this rather
special code from generic GUP handling -- especially because KSM never
required the PMD handling as KSM only deals with individual base pages.

Link: https://lkml.kernel.org/r/20221021101141.84170-10-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 mm/gup.c           |   31 +++----------------------------
 2 files changed, 3 insertions(+), 29 deletions(-)

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
 
@@ -688,18 +671,10 @@ retry:
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

selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory.patch
selftests-vm-factor-out-pagemap_is_populated-into-vm_util.patch
selftests-vm-anon_cow-thp-tests.patch
selftests-vm-anon_cow-hugetlb-tests.patch
selftests-vm-anon_cow-add-liburing-test-cases.patch
mm-gup_test-start-stop-read-functionality-for-pin-longterm-test.patch
mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix.patch
selftests-vm-anon_cow-add-r-o-longterm-tests-via-gup_test.patch
selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch

