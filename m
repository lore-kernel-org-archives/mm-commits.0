Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEDA3C00140
	for <mm-commits@archiver.kernel.org>; Tue,  9 Aug 2022 01:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244767AbiHIBOc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Aug 2022 21:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244801AbiHIBO2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Aug 2022 21:14:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11BC1DA69
        for <mm-commits@vger.kernel.org>; Mon,  8 Aug 2022 18:14:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DF016116C
        for <mm-commits@vger.kernel.org>; Tue,  9 Aug 2022 01:14:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED2EC433D7;
        Tue,  9 Aug 2022 01:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660007662;
        bh=/zwXDgYI6+qD9iP0N+8WNu/C3y35g4Apj9bpFL0ZZAc=;
        h=Date:To:From:Subject:From;
        b=iHTOvzPj0vIjt2iSunlaXH30yiqYxjpy0XPQQ2N4TV0i5IjnEB+j8bU5CdXilExET
         A5L3pKiKMrK4Ymvnjgx5sZibaDB/jN8GoBV1aQ4Xs30mgb66GaCPhhuHvM0bxC59RL
         rIuvyB9OtfOWJDRwOdl5rwtzJxcnoov1yAXBHkRY=
Date:   Mon, 08 Aug 2022 18:14:22 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        mike.kravetz@oracle.com, duanxiongchun@bytedance.com,
        david@redhat.com, corbet@lwn.net, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-use-ptrs_per_pte-instead-of-pmd_size-page_size.patch removed from -mm tree
Message-Id: <20220809011422.CED2EC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: use PTRS_PER_PTE instead of PMD_SIZE / PAGE_SIZE
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-use-ptrs_per_pte-instead-of-pmd_size-page_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: use PTRS_PER_PTE instead of PMD_SIZE / PAGE_SIZE
Date: Tue, 28 Jun 2022 17:22:35 +0800

There is already a macro PTRS_PER_PTE to represent the number of page
table entries, just use it.

Link: https://lkml.kernel.org/r/20220628092235.91270-9-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Will Deacon <will@kernel.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-use-ptrs_per_pte-instead-of-pmd_size-page_size
+++ a/mm/hugetlb_vmemmap.c
@@ -48,7 +48,7 @@ static int __split_vmemmap_huge_pmd(pmd_
 
 	pmd_populate_kernel(&init_mm, &__pmd, pgtable);
 
-	for (i = 0; i < PMD_SIZE / PAGE_SIZE; i++, addr += PAGE_SIZE) {
+	for (i = 0; i < PTRS_PER_PTE; i++, addr += PAGE_SIZE) {
 		pte_t entry, *pte;
 		pgprot_t pgprot = PAGE_KERNEL;
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


