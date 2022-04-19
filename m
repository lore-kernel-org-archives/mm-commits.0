Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A3AC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 19:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356314AbiDST4c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 15:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344535AbiDST4c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 15:56:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C6D3818F
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 12:53:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B415B81B67
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 19:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD8DC385A5;
        Tue, 19 Apr 2022 19:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650398025;
        bh=m/JgO9eAbrZ+yfJC0zJGDBFLRHzK+28z089hSxHu8lI=;
        h=Date:To:From:Subject:From;
        b=rK0SpvZ3I23Xlgg3kzaDjgROCKhZpQY7tM/dKGGrCrrW3Sn2yZk8zPPXSdF3uQRBz
         ReZXUQ31v2Iqh4yH3JnBTe1gGxO+2p6tD43jGU9w9NKeNIMp3TyDIw6TT0hiK1i8b+
         W8guJiUEFaQJtcgkum0ZcApLtucyhlFT66MQjKGg=
Date:   Tue, 19 Apr 2022 12:53:44 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-pgtable-support-__have_arch_pte_swp_exclusive-fix.patch added to -mm tree
Message-Id: <20220419195344.DFD8DC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86-pgtable-support-__have_arch_pte_swp_exclusive-fix
has been added to the -mm tree.  Its filename is
     x86-pgtable-support-__have_arch_pte_swp_exclusive-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/x86-pgtable-support-__have_arch_pte_swp_exclusive-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/x86-pgtable-support-__have_arch_pte_swp_exclusive-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: x86-pgtable-support-__have_arch_pte_swp_exclusive-fix

Looks like I ignored that 32bit uses a different (undocumented) swap layout
and bit 3 falls into the swp type. We'll restrict this to x86-64 for now, just
like for the other architectures.

Link: https://lkml.kernel.org/r/d875c292-46b3-f281-65ae-71d0b0c6f592@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h          |    3 ++-
 arch/x86/include/asm/pgtable_64_types.h |    5 +++++
 arch/x86/include/asm/pgtable_types.h    |    5 -----
 3 files changed, 7 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/pgtable_64_types.h~x86-pgtable-support-__have_arch_pte_swp_exclusive-fix
+++ a/arch/x86/include/asm/pgtable_64_types.h
@@ -163,4 +163,9 @@ extern unsigned int ptrs_per_p4d;
 
 #define PGD_KERNEL_START	((PAGE_SIZE / 2) / sizeof(pgd_t))
 
+/*
+ * We borrow bit 3 to remember PG_anon_exclusive.
+ */
+#define _PAGE_SWP_EXCLUSIVE	_PAGE_PWT
+
 #endif /* _ASM_X86_PGTABLE_64_DEFS_H */
--- a/arch/x86/include/asm/pgtable.h~x86-pgtable-support-__have_arch_pte_swp_exclusive-fix
+++ a/arch/x86/include/asm/pgtable.h
@@ -1291,7 +1291,7 @@ static inline void update_mmu_cache_pud(
 		unsigned long addr, pud_t *pud)
 {
 }
-
+#ifdef _PAGE_SWP_EXCLUSIVE
 #define __HAVE_ARCH_PTE_SWP_EXCLUSIVE
 static inline pte_t pte_swp_mkexclusive(pte_t pte)
 {
@@ -1307,6 +1307,7 @@ static inline pte_t pte_swp_clear_exclus
 {
 	return pte_clear_flags(pte, _PAGE_SWP_EXCLUSIVE);
 }
+#endif /* _PAGE_SWP_EXCLUSIVE */
 
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
--- a/arch/x86/include/asm/pgtable_types.h~x86-pgtable-support-__have_arch_pte_swp_exclusive-fix
+++ a/arch/x86/include/asm/pgtable_types.h
@@ -84,11 +84,6 @@
 #endif
 
 /*
- * We borrow bit 3 to remember PG_anon_exclusive.
- */
-#define _PAGE_SWP_EXCLUSIVE	_PAGE_PWT
-
-/*
  * Tracking soft dirty bit when a page goes to a swap is tricky.
  * We need a bit which can be stored in pte _and_ not conflict
  * with swap entry format. On x86 bits 1-4 are *not* involved
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-fix-missing-swap_free-in-try_to_unmap-after-arch_unmap_one-failed.patch
mm-hugetlb-take-src_mm-write_protect_seq-in-copy_hugetlb_page_range.patch
mm-memory-slightly-simplify-copy_present_pte.patch
mm-rmap-split-page_dup_rmap-into-page_dup_file_rmap-and-page_try_dup_anon_rmap.patch
mm-rmap-convert-rmap-flags-to-a-proper-distinct-rmap_t-type.patch
mm-rmap-remove-do_page_add_anon_rmap.patch
mm-rmap-pass-rmap-flags-to-hugepage_add_anon_rmap.patch
mm-rmap-drop-compound-parameter-from-page_add_new_anon_rmap.patch
mm-rmap-use-page_move_anon_rmap-when-reusing-a-mapped-pageanon-page-exclusively.patch
mm-huge_memory-remove-outdated-vm_warn_on_once_page-from-unmap_page.patch
mm-page-flags-reuse-pg_mappedtodisk-as-pg_anon_exclusive-for-pageanon-pages.patch
mm-remember-exclusively-mapped-anonymous-pages-with-pg_anon_exclusive.patch
mm-gup-disallow-follow_pagefoll_pin.patch
mm-support-gup-triggered-unsharing-of-anonymous-pages.patch
mm-support-gup-triggered-unsharing-of-anonymous-pages-fix.patch
mm-gup-trigger-fault_flag_unshare-when-r-o-pinning-a-possibly-shared-anonymous-page.patch
mm-gup-sanity-check-with-config_debug_vm-that-anonymous-pages-are-exclusive-when-unpinning.patch
mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit.patch
mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit-fix.patch
mm-debug_vm_pgtable-add-tests-for-__have_arch_pte_swp_exclusive.patch
x86-pgtable-support-__have_arch_pte_swp_exclusive.patch
x86-pgtable-support-__have_arch_pte_swp_exclusive-fix.patch
arm64-pgtable-support-__have_arch_pte_swp_exclusive.patch
s390-pgtable-cleanup-description-of-swp-pte-layout.patch
s390-pgtable-support-__have_arch_pte_swp_exclusive.patch
powerpc-pgtable-remove-_page_bit_swap_type-for-book3s.patch
powerpc-pgtable-support-__have_arch_pte_swp_exclusive-for-book3s.patch

