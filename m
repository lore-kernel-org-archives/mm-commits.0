Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0760BC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:16:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E57B961C91
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:16:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbhGFTTd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:19:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231742AbhGFTTc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:19:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C20B61C7A;
        Tue,  6 Jul 2021 19:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599013;
        bh=wNeMtYG6TEzT0uiMMHH9Ij0cjtsaRTWqY0wgUcvmA3E=;
        h=Date:From:To:Subject:From;
        b=c4cGaQrIKPI89JXvhrVAj/S/WeIL4mi/6qxwczq+C5Uvh/d34y0Ms/AMW2KYQYu5/
         opRWrLc7fq542oiLKS/3jMNjqG/0s+DuXKTxcSo/sSISIzdUO9ibSM3ZTfosIOX2Fr
         vJ40JXezoLWGIWzhkoNlCGc5dLbssHM+uew+90WA=
Date:   Tue, 06 Jul 2021 12:16:53 -0700
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, npiggin@gmail.com, paulus@samba.org,
        rppt@kernel.org, uladzislau.rezki@sony.com
Subject:  [merged]
 mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmap.patch removed
 from -mm tree
Message-ID: <20210706191653.BCFUu_oX1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: enable mapping of huge pages at pte level in vmap
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm/vmalloc: enable mapping of huge pages at pte level in vmap

On some architectures like powerpc, there are huge pages that are mapped
at pte level.

Enable it in vmap.

For that, architectures can provide arch_vmap_pte_range_map_size() that
returns the size of pages to map at pte level.

Link: https://lkml.kernel.org/r/fb3ccc73377832ac6708181ec419128a2f98ce36.1620795204.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Uladzislau Rezki <uladzislau.rezki@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    8 ++++++++
 mm/vmalloc.c            |   21 ++++++++++++++++++---
 2 files changed, 26 insertions(+), 3 deletions(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmap
+++ a/include/linux/vmalloc.h
@@ -104,6 +104,14 @@ static inline bool arch_vmap_pmd_support
 }
 #endif
 
+#ifndef arch_vmap_pte_range_map_size
+static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr, unsigned long end,
+							 u64 pfn, unsigned int max_page_shift)
+{
+	return PAGE_SIZE;
+}
+#endif
+
 /*
  *	Highlevel APIs for driver use
  */
--- a/mm/vmalloc.c~mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmap
+++ a/mm/vmalloc.c
@@ -36,6 +36,7 @@
 #include <linux/overflow.h>
 #include <linux/pgtable.h>
 #include <linux/uaccess.h>
+#include <linux/hugetlb.h>
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
 
@@ -83,10 +84,11 @@ static void free_work(struct work_struct
 /*** Page table manipulation functions ***/
 static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
-			pgtbl_mod_mask *mask)
+			unsigned int max_page_shift, pgtbl_mod_mask *mask)
 {
 	pte_t *pte;
 	u64 pfn;
+	unsigned long size = PAGE_SIZE;
 
 	pfn = phys_addr >> PAGE_SHIFT;
 	pte = pte_alloc_kernel_track(pmd, addr, mask);
@@ -94,9 +96,22 @@ static int vmap_pte_range(pmd_t *pmd, un
 		return -ENOMEM;
 	do {
 		BUG_ON(!pte_none(*pte));
+
+#ifdef CONFIG_HUGETLB_PAGE
+		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
+		if (size != PAGE_SIZE) {
+			pte_t entry = pfn_pte(pfn, prot);
+
+			entry = pte_mkhuge(entry);
+			entry = arch_make_huge_pte(entry, ilog2(size), 0);
+			set_huge_pte_at(&init_mm, addr, pte, entry);
+			pfn += PFN_DOWN(size);
+			continue;
+		}
+#endif
 		set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
 		pfn++;
-	} while (pte++, addr += PAGE_SIZE, addr != end);
+	} while (pte += PFN_DOWN(size), addr += size, addr != end);
 	*mask |= PGTBL_PTE_MODIFIED;
 	return 0;
 }
@@ -145,7 +160,7 @@ static int vmap_pmd_range(pud_t *pud, un
 			continue;
 		}
 
-		if (vmap_pte_range(pmd, addr, next, phys_addr, prot, mask))
+		if (vmap_pte_range(pmd, addr, next, phys_addr, prot, max_page_shift, mask))
 			return -ENOMEM;
 	} while (pmd++, phys_addr += (next - addr), addr = next, addr != end);
 	return 0;
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are


