Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA70C54EE9
	for <mm-commits@archiver.kernel.org>; Sun, 25 Sep 2022 19:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiIYTuv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 25 Sep 2022 15:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbiIYTuu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 25 Sep 2022 15:50:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9281526104
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 12:50:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4590EB80D2F
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 19:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2870C433D6;
        Sun, 25 Sep 2022 19:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664135446;
        bh=RlLinzjpl3Wja0q6nBl73MEyZZAy+UYvjfq4oWqPCmw=;
        h=Date:To:From:Subject:From;
        b=OYxQtJYRBQaXzQ+CwqIm8qVWlqJFyAvZilEsdvq9NLjcPHRIzxFY4ixW8S2gN4vrp
         MjAuDuLRJsrwraJOIb5cfF2YCUeCrU8sHFsR218pi9nqgErWFe0Eq1rnGKO316wQSg
         Ckzo1sD73SHl9KEqW4mkRtHigBzVqfRJnKtcYqvM=
Date:   Sun, 25 Sep 2022 12:50:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, peterx@redhat.com, osalvador@suse.de,
        mhocko@suse.com, linmiaohe@huawei.com, joao.m.martins@oracle.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages-v3.patch added to mm-unstable branch
Message-Id: <20220925195046.B2870C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages-v3
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages-v3.patch

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
Subject: hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages-v3
Date: Wed, 21 Sep 2022 13:27:02 -0700

fix NULL pointer dereference in alloc_buddy_huge_page caused by not
checking for page before attempting to freeze.  Thanks Naoya.

Link: https://lkml.kernel.org/r/20220921202702.106069-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb.c~hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages-v3
+++ a/mm/hugetlb.c
@@ -1957,7 +1957,7 @@ retry:
 	page = __alloc_pages(gfp_mask, order, nid, nmask);
 
 	/* Freeze head page */
-	if (!page_ref_freeze(page, 1)) {
+	if (page && !page_ref_freeze(page, 1)) {
 		__free_pages(page, order);
 		if (retry) {	/* retry once */
 			retry = false;
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
hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages-v3.patch
hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch

