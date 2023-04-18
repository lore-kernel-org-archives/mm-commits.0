Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3003CC6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbjDRXfg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbjDRXeq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C25AD2F
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 878A161528
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD875C433D2;
        Tue, 18 Apr 2023 23:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860860;
        bh=QjuFx32heEgAl3SE9zHn64kncU/w/puWQHUExk+lv1k=;
        h=Date:To:From:Subject:From;
        b=LFMbhEINKRgGuQuuk7ye6jzVQJSp/dNHtQMKOpieIno+Fw7KUA4fyjNrUnPEV4VWq
         dvn0gMePsxSPFYNTKCpN8cR/9+QtYMHJJdWExrcjwd8cl9BAYMFB93GxIyB0AoHQuR
         2rNn19sYT/6N3O4fU1pJQokzxpUREToYpLdaMm+8=
Date:   Tue, 18 Apr 2023 16:34:19 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-use-vma_lookup-instead-of-find_vma.patch removed from -mm tree
Message-Id: <20230418233419.DD875C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/madvise: use vma_lookup() instead of find_vma()
has been removed from the -mm tree.  Its filename was
     mm-madvise-use-vma_lookup-instead-of-find_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/madvise: use vma_lookup() instead of find_vma()
Date: Tue, 4 Apr 2023 17:45:15 +0800

Using vma_lookup() verifies the address is contained in the found vma. 
This results in easier to read the code.

Link: https://lkml.kernel.org/r/20230404094515.1883552-1-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
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
mm-convert-copy_user_huge_page-to-copy_user_large_folio.patch
userfaultfd-convert-mfill_atomic-to-use-a-folio.patch
userfaultfd-use-helper-function-range_in_vma.patch

