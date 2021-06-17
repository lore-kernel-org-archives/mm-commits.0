Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E499C49361
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 04:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BDAB611CE
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 04:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhFQEGS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Jun 2021 00:06:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229546AbhFQEGP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 17 Jun 2021 00:06:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4803611CE;
        Thu, 17 Jun 2021 04:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623902631;
        bh=stmkvBvEaCp/0U11hGq3C+geWAHmxpJ5aDzDk+UTpeY=;
        h=Date:From:To:Subject:From;
        b=RYKXAqp6GklqZwPNs1rAcpZKzlxW6VyOmUIyYp9gS/qoxjKf4LFPkCB7st9Ij9fNC
         P33jtYjBF74pZ9DJUoLya/FVIOQSPv3+VXMCfrwcYHqIX/GAUaebsvCc8S2Keyi38c
         Ka7b4mjKapTVUdc1qURpNy6aOgSR0W30YdFWhwz8=
Date:   Wed, 16 Jun 2021 21:03:50 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        hughd@google.com, joel@joelfernandes.org, kaleshsingh@google.com,
        kirill.shutemov@linux.intel.com, kirill@shutemov.name,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
        sfr@canb.auug.org.au
Subject:  + mm-mremap-allow-arch-runtime-override.patch added to
 -mm tree
Message-ID: <20210617040350.vZU_vRIWR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: allow arch runtime override
has been added to the -mm tree.  Its filename is
     mm-mremap-allow-arch-runtime-override.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-allow-arch-runtime-override.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-allow-arch-runtime-override.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/mremap: allow arch runtime override

Patch series "Speedup mremap on ppc64", v8.

This patchset enables MOVE_PMD/MOVE_PUD support on power.  This requires
the platform to support updating higher-level page tables without updating
page table entries.  This also needs to invalidate the Page Walk Cache on
architecture supporting the same.


This patch (of 3):

Architectures like ppc64 support faster mremap only with radix
translation.  Hence allow a runtime check w.r.t support for fast mremap.

Link: https://lkml.kernel.org/r/20210616045735.374532-1-aneesh.kumar@linux.ibm.com
Link: https://lkml.kernel.org/r/20210616045735.374532-2-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/tlb.h |    6 ++++++
 mm/mremap.c                    |   15 ++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/tlb.h~mm-mremap-allow-arch-runtime-override
+++ a/arch/powerpc/include/asm/tlb.h
@@ -83,5 +83,11 @@ static inline int mm_is_thread_local(str
 }
 #endif
 
+#define arch_supports_page_table_move arch_supports_page_table_move
+static inline bool arch_supports_page_table_move(void)
+{
+	return radix_enabled();
+}
+
 #endif /* __KERNEL__ */
 #endif /* __ASM_POWERPC_TLB_H */
--- a/mm/mremap.c~mm-mremap-allow-arch-runtime-override
+++ a/mm/mremap.c
@@ -25,7 +25,7 @@
 #include <linux/userfaultfd_k.h>
 
 #include <asm/cacheflush.h>
-#include <asm/tlbflush.h>
+#include <asm/tlb.h>
 #include <asm/pgalloc.h>
 
 #include "internal.h"
@@ -210,6 +210,15 @@ static void move_ptes(struct vm_area_str
 		drop_rmap_locks(vma);
 }
 
+#ifndef arch_supports_page_table_move
+#define arch_supports_page_table_move arch_supports_page_table_move
+static inline bool arch_supports_page_table_move(void)
+{
+	return IS_ENABLED(CONFIG_HAVE_MOVE_PMD) ||
+		IS_ENABLED(CONFIG_HAVE_MOVE_PUD);
+}
+#endif
+
 #ifdef CONFIG_HAVE_MOVE_PMD
 static bool move_normal_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 		  unsigned long new_addr, pmd_t *old_pmd, pmd_t *new_pmd)
@@ -218,6 +227,8 @@ static bool move_normal_pmd(struct vm_ar
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t pmd;
 
+	if (!arch_supports_page_table_move())
+		return false;
 	/*
 	 * The destination pmd shouldn't be established, free_pgtables()
 	 * should have released it.
@@ -284,6 +295,8 @@ static bool move_normal_pud(struct vm_ar
 	struct mm_struct *mm = vma->vm_mm;
 	pud_t pud;
 
+	if (!arch_supports_page_table_move())
+		return false;
 	/*
 	 * The destination pud shouldn't be established, free_pgtables()
 	 * should have released it.
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t.patch
mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-2.patch
mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t.patch
mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix.patch
selftest-mremap_test-update-the-test-to-handle-pagesize-other-than-4k.patch
selftest-mremap_test-avoid-crash-with-static-build.patch
mm-mremap-convert-huge-pud-move-to-separate-helper.patch
mm-mremap-dont-enable-optimized-pud-move-if-page-table-levels-is-2.patch
mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries.patch
mm-mremap-hold-the-rmap-lock-in-write-mode-when-moving-page-table-entries.patch
mm-mremap-allow-arch-runtime-override.patch
powerpc-book3s64-mm-update-flush_tlb_range-to-flush-page-walk-cache.patch
powerpc-mm-enable-have_move_pmd-support.patch

