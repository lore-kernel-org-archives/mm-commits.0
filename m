Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ABE3C352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiLAAHf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiLAAFe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:05:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A343491361
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F36661E6C
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA260C433B5;
        Thu,  1 Dec 2022 00:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852936;
        bh=wPUVp16wnNTmB+dIK1Jzw9LEYY+oOBDuKdRP2s9gyRc=;
        h=Date:To:From:Subject:From;
        b=bq+1d1E6nfEVMBx5u8sBWrCnd/OH8SSlGdJKcNo/IqTmtkvqd+eemADQVsaMKJ7cI
         COIXOohH6djlAHXklLMB91cVJELOx5tuwkNKbA2s7oSqoA9rcYMncw0TeQBSQyn9Ud
         8aVXUgFdaagWlBlmWB+y+vBtgX8s9edM5CNGKn8w=
Date:   Wed, 30 Nov 2022 16:02:16 -0800
To:     mm-commits@vger.kernel.org, leon@kernel.org, jgg@nvidia.com,
        bmt@zurich.ibm.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] rdma-siw-remove-foll_force-usage.patch removed from -mm tree
Message-Id: <20221201000216.AA260C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: RDMA/siw: remove FOLL_FORCE usage
has been removed from the -mm tree.  Its filename was
     rdma-siw-remove-foll_force-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: RDMA/siw: remove FOLL_FORCE usage
Date: Wed, 16 Nov 2022 11:26:51 +0100

GUP now supports reliable R/O long-term pinning in COW mappings, such
that we break COW early. MAP_SHARED VMAs only use the shared zeropage so
far in one corner case (DAXFS file with holes), which can be ignored
because GUP does not support long-term pinning in fsdax (see
check_vma_flags()).

Consequently, FOLL_FORCE | FOLL_WRITE | FOLL_LONGTERM is no longer required
for reliable R/O long-term pinning: FOLL_LONGTERM is sufficient. So stop
using FOLL_FORCE, which is really only for ptrace access.

Link: https://lkml.kernel.org/r/20221116102659.70287-13-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bernard Metzler <bmt@zurich.ibm.com>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/sw/siw/siw_mem.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/infiniband/sw/siw/siw_mem.c~rdma-siw-remove-foll_force-usage
+++ a/drivers/infiniband/sw/siw/siw_mem.c
@@ -368,7 +368,7 @@ struct siw_umem *siw_umem_get(u64 start,
 	struct mm_struct *mm_s;
 	u64 first_page_va;
 	unsigned long mlock_limit;
-	unsigned int foll_flags = FOLL_WRITE;
+	unsigned int foll_flags = FOLL_LONGTERM;
 	int num_pages, num_chunks, i, rv = 0;
 
 	if (!can_do_mlock())
@@ -391,8 +391,8 @@ struct siw_umem *siw_umem_get(u64 start,
 
 	mmgrab(mm_s);
 
-	if (!writable)
-		foll_flags |= FOLL_FORCE;
+	if (writable)
+		foll_flags |= FOLL_WRITE;
 
 	mmap_read_lock(mm_s);
 
@@ -423,8 +423,7 @@ struct siw_umem *siw_umem_get(u64 start,
 		while (nents) {
 			struct page **plist = &umem->page_chunk[i].plist[got];
 
-			rv = pin_user_pages(first_page_va, nents,
-					    foll_flags | FOLL_LONGTERM,
+			rv = pin_user_pages(first_page_va, nents, foll_flags,
 					    plist, NULL);
 			if (rv < 0)
 				goto out_sem_up;
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch

