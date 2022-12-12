Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF16C001B2
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbiLLCOJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:14:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbiLLCNx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:13:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56EADED6
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:13:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BB6AB80B6A
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C440C433F0;
        Mon, 12 Dec 2022 02:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811222;
        bh=uwMVUDnvJ4nrSduisv21rRS2RtNlZpfcBk0kEKoDvWk=;
        h=Date:To:From:Subject:From;
        b=nRVJCHF1Hh+bHZqc17NliP6anpBq5TsC22gaQpUJmC0oRSNBDgmKaA6qt8Y/FE2/W
         L/YbeVrNRshgtRn3j7Yh9wjQT+o3FvL6qB0dzS6QpYzIrgjxbnzxcN/5vSZw26yTyA
         yWJeSj/tRSv8ecwQlJ2jqAdAVofFA8lsZtfJwyZY=
Date:   Sun, 11 Dec 2022 18:13:41 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shuah@kernel.org, peterx@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, hughd@google.com, aarcange@redhat.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-remove-foll_migration.patch removed from -mm tree
Message-Id: <20221212021342.2C440C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: remove FOLL_MIGRATION
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-foll_migration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/gup: remove FOLL_MIGRATION
Date: Fri, 21 Oct 2022 12:11:41 +0200

Fortunately, the last user (KSM) is gone, so let's just remove this rather
special code from generic GUP handling -- especially because KSM never
required the PMD handling as KSM only deals with individual base pages.

[akpm@linux-foundation.org: fix merge snafu]Link: https://lkml.kernel.org/r/20221021101141.84170-10-david@redhat.com
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

 include/linux/mm.h |    1 
 mm/gup.c           |   55 +++----------------------------------------
 2 files changed, 5 insertions(+), 51 deletions(-)

--- a/include/linux/mm.h~mm-gup-remove-foll_migration
+++ a/include/linux/mm.h
@@ -3057,7 +3057,6 @@ struct page *follow_page(struct vm_area_
 				 * and return without waiting upon it */
 #define FOLL_NOFAULT	0x80	/* do not fault in pages */
 #define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
-#define FOLL_MIGRATION	0x400	/* wait for page to replace migration entry */
 #define FOLL_TRIED	0x800	/* a retry, previous pass started an IO */
 #define FOLL_REMOTE	0x2000	/* we are working on non-current tsk/mm */
 #define FOLL_ANON	0x8000	/* don't do file mappings */
--- a/mm/gup.c~mm-gup-remove-foll_migration
+++ a/mm/gup.c
@@ -537,30 +537,13 @@ static struct page *follow_page_pte(stru
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
 
@@ -668,28 +651,8 @@ static struct page *follow_pmd_mask(stru
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
 	if (pmd_devmap(pmdval)) {
 		ptl = pmd_lock(mm, pmd);
 		page = follow_devmap_pmd(vma, address, pmd, flags, &ctx->pgmap);
@@ -703,18 +666,10 @@ retry:
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
 	if (unlikely(!pmd_trans_huge(*pmd))) {
 		spin_unlock(ptl);
_

Patches currently in -mm which might be from david@redhat.com are


