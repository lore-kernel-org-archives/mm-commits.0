Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98DBBC04A95
	for <mm-commits@archiver.kernel.org>; Thu, 29 Sep 2022 04:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbiI2EGu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Sep 2022 00:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiI2EGt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2022 00:06:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F241E1A3B0
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 21:06:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E8656200C
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 04:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC97C433D7;
        Thu, 29 Sep 2022 04:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664424407;
        bh=YqPh3rr6x6pwHlULUjQwbQWNFO0x5aLc0fm6h4QIKD0=;
        h=Date:To:From:Subject:From;
        b=rzYSiubZdFzDyOuhEeSfs0fj3Xs3cIUZk4E3kJK3tAqsxfMpnB8jObC1T4vbp4mYg
         OUSBDXAwz/vW5O0w9hyTcjytv4ifhzWEAGElpr0awfUre0esLyrpoA3VW0X4DTsY4q
         OlM/b5s91sgJrJJRze9P67HEGtVfdeQ1Ejl/hTb8=
Date:   Wed, 28 Sep 2022 21:06:45 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] hugetlb-clean-up-code-checking-for-fault-truncation-races-fix.patch removed from -mm tree
Message-Id: <20220929040646.CBC97C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: fix reserve_alloc set but not used compiler warning
has been removed from the -mm tree.  Its filename was
     hugetlb-clean-up-code-checking-for-fault-truncation-races-fix.patch

This patch was dropped because it was folded into hugetlb-clean-up-code-checking-for-fault-truncation-races.patch

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: fix reserve_alloc set but not used compiler warning

Error path code checking the reserve_alloc variable was removed as it was
determined it was not necessary.  However, the variable itself was not
removed at the same time.  Remove now.

Link: https://lkml.kernel.org/r/Yyj7HsJWfHDoU24U@monkey
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/hugetlb.c~hugetlb-clean-up-code-checking-for-fault-truncation-races-fix
+++ a/mm/hugetlb.c
@@ -5562,7 +5562,6 @@ static vm_fault_t hugetlb_no_page(struct
 	spinlock_t *ptl;
 	unsigned long haddr = address & huge_page_mask(h);
 	bool new_page, new_pagecache_page = false;
-	bool reserve_alloc = false;
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -5618,8 +5617,6 @@ static vm_fault_t hugetlb_no_page(struct
 		clear_huge_page(page, address, pages_per_huge_page(h));
 		__SetPageUptodate(page);
 		new_page = true;
-		if (HPageRestoreReserve(page))
-			reserve_alloc = true;
 
 		if (vma->vm_flags & VM_MAYSHARE) {
 			int err = hugetlb_add_to_page_cache(page, mapping, idx);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlbfs-revert-use-i_mmap_rwsem-to-address-page-fault-truncate-race.patch
hugetlbfs-revert-use-i_mmap_rwsem-for-more-pmd-sharing-synchronization.patch
hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache.patch
hugetlb-create-remove_inode_single_folio-to-remove-single-file-folio.patch
hugetlb-rename-vma_shareable-and-refactor-code.patch
hugetlb-add-vma-based-lock-for-pmd-sharing.patch
hugetlb-create-hugetlb_unmap_file_folio-to-unmap-single-file-folio.patch
hugetlb-use-new-vma_lock-for-pmd-sharing-synchronization.patch
hugetlb-clean-up-code-checking-for-fault-truncation-races.patch
hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages.patch
hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages-v3.patch
hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch

