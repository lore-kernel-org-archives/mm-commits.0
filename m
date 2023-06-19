Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18571EB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjFSXWF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjFSXVO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:21:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A416E74
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3D5B60F87
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3917CC433C8;
        Mon, 19 Jun 2023 23:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216867;
        bh=k3aDquLt5NRm1DMMAIsDTBvxPdbzKmbdnwXJILsVwZk=;
        h=Date:To:From:Subject:From;
        b=F/7x6bFvzj27YnYZvmU7eJipJ5pNhNIk0ng+AvqilcLruau2XuR+1OpuORwMjsv12
         /MUGtOpBR7iu1CQSkHaIjxlohc+P5CGFXSC9pM4Pd3EsQ4AqF6aaXzHsXpkrsOgrbm
         rbGfapRG4qccnLy5i6BEJriYUiLkhJwbkAzb22JM=
Date:   Mon, 19 Jun 2023 16:21:06 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, will@kernel.org, tsbogend@alpha.franken.de,
        tglx@linutronix.de, surenb@google.com, rppt@kernel.org,
        peterz@infradead.org, palmer@dabbelt.com, mpe@ellerman.id.au,
        monstr@monstr.eu, mingo@kernel.org, mike.kravetz@oracle.com,
        linux@armlinux.org.uk, kirill.shutemov@linux.intel.com,
        jcmvbkbc@gmail.com, imbrenda@linux.ibm.com, hpa@zytor.com,
        hca@linux.ibm.com, glaubitz@physik.fu-berlin.de,
        gerg@linux-m68k.org, geert@linux-m68k.org, deller@gmx.de,
        david@redhat.com, davem@davemloft.net, dave.anglin@bell.net,
        chris@zankel.net, catalin.marinas@arm.com,
        borntraeger@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        alexghiti@rivosinc.com, agordeev@linux.ibm.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-allow-pte_offset_map_lock-to-fail.patch removed from -mm tree
Message-Id: <20230619232107.3917CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: s390: allow pte_offset_map_lock() to fail
has been removed from the -mm tree.  Its filename was
     s390-allow-pte_offset_map_lock-to-fail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: s390: allow pte_offset_map_lock() to fail
Date: Thu, 8 Jun 2023 12:27:22 -0700 (PDT)

In rare transient cases, not yet made possible, pte_offset_map() and
pte_offset_map_lock() may not find a page table: handle appropriately.

Add comment on mm's contract with s390 above __zap_zero_pages(),
and fix old comment there: must be called after THP was disabled.

Link: https://lkml.kernel.org/r/3ff29363-336a-9733-12a1-5c31a45c8aeb@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: John David Anglin <dave.anglin@bell.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/uv.c  |    2 ++
 arch/s390/mm/gmap.c    |    9 ++++++++-
 arch/s390/mm/pgtable.c |   12 +++++++++---
 3 files changed, 19 insertions(+), 4 deletions(-)

--- a/arch/s390/kernel/uv.c~s390-allow-pte_offset_map_lock-to-fail
+++ a/arch/s390/kernel/uv.c
@@ -294,6 +294,8 @@ again:
 
 	rc = -ENXIO;
 	ptep = get_locked_pte(gmap->mm, uaddr, &ptelock);
+	if (!ptep)
+		goto out;
 	if (pte_present(*ptep) && !(pte_val(*ptep) & _PAGE_INVALID) && pte_write(*ptep)) {
 		page = pte_page(*ptep);
 		rc = -EAGAIN;
--- a/arch/s390/mm/gmap.c~s390-allow-pte_offset_map_lock-to-fail
+++ a/arch/s390/mm/gmap.c
@@ -2537,7 +2537,12 @@ static inline void thp_split_mm(struct m
  * Remove all empty zero pages from the mapping for lazy refaulting
  * - This must be called after mm->context.has_pgste is set, to avoid
  *   future creation of zero pages
- * - This must be called after THP was enabled
+ * - This must be called after THP was disabled.
+ *
+ * mm contracts with s390, that even if mm were to remove a page table,
+ * racing with the loop below and so causing pte_offset_map_lock() to fail,
+ * it will never insert a page table containing empty zero pages once
+ * mm_forbids_zeropage(mm) i.e. mm->context.has_pgste is set.
  */
 static int __zap_zero_pages(pmd_t *pmd, unsigned long start,
 			   unsigned long end, struct mm_walk *walk)
@@ -2549,6 +2554,8 @@ static int __zap_zero_pages(pmd_t *pmd,
 		spinlock_t *ptl;
 
 		ptep = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+		if (!ptep)
+			break;
 		if (is_zero_pfn(pte_pfn(*ptep)))
 			ptep_xchg_direct(walk->mm, addr, ptep, __pte(_PAGE_INVALID));
 		pte_unmap_unlock(ptep, ptl);
--- a/arch/s390/mm/pgtable.c~s390-allow-pte_offset_map_lock-to-fail
+++ a/arch/s390/mm/pgtable.c
@@ -829,7 +829,7 @@ int set_guest_storage_key(struct mm_stru
 	default:
 		return -EFAULT;
 	}
-
+again:
 	ptl = pmd_lock(mm, pmdp);
 	if (!pmd_present(*pmdp)) {
 		spin_unlock(ptl);
@@ -850,6 +850,8 @@ int set_guest_storage_key(struct mm_stru
 	spin_unlock(ptl);
 
 	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+	if (!ptep)
+		goto again;
 	new = old = pgste_get_lock(ptep);
 	pgste_val(new) &= ~(PGSTE_GR_BIT | PGSTE_GC_BIT |
 			    PGSTE_ACC_BITS | PGSTE_FP_BIT);
@@ -938,7 +940,7 @@ int reset_guest_reference_bit(struct mm_
 	default:
 		return -EFAULT;
 	}
-
+again:
 	ptl = pmd_lock(mm, pmdp);
 	if (!pmd_present(*pmdp)) {
 		spin_unlock(ptl);
@@ -955,6 +957,8 @@ int reset_guest_reference_bit(struct mm_
 	spin_unlock(ptl);
 
 	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+	if (!ptep)
+		goto again;
 	new = old = pgste_get_lock(ptep);
 	/* Reset guest reference bit only */
 	pgste_val(new) &= ~PGSTE_GR_BIT;
@@ -1000,7 +1004,7 @@ int get_guest_storage_key(struct mm_stru
 	default:
 		return -EFAULT;
 	}
-
+again:
 	ptl = pmd_lock(mm, pmdp);
 	if (!pmd_present(*pmdp)) {
 		spin_unlock(ptl);
@@ -1017,6 +1021,8 @@ int get_guest_storage_key(struct mm_stru
 	spin_unlock(ptl);
 
 	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+	if (!ptep)
+		goto again;
 	pgste = pgste_get_lock(ptep);
 	*key = (pgste_val(pgste) & (PGSTE_ACC_BITS | PGSTE_FP_BIT)) >> 56;
 	paddr = pte_val(*ptep) & PAGE_MASK;
_

Patches currently in -mm which might be from hughd@google.com are


