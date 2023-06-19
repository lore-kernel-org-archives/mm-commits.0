Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A39EB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjFSXXL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjFSXVw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:21:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC69128
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D74760F0D
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9EAC433C8;
        Mon, 19 Jun 2023 23:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216906;
        bh=ePbOKkZ1TzwAWJ3DYj0MH0OEHdLFmwNlMnozRWAFKNs=;
        h=Date:To:From:Subject:From;
        b=b2zwviioXcq1EzKIO46z3WQFI4uLjMahs9pcBRkihkeTpkR0rlq0SSuNzC+jM8pa2
         dnhR8LWI4Hbdq4dBxwZE0EOxcUKFQ7miBnsLZmhBZwZQe7CRaYxQ5apGmDEf/hrNzZ
         60imAVMr2rNFgQ4sR13GcQC4s9v+GPB9fD7epwJ0=
Date:   Mon, 19 Jun 2023 16:21:46 -0700
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
Subject: [merged mm-stable] mm-debug_vm_pgtablepage_table_check-warn-pte-map-fails.patch removed from -mm tree
Message-Id: <20230619232146.7F9EAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/debug_vm_pgtable,page_table_check: warn pte map fails
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtablepage_table_check-warn-pte-map-fails.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/debug_vm_pgtable,page_table_check: warn pte map fails
Date: Thu, 8 Jun 2023 18:27:52 -0700 (PDT)

Failures here would be surprising: pte_advanced_tests() and
pte_clear_tests() and __page_table_check_pte_clear_range() each issue a
warning if pte_offset_map() or pte_offset_map_lock() fails.

Link: https://lkml.kernel.org/r/3ea9e4f-e5cf-d7d9-4c2-291b3c5a3636@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
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
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zack Rusin <zackr@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    9 ++++++++-
 mm/page_table_check.c |    2 ++
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtablepage_table_check-warn-pte-map-fails
+++ a/mm/debug_vm_pgtable.c
@@ -138,6 +138,9 @@ static void __init pte_advanced_tests(st
 		return;
 
 	pr_debug("Validating PTE advanced\n");
+	if (WARN_ON(!args->ptep))
+		return;
+
 	pte = pfn_pte(args->pte_pfn, args->page_prot);
 	set_pte_at(args->mm, args->vaddr, args->ptep, pte);
 	flush_dcache_page(page);
@@ -619,6 +622,9 @@ static void __init pte_clear_tests(struc
 	 * the unexpected overhead of cache flushing is acceptable.
 	 */
 	pr_debug("Validating PTE clear\n");
+	if (WARN_ON(!args->ptep))
+		return;
+
 #ifndef CONFIG_RISCV
 	pte = __pte(pte_val(pte) | RANDOM_ORVALUE);
 #endif
@@ -1377,7 +1383,8 @@ static int __init debug_vm_pgtable(void)
 	args.ptep = pte_offset_map_lock(args.mm, args.pmdp, args.vaddr, &ptl);
 	pte_clear_tests(&args);
 	pte_advanced_tests(&args);
-	pte_unmap_unlock(args.ptep, ptl);
+	if (args.ptep)
+		pte_unmap_unlock(args.ptep, ptl);
 
 	ptl = pmd_lock(args.mm, args.pmdp);
 	pmd_clear_tests(&args);
--- a/mm/page_table_check.c~mm-debug_vm_pgtablepage_table_check-warn-pte-map-fails
+++ a/mm/page_table_check.c
@@ -240,6 +240,8 @@ void __page_table_check_pte_clear_range(
 		pte_t *ptep = pte_offset_map(&pmd, addr);
 		unsigned long i;
 
+		if (WARN_ON(!ptep))
+			return;
 		for (i = 0; i < PTRS_PER_PTE; i++) {
 			__page_table_check_pte_clear(mm, addr, *ptep);
 			addr += PAGE_SIZE;
_

Patches currently in -mm which might be from hughd@google.com are


