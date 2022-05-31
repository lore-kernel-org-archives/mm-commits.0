Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD030C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 31 May 2022 19:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiEaTiI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 May 2022 15:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242211AbiEaTiH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2022 15:38:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFEDE4B415
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 12:38:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0327B8111E
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 19:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCEEC3411D;
        Tue, 31 May 2022 19:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654025883;
        bh=SudSyNo7zt27RDQpWH+YPeBPkkdO30UHlFIfxsERR3E=;
        h=Date:To:From:Subject:From;
        b=gopUmBFRZuW4g0d3ZRVere+LztmUZSDZQQxINpZf2cYqiovyd2m81BWREVXO7QMeY
         GlulRbZgLZHFeleqNmR9y/zE8QobWOcNYXtGdXaKgN3Lwqkmo2EHlEVL70MWMGmLer
         cair7JPQ2iKCCvJEw1TdwSdxmu3ZIrQ0grzHIwdk=
Date:   Tue, 31 May 2022 12:38:02 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, anshuman.khandual@arm.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-remove-unnecessary-huge_ptep_set_access_flags-in-hugetlb_mcopy_atomic_pte.patch added to mm-unstable branch
Message-Id: <20220531193803.5BCEEC3411D@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: remove unnecessary huge_ptep_set_access_flags() in hugetlb_mcopy_atomic_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-remove-unnecessary-huge_ptep_set_access_flags-in-hugetlb_mcopy_atomic_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-remove-unnecessary-huge_ptep_set_access_flags-in-hugetlb_mcopy_atomic_pte.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm/hugetlb: remove unnecessary huge_ptep_set_access_flags() in hugetlb_mcopy_atomic_pte()
Date: Fri, 27 May 2022 10:01:35 +0800

There is no need to update the hugetlb access flags after just setting the
hugetlb page table entry by set_huge_pte_at(), since the page table entry
value has no changes.

Thus remove the unnecessary huge_ptep_set_access_flags() in
hugetlb_mcopy_atomic_pte().

Link: https://lkml.kernel.org/r/f3e28b897b53a69967a8b98a6fdcda3be80c9229.1653616175.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-remove-unnecessary-huge_ptep_set_access_flags-in-hugetlb_mcopy_atomic_pte
+++ a/mm/hugetlb.c
@@ -6031,8 +6031,6 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 
 	set_huge_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
 
-	(void)huge_ptep_set_access_flags(dst_vma, dst_addr, dst_pte, _dst_pte,
-					dst_vma->vm_flags & VM_WRITE);
 	hugetlb_count_add(pages_per_huge_page(h), dst_mm);
 
 	/* No need to invalidate - it was non-present before */
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-hugetlb-remove-unnecessary-huge_ptep_set_access_flags-in-hugetlb_mcopy_atomic_pte.patch

