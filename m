Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F44C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:09:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbiGDBJs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbiGDBJl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E284362F8
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59EF761303
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF2AC341C7;
        Mon,  4 Jul 2022 01:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896978;
        bh=sUcqMoNUDEKhTqkXURCT8QZptACVGvRDBXPI6WziX30=;
        h=Date:To:From:Subject:From;
        b=KnqxkoTcz1MOPf8MAGKi4rgnllQfm6QAJ45p72EIo5Pj0h2gBghJNCAOZqlRpHdOD
         JPLJOE8QdB4bcSaGvSIzfkdld0/DuWov5snjenuHQ1IBtN7EEN9UxhexgIrH83NjDM
         HBF4vGpq9p4GlUwMsos08sObiM4QjA6ev9Algjzg=
Date:   Sun, 03 Jul 2022 18:09:38 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, anshuman.khandual@arm.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-remove-unnecessary-huge_ptep_set_access_flags-in-hugetlb_mcopy_atomic_pte.patch removed from -mm tree
Message-Id: <20220704010938.AEF2AC341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: remove unnecessary huge_ptep_set_access_flags() in hugetlb_mcopy_atomic_pte()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-unnecessary-huge_ptep_set_access_flags-in-hugetlb_mcopy_atomic_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -6039,8 +6039,6 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 
 	set_huge_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
 
-	(void)huge_ptep_set_access_flags(dst_vma, dst_addr, dst_pte, _dst_pte,
-					dst_vma->vm_flags & VM_WRITE);
 	hugetlb_count_add(pages_per_huge_page(h), dst_mm);
 
 	/* No need to invalidate - it was non-present before */
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-rmap-simplify-the-hugetlb-handling-when-unmapping-or-migration.patch
arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page.patch
arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page-fix.patch

