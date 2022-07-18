Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF94CCA486
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbiGRASQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233159AbiGRARR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:17:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BB313CE8
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:17:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F011CB80EEC
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FECFC3411E;
        Mon, 18 Jul 2022 00:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103429;
        bh=Q+92tV46i+dBh5J/rps7fsjhg3l7VZRugSLy4mN8xTg=;
        h=Date:To:From:Subject:From;
        b=QGdfuSM44fW4nf8ugQfzK8zKv1q/2ZBbSkb+NLhs9xK+yTTmc0+vV2aWnm5mMWj9c
         ImWcAIjgmceFRL1CSIX2ChVFleOGuE0O8AoP8sbrWJ05P2yjNy0BwvK5Qs3Q/QVUU7
         1az0iJ4basqubmzUtZeHCxnvObKmbC6WAhcKbXQc=
Date:   Sun, 17 Jul 2022 17:17:08 -0700
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
Subject: [merged mm-stable] arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page.patch removed from -mm tree
Message-Id: <20220718001709.7FECFC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64/hugetlb: implement arm64 specific hugetlb_mask_last_page
has been removed from the -mm tree.  Its filename was
     arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[baolin.wang@linux.alibaba.com: fix build]
  Link: https://lkml.kernel.org/r/a14e7b39-6a8a-4609-b4a1-84ac574f5c96@linux.alibaba.com
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

 arch/arm64/mm/hugetlbpage.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/arch/arm64/mm/hugetlbpage.c~arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -368,6 +368,28 @@ pte_t *huge_pte_offset(struct mm_struct
 	return NULL;
 }
 
+unsigned long hugetlb_mask_last_page(struct hstate *h)
+{
+	unsigned long hp_size = huge_page_size(h);
+
+	switch (hp_size) {
+#ifndef __PAGETABLE_PMD_FOLDED
+	case PUD_SIZE:
+		return PGDIR_SIZE - PUD_SIZE;
+#endif
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


