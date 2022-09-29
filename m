Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2965C04A95
	for <mm-commits@archiver.kernel.org>; Thu, 29 Sep 2022 04:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234719AbiI2EGZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Sep 2022 00:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234669AbiI2EGR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2022 00:06:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004F7D69C7
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 21:06:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D6B361F8D
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 04:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74C3C433D7;
        Thu, 29 Sep 2022 04:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664424375;
        bh=X2hPdZrzbA9QEgCxVmD2ECc8kwTmNfRFIlj5fFjhltQ=;
        h=Date:To:From:Subject:From;
        b=ZKC5NqyJwBdISoxgic+zpmVmLGtq+Pzcf/ST3go6L8SltlI5NZEve/MXXhPdY2KOA
         cDu9gVKmt1zT5ZnzueqzFlobdn2p+FkhQ7d31qLldAD6YDyyWz6qj3B3+YikrF/Y7U
         0q+YY0V5oEWy5keAPHfgPDl2/6mZhO7pNZQTDYlI=
Date:   Wed, 28 Sep 2022 21:06:13 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] hugetlb-add-vma-based-lock-for-pmd-sharing-fix.patch removed from -mm tree
Message-Id: <20220929040614.C74C3C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: fix build issue for missing hugetlb_vma_lock_release
has been removed from the -mm tree.  Its filename was
     hugetlb-add-vma-based-lock-for-pmd-sharing-fix.patch

This patch was dropped because it was folded into hugetlb-add-vma-based-lock-for-pmd-sharing.patch

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: fix build issue for missing hugetlb_vma_lock_release

Add a stub for hugetlb_vma_lock_release to build in the case
CONFIG_HUGETLB_PAGE && !CONFIG_ARCH_WANT_HUGE_PMD_SHARE.

Link: https://lkml.kernel.org/r/YyNUtA1vRASOE4+M@monkey
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/hugetlb.c~hugetlb-add-vma-based-lock-for-pmd-sharing-fix
+++ a/mm/hugetlb.c
@@ -6942,6 +6942,11 @@ int huge_pmd_unshare(struct mm_struct *m
 }
 
 #else /* !CONFIG_ARCH_WANT_HUGE_PMD_SHARE */
+
+void hugetlb_vma_lock_release(struct kref *kref)
+{
+}
+
 static void hugetlb_vma_lock_free(struct vm_area_struct *vma)
 {
 }
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
hugetlb-clean-up-code-checking-for-fault-truncation-races-fix.patch
hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages.patch
hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages-v3.patch
hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch

