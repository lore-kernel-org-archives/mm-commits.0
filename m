Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9551AC433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 00:54:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CDF2613BA
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 00:54:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbhEEAzM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 20:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhEEAzM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 20:55:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3546D61168;
        Wed,  5 May 2021 00:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620176056;
        bh=jgU/ElKz8GDZbt/oR/UFBC9Zq+TvPsR1vwrf5IM7zhs=;
        h=Date:From:To:Subject:From;
        b=kktjPlY9JdWA/khpXcr73x5cHi3/LIjLNGya01lpO5y/7oyp34QQtQlr8Vrekt9Nb
         FsqxkkYnp/Ne1lEiWzhfL2j/s5kkAKFu/XN4Ja4P5zSiS0NAlL31Po4ieSZ36Nes81
         dKzpow6i7/FkaeFDxGG4YDslqrXF5BiC+fLOkoqY=
Date:   Tue, 04 May 2021 17:54:15 -0700
From:   akpm@linux-foundation.org
To:     axelrasmussen@google.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naresh.kamboju@linaro.org,
        peterx@redhat.com
Subject:  [folded-merged]
 hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled-fix.patch
 removed from -mm tree
Message-ID: <20210505005415.IwsaEVCfJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix build with !ARCH_WANT_HUGE_PMD_SHARE
has been removed from the -mm tree.  Its filename was
     hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled-fix.patch

This patch was dropped because it was folded into hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled.patch

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: fix build with !ARCH_WANT_HUGE_PMD_SHARE

want_pmd_share() is undefined with !ARCH_WANT_HUGE_PMD_SHARE since it's
put by accident into a "#ifdef ARCH_WANT_HUGE_PMD_SHARE" block.  Moving it
out won't work either since vma_shareable() is only defined within the
block.  Define it for !ARCH_WANT_HUGE_PMD_SHARE instead.

Link: https://lkml.kernel.org/r/20210310185359.88297-1-peterx@redhat.com
Fixes: 5b109cc1cdcc ("hugetlb/userfaultfd: forbid huge pmd sharing when uffd enabled")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled-fix
+++ a/mm/hugetlb.c
@@ -5328,9 +5328,6 @@ static bool vma_shareable(struct vm_area
 
 bool want_pmd_share(struct vm_area_struct *vma, unsigned long addr)
 {
-#ifndef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
-	return false;
-#endif
 #ifdef CONFIG_USERFAULTFD
 	if (uffd_disable_huge_pmd_share(vma))
 		return false;
@@ -5475,6 +5472,11 @@ void adjust_range_if_pmd_sharing_possibl
 				unsigned long *start, unsigned long *end)
 {
 }
+
+bool want_pmd_share(struct vm_area_struct *vma, unsigned long addr)
+{
+	return false;
+}
 #endif /* CONFIG_ARCH_WANT_HUGE_PMD_SHARE */
 
 #ifdef CONFIG_ARCH_WANT_GENERAL_HUGETLB
_

Patches currently in -mm which might be from peterx@redhat.com are

hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled.patch
mm-hugetlb-move-flush_hugetlb_tlb_range-into-hugetlbh.patch
hugetlb-userfaultfd-unshare-all-pmds-for-hugetlbfs-when-register-wp.patch
userfaultfd-add-minor-fault-registration-mode-fix.patch
mm-hugetlb-fix-f_seal_future_write.patch
mm-hugetlb-fix-cow-where-page-writtable-in-child.patch

