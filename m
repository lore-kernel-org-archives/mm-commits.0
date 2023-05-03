Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0666C77B75
	for <mm-commits@archiver.kernel.org>; Wed,  3 May 2023 21:23:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjECVXm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 May 2023 17:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjECVXl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2023 17:23:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315917AAD
        for <mm-commits@vger.kernel.org>; Wed,  3 May 2023 14:23:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4D7D62A71
        for <mm-commits@vger.kernel.org>; Wed,  3 May 2023 21:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E38C433EF;
        Wed,  3 May 2023 21:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683149016;
        bh=zN91yCRmdrtMHgvF9nIYAGOEDjKOryljzJdopTHK5uE=;
        h=Date:To:From:Subject:From;
        b=q2UdyNdtwS7oFiVVfbsiVQY2cboaz+jT+PI1Qm6mjokyPJ5NYlo3dnAWJPeXdvLD6
         H3R0dtu65N1Z5DpU1WaLMxHV1p6hD4T1SMYRdIqFPMU7MQOK8I0R1+jTPqS3OBmge7
         35IqzIcBpmlD6wL0Q8SeS8aA1ktLiR5MPLhbbO2Y=
Date:   Wed, 03 May 2023 14:23:35 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vannapurve@google.com, sidhartha.kumar@oracle.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, erdemaktas@google.com, ackerleytng@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-hugetlbfs-set-vma-policy-only-when-needed-for-allocating-folio.patch added to mm-unstable branch
Message-Id: <20230503212336.19E38C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: hugetlbfs: set vma policy only when needed for allocating folio
has been added to the -mm mm-unstable branch.  Its filename is
     fs-hugetlbfs-set-vma-policy-only-when-needed-for-allocating-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-hugetlbfs-set-vma-policy-only-when-needed-for-allocating-folio.patch

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

fs-hugetlbfs-set-vma-policy-only-when-needed-for-allocating-folio.patch

