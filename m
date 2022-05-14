Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33706C433FE
	for <mm-commits@archiver.kernel.org>; Sat, 14 May 2022 19:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbiENTz2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 May 2022 15:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234993AbiENTzX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 May 2022 15:55:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A35377EA
        for <mm-commits@vger.kernel.org>; Sat, 14 May 2022 12:55:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE3B7B80B03
        for <mm-commits@vger.kernel.org>; Sat, 14 May 2022 19:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409A4C340EE;
        Sat, 14 May 2022 19:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652558119;
        bh=YhZHOAzfSyHhpZcRsbG9azxE18EGpr63f8P2OJmDsm8=;
        h=Date:To:From:Subject:From;
        b=Ox7uuKpLhlOyhEGRD5/zYPkk2YKtz+9l6vj4AY+efoqCjxBVYRIl4G245u/M7gEc0
         awc4Cczs8zrOZn8jcn1x0pnTPdB/XznziCLWmFiTr+gS8wNP1ImzA9T5Fct0oV1Fct
         jaa2pzzB7oJVqOdIwyZIKdj8WwSdnNOnS7w0xSjo=
Date:   Sat, 14 May 2022 12:55:18 -0700
To:     mm-commits@vger.kernel.org, ysato@users.osdn.me, will@kernel.org,
        tsbogend@alpha.franken.de, svens@linux.ibm.com,
        songmuchun@bytedance.com, paulus@samba.org, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, James.Bottomley@HansenPartnership.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, deller@gmx.de, david@redhat.com,
        davem@davemloft.net, dalias@libc.org, catalin.marinas@arm.com,
        borntraeger@linux.ibm.com, benh@kernel.crashing.org, arnd@arndb.de,
        agordeev@linux.ibm.com, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration.patch removed from -mm tree
Message-Id: <20220514195519.409A4C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: rmap: fix CONT-PTE/PMD size hugetlb issue when migration
has been removed from the -mm tree.  Its filename was
     mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: rmap: fix CONT-PTE/PMD size hugetlb issue when migration

On some architectures (like ARM64), it can support CONT-PTE/PMD size
hugetlb, which means it can support not only PMD/PUD size hugetlb: 2M and
1G, but also CONT-PTE/PMD size: 64K and 32M if a 4K page size specified.

When migrating a hugetlb page, we will get the relevant page table entry
by huge_pte_offset() only once to nuke it and remap it with a migration
pte entry.  This is correct for PMD or PUD size hugetlb, since they always
contain only one pmd entry or pud entry in the page table.

However this is incorrect for CONT-PTE and CONT-PMD size hugetlb, since
they can contain several continuous pte or pmd entry with same page table
attributes.  So we will nuke or remap only one pte or pmd entry for this
CONT-PTE/PMD size hugetlb page, which is not expected for hugetlb
migration.  The problem is we can still continue to modify the subpages'
data of a hugetlb page during migrating a hugetlb page, which can cause a
serious data consistent issue, since we did not nuke the page table entry
and set a migration pte for the subpages of a hugetlb page.

To fix this issue, we should change to use huge_ptep_clear_flush() to nuke
a hugetlb page table, and remap it with set_huge_pte_at() and
set_huge_swap_pte_at() when migrating a hugetlb page, which already
considered the CONT-PTE or CONT-PMD size hugetlb.

[akpm@linux-foundation.org: fix nommu build]
[baolin.wang@linux.alibaba.com: fix build errors for !CONFIG_MMU]
  Link: https://lkml.kernel.org/r/a4baca670aca637e7198d9ae4543b8873cb224dc.1652270205.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/ea5abf529f0997b5430961012bfda6166c1efc8c.1652147571.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.osdn.me>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   11 +++++++++++
 mm/rmap.c               |   24 ++++++++++++++++++------
 2 files changed, 29 insertions(+), 6 deletions(-)

--- a/include/linux/hugetlb.h~mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration
+++ a/include/linux/hugetlb.h
@@ -1093,6 +1093,17 @@ static inline void set_huge_swap_pte_at(
 					pte_t *ptep, pte_t pte, unsigned long sz)
 {
 }
+
+static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
+					  unsigned long addr, pte_t *ptep)
+{
+	return *ptep;
+}
+
+static inline void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
+				   pte_t *ptep, pte_t pte)
+{
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
--- a/mm/rmap.c~mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration
+++ a/mm/rmap.c
@@ -1926,13 +1926,15 @@ static bool try_to_migrate_one(struct fo
 					break;
 				}
 			}
+
+			/* Nuke the hugetlb page table entry */
+			pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
 		} else {
 			flush_cache_page(vma, address, pte_pfn(*pvmw.pte));
+			/* Nuke the page table entry. */
+			pteval = ptep_clear_flush(vma, address, pvmw.pte);
 		}
 
-		/* Nuke the page table entry. */
-		pteval = ptep_clear_flush(vma, address, pvmw.pte);
-
 		/* Set the dirty flag on the folio now the pte is gone. */
 		if (pte_dirty(pteval))
 			folio_mark_dirty(folio);
@@ -2017,7 +2019,10 @@ static bool try_to_migrate_one(struct fo
 			pte_t swp_pte;
 
 			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
-				set_pte_at(mm, address, pvmw.pte, pteval);
+				if (folio_test_hugetlb(folio))
+					set_huge_pte_at(mm, address, pvmw.pte, pteval);
+				else
+					set_pte_at(mm, address, pvmw.pte, pteval);
 				ret = false;
 				page_vma_mapped_walk_done(&pvmw);
 				break;
@@ -2026,7 +2031,10 @@ static bool try_to_migrate_one(struct fo
 				       !anon_exclusive, subpage);
 			if (anon_exclusive &&
 			    page_try_share_anon_rmap(subpage)) {
-				set_pte_at(mm, address, pvmw.pte, pteval);
+				if (folio_test_hugetlb(folio))
+					set_huge_pte_at(mm, address, pvmw.pte, pteval);
+				else
+					set_pte_at(mm, address, pvmw.pte, pteval);
 				ret = false;
 				page_vma_mapped_walk_done(&pvmw);
 				break;
@@ -2052,7 +2060,11 @@ static bool try_to_migrate_one(struct fo
 				swp_pte = pte_swp_mksoft_dirty(swp_pte);
 			if (pte_uffd_wp(pteval))
 				swp_pte = pte_swp_mkuffd_wp(swp_pte);
-			set_pte_at(mm, address, pvmw.pte, swp_pte);
+			if (folio_test_hugetlb(folio))
+				set_huge_swap_pte_at(mm, address, pvmw.pte,
+						     swp_pte, vma_mmu_pagesize(vma));
+			else
+				set_pte_at(mm, address, pvmw.pte, swp_pte);
 			trace_set_migration_pte(address, pte_val(swp_pte),
 						compound_order(&folio->page));
 			/*
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


