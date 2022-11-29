Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53783C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 29 Nov 2022 21:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237041AbiK2VXI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237051AbiK2VXH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2022 16:23:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC79120BC
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 13:23:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2A09B8191E
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 21:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D07C433D7;
        Tue, 29 Nov 2022 21:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669756983;
        bh=ss2MFv93+xuey2cqRjFBcPnOdXbTegoNBBs5VERaqWs=;
        h=Date:To:From:Subject:From;
        b=N5v3uvty2Zbos74dQJKG9dlppj0MoCcMd80eT+e7eXAQ26qwqwQOr/a/XAbndLQHs
         hd0He1o+BMr6pLmuY7fJlA+Hj0iCUya7RKni0yweDHklYzrXcrLRAUsRONZeS0sdZr
         0XmQ9QfRgzNJsO4cbxBr/An+CLjCwXKlzbKZ7NP4=
Date:   Tue, 29 Nov 2022 13:23:02 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        riel@surriel.com, nadav.amit@gmail.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jthoughton@google.com, jannh@google.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-make-hugetlb_follow_page_mask-safe-to-pmd-unshare.patch added to mm-unstable branch
Message-Id: <20221129212303.79D07C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: make hugetlb_follow_page_mask() safe to pmd unshare
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-make-hugetlb_follow_page_mask-safe-to-pmd-unshare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-make-hugetlb_follow_page_mask-safe-to-pmd-unshare.patch

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
Subject: mm/hugetlb: make hugetlb_follow_page_mask() safe to pmd unshare
Date: Tue, 29 Nov 2022 14:35:22 -0500

Since hugetlb_follow_page_mask() walks the pgtable, it needs the vma lock
to make sure the pgtable page will not be freed concurrently.

Link: https://lkml.kernel.org/r/20221129193526.3588187-7-peterx@redhat.com
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

 mm/hugetlb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-make-hugetlb_follow_page_mask-safe-to-pmd-unshare
+++ a/mm/hugetlb.c
@@ -6232,9 +6232,10 @@ struct page *hugetlb_follow_page_mask(st
 	if (WARN_ON_ONCE(flags & FOLL_PIN))
 		return NULL;
 
+	hugetlb_vma_lock_read(vma);
 	pte = huge_pte_offset(mm, haddr, huge_page_size(h));
 	if (!pte)
-		return NULL;
+		goto out_unlock;
 
 	ptl = huge_pte_lock(h, mm, pte);
 	entry = huge_ptep_get(pte);
@@ -6257,6 +6258,8 @@ struct page *hugetlb_follow_page_mask(st
 	}
 out:
 	spin_unlock(ptl);
+out_unlock:
+	hugetlb_vma_unlock_read(vma);
 	return page;
 }
 
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

