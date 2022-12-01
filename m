Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C71BDC47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiLAAHP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiLAAFN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:05:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2F092A3E
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C16A61E89
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85ABDC433D6;
        Thu,  1 Dec 2022 00:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852935;
        bh=pMTi4J3n8RmrDrUJIqPR6o93GVq5zAqeECfZk0te6DU=;
        h=Date:To:From:Subject:From;
        b=iNpdYl9k1Kpw0jic+JHG3aeWjrZTu53K7lRzOwHZZ0kavFUQEA+oBaaJtsKiFJEn6
         ZpKH3AxT09D56/3m4D+xbyqgNICIe+qka85tBnbs9mNZT8StdmyuYpq1hM6rXr0k2s
         Pgu7MroM5n/LXBv/Uq/PlbxdndkN91esoiVlWDp4=
Date:   Wed, 30 Nov 2022 16:02:14 -0800
To:     mm-commits@vger.kernel.org, neescoba@cisco.com, leon@kernel.org,
        jgg@nvidia.com, benve@cisco.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] rdma-usnic-remove-foll_force-usage.patch removed from -mm tree
Message-Id: <20221201000215.85ABDC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: RDMA/usnic: remove FOLL_FORCE usage
has been removed from the -mm tree.  Its filename was
     rdma-usnic-remove-foll_force-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christian Benvenuti <benve@cisco.com>
Cc: Nelson Escobar <neescoba@cisco.com>
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

