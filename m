Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82AABC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 16 Nov 2022 22:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238905AbiKPWpJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Nov 2022 17:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238982AbiKPWoV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Nov 2022 17:44:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2B1A198
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 14:44:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 670C161FF6
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 22:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC78EC433C1;
        Wed, 16 Nov 2022 22:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668638646;
        bh=uU/u+PWmMgmIz+Z27ziNliGXEz8+PhjATD3DpAVpknQ=;
        h=Date:To:From:Subject:From;
        b=WuPHUI5nmTBuuwPanTx5LC/tWOzWmOIy9rvGy4cGwngEWSthIK8XyUmXqj1dYwN5+
         nBg+jjK1qBaCqBgVg2bDTQIgGvNJzE05EDdSYb0IOGNcGhjtAvKt7oUlrvWsaFh0oe
         XK6/bjAmOXnlo8lleewkiF33n/WqZB0oZBC0+LmY=
Date:   Wed, 16 Nov 2022 14:44:06 -0800
To:     mm-commits@vger.kernel.org, neescoba@cisco.com, leon@kernel.org,
        jgg@ziepe.ca, benve@cisco.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + rdma-usnic-remove-foll_force-usage.patch added to mm-unstable branch
Message-Id: <20221116224406.BC78EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: RDMA/usnic: remove FOLL_FORCE usage
has been added to the -mm mm-unstable branch.  Its filename is
     rdma-usnic-remove-foll_force-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rdma-usnic-remove-foll_force-usage.patch

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
Subject: RDMA/usnic: remove FOLL_FORCE usage
Date: Wed, 16 Nov 2022 11:26:50 +0100

GUP now supports reliable R/O long-term pinning in COW mappings, such
that we break COW early. MAP_SHARED VMAs only use the shared zeropage so
far in one corner case (DAXFS file with holes), which can be ignored
because GUP does not support long-term pinning in fsdax (see
check_vma_flags()).

Consequently, FOLL_FORCE | FOLL_WRITE | FOLL_LONGTERM is no longer required
for reliable R/O long-term pinning: FOLL_LONGTERM is sufficient. So stop
using FOLL_FORCE, which is really only for ptrace access.

Link: https://lkml.kernel.org/r/20221116102659.70287-12-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Christian Benvenuti <benve@cisco.com>
Cc: Nelson Escobar <neescoba@cisco.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/usnic/usnic_uiom.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/infiniband/hw/usnic/usnic_uiom.c~rdma-usnic-remove-foll_force-usage
+++ a/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -85,6 +85,7 @@ static int usnic_uiom_get_pages(unsigned
 				int dmasync, struct usnic_uiom_reg *uiomr)
 {
 	struct list_head *chunk_list = &uiomr->chunk_list;
+	unsigned int gup_flags = FOLL_LONGTERM;
 	struct page **page_list;
 	struct scatterlist *sg;
 	struct usnic_uiom_chunk *chunk;
@@ -96,7 +97,6 @@ static int usnic_uiom_get_pages(unsigned
 	int off;
 	int i;
 	dma_addr_t pa;
-	unsigned int gup_flags;
 	struct mm_struct *mm;
 
 	/*
@@ -131,8 +131,8 @@ static int usnic_uiom_get_pages(unsigned
 		goto out;
 	}
 
-	gup_flags = FOLL_WRITE;
-	gup_flags |= (writable) ? 0 : FOLL_FORCE;
+	if (writable)
+		gup_flags |= FOLL_WRITE;
 	cur_base = addr & PAGE_MASK;
 	ret = 0;
 
@@ -140,8 +140,7 @@ static int usnic_uiom_get_pages(unsigned
 		ret = pin_user_pages(cur_base,
 				     min_t(unsigned long, npages,
 				     PAGE_SIZE / sizeof(struct page *)),
-				     gup_flags | FOLL_LONGTERM,
-				     page_list, NULL);
+				     gup_flags, page_list, NULL);
 
 		if (ret < 0)
 			goto out;
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

