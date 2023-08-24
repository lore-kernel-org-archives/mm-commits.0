Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4585CEE49BA
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241361AbjHXXV5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244037AbjHXXV2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889F2E51
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67FEE64452
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB2FC433C7;
        Thu, 24 Aug 2023 23:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919285;
        bh=gTuuHdyLgH/d7lu+4MPTdBTcD0qrt8nKWPN1oLp3rQY=;
        h=Date:To:From:Subject:From;
        b=q8goODisbkaQu/Hxm2VTfYtv13wsNasfyTIeTIHk/jCViFljR5yFhnh3Osr87UB/s
         vy6wZ2csYUISULu7ZVCrGQWKcy/X+c9mrJzg8yzRDgsjQD1StLJ17V2NsNa+YYAbAS
         9DG6mhqlHR/GBSfP+ZQks03l1BPOn+zW3v38kFrs=
Date:   Thu, 24 Aug 2023 16:21:25 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, bcain@quicinc.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hexagon-implement-the-new-page-table-range-api.patch removed from -mm tree
Message-Id: <20230824232125.BDB2FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hexagon: implement the new page table range API
has been removed from the -mm tree.  Its filename was
     hexagon-implement-the-new-page-table-range-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: hexagon: implement the new page table range API
Date: Wed, 2 Aug 2023 16:13:40 +0100

Add PFN_PTE_SHIFT and update_mmu_cache_range().

Link: https://lkml.kernel.org/r/20230802151406.3735276-13-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Brian Cain <bcain@quicinc.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/include/asm/cacheflush.h |    8 ++++++--
 arch/hexagon/include/asm/pgtable.h    |    9 +--------
 2 files changed, 7 insertions(+), 10 deletions(-)

--- a/arch/hexagon/include/asm/cacheflush.h~hexagon-implement-the-new-page-table-range-api
+++ a/arch/hexagon/include/asm/cacheflush.h
@@ -58,12 +58,16 @@ extern void flush_cache_all_hexagon(void
  * clean the cache when the PTE is set.
  *
  */
-static inline void update_mmu_cache(struct vm_area_struct *vma,
-					unsigned long address, pte_t *ptep)
+static inline void update_mmu_cache_range(struct vm_fault *vmf,
+		struct vm_area_struct *vma, unsigned long address,
+		pte_t *ptep, unsigned int nr)
 {
 	/*  generic_ptrace_pokedata doesn't wind up here, does it?  */
 }
 
+#define update_mmu_cache(vma, addr, ptep) \
+	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
+
 void copy_to_user_page(struct vm_area_struct *vma, struct page *page,
 		       unsigned long vaddr, void *dst, void *src, int len);
 #define copy_to_user_page copy_to_user_page
--- a/arch/hexagon/include/asm/pgtable.h~hexagon-implement-the-new-page-table-range-api
+++ a/arch/hexagon/include/asm/pgtable.h
@@ -338,6 +338,7 @@ static inline int pte_exec(pte_t pte)
 /* __swp_entry_to_pte - extract PTE from swap entry */
 #define __swp_entry_to_pte(x) ((pte_t) { (x).val })
 
+#define PFN_PTE_SHIFT	PAGE_SHIFT
 /* pfn_pte - convert page number and protection value to page table entry */
 #define pfn_pte(pfn, pgprot) __pte((pfn << PAGE_SHIFT) | pgprot_val(pgprot))
 
@@ -345,14 +346,6 @@ static inline int pte_exec(pte_t pte)
 #define pte_pfn(pte) (pte_val(pte) >> PAGE_SHIFT)
 #define set_pmd(pmdptr, pmdval) (*(pmdptr) = (pmdval))
 
-/*
- * set_pte_at - update page table and do whatever magic may be
- * necessary to make the underlying hardware/firmware take note.
- *
- * VM may require a virtual instruction to alert the MMU.
- */
-#define set_pte_at(mm, addr, ptep, pte) set_pte(ptep, pte)
-
 static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 {
 	return (unsigned long)__va(pmd_val(pmd) & PAGE_MASK);
_

Patches currently in -mm which might be from willy@infradead.org are


