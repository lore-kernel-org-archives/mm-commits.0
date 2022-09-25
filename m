Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B52BC04A95
	for <mm-commits@archiver.kernel.org>; Sun, 25 Sep 2022 19:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiIYTqk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 25 Sep 2022 15:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbiIYTqj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 25 Sep 2022 15:46:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4986222B1
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 12:46:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 894ADB80DE6
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 19:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A553C433D6;
        Sun, 25 Sep 2022 19:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664135195;
        bh=jC4NKBNyoXXJfN0zZwoMsWQBWcGlF1av++bXYNrCqYQ=;
        h=Date:To:From:Subject:From;
        b=qUWhn7KEKY/5zaiNia+/MRy9+TwUHPVVe5grl09dlAVEy19xHRrs5ge0SILu9AOYu
         iFtCE7TKYkB6z8mgwazPFb3Kywxj3flk32/JnZPNisEbSzUAPX81eSk2TDtiFD09Z4
         szGPrH8gUf0QAqfpeQavzXYj3laH51jt5U7RB3CQ=
Date:   Sun, 25 Sep 2022 12:46:33 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-clean-up-code-checking-for-fault-truncation-races-fix.patch added to mm-unstable branch
Message-Id: <20220925194635.1A553C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix reserve_alloc set but not used compiler warning
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-clean-up-code-checking-for-fault-truncation-races-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-clean-up-code-checking-for-fault-truncation-races-fix.patch

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
hugetlb-add-vma-based-lock-for-pmd-sharing-fix.patch
hugetlb-create-hugetlb_unmap_file_folio-to-unmap-single-file-folio.patch
hugetlb-use-new-vma_lock-for-pmd-sharing-synchronization.patch
hugetlb-clean-up-code-checking-for-fault-truncation-races.patch
hugetlb-clean-up-code-checking-for-fault-truncation-races-fix.patch
hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages.patch
hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch

