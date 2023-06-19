Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD2BFEB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjFSXWF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjFSXVO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:21:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50C110F0
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7335B60F73
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDFCC433C0;
        Mon, 19 Jun 2023 23:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216865;
        bh=u+DqTbZY28TkCN4EpAV8jJrwpt5+n3o49H8IUdpgAX0=;
        h=Date:To:From:Subject:From;
        b=vSdNF+TYvy6qGpYIcQ6o7E0301gWbn2CaRagacOAllUgFHKHULPCKw4EqH1VHWc72
         UXrcLTefM6P59qpnRPjFeruN8MsaEXpwSuaGu0jh0LKScw93YP9Y85W75MGcT1l6Jz
         uVsKGQN063GmStrVETOkECvXEzdQmmVgI3k8/7as=
Date:   Mon, 19 Jun 2023 16:21:05 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, will@kernel.org, tsbogend@alpha.franken.de,
        tglx@linutronix.de, surenb@google.com, rppt@kernel.org,
        peterz@infradead.org, palmer@rivosync.com, palmer@dabbelt.com,
        mpe@ellerman.id.au, monstr@monstr.eu, mingo@kernel.org,
        mike.kravetz@oracle.com, linux@armlinux.org.uk,
        kirill.shutemov@linux.intel.com, jcmvbkbc@gmail.com,
        imbrenda@linux.ibm.com, hpa@zytor.com, hca@linux.ibm.com,
        glaubitz@physik.fu-berlin.de, gerg@linux-m68k.org,
        geert@linux-m68k.org, deller@gmx.de, david@redhat.com,
        davem@davemloft.net, dave.anglin@bell.net, chris@zankel.net,
        catalin.marinas@arm.com, borntraeger@linux.ibm.com,
        aneesh.kumar@linux.ibm.com, alexghiti@rivosinc.com,
        agordeev@linux.ibm.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] riscv-hugetlb-pte_alloc_huge-pte_offset_huge.patch removed from -mm tree
Message-Id: <20230619232105.BBDFCC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: riscv/hugetlb: pte_alloc_huge() pte_offset_huge()
has been removed from the -mm tree.  Its filename was
     riscv-hugetlb-pte_alloc_huge-pte_offset_huge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: riscv/hugetlb: pte_alloc_huge() pte_offset_huge()
Date: Thu, 8 Jun 2023 12:25:42 -0700 (PDT)

pte_alloc_map() expects to be followed by pte_unmap(), but hugetlb omits
that: to keep balance in future, use the recently added pte_alloc_huge()
instead; with pte_offset_huge() a better name for pte_offset_kernel().

Link: https://lkml.kernel.org/r/291f20-5947-9f5f-ec7f-96a18df336d9@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Acked-by: Palmer Dabbelt <palmer@rivosync.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
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

 arch/riscv/mm/hugetlbpage.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/mm/hugetlbpage.c~riscv-hugetlb-pte_alloc_huge-pte_offset_huge
+++ a/arch/riscv/mm/hugetlbpage.c
@@ -43,7 +43,7 @@ pte_t *huge_pte_alloc(struct mm_struct *
 
 	for_each_napot_order(order) {
 		if (napot_cont_size(order) == sz) {
-			pte = pte_alloc_map(mm, pmd, addr & napot_cont_mask(order));
+			pte = pte_alloc_huge(mm, pmd, addr & napot_cont_mask(order));
 			break;
 		}
 	}
@@ -90,7 +90,7 @@ pte_t *huge_pte_offset(struct mm_struct
 
 	for_each_napot_order(order) {
 		if (napot_cont_size(order) == sz) {
-			pte = pte_offset_kernel(pmd, addr & napot_cont_mask(order));
+			pte = pte_offset_huge(pmd, addr & napot_cont_mask(order));
 			break;
 		}
 	}
_

Patches currently in -mm which might be from hughd@google.com are


