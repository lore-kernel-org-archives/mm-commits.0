Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6475E77353
	for <mm-commits@archiver.kernel.org>; Sat, 30 Sep 2023 00:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbjI3AVV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 20:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233908AbjI3AVU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 20:21:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458051B8
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 17:21:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8129C433C8;
        Sat, 30 Sep 2023 00:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696033274;
        bh=pLNB6E5dKhS1qqtKNOnfx4/T1XTlhnX+u50hSNFianw=;
        h=Date:To:From:Subject:From;
        b=yDr2p+t15fI2IozvEL88i06reSYKcnYBbGevq3MxhF1bqSJPoYZ/frv5KNvcqEQKT
         g57bftz9sGsLiYkRsAb+7URGleVcgYXgG3hpO70qwkfxYdOC8vFkkB3spDcdmmrX22
         q3U7G+E2nTdezIIoBrAiucf0dhA6RnSV9jpaQpiU=
Date:   Fri, 29 Sep 2023 17:21:14 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        fengwei.yin@intel.com, david@redhat.com, dave.hansen@intel.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-abstract-moving-to-the-next-pfn.patch removed from -mm tree
Message-Id: <20230930002114.C8129C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: abstract moving to the next PFN
has been removed from the -mm tree.  Its filename was
     mm-abstract-moving-to-the-next-pfn.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: abstract moving to the next PFN
Date: Wed, 20 Sep 2023 05:09:58 +0100

In order to fix the L1TF vulnerability, x86 can invert the PTE bits for
PROT_NONE VMAs, which means we cannot move from one PTE to the next by
adding 1 to the PFN field of the PTE.  This results in the BUG reported at
[1].

Abstract advancing the PTE to the next PFN through a pte_next_pfn()
function/macro.

Link: https://lkml.kernel.org/r/20230920040958.866520-1-willy@infradead.org
Fixes: bcc6cc832573 ("mm: add default definition of set_ptes()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: syzbot+55cc72f8cc3a549119df@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/000000000000d099fa0604f03351@google.com [1]
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    8 ++++++++
 include/linux/pgtable.h        |   10 +++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/pgtable.h~mm-abstract-moving-to-the-next-pfn
+++ a/arch/x86/include/asm/pgtable.h
@@ -955,6 +955,14 @@ static inline int pte_same(pte_t a, pte_
 	return a.pte == b.pte;
 }
 
+static inline pte_t pte_next_pfn(pte_t pte)
+{
+	if (__pte_needs_invert(pte_val(pte)))
+		return __pte(pte_val(pte) - (1UL << PFN_PTE_SHIFT));
+	return __pte(pte_val(pte) + (1UL << PFN_PTE_SHIFT));
+}
+#define pte_next_pfn	pte_next_pfn
+
 static inline int pte_present(pte_t a)
 {
 	return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE);
--- a/include/linux/pgtable.h~mm-abstract-moving-to-the-next-pfn
+++ a/include/linux/pgtable.h
@@ -206,6 +206,14 @@ static inline int pmd_young(pmd_t pmd)
 #endif
 
 #ifndef set_ptes
+
+#ifndef pte_next_pfn
+static inline pte_t pte_next_pfn(pte_t pte)
+{
+	return __pte(pte_val(pte) + (1UL << PFN_PTE_SHIFT));
+}
+#endif
+
 /**
  * set_ptes - Map consecutive pages to a contiguous range of addresses.
  * @mm: Address space to map the pages into.
@@ -231,7 +239,7 @@ static inline void set_ptes(struct mm_st
 		if (--nr == 0)
 			break;
 		ptep++;
-		pte = __pte(pte_val(pte) + (1UL << PFN_PTE_SHIFT));
+		pte = pte_next_pfn(pte);
 	}
 	arch_leave_lazy_mmu_mode();
 }
_

Patches currently in -mm which might be from willy@infradead.org are

i915-limit-the-length-of-an-sg-list-to-the-requested-length.patch
mm-convert-dax-lock-unlock-page-to-lock-unlock-folio.patch
buffer-pass-gfp-flags-to-folio_alloc_buffers.patch
buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp.patch
buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp-fix.patch
ext4-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-convert-getblk_unmovable-and-__getblk-to-use-bdev_getblk.patch
buffer-convert-sb_getblk-to-call-__getblk.patch
ext4-call-bdev_getblk-from-sb_getblk_gfp.patch
buffer-remove-__getblk_gfp.patch
hugetlb-use-a-folio-in-free_hpage_workfn.patch
hugetlb-remove-a-few-calls-to-page_folio.patch
hugetlb-convert-remove_pool_huge_page-to-remove_pool_hugetlb_folio.patch
mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch
mm-call-wp_page_copy-under-the-vma-lock.patch
mm-handle-shared-faults-under-the-vma-lock.patch
mm-handle-cow-faults-under-the-vma-lock.patch
mm-handle-read-faults-under-the-vma-lock.patch
mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch

