Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7368DC4167B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Nov 2022 21:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235900AbiK2VXZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237083AbiK2VXW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2022 16:23:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36DC1DF28
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 13:23:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E962B8191D
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 21:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FDAC433D6;
        Tue, 29 Nov 2022 21:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669756990;
        bh=0mEpvMp8Z/cQD/op0y1NrukRdIkd5mdQ5V8chlWVDsY=;
        h=Date:To:From:Subject:From;
        b=BQg2N249yTS+VoeCpYBnwmDbPSCCjyMcWGcLwu9CK5DJBWxFB0EG21EouPGetFCov
         DZ/XGu2nAmrTcJxr4ZNLKidmMLInI/DDQ98krS8tJ0UkGw4UW3WMM35HNEH2koxEdW
         skmGUJlmqzXGmr6BbQGJ3CDcDNvSfZuThejECtSQ=
Date:   Tue, 29 Nov 2022 13:23:09 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        riel@surriel.com, nadav.amit@gmail.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jthoughton@google.com, jannh@google.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-make-page_vma_mapped_walk-safe-to-pmd-unshare.patch added to mm-unstable branch
Message-Id: <20221129212310.42FDAC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: make page_vma_mapped_walk() safe to pmd unshare
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-make-page_vma_mapped_walk-safe-to-pmd-unshare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-make-page_vma_mapped_walk-safe-to-pmd-unshare.patch

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
Subject: mm/hugetlb: make page_vma_mapped_walk() safe to pmd unshare
Date: Tue, 29 Nov 2022 14:35:25 -0500

Since page_vma_mapped_walk() walks the pgtable, it needs the vma lock
to make sure the pgtable page will not be freed concurrently.

Link: https://lkml.kernel.org/r/20221129193526.3588187-10-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    4 ++++
 mm/page_vma_mapped.c |    5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/rmap.h~mm-hugetlb-make-page_vma_mapped_walk-safe-to-pmd-unshare
+++ a/include/linux/rmap.h
@@ -13,6 +13,7 @@
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
 #include <linux/memremap.h>
+#include <linux/hugetlb.h>
 
 /*
  * The anon_vma heads a list of private "related" vmas, to scan if
@@ -408,6 +409,9 @@ static inline void page_vma_mapped_walk_
 		pte_unmap(pvmw->pte);
 	if (pvmw->ptl)
 		spin_unlock(pvmw->ptl);
+	/* This needs to be after unlock of the spinlock */
+	if (is_vm_hugetlb_page(pvmw->vma))
+		hugetlb_vma_unlock_read(pvmw->vma);
 }
 
 bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw);
--- a/mm/page_vma_mapped.c~mm-hugetlb-make-page_vma_mapped_walk-safe-to-pmd-unshare
+++ a/mm/page_vma_mapped.c
@@ -169,10 +169,13 @@ bool page_vma_mapped_walk(struct page_vm
 		if (pvmw->pte)
 			return not_found(pvmw);
 
+		hugetlb_vma_lock_read(vma);
 		/* when pud is not present, pte will be NULL */
 		pvmw->pte = huge_pte_offset(mm, pvmw->address, size);
-		if (!pvmw->pte)
+		if (!pvmw->pte) {
+			hugetlb_vma_unlock_read(vma);
 			return false;
+		}
 
 		pvmw->ptl = huge_pte_lock(hstate, mm, pvmw->pte);
 		if (!check_pte(pvmw))
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-migrate-fix-read-only-page-got-writable-when-recover-pte.patch
mm-always-compile-in-pte-markers.patch
mm-use-pte-markers-for-swap-errors.patch
mm-uffd-sanity-check-write-bit-for-uffd-wp-protected-ptes.patch
selftests-vm-use-memfd-for-hugepage-mmap-test.patch
mm-thp-re-apply-mkdirty-for-small-pages-after-split.patch
mm-hugetlb-let-vma_offset_start-to-return-start.patch
mm-hugetlb-dont-wait-for-migration-entry-during-follow-page.patch
mm-hugetlb-document-huge_pte_offset-usage.patch
mm-hugetlb-move-swap-entry-handling-into-vma-lock-when-faulted.patch
mm-hugetlb-make-userfaultfd_huge_must_wait-safe-to-pmd-unshare.patch
mm-hugetlb-make-hugetlb_follow_page_mask-safe-to-pmd-unshare.patch
mm-hugetlb-make-follow_hugetlb_page-safe-to-pmd-unshare.patch
mm-hugetlb-make-walk_hugetlb_range-safe-to-pmd-unshare.patch
mm-hugetlb-make-page_vma_mapped_walk-safe-to-pmd-unshare.patch
mm-hugetlb-introduce-hugetlb_walk.patch

