Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09796C43219
	for <mm-commits@archiver.kernel.org>; Wed, 16 Nov 2022 22:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238923AbiKPWpK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Nov 2022 17:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238629AbiKPWoV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Nov 2022 17:44:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3B5BCB
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 14:44:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16DA3B81EE1
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 22:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75A5C433D6;
        Wed, 16 Nov 2022 22:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668638648;
        bh=Ezt5KaHoVHl10Nuc6FtPTtkIbYjykpkDnNhB0ZWfMO4=;
        h=Date:To:From:Subject:From;
        b=SMAsREEYUT9gjbdiaymdn/YgOeOIaWQUHSy8K1ik09yqeJJ9LKqkVXbkCXKBYyAT7
         RFhubklbxM0c2+iFbT6k1JokVgnUM4dMcWHiBRmu+0YU9DcLqI9AK2zM9s1Tl64Zm/
         T4aVPPyQ3NWj2vd9uYGPmjSMu3j1bDbJ8fDsMfPU=
Date:   Wed, 16 Nov 2022 14:44:08 -0800
To:     mm-commits@vger.kernel.org, leon@kernel.org, jgg@ziepe.ca,
        bmt@zurich.ibm.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + rdma-siw-remove-foll_force-usage.patch added to mm-unstable branch
Message-Id: <20221116224408.B75A5C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: RDMA/siw: remove FOLL_FORCE usage
has been added to the -mm mm-unstable branch.  Its filename is
     rdma-siw-remove-foll_force-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rdma-siw-remove-foll_force-usage.patch

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
Cc: Bernard Metzler <bmt@zurich.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
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
mm-mprotect-minor-can_change_pte_writable-cleanups.patch
mm-huge_memory-try-avoiding-write-faults-when-changing-pmd-protection.patch
mm-mprotect-factor-out-check-whether-manual-pte-write-upgrades-are-required.patch
mm-autonuma-use-can_change_ptepmd_writable-to-replace-savedwrite.patch
mm-remove-unused-savedwrite-infrastructure.patch
selftests-vm-anon_cow-add-mprotect-optimization-tests.patch
selftests-vm-anon_cow-prepare-for-non-anonymous-cow-tests.patch
selftests-vm-cow-basic-cow-tests-for-non-anonymous-pages.patch
selftests-vm-cow-r-o-long-term-pinning-reliability-tests-for-non-anon-pages.patch
mm-add-early-fault_flag_unshare-consistency-checks.patch
mm-add-early-fault_flag_write-consistency-checks.patch
mm-rework-handling-in-do_wp_page-based-on-private-vs-shared-mappings.patch
mm-dont-call-vm_ops-huge_fault-in-wp_huge_pmd-wp_huge_pud-for-private-mappings.patch
mm-extend-fault_flag_unshare-support-to-anything-in-a-cow-mapping.patch
mm-gup-reliable-r-o-long-term-pinning-in-cow-mappings.patch
rdma-umem-remove-foll_force-usage.patch
rdma-usnic-remove-foll_force-usage.patch
rdma-siw-remove-foll_force-usage.patch
media-videobuf-dma-sg-remove-foll_force-usage.patch
drm-etnaviv-remove-foll_force-usage.patch
media-pci-ivtv-remove-foll_force-usage.patch
mm-frame-vector-remove-foll_force-usage.patch
drm-exynos-remove-foll_force-usage.patch
rdma-hw-qib-qib_user_pages-remove-foll_force-usage.patch
habanalabs-remove-foll_force-usage.patch

