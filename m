Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC46C761A6
	for <mm-commits@archiver.kernel.org>; Tue,  4 Apr 2023 19:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbjDDT7e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Apr 2023 15:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbjDDT7d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2023 15:59:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A1419AA
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 12:59:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B010D637AD
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 19:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E29C433EF;
        Tue,  4 Apr 2023 19:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680638371;
        bh=2uYLFLw2PNasSTBLvo2oXbo9fPqjHLsEByzhNmCKKwc=;
        h=Date:To:From:Subject:From;
        b=t0rZaySAmIP3d3FGMqg4QtH0STQQh5szBmYNV27N8soeeN+lRQhZo/D9KkByP/aBc
         YqoJdPrzk1KwpBAVoxOWWnXI//aGovXi4BFB1TjkzJygr9imlIzQp/r6iTewIdmYCn
         SlRj2FRCRxRNKJP87FbyX9IolzcLRs4x0Lme5eGc=
Date:   Tue, 04 Apr 2023 12:59:30 -0700
To:     mm-commits@vger.kernel.org, liam.howlett@oracle.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-use-vma_lookup-instead-of-find_vma.patch added to mm-unstable branch
Message-Id: <20230404195931.08E29C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: use vma_lookup() instead of find_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-use-vma_lookup-instead-of-find_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-use-vma_lookup-instead-of-find_vma.patch

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
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/madvise: use vma_lookup() instead of find_vma()
Date: Tue, 4 Apr 2023 17:45:15 +0800

Using vma_lookup() verifies the address is contained in the found vma. 
This results in easier to read the code.

Link: https://lkml.kernel.org/r/20230404094515.1883552-1-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

--- a/mm/madvise.c~mm-madvise-use-vma_lookup-instead-of-find_vma
+++ a/mm/madvise.c
@@ -852,21 +852,9 @@ static long madvise_dontneed_free(struct
 		*prev = NULL; /* mmap_lock has been dropped, prev is stale */
 
 		mmap_read_lock(mm);
-		vma = find_vma(mm, start);
+		vma = vma_lookup(mm, start);
 		if (!vma)
 			return -ENOMEM;
-		if (start < vma->vm_start) {
-			/*
-			 * This "vma" under revalidation is the one
-			 * with the lowest vma->vm_start where start
-			 * is also < vma->vm_end. If start <
-			 * vma->vm_start it means an hole materialized
-			 * in the user address space within the
-			 * virtual range passed to MADV_DONTNEED
-			 * or MADV_FREE.
-			 */
-			return -ENOMEM;
-		}
 		/*
 		 * Potential end adjustment for hugetlb vma is OK as
 		 * the check below keeps end within vma.
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

userfaultfd-convert-mfill_atomic_pte_copy-to-use-a-folio.patch
userfaultfd-use-kmap_local_page-in-copy_huge_page_from_user.patch
userfaultfd-convert-copy_huge_page_from_user-to-copy_folio_from_user.patch
userfaultfd-convert-mfill_atomic_hugetlb-to-use-a-folio.patch
mm-convert-copy_user_huge_page-to-copy_user_folio.patch
userfaultfd-convert-mfill_atomic-to-use-a-folio.patch
mm-madvise-use-vma_lookup-instead-of-find_vma.patch

