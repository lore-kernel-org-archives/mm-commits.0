Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D383FC4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiLAAHf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiLAAFd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:05:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340DC934CA
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 442E661E8A
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD7AC433D6;
        Thu,  1 Dec 2022 00:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852934;
        bh=HX0gdxIJYUBTcDupMh2jg9a03AIJNTCIBwLYh8qBhaM=;
        h=Date:To:From:Subject:From;
        b=c36wPi1uRJ2UrsFZMEYHU52xeF8C5GsGKxaWJBKVTMhkC/nQkgHEH52KMh2DhOalu
         dH+jctEYphAu37jORyAjZAK47Huc84cH9cIs4b1vz/sBA4oMq4NsUPEgBs+I00Ayg2
         X2JxkUAp+xAGCdhedr7YQYGWSBxJtkR/znPyRhmw=
Date:   Wed, 30 Nov 2022 16:02:13 -0800
To:     mm-commits@vger.kernel.org, leonro@nvidia.com, leon@kernel.org,
        jgg@nvidia.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] rdma-umem-remove-foll_force-usage.patch removed from -mm tree
Message-Id: <20221201000214.5BD7AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: RDMA/umem: remove FOLL_FORCE usage
has been removed from the -mm tree.  Its filename was
     rdma-umem-remove-foll_force-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: RDMA/umem: remove FOLL_FORCE usage
Date: Wed, 16 Nov 2022 11:26:49 +0100

GUP now supports reliable R/O long-term pinning in COW mappings, such
that we break COW early. MAP_SHARED VMAs only use the shared zeropage so
far in one corner case (DAXFS file with holes), which can be ignored
because GUP does not support long-term pinning in fsdax (see
check_vma_flags()).

Consequently, FOLL_FORCE | FOLL_WRITE | FOLL_LONGTERM is no longer required
for reliable R/O long-term pinning: FOLL_LONGTERM is sufficient. So stop
using FOLL_FORCE, which is really only for ptrace access.

Link: https://lkml.kernel.org/r/20221116102659.70287-11-david@redhat.com
Tested-by: Leon Romanovsky <leonro@nvidia.com>	[over mlx4 and mlx5]
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/core/umem.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/core/umem.c~rdma-umem-remove-foll_force-usage
+++ a/drivers/infiniband/core/umem.c
@@ -156,7 +156,7 @@ struct ib_umem *ib_umem_get(struct ib_de
 	struct mm_struct *mm;
 	unsigned long npages;
 	int pinned, ret;
-	unsigned int gup_flags = FOLL_WRITE;
+	unsigned int gup_flags = FOLL_LONGTERM;
 
 	/*
 	 * If the combination of the addr and size requested for this memory
@@ -210,8 +210,8 @@ struct ib_umem *ib_umem_get(struct ib_de
 
 	cur_base = addr & PAGE_MASK;
 
-	if (!umem->writable)
-		gup_flags |= FOLL_FORCE;
+	if (umem->writable)
+		gup_flags |= FOLL_WRITE;
 
 	while (npages) {
 		cond_resched();
@@ -219,7 +219,7 @@ struct ib_umem *ib_umem_get(struct ib_de
 					  min_t(unsigned long, npages,
 						PAGE_SIZE /
 						sizeof(struct page *)),
-					  gup_flags | FOLL_LONGTERM, page_list);
+					  gup_flags, page_list);
 		if (pinned < 0) {
 			ret = pinned;
 			goto umem_release;
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

