Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 770E3C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 17:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbiLPRRx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 12:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiLPRRw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 12:17:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12CE29CAE
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 09:17:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 641C5621B2
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 17:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B682BC433EF;
        Fri, 16 Dec 2022 17:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671211070;
        bh=4f2X10vWwUQ0pPUkMQ+OI0tzrsrxXQ46PtMLT/pQ7F4=;
        h=Date:To:From:Subject:From;
        b=zu1DG0b8iVcHsmdc6ORjZRILDZYutej+oCnto4wSXTBu/ltj/tLr+Nv6Pn5aEJ6qM
         8AuVT9LhkttqjQ18uC7jAmT+AY+ykqoLimTgIsOt/4UmhgsrSo9+K2K+MBTO0b2b99
         +yO9vDa1JxwNBsBAWsXi4TGXkodWS5YudKUOWYJY=
Date:   Fri, 16 Dec 2022 09:17:50 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        riel@surriel.com, nadav.amit@gmail.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jthoughton@google.com, jhubbard@nvidia.com,
        jannh@google.com, david@redhat.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-dont-wait-for-migration-entry-during-follow-page.patch added to mm-unstable branch
Message-Id: <20221216171750.B682BC433EF@smtp.kernel.org>
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
Date: Fri, 16 Dec 2022 10:50:53 -0500

That's what the code does with !hugetlb pages, so we should logically do
the same for hugetlb, so migration entry will also be treated as no page.

This is probably also the last piece in follow_page code that may sleep,
the last one should be removed in cf994dd8af27 ("mm/gup: remove
FOLL_MIGRATION", 2022-11-16).

Link: https://lkml.kernel.org/r/20221216155100.2043537-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-dont-wait-for-migration-entry-during-follow-page
+++ a/mm/hugetlb.c
@@ -6380,7 +6380,6 @@ struct page *hugetlb_follow_page_mask(st
 	if (WARN_ON_ONCE(flags & FOLL_PIN))
 		return NULL;
 
-retry:
 	pte = huge_pte_offset(mm, haddr, huge_page_size(h));
 	if (!pte)
 		return NULL;
@@ -6403,16 +6402,6 @@ retry:
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

mm-uffd-fix-pte-marker-when-fork-without-fork-event.patch
mm-fix-a-few-rare-cases-of-using-swapin-error-pte-marker.patch
mm-uffd-always-wr-protect-pte-in-ptepmd_mkuffd_wp.patch
mm-hugetlb-let-vma_offset_start-to-return-start.patch
mm-hugetlb-dont-wait-for-migration-entry-during-follow-page.patch
mm-hugetlb-document-huge_pte_offset-usage.patch
mm-hugetlb-move-swap-entry-handling-into-vma-lock-when-faulted.patch
mm-hugetlb-make-userfaultfd_huge_must_wait-safe-to-pmd-unshare.patch
mm-hugetlb-make-hugetlb_follow_page_mask-safe-to-pmd-unshare.patch
mm-hugetlb-make-follow_hugetlb_page-safe-to-pmd-unshare.patch
mm-hugetlb-make-walk_hugetlb_range-safe-to-pmd-unshare.patch
mm-hugetlb-introduce-hugetlb_walk.patch

