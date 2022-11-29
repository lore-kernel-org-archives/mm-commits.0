Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2741CC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 29 Nov 2022 21:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237057AbiK2VXE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiK2VW6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2022 16:22:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F80511C3A
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 13:22:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0203617A0
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 21:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34291C433C1;
        Tue, 29 Nov 2022 21:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669756975;
        bh=CTJoS5rHbSp0IYGYOB9xYCSfCSOtBCAPs2+e5PPPB5Y=;
        h=Date:To:From:Subject:From;
        b=Ih5c4Utcb2SpzyZzAtPkAQAVRoLBR45XrI8E1QJZS/O6k7nHdnKmORPtwmO3S0/9L
         6HBYK7gTEXrMBwiFqrPU2V4OwWI83bfI2N9HgjVrTOaY4/zunXCHf+5S6WckIRFQHS
         5jfHNdvucE61pR1CGhpwclpw6q7tv7mkKhtm78MY=
Date:   Tue, 29 Nov 2022 13:22:54 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        riel@surriel.com, nadav.amit@gmail.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jthoughton@google.com, jannh@google.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-dont-wait-for-migration-entry-during-follow-page.patch added to mm-unstable branch
Message-Id: <20221129212255.34291C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: don't wait for migration entry during follow page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-dont-wait-for-migration-entry-during-follow-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-dont-wait-for-migration-entry-during-follow-page.patch

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
Subject: mm/hugetlb: don't wait for migration entry during follow page
Date: Tue, 29 Nov 2022 14:35:18 -0500

That's what the code does with !hugetlb pages, so we should logically do
the same for hugetlb, so migration entry will also be treated as no page.

This is probably also the last piece in follow_page code that may sleep,
the last one should be removed in cf994dd8af27 ("mm/gup: remove
FOLL_MIGRATION", 2022-11-16).

Link: https://lkml.kernel.org/r/20221129193526.3588187-3-peterx@redhat.com
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

 mm/hugetlb.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-dont-wait-for-migration-entry-during-follow-page
+++ a/mm/hugetlb.c
@@ -6234,7 +6234,6 @@ struct page *hugetlb_follow_page_mask(st
 	if (WARN_ON_ONCE(flags & FOLL_PIN))
 		return NULL;
 
-retry:
 	pte = huge_pte_offset(mm, haddr, huge_page_size(h));
 	if (!pte)
 		return NULL;
@@ -6257,16 +6256,6 @@ retry:
 			page = NULL;
 			goto out;
 		}
-	} else {
-		if (is_hugetlb_entry_migration(entry)) {
-			spin_unlock(ptl);
-			__migration_entry_wait_huge(pte, ptl);
-			goto retry;
-		}
-		/*
-		 * hwpoisoned entry is treated as no_page_table in
-		 * follow_page_mask().
-		 */
 	}
 out:
 	spin_unlock(ptl);
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

