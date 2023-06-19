Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF9FEEB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjFSXVk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjFSXVM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:21:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3771810CE
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C293460F51
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA94C433C0;
        Mon, 19 Jun 2023 23:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216856;
        bh=rsW+5t/f9+lV3JN86NEXbAwpyPxU6D40miIBRTFypIY=;
        h=Date:To:From:Subject:From;
        b=aZyq8wqBkPn3Z5SnIqPGMdsVsEIegNA2vZQXowTNm210V3hbI8gI5bkdVhSJTYdCP
         g6X7B/LpJJoq0Qi19Bl/1dvgyGH3iJoxje5/U265839pR9fxRxleWnYtKZsAfMhKyZ
         u5CWXr+LBDu/lVCN2OpdY0dk+Mb2FMYZnqnWvlPk=
Date:   Mon, 19 Jun 2023 16:20:55 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        yuzhao@google.com, willy@infradead.org, will@kernel.org,
        tsbogend@alpha.franken.de, tglx@linutronix.de, surenb@google.com,
        rppt@kernel.org, peterz@infradead.org, palmer@dabbelt.com,
        nathan@kernel.org, mpe@ellerman.id.au, monstr@monstr.eu,
        mingo@kernel.org, mike.kravetz@oracle.com, linux@armlinux.org.uk,
        kirill.shutemov@linux.intel.com, jcmvbkbc@gmail.com,
        imbrenda@linux.ibm.com, hpa@zytor.com, hca@linux.ibm.com,
        glaubitz@physik.fu-berlin.de, gerg@linux-m68k.org,
        geert@linux-m68k.org, deller@gmx.de, david@redhat.com,
        davem@davemloft.net, dave.anglin@bell.net, chris@zankel.net,
        catalin.marinas@arm.com, borntraeger@linux.ibm.com,
        aneesh.kumar@linux.ibm.com, alexghiti@rivosinc.com,
        agordeev@linux.ibm.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mips-add-pte_unmap-to-balance-pte_offset_map.patch removed from -mm tree
Message-Id: <20230619232056.1DA94C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mips: add pte_unmap() to balance pte_offset_map()
has been removed from the -mm tree.  Its filename was
     mips-add-pte_unmap-to-balance-pte_offset_map.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mips: add pte_unmap() to balance pte_offset_map()
Date: Thu, 15 Jun 2023 16:02:43 -0700 (PDT)

To keep balance in future, __update_tlb() remember to pte_unmap() after
pte_offset_map().  This is an odd case, since the caller has already done
pte_offset_map_lock(), then mips forgets the address and recalculates it;
but my two naive attempts to clean that up did more harm than good.

Link: https://lkml.kernel.org/r/addfcb3-b5f4-976e-e050-a2508e589cfe@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Yu Zhao <yuzhao@google.com>
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

 arch/mips/mm/tlb-r4k.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/arch/mips/mm/tlb-r4k.c~mips-add-pte_unmap-to-balance-pte_offset_map
+++ a/arch/mips/mm/tlb-r4k.c
@@ -297,7 +297,7 @@ void __update_tlb(struct vm_area_struct
 	p4d_t *p4dp;
 	pud_t *pudp;
 	pmd_t *pmdp;
-	pte_t *ptep;
+	pte_t *ptep, *ptemap = NULL;
 	int idx, pid;
 
 	/*
@@ -344,7 +344,12 @@ void __update_tlb(struct vm_area_struct
 	} else
 #endif
 	{
-		ptep = pte_offset_map(pmdp, address);
+		ptemap = ptep = pte_offset_map(pmdp, address);
+		/*
+		 * update_mmu_cache() is called between pte_offset_map_lock()
+		 * and pte_unmap_unlock(), so we can assume that ptep is not
+		 * NULL here: and what should be done below if it were NULL?
+		 */
 
 #if defined(CONFIG_PHYS_ADDR_T_64BIT) && defined(CONFIG_CPU_MIPS32)
 #ifdef CONFIG_XPA
@@ -373,6 +378,9 @@ void __update_tlb(struct vm_area_struct
 	tlbw_use_hazard();
 	htw_start();
 	flush_micro_tlb_vm(vma);
+
+	if (ptemap)
+		pte_unmap(ptemap);
 	local_irq_restore(flags);
 }
 
_

Patches currently in -mm which might be from hughd@google.com are


