Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 593DFECAAA1
	for <mm-commits@archiver.kernel.org>; Thu, 15 Sep 2022 20:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiIOUFf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Sep 2022 16:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiIOUFe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2022 16:05:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4911F2D6
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 13:05:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53260B8222A
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 20:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0887FC433D6;
        Thu, 15 Sep 2022 20:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663272331;
        bh=p+DU2wVmZVvwSLNgj2Hys4PlZvUFYtdrgF11fmay+pQ=;
        h=Date:To:From:Subject:From;
        b=MIoWga3ZFdXxF7nkQAHCD9pA73AIiAu8CQOULzarvoE4DTKedDEA3Ezv9yiEsRYAJ
         cBZFFVxkPwgKej+90dvhpaZQtx+cvpfWyq8TOg4zd7Y8SaZldNUVGCH05K/mivu0Ok
         reVvMrXtz0O1YgHzw1JSmkIxlpHkdaEqLKi6v5Bw=
Date:   Thu, 15 Sep 2022 13:05:30 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-add-vma-based-lock-for-pmd-sharing-fix.patch added to mm-unstable branch
Message-Id: <20220915200531.0887FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix build issue for missing hugetlb_vma_lock_release
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-add-vma-based-lock-for-pmd-sharing-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-add-vma-based-lock-for-pmd-sharing-fix.patch

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
hugetlb-add-vma-based-lock-for-pmd-sharing-fix.patch
hugetlb-create-hugetlb_unmap_file_folio-to-unmap-single-file-folio.patch
hugetlb-use-new-vma_lock-for-pmd-sharing-synchronization.patch
hugetlb-clean-up-code-checking-for-fault-truncation-races.patch

