Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A950EC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 10 Mar 2021 20:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66DB864FCA
	for <mm-commits@archiver.kernel.org>; Wed, 10 Mar 2021 20:26:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbhCJUZ3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:25:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:56412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231550AbhCJUZA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Mar 2021 15:25:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C08A564FCA;
        Wed, 10 Mar 2021 20:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615407900;
        bh=MhdXdarHssYOFrA9N93/OPvJxY8rZWfwHZG21eipGU0=;
        h=Date:From:To:Subject:From;
        b=Amh45Itu80gnp/gU2thLf7+iQzI4R2oAfG3DdXNB21yN8KvcsURsD4d2l56v44rIb
         yTNvneNGwYImH3Mt6ymsSfk9LeRvldBfp6CvWD+w/FRLYIaGzFy4nMkTMN0mpGdjqQ
         PPNgNI+MnrVbOjqHa1OrBVvSAEeDgGe1Tk4tU4AU=
Date:   Wed, 10 Mar 2021 12:24:59 -0800
From:   akpm@linux-foundation.org
To:     axelrasmussen@google.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naresh.kamboju@linaro.org,
        peterx@redhat.com
Subject:  +
 hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled-fix.patch
 added to -mm tree
Message-ID: <20210310202459.czoA3UEwR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix build with !ARCH_WANT_HUGE_PMD_SHARE
has been added to the -mm tree.  Its filename is
     hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5329,9 +5329,6 @@ static bool vma_shareable(struct vm_area
 
 bool want_pmd_share(struct vm_area_struct *vma, unsigned long addr)
 {
-#ifndef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
-	return false;
-#endif
 #ifdef CONFIG_USERFAULTFD
 	if (uffd_disable_huge_pmd_share(vma))
 		return false;
@@ -5476,6 +5473,11 @@ void adjust_range_if_pmd_sharing_possibl
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

hugetlb-dedup-the-code-to-add-a-new-file_region.patch
hugetlg-break-earlier-in-add_reservation_in_range-when-we-can.patch
mm-introduce-page_needs_cow_for_dma-for-deciding-whether-cow.patch
mm-use-is_cow_mapping-across-tree-where-proper.patch
hugetlb-do-early-cow-when-page-pinned-on-src-mm.patch
hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share.patch
hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share-fix.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled-fix.patch
mm-hugetlb-move-flush_hugetlb_tlb_range-into-hugetlbh.patch
hugetlb-userfaultfd-unshare-all-pmds-for-hugetlbfs-when-register-wp.patch

