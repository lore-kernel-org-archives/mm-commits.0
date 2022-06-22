Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 378ECC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 22 Jun 2022 01:02:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350727AbiFVBCL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jun 2022 21:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245332AbiFVBCJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2022 21:02:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B28F3206A
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 18:02:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED08B617F4
        for <mm-commits@vger.kernel.org>; Wed, 22 Jun 2022 01:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B29AC341C4;
        Wed, 22 Jun 2022 01:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655859726;
        bh=U51Yhy+thfxcnwzS+TPXgcTExOxb1GfAMV1EAA0n7Lo=;
        h=Date:To:From:Subject:From;
        b=V6a4gnpJS78lLc16ffVegUkfdxrlKr6CVI9BXBBOCogBBbgDE2mVy+BXDh/uGU25b
         ehLE3GBZdhtW7/kyY+ntJ0BYmhBywL7SMlsySBwgJE+Eh7riv2Nh/KMO5jgw9L2OEw
         ovFDjENhcIxwTg7hilpye26wiVvJvniNhN2AxZYc=
Date:   Tue, 21 Jun 2022 18:01:56 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        songmuchun@bytedance.com, peterx@redhat.com,
        paul.walmsley@sifive.com, naoya.horiguchi@linux.dev,
        mike.kravetz@oracle.com, mhocko@suse.com, lkp@intel.com,
        jthoughton@google.com, eike-kernel@sf-tec.de, david@redhat.com,
        catalin.marinas@arm.com, borntraeger@linux.ibm.com,
        anshuman.khandual@arm.com, aneesh.kumar@linux.vnet.ibm.com,
        almasrymina@google.com, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page.patch added to mm-unstable branch
Message-Id: <20220622010204.4B29AC341C4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64/hugetlb: implement arm64 specific hugetlb_mask_last_page
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page.patch

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
Subject: arm64/hugetlb: implement arm64 specific hugetlb_mask_last_page
Date: Tue, 21 Jun 2022 16:56:18 -0700

The HugeTLB address ranges are linearly scanned during fork, unmap and
remap operations, and the linear scan can skip to the end of range mapped
by the page table page if hitting a non-present entry, which can help to
speed linear scanning of the HugeTLB address ranges.

So hugetlb_mask_last_page() is introduced to help to update the address in
the loop of HugeTLB linear scanning with getting the last huge page mapped
by the associated page table page[1], when a non-present entry is
encountered.

Considering ARM64 specific cont-pte/pmd size HugeTLB, this patch
implemented an ARM64 specific hugetlb_mask_last_page() to help this case.

[1] https://lore.kernel.org/linux-mm/20220527225849.284839-1-mike.kravetz@oracle.com/

Link: https://lkml.kernel.org/r/20220621235620.291305-3-mike.kravetz@oracle.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/hugetlbpage.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/arch/arm64/mm/hugetlbpage.c~arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -368,6 +368,26 @@ pte_t *huge_pte_offset(struct mm_struct
 	return NULL;
 }
 
+unsigned long hugetlb_mask_last_page(struct hstate *h)
+{
+	unsigned long hp_size = huge_page_size(h);
+
+	switch (hp_size) {
+	case PUD_SIZE:
+		return PGDIR_SIZE - PUD_SIZE;
+	case CONT_PMD_SIZE:
+		return PUD_SIZE - CONT_PMD_SIZE;
+	case PMD_SIZE:
+		return PUD_SIZE - PMD_SIZE;
+	case CONT_PTE_SIZE:
+		return PMD_SIZE - CONT_PTE_SIZE;
+	default:
+		break;
+	}
+
+	return 0UL;
+}
+
 pte_t arch_make_huge_pte(pte_t entry, unsigned int shift, vm_flags_t flags)
 {
 	size_t pagesize = 1UL << shift;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-damon-use-set_huge_pte_at-to-make-huge-pte-old.patch
mm-hugetlb-remove-unnecessary-huge_ptep_set_access_flags-in-hugetlb_mcopy_atomic_pte.patch
mm-rmap-simplify-the-hugetlb-handling-when-unmapping-or-migration.patch
arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page.patch

