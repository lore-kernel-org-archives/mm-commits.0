Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADF51EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjFSXWD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjFSXVO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:21:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F1010E6
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 002FD60F73
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B2FC433CB;
        Mon, 19 Jun 2023 23:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216864;
        bh=k8bRxu39aU2+6A2pV950qlm0FWrm+I82kpXvcK6eGs8=;
        h=Date:To:From:Subject:From;
        b=HYLdZsZGFl60rexGkAdJ1A0U1524MJ8PPTWKDxjbpsoJ4GKzVK2XdmGjaX3ye+hn8
         aOoJIriWVovXUtJVA1l105U0zUQBa73V8WNZR3JLO2s33eHWmjK9KxWqdsM638776r
         BGySwipxpaTvLo0tA2IyM07zws/IwdwX1JwXNxR8=
Date:   Mon, 19 Jun 2023 16:21:03 -0700
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
Subject: [merged mm-stable] powerpc-hugetlb-pte_alloc_huge.patch removed from -mm tree
Message-Id: <20230619232104.50B2FC433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc/hugetlb: pte_alloc_huge()
has been removed from the -mm tree.  Its filename was
     powerpc-hugetlb-pte_alloc_huge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: powerpc/hugetlb: pte_alloc_huge()
Date: Thu, 8 Jun 2023 12:24:32 -0700 (PDT)

pte_alloc_map() expects to be followed by pte_unmap(), but hugetlb omits
that: to keep balance in future, use the recently added pte_alloc_huge()
instead.  huge_pte_offset() is using __find_linux_pte(), which is using
pte_offset_kernel() - don't rename that to _huge, it's more complicated.

Link: https://lkml.kernel.org/r/36b4e5d-954b-8569-4fe2-bd1797362441@google.com
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

 arch/powerpc/mm/hugetlbpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/hugetlbpage.c~powerpc-hugetlb-pte_alloc_huge
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -183,7 +183,7 @@ pte_t *huge_pte_alloc(struct mm_struct *
 		return NULL;
 
 	if (IS_ENABLED(CONFIG_PPC_8xx) && pshift < PMD_SHIFT)
-		return pte_alloc_map(mm, (pmd_t *)hpdp, addr);
+		return pte_alloc_huge(mm, (pmd_t *)hpdp, addr);
 
 	BUG_ON(!hugepd_none(*hpdp) && !hugepd_ok(*hpdp));
 
_

Patches currently in -mm which might be from hughd@google.com are


