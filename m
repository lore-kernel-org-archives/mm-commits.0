Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB28C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 14 May 2022 19:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbiENTz1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 May 2022 15:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234999AbiENTzY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 May 2022 15:55:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29327377EB
        for <mm-commits@vger.kernel.org>; Sat, 14 May 2022 12:55:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C32A4B80AFE
        for <mm-commits@vger.kernel.org>; Sat, 14 May 2022 19:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FE5C34117;
        Sat, 14 May 2022 19:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652558120;
        bh=/k8x09qzXW9YyWPz9NzTNyNRUMmYkvkHTqkv1eJmJHQ=;
        h=Date:To:From:Subject:From;
        b=V5x3pdUQDUIhgrbJzb+zMlyhkNd8ELxai5rRNsYAl8k4CQH9UvOf5lelwibCUjxTy
         K4QN0VfgR9j/7WyZdjmT+TxjnmD/Rij08R3dN7iko38YCaUaKmNTN887a+9BOF2Zg1
         CCx3alnMMiPjxZyowZBFUPUHlsDlyc4v5esjQmWs=
Date:   Sat, 14 May 2022 12:55:19 -0700
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
Subject: [merged mm-stable] mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-unmapping.patch removed from -mm tree
Message-Id: <20220514195520.86FE5C34117@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: rmap: fix CONT-PTE/PMD size hugetlb issue when unmapping
has been removed from the -mm tree.  Its filename was
     mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-unmapping.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: rmap: fix CONT-PTE/PMD size hugetlb issue when unmapping

On some architectures (like ARM64), it can support CONT-PTE/PMD size
hugetlb, which means it can support not only PMD/PUD size hugetlb: 2M and
1G, but also CONT-PTE/PMD size: 64K and 32M if a 4K page size specified.

When unmapping a hugetlb page, we will get the relevant page table entry
by huge_pte_offset() only once to nuke it.  This is correct for PMD or PUD
size hugetlb, since they always contain only one pmd entry or pud entry in
the page table.

However this is incorrect for CONT-PTE and CONT-PMD size hugetlb, since
they can contain several continuous pte or pmd entry with same page table
attributes, so we will nuke only one pte or pmd entry for this
CONT-PTE/PMD size hugetlb page.

And now try_to_unmap() is only passed a hugetlb page in the case where the
hugetlb page is poisoned.  Which means now we will unmap only one pte
entry for a CONT-PTE or CONT-PMD size poisoned hugetlb page, and we can
still access other subpages of a CONT-PTE or CONT-PMD size poisoned
hugetlb page, which will cause serious issues possibly.

So we should change to use huge_ptep_clear_flush() to nuke the hugetlb
page table to fix this issue, which already considered CONT-PTE and
CONT-PMD size hugetlb.

We've already used set_huge_swap_pte_at() to set a poisoned swap entry for
a poisoned hugetlb page.  Meanwhile adding a VM_BUG_ON() to make sure the
passed hugetlb page is poisoned in try_to_unmap().

Link: https://lkml.kernel.org/r/0a2e547238cad5bc153a85c3e9658cb9d55f9cac.1652270205.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/730ea4b6d292f32fb10b7a4e87dad49b0eb30474.1652147571.git.baolin.wang@linux.alibaba.com
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

 mm/rmap.c |   39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

--- a/mm/rmap.c~mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-unmapping
+++ a/mm/rmap.c
@@ -1528,6 +1528,11 @@ static bool try_to_unmap_one(struct foli
 
 		if (folio_test_hugetlb(folio)) {
 			/*
+			 * The try_to_unmap() is only passed a hugetlb page
+			 * in the case where the hugetlb page is poisoned.
+			 */
+			VM_BUG_ON_PAGE(!PageHWPoison(subpage), subpage);
+			/*
 			 * huge_pmd_unshare may unmap an entire PMD page.
 			 * There is no way of knowing exactly which PMDs may
 			 * be cached for this mm, so we must flush them all.
@@ -1562,28 +1567,28 @@ static bool try_to_unmap_one(struct foli
 					break;
 				}
 			}
+			pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
 		} else {
 			flush_cache_page(vma, address, pte_pfn(*pvmw.pte));
-		}
-
-		/*
-		 * Nuke the page table entry. When having to clear
-		 * PageAnonExclusive(), we always have to flush.
-		 */
-		if (should_defer_flush(mm, flags) && !anon_exclusive) {
 			/*
-			 * We clear the PTE but do not flush so potentially
-			 * a remote CPU could still be writing to the folio.
-			 * If the entry was previously clean then the
-			 * architecture must guarantee that a clear->dirty
-			 * transition on a cached TLB entry is written through
-			 * and traps if the PTE is unmapped.
+			 * Nuke the page table entry. When having to clear
+			 * PageAnonExclusive(), we always have to flush.
 			 */
-			pteval = ptep_get_and_clear(mm, address, pvmw.pte);
+			if (should_defer_flush(mm, flags) && !anon_exclusive) {
+				/*
+				 * We clear the PTE but do not flush so potentially
+				 * a remote CPU could still be writing to the folio.
+				 * If the entry was previously clean then the
+				 * architecture must guarantee that a clear->dirty
+				 * transition on a cached TLB entry is written through
+				 * and traps if the PTE is unmapped.
+				 */
+				pteval = ptep_get_and_clear(mm, address, pvmw.pte);
 
-			set_tlb_ubc_flush_pending(mm, pte_dirty(pteval));
-		} else {
-			pteval = ptep_clear_flush(vma, address, pvmw.pte);
+				set_tlb_ubc_flush_pending(mm, pte_dirty(pteval));
+			} else {
+				pteval = ptep_clear_flush(vma, address, pvmw.pte);
+			}
 		}
 
 		/*
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


