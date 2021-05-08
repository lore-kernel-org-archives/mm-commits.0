Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C8AC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4465861402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhEHWni (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229728AbhEHWng (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:43:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C23FF6141E;
        Sat,  8 May 2021 22:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513754;
        bh=/9zG3435Rkfzc92EEM1fRdpb66i7EFtcM7iXoIda1Wg=;
        h=Date:From:To:Subject:From;
        b=mKuuW8nqjm+vsdsKUaZTZ4Zk2B0OEWwxi7SUdiJ8DoaAQls7kEtUNR4hJzvkxnnEh
         DFYAoLJQV+mc9BAb03bmkYRoy0s8Ff/YnIKx3V5Nt1n1iwwkOL3cfmx1qGKBdr/nP0
         DKYDiZYDbG+OcvZgLahLPKad2iEBCJCijCQ+a+h0=
Date:   Sat, 08 May 2021 15:42:33 -0700
From:   akpm@linux-foundation.org
To:     bp@alien8.de, catalin.marinas@arm.com, davem@davemloft.net,
        dingtianhong@huawei.com, hch@lst.de, hpa@zytor.com,
        linmiaohe@huawei.com, linux@armlinux.org.uk, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
        sfr@canb.auug.org.au, tglx@linutronix.de, urezki@gmail.com,
        will@kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-vmalloc-fix-huge=5Fvmap-regression-by-enabling-huge-pa?=
 =?US-ASCII?Q?ges-in-vmalloc=5Fto=5Fpage.patch?= removed from -mm tree
Message-ID: <20210508224233.hVhYVTKRF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: fix HUGE_VMAP regression by enabling huge pages in vmalloc_to_page
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-huge_vmap-regression-by-enabling-huge-pages-in-vmalloc_to_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: mm/vmalloc: fix HUGE_VMAP regression by enabling huge pages in vmalloc_to_page

vmalloc_to_page returns NULL for addresses mapped by larger pages[*]. 
Whether or not a vmap is huge depends on the architecture details,
alignments, boot options, etc., which the caller can not be expected to
know.  Therefore HUGE_VMAP is a regression for vmalloc_to_page.

This change teaches vmalloc_to_page about larger pages, and returns the
struct page that corresponds to the offset within the large page.  This
makes the API agnostic to mapping implementation details.

[*] As explained by commit 029c54b095995 ("mm/vmalloc.c: huge-vmap:
    fail gracefully on unexpected huge vmap mappings")

[npiggin@gmail.com: sparc32: add stub pud_page define for walking huge vmalloc page tables]
  Link: https://lkml.kernel.org/r/20210324232825.1157363-1-npiggin@gmail.com
Link: https://lkml.kernel.org/r/20210317062402.533919-3-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ding Tianhong <dingtianhong@huawei.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_32.h |    3 +
 mm/vmalloc.c                        |   41 ++++++++++++++++----------
 2 files changed, 29 insertions(+), 15 deletions(-)

--- a/arch/sparc/include/asm/pgtable_32.h~mm-vmalloc-fix-huge_vmap-regression-by-enabling-huge-pages-in-vmalloc_to_page
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -321,6 +321,9 @@ static inline pte_t pte_modify(pte_t pte
 		pgprot_val(newprot));
 }
 
+/* only used by the huge vmap code, should never be called */
+#define pud_page(pud)			NULL
+
 struct seq_file;
 void mmu_info(struct seq_file *m);
 
--- a/mm/vmalloc.c~mm-vmalloc-fix-huge_vmap-regression-by-enabling-huge-pages-in-vmalloc_to_page
+++ a/mm/vmalloc.c
@@ -34,7 +34,7 @@
 #include <linux/bitops.h>
 #include <linux/rbtree_augmented.h>
 #include <linux/overflow.h>
-
+#include <linux/pgtable.h>
 #include <linux/uaccess.h>
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
@@ -343,7 +343,9 @@ int is_vmalloc_or_module_addr(const void
 }
 
 /*
- * Walk a vmap address to the struct page it maps.
+ * Walk a vmap address to the struct page it maps. Huge vmap mappings will
+ * return the tail page that corresponds to the base page address, which
+ * matches small vmap mappings.
  */
 struct page *vmalloc_to_page(const void *vmalloc_addr)
 {
@@ -363,25 +365,33 @@ struct page *vmalloc_to_page(const void
 
 	if (pgd_none(*pgd))
 		return NULL;
+	if (WARN_ON_ONCE(pgd_leaf(*pgd)))
+		return NULL; /* XXX: no allowance for huge pgd */
+	if (WARN_ON_ONCE(pgd_bad(*pgd)))
+		return NULL;
+
 	p4d = p4d_offset(pgd, addr);
 	if (p4d_none(*p4d))
 		return NULL;
-	pud = pud_offset(p4d, addr);
+	if (p4d_leaf(*p4d))
+		return p4d_page(*p4d) + ((addr & ~P4D_MASK) >> PAGE_SHIFT);
+	if (WARN_ON_ONCE(p4d_bad(*p4d)))
+		return NULL;
 
-	/*
-	 * Don't dereference bad PUD or PMD (below) entries. This will also
-	 * identify huge mappings, which we may encounter on architectures
-	 * that define CONFIG_HAVE_ARCH_HUGE_VMAP=y. Such regions will be
-	 * identified as vmalloc addresses by is_vmalloc_addr(), but are
-	 * not [unambiguously] associated with a struct page, so there is
-	 * no correct value to return for them.
-	 */
-	WARN_ON_ONCE(pud_bad(*pud));
-	if (pud_none(*pud) || pud_bad(*pud))
+	pud = pud_offset(p4d, addr);
+	if (pud_none(*pud))
+		return NULL;
+	if (pud_leaf(*pud))
+		return pud_page(*pud) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
+	if (WARN_ON_ONCE(pud_bad(*pud)))
 		return NULL;
+
 	pmd = pmd_offset(pud, addr);
-	WARN_ON_ONCE(pmd_bad(*pmd));
-	if (pmd_none(*pmd) || pmd_bad(*pmd))
+	if (pmd_none(*pmd))
+		return NULL;
+	if (pmd_leaf(*pmd))
+		return pmd_page(*pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
+	if (WARN_ON_ONCE(pmd_bad(*pmd)))
 		return NULL;
 
 	ptep = pte_offset_map(pmd, addr);
@@ -389,6 +399,7 @@ struct page *vmalloc_to_page(const void
 	if (pte_present(pte))
 		page = pte_page(pte);
 	pte_unmap(ptep);
+
 	return page;
 }
 EXPORT_SYMBOL(vmalloc_to_page);
_

Patches currently in -mm which might be from npiggin@gmail.com are


