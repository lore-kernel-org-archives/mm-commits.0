Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D12FC727AB
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244074AbjHXXWR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237176AbjHXXVr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79E9CEE
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E3D263778
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A76C433C8;
        Thu, 24 Aug 2023 23:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919304;
        bh=7frQKjZMJc7C1Af69KCAataQCdU/cmz0ftePhPy4+RM=;
        h=Date:To:From:Subject:From;
        b=1paC0FsSzKmWsgOsVri8yiB1DcyfA8ghz73ump0ZcRR7wafEmE6zlz+o6AIT6qZf1
         dkQOfUwqwyMFSeCtvPfJgA6plbsD8N01zjcQQVlGCsMvs2AjODBe3PGtY4WzEw69YT
         ahcz0xGtPu37NtZ2Bls7fbDY4lym9M+IAXRJ4WvY=
Date:   Thu, 24 Aug 2023 16:21:44 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, rppt@kernel.org,
        mingo@redhat.com, hpa@zytor.com, dave.hansen@linux.intel.com,
        bp@alien8.de, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-implement-the-new-page-table-range-api.patch removed from -mm tree
Message-Id: <20230824232144.95A76C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86: implement the new page table range API
has been removed from the -mm tree.  Its filename was
     x86-implement-the-new-page-table-range-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: x86: implement the new page table range API
Date: Wed, 2 Aug 2023 16:13:56 +0100

Add PFN_PTE_SHIFT and a noop update_mmu_cache_range().

Link: https://lkml.kernel.org/r/20230802151406.3735276-29-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~x86-implement-the-new-page-table-range-api
+++ a/arch/x86/include/asm/pgtable.h
@@ -185,6 +185,8 @@ static inline int pte_special(pte_t pte)
 
 static inline u64 protnone_mask(u64 val);
 
+#define PFN_PTE_SHIFT	PAGE_SHIFT
+
 static inline unsigned long pte_pfn(pte_t pte)
 {
 	phys_addr_t pfn = pte_val(pte);
@@ -1020,13 +1022,6 @@ static inline pud_t native_local_pudp_ge
 	return res;
 }
 
-static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep, pte_t pte)
-{
-	page_table_check_ptes_set(mm, ptep, pte, 1);
-	set_pte(ptep, pte);
-}
-
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 			      pmd_t *pmdp, pmd_t pmd)
 {
@@ -1292,6 +1287,11 @@ static inline void update_mmu_cache(stru
 		unsigned long addr, pte_t *ptep)
 {
 }
+static inline void update_mmu_cache_range(struct vm_fault *vmf,
+		struct vm_area_struct *vma, unsigned long addr,
+		pte_t *ptep, unsigned int nr)
+{
+}
 static inline void update_mmu_cache_pmd(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmd)
 {
_

Patches currently in -mm which might be from willy@infradead.org are


