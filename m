Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D4EFC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:27:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbjFIX1f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbjFIX1Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 689723A9D
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAB606169F
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9A5C433D2;
        Fri,  9 Jun 2023 23:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353231;
        bh=PbRY+0SxuL2Au4BM4s1qMycA90sWdpPx9lv7DJ7OA5U=;
        h=Date:To:From:Subject:From;
        b=wbE35MJd+HDkisWLG8w5RXPz3jLR2ez8i8zW68lao9caQguPClkHDgx2PtTooxVfE
         SK75vlrcUac2pMESUBr1xyFf9nRRMqkTKSrum1vR8rX3KnbYBpyimw1DqaxEySBmS5
         rZpqSfDOysgBJtgM2pHd2K0Kgl+ZcV4tuoRSRowE=
Date:   Fri, 09 Jun 2023 16:27:10 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vannapurve@google.com, sidhartha.kumar@oracle.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, erdemaktas@google.com, ackerleytng@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-hugetlbfs-set-vma-policy-only-when-needed-for-allocating-folio.patch removed from -mm tree
Message-Id: <20230609232711.4B9A5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs: hugetlbfs: set vma policy only when needed for allocating folio
has been removed from the -mm tree.  Its filename was
     fs-hugetlbfs-set-vma-policy-only-when-needed-for-allocating-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ackerley Tng <ackerleytng@google.com>
Subject: fs: hugetlbfs: set vma policy only when needed for allocating folio
Date: Tue, 2 May 2023 23:56:22 +0000

Calling hugetlb_set_vma_policy() later avoids setting the vma policy
and then dropping it on a page cache hit.

Link: https://lkml.kernel.org/r/20230502235622.3652586-1-ackerleytng@google.com
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Erdem Aktas <erdemaktas@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/fs/hugetlbfs/inode.c~fs-hugetlbfs-set-vma-policy-only-when-needed-for-allocating-folio
+++ a/fs/hugetlbfs/inode.c
@@ -834,9 +834,6 @@ static long hugetlbfs_fallocate(struct f
 			break;
 		}
 
-		/* Set numa allocation policy based on index */
-		hugetlb_set_vma_policy(&pseudo_vma, inode, index);
-
 		/* addr is the offset within the file (zero based) */
 		addr = index * hpage_size;
 
@@ -850,7 +847,6 @@ static long hugetlbfs_fallocate(struct f
 		rcu_read_unlock();
 		if (present) {
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
-			hugetlb_drop_vma_policy(&pseudo_vma);
 			continue;
 		}
 
@@ -862,6 +858,7 @@ static long hugetlbfs_fallocate(struct f
 		 * folios in these areas, we need to consume the reserves
 		 * to keep reservation accounting consistent.
 		 */
+		hugetlb_set_vma_policy(&pseudo_vma, inode, index);
 		folio = alloc_hugetlb_folio(&pseudo_vma, addr, 0);
 		hugetlb_drop_vma_policy(&pseudo_vma);
 		if (IS_ERR(folio)) {
_

Patches currently in -mm which might be from ackerleytng@google.com are


