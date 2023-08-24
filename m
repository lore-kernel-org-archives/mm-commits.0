Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 126E0C727A1
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244045AbjHXXWA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244046AbjHXXVd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B382FA1
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0098563676
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CC8C433C7;
        Thu, 24 Aug 2023 23:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919290;
        bh=NZtdWPAKjOeoZ1KO/bJZfJhm3RfwV3pBzfzR750ABu4=;
        h=Date:To:From:Subject:From;
        b=B67ZMjeaDhj2PLztCGS7k40TE4xLzg4W7EwBmYyJzrgRajA0D3R1HRuGQvZm1qKKD
         z7oWebp4wL/9sKPqU9IW7xIDVJU694J/tl8Ye+ErSAWfjdPHwuJHKnm9O3+ae1d5cG
         menBS0lr1dQugB24p9c7Xspz15UMWbon7Ho875HQ=
Date:   Thu, 24 Aug 2023 16:21:29 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, monstr@monstr.eu,
        arnd@arndb.de, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] microblaze-implement-the-new-page-table-range-api.patch removed from -mm tree
Message-Id: <20230824232130.58CC8C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: microblaze: implement the new page table range API
has been removed from the -mm tree.  Its filename was
     microblaze-implement-the-new-page-table-range-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: microblaze: implement the new page table range API
Date: Wed, 2 Aug 2023 16:13:44 +0100

Rename PFN_SHIFT_OFFSET to PTE_PFN_SHIFT.  Change the calling convention
for set_pte() to be the same as other architectures.  Add
update_mmu_cache_range(), flush_icache_pages() and flush_dcache_folio().

[arnd@arndb.de: mark flush_dcache_folio() inline]
  Link: https://lkml.kernel.org/r/20230810141947.1236730-9-arnd@kernel.org
Link: https://lkml.kernel.org/r/20230802151406.3735276-17-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/include/asm/cacheflush.h |    8 ++++++++
 arch/microblaze/include/asm/pgtable.h    |   15 ++++-----------
 arch/microblaze/include/asm/tlbflush.h   |    4 +++-
 3 files changed, 15 insertions(+), 12 deletions(-)

--- a/arch/microblaze/include/asm/cacheflush.h~microblaze-implement-the-new-page-table-range-api
+++ a/arch/microblaze/include/asm/cacheflush.h
@@ -74,6 +74,14 @@ do { \
 	flush_dcache_range((unsigned) (addr), (unsigned) (addr) + PAGE_SIZE); \
 } while (0);
 
+static inline void flush_dcache_folio(struct folio *folio)
+{
+	unsigned long addr = folio_pfn(folio) << PAGE_SHIFT;
+
+	flush_dcache_range(addr, addr + folio_size(folio));
+}
+#define flush_dcache_folio flush_dcache_folio
+
 #define flush_cache_page(vma, vmaddr, pfn) \
 	flush_dcache_range(pfn << PAGE_SHIFT, (pfn << PAGE_SHIFT) + PAGE_SIZE);
 
--- a/arch/microblaze/include/asm/pgtable.h~microblaze-implement-the-new-page-table-range-api
+++ a/arch/microblaze/include/asm/pgtable.h
@@ -230,12 +230,12 @@ extern unsigned long empty_zero_page[102
 
 #define pte_page(x)		(mem_map + (unsigned long) \
 				((pte_val(x) - memory_start) >> PAGE_SHIFT))
-#define PFN_SHIFT_OFFSET	(PAGE_SHIFT)
+#define PFN_PTE_SHIFT		PAGE_SHIFT
 
-#define pte_pfn(x)		(pte_val(x) >> PFN_SHIFT_OFFSET)
+#define pte_pfn(x)		(pte_val(x) >> PFN_PTE_SHIFT)
 
 #define pfn_pte(pfn, prot) \
-	__pte(((pte_basic_t)(pfn) << PFN_SHIFT_OFFSET) | pgprot_val(prot))
+	__pte(((pte_basic_t)(pfn) << PFN_PTE_SHIFT) | pgprot_val(prot))
 
 #ifndef __ASSEMBLY__
 /*
@@ -330,14 +330,7 @@ static inline unsigned long pte_update(p
 /*
  * set_pte stores a linux PTE into the linux page table.
  */
-static inline void set_pte(struct mm_struct *mm, unsigned long addr,
-		pte_t *ptep, pte_t pte)
-{
-	*ptep = pte;
-}
-
-static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
-		pte_t *ptep, pte_t pte)
+static inline void set_pte(pte_t *ptep, pte_t pte)
 {
 	*ptep = pte;
 }
--- a/arch/microblaze/include/asm/tlbflush.h~microblaze-implement-the-new-page-table-range-api
+++ a/arch/microblaze/include/asm/tlbflush.h
@@ -33,7 +33,9 @@ static inline void local_flush_tlb_range
 
 #define flush_tlb_kernel_range(start, end)	do { } while (0)
 
-#define update_mmu_cache(vma, addr, ptep)	do { } while (0)
+#define update_mmu_cache_range(vmf, vma, addr, ptep, nr) do { } while (0)
+#define update_mmu_cache(vma, addr, pte) \
+	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
 
 #define flush_tlb_all local_flush_tlb_all
 #define flush_tlb_mm local_flush_tlb_mm
_

Patches currently in -mm which might be from willy@infradead.org are


