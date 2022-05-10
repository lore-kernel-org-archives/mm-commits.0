Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83AEFC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 21:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiEJVcr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 17:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiEJVcr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 17:32:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE1E1796C5
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 14:32:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE0C7B81FEC
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 21:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7431EC385CA;
        Tue, 10 May 2022 21:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652218362;
        bh=k5i6dHeEeeszr83cF0GiPMYrnXkJRb4omA+RCSdL/q8=;
        h=Date:To:From:Subject:From;
        b=Jv/MZXO+NGdLZZJPUou9I4dMfJDMYJBzNcaG0zeBOSVpMtVx65FoeUqMfIpObjyAc
         v0bar42mlN/jERVs2qZv0isWU5sFrI1qNy2Gy+pHWwGtQovdLS7wc2TCnybj9jijgY
         9U/HQ8jZ3zEE0WcekdEMeHhdYHrrK/fRlq4ALDmg=
Date:   Tue, 10 May 2022 14:32:41 -0700
To:     mm-commits@vger.kernel.org, ysato@users.osdn.me, will@kernel.org,
        tsbogend@alpha.franken.de, svens@linux.ibm.com,
        songmuchun@bytedance.com, paulus@samba.org, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, James.Bottomley@HansenPartnership.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, deller@gmx.de, davem@davemloft.net,
        dalias@libc.org, catalin.marinas@arm.com,
        borntraeger@linux.ibm.com, benh@kernel.crashing.org, arnd@arndb.de,
        agordeev@linux.ibm.com, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-unmapping.patch added to mm-unstable branch
Message-Id: <20220510213242.7431EC385CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rmap: fix CONT-PTE/PMD size hugetlb issue when unmapping
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-unmapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-unmapping.patch

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

Link: https://lkml.kernel.org/r/730ea4b6d292f32fb10b7a4e87dad49b0eb30474.1652147571.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
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

mm-change-huge_ptep_clear_flush-to-return-the-original-pte.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-unmapping.patch

