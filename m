Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F18E7C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 22:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbiLAWbX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Dec 2022 17:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbiLAWbQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2022 17:31:16 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABFBBE6AE
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 14:31:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 41D9DCE1D9D
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 22:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7316EC433D6;
        Thu,  1 Dec 2022 22:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669933871;
        bh=TWP25VVWpAOLM+kt7s3PmI0RSnHIZ2/BfvRyyfWg2lM=;
        h=Date:To:From:Subject:From;
        b=jSsNEY/DMbMbHeARupXnJREdkHhEJHlQSk2jT3dfsZOUQb3vZ7/dCRHnFdzcVYEFf
         QblsjZbrnrK/knXCj/TV4njGSPCnw4o4Sfi4pMkBww4P1V9CuEUw9hzwYuCJ3Lo+Z5
         zOlrH63InTCMQZsetBAFPh5HTGu0g/J0F2Cd8+cs=
Date:   Thu, 01 Dec 2022 14:31:10 -0800
To:     mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com,
        nadav.amit@gmail.com, ives@codesandbox.io, david@redhat.com,
        axelrasmussen@google.com, apopple@nvidia.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-fix-read-only-page-got-writable-when-recover-pte-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20221201223111.7316EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Date: Thu, 1 Dec 2022 10:19:22 -0500
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-migrate-fix-read-only-page-got-writable-when-recover-pte-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-fix-read-only-page-got-writable-when-recover-pte-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Date: Thu, 1 Dec 2022 10:19:22 -0500
Subject: mm-migrate-fix-read-only-page-got-writable-when-recover-pte-fix

enhance comment

Link: https://lkml.kernel.org/r/Y4jIHureiOd8XjDX@x1n
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Ives van Hoorne <ives@codesandbox.io>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-fix-read-only-page-got-writable-when-recover-pte-fix
+++ a/mm/migrate.c
@@ -214,7 +214,14 @@ static bool remove_migration_pte(struct
 		if (is_writable_migration_entry(entry))
 			pte = maybe_mkwrite(pte, vma);
 		else
-			/* NOTE: mk_pte can have write bit set */
+			/*
+			 * NOTE: mk_pte() can have write bit set per memory
+			 * type (e.g. shmem), or pte_mkdirty() per archs
+			 * (e.g., sparc64).  If this is a read migration
+			 * entry, we need to make sure when we recover the
+			 * pte from migration entry to present entry the
+			 * write bit is cleared.
+			 */
 			pte = pte_wrprotect(pte);
 
 		if (pte_swp_uffd_wp(*pvmw.pte)) {
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-migrate-fix-read-only-page-got-writable-when-recover-pte.patch
mm-migrate-fix-read-only-page-got-writable-when-recover-pte-fix.patch
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
mm-hugetlb-introduce-hugetlb_walk-fix.patch
mm-hugetlb-introduce-hugetlb_walk-fix-2.patch

