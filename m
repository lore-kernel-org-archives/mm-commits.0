Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D07C0015E
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjFSXXw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjFSXWT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:22:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E91B171F
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F5B160FB6
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEFD9C433C0;
        Mon, 19 Jun 2023 23:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216920;
        bh=zE4SY35lkuTEAg0bNXuoo6QjQpcJrnKXcg7K4nyp1OQ=;
        h=Date:To:From:Subject:From;
        b=gdodUw/NZH6G6MgX+13nhkrkYUCupE0VrcmoMCLB39ETSI4YD/z9cxUycbpup426e
         /aBfCMGGHHfrcxhxXjGi4tlp5URHFJaMADQOMHEdUvjkAr4ql89Qth56DdyCqPfCBj
         vCGJ20veMcI7OtsJFigMkivvIO3Ra+jQUofg8dp0=
Date:   Mon, 19 Jun 2023 16:22:00 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        zackr@vmware.com, yuzhao@google.com, ying.huang@intel.com,
        willy@infradead.org, will@kernel.org,
        thomas.hellstrom@linux.intel.com, surenb@google.com,
        steven.price@arm.com, song@kernel.org, sj@kernel.org,
        shy828301@gmail.com, ryan.roberts@arm.com, rppt@kernel.org,
        rcampbell@nvidia.com, peterz@infradead.org, peterx@redhat.com,
        pasha.tatashin@soleen.com, naoya.horiguchi@nec.com,
        minchan@kernel.org, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, lstoakes@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jgg@ziepe.ca, ira.weiny@intel.com, hch@infradead.org,
        david@redhat.com, christophe.leroy@csgroup.eu,
        axelrasmussen@google.com, apopple@nvidia.com,
        anshuman.khandual@arm.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-split-huge-pmd-under-one-pte_offset_map.patch removed from -mm tree
Message-Id: <20230619232200.BEFD9C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: split huge pmd under one pte_offset_map()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-split-huge-pmd-under-one-pte_offset_map.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/huge_memory: split huge pmd under one pte_offset_map()
Date: Thu, 8 Jun 2023 18:41:31 -0700 (PDT)

__split_huge_zero_page_pmd() use a single pte_offset_map() to sweep the
extent: it's already under pmd_lock(), so this is no worse for latency;
and since it's supposed to have full control of the just-withdrawn page
table, here choose to VM_BUG_ON if it were to fail.  And please don't
increment haddr by PAGE_SIZE, that should remain huge aligned: declare a
separate addr (not a bugfix, but it was deceptive).

__split_huge_pmd_locked() likewise (but it had declared a separate addr);
and change its BUG_ON(!pte_none) to VM_BUG_ON, for consistency with zero
(those deposited page tables are sometimes victims of random corruption).

Link: https://lkml.kernel.org/r/90cbed7f-90d9-b779-4a46-d2485baf9595@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zack Rusin <zackr@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-split-huge-pmd-under-one-pte_offset_map
+++ a/mm/huge_memory.c
@@ -2037,6 +2037,8 @@ static void __split_huge_zero_page_pmd(s
 	struct mm_struct *mm = vma->vm_mm;
 	pgtable_t pgtable;
 	pmd_t _pmd, old_pmd;
+	unsigned long addr;
+	pte_t *pte;
 	int i;
 
 	/*
@@ -2052,17 +2054,20 @@ static void __split_huge_zero_page_pmd(s
 	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
 	pmd_populate(mm, &_pmd, pgtable);
 
-	for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
-		pte_t *pte, entry;
-		entry = pfn_pte(my_zero_pfn(haddr), vma->vm_page_prot);
+	pte = pte_offset_map(&_pmd, haddr);
+	VM_BUG_ON(!pte);
+	for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
+		pte_t entry;
+
+		entry = pfn_pte(my_zero_pfn(addr), vma->vm_page_prot);
 		entry = pte_mkspecial(entry);
 		if (pmd_uffd_wp(old_pmd))
 			entry = pte_mkuffd_wp(entry);
-		pte = pte_offset_map(&_pmd, haddr);
 		VM_BUG_ON(!pte_none(*pte));
-		set_pte_at(mm, haddr, pte, entry);
-		pte_unmap(pte);
+		set_pte_at(mm, addr, pte, entry);
+		pte++;
 	}
+	pte_unmap(pte - 1);
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(mm, pmd, pgtable);
 }
@@ -2077,6 +2082,7 @@ static void __split_huge_pmd_locked(stru
 	bool young, write, soft_dirty, pmd_migration = false, uffd_wp = false;
 	bool anon_exclusive = false, dirty = false;
 	unsigned long addr;
+	pte_t *pte;
 	int i;
 
 	VM_BUG_ON(haddr & ~HPAGE_PMD_MASK);
@@ -2205,8 +2211,10 @@ static void __split_huge_pmd_locked(stru
 	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
 	pmd_populate(mm, &_pmd, pgtable);
 
+	pte = pte_offset_map(&_pmd, haddr);
+	VM_BUG_ON(!pte);
 	for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
-		pte_t entry, *pte;
+		pte_t entry;
 		/*
 		 * Note that NUMA hinting access restrictions are not
 		 * transferred to avoid any possibility of altering
@@ -2249,11 +2257,11 @@ static void __split_huge_pmd_locked(stru
 				entry = pte_mkuffd_wp(entry);
 			page_add_anon_rmap(page + i, vma, addr, false);
 		}
-		pte = pte_offset_map(&_pmd, addr);
-		BUG_ON(!pte_none(*pte));
+		VM_BUG_ON(!pte_none(*pte));
 		set_pte_at(mm, addr, pte, entry);
-		pte_unmap(pte);
+		pte++;
 	}
+	pte_unmap(pte - 1);
 
 	if (!pmd_migration)
 		page_remove_rmap(page, vma, true);
_

Patches currently in -mm which might be from hughd@google.com are


