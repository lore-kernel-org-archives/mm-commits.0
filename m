Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E31CC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:58:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 681D461490
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhD3F7D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:59:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230318AbhD3F67 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:58:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 785FC613A9;
        Fri, 30 Apr 2021 05:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762291;
        bh=nuUza+JiUgpMEFjhqhCVPxYjBmQSGOsx8M5qYIcUOww=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zg77JfCuujGxpll+kVBpAv/qTsdMK+nVVsLQwZaTGkfNYRTOUAOB/SA/+2hl2Az7M
         MlQ124nAgtK3pkfX/WF/5mV1z3vuArIP/JgNNpWiX/JWRImKbtqHT8bgW3zKiH2Frx
         CmIncqNIxz/+EsM2aKiMdi16QTTi8hJCKWZdHNjc=
Date:   Thu, 29 Apr 2021 22:58:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bp@alien8.de, catalin.marinas@arm.com,
        dingtianhong@huawei.com, hch@lst.de, hpa@zytor.com,
        linmiaohe@huawei.com, linux-mm@kvack.org, linux@armlinux.org.uk,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        npiggin@gmail.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, urezki@gmail.com, will@kernel.org
Subject:  [patch 097/178] ARM: mm: add missing pud_page define to
 2-level page tables
Message-ID: <20210430055810.7H3U1d33-%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>
Subject: ARM: mm: add missing pud_page define to 2-level page tables

Patch series "huge vmalloc mappings", v13.

The kernel virtual mapping layer grew support for mapping memory with >
PAGE_SIZE ptes with 0ddab1d2ed664 ("lib/ioremap.c: add huge I/O map
capability interfaces"), and implemented support for using those huge page
mappings with ioremap.

According to the submission, the use-case is mapping very large
non-volatile memory devices, which could be GB or TB. 
https://lore.kernel.org/lkml/1425404664-19675-1-git-send-email-toshi.kani@hp.com/
The benefit is said to be in the overhead of maintaining the mapping,
perhaps both in memory overhead and setup / teardown time.  Memory
overhead for the mapping with a 4kB page and 8 byte page table is 2GB per
TB of mapping, down to 4MB / TB with 2MB pages.

The same huge page vmap infrastructure can be quite easily adapted and
used for mapping vmalloc memory pages without more complexity for arch or
core vmap code.  However unlike ioremap, vmalloc page table overhead is
not a real problem, so the advantage to justify this is performance.

Several of the most structures in the kernel (e.g., vfs and network hash
tables) are allocated with vmalloc on NUMA machines, in order to
distribute access bandwidth over the machine.  Mapping these with larger
pages can improve TLB usage significantly, for example this reduces TLB
misses by nearly 30x on a `git diff` workload on a 2-node POWER9 (59,800
-> 2,100) and reduces CPU cycles by 0.54%, due to vfs hashes being
allocated with 2MB pages.

[ Other numbers?
  - The difference is even larger in a guest due to more costly TLB 
    misses.
  - Eric Dumazet was keen on the network hash performance possibilities.
  - Other archs? Ding was doing x86 testing. ]

The kernel module allocator also uses vmalloc to map module images even on
non-NUMA, which can result in high iTLB pressure on highly modular distro
type of kernels.  This series does not implement huge mappings for modules
yet, but it's a step along the way.  Rick Edgecombe was looking at that
IIRC.

The per-cpu allocator similarly might be able to take advantage of this. 
Also on the todo list.

The disadvantages of this I can see are:
* Memory fragmentation can waste some physical memory because it will 
  attempt to allocate larger pages to fit the required size, rounding up 
  (once the requested size is >= 2MB).
  - I don't see it being a big problem in practice unless some user 
    crops up that allocates thousands of 2.5MB ranges. We can tewak 
    heuristics a bit there if needed to reduce peak waste.
* Less granular mappings can make the NUMA distribution less balanced.
  - Similar to the above.
  - Could also allocate all major system hashes with one allocation
    up-front and spread them all across the one block, which should help
    overall NUMA distribution and reduce fragmentation waste.
* Callers might expect something about the underlying allocated pages.
  - Tried to keep the apperance of base PAGE_SIZE pages throughout the 
    APIs and exposed data structures.
  - Added a VM_NO_HUGE_VMAP flag to hammer troublesome cases with.

- Finally, added a nohugevmalloc boot option to turn it off (independent
  of nohugeiomap).


This patch (of 14):

ARM uses its own PMD folding scheme which is missing pud_page which should
just pass through to pmd_page.  Move this from the 3-level page table to
common header.

Link: https://lkml.kernel.org/r/20210317062402.533919-2-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Ding Tianhong <dingtianhong@huawei.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable-3level.h |    2 --
 arch/arm/include/asm/pgtable.h        |    3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/arch/arm/include/asm/pgtable-3level.h~arm-mm-add-missing-pud_page-define-to-2-level-page-tables
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -186,8 +186,6 @@ static inline pte_t pte_mkspecial(pte_t
 
 #define pmd_write(pmd)		(pmd_isclear((pmd), L_PMD_SECT_RDONLY))
 #define pmd_dirty(pmd)		(pmd_isset((pmd), L_PMD_SECT_DIRTY))
-#define pud_page(pud)		pmd_page(__pmd(pud_val(pud)))
-#define pud_write(pud)		pmd_write(__pmd(pud_val(pud)))
 
 #define pmd_hugewillfault(pmd)	(!pmd_young(pmd) || !pmd_write(pmd))
 #define pmd_thp_or_huge(pmd)	(pmd_huge(pmd) || pmd_trans_huge(pmd))
--- a/arch/arm/include/asm/pgtable.h~arm-mm-add-missing-pud_page-define-to-2-level-page-tables
+++ a/arch/arm/include/asm/pgtable.h
@@ -166,6 +166,9 @@ extern struct page *empty_zero_page;
 
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
+#define pud_page(pud)		pmd_page(__pmd(pud_val(pud)))
+#define pud_write(pud)		pmd_write(__pmd(pud_val(pud)))
+
 #define pmd_none(pmd)		(!pmd_val(pmd))
 
 static inline pte_t *pmd_page_vaddr(pmd_t pmd)
_
