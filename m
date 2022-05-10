Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E761C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 00:39:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbiEJAm5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 May 2022 20:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiEJAm4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2022 20:42:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF3D766D
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 17:39:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D6FE614EC
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 00:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0133FC385C6;
        Tue, 10 May 2022 00:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652143140;
        bh=vRnECyfg/1hN7/yjUrBpBcU7HzuMRMKlDpQd3ZyHsZ0=;
        h=Date:To:From:Subject:From;
        b=YNCEqncZR9ObJod35+HKoRbRYdhobaNaQZ+6vXbZFPiOexk7KR0ezMwS911QC5SJG
         pbTuMqKv2R1uzNlThE14tc1jdD1HkX79c+H2SVRszMldRJsOffS14M+FATP4KeWRAW
         BYACpZtEsneVwbr9DGIkCOBFIwZ33Z5Qtdj+c86Q=
Date:   Mon, 09 May 2022 17:38:59 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] x86-pgtable-support-__have_arch_pte_swp_exclusive-fix.patch removed from -mm tree
Message-Id: <20220510003900.0133FC385C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86-pgtable-support-__have_arch_pte_swp_exclusive-fix
has been removed from the -mm tree.  Its filename was
     x86-pgtable-support-__have_arch_pte_swp_exclusive-fix.patch

This patch was dropped because it was folded into x86-pgtable-support-__have_arch_pte_swp_exclusive.patch

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
mm-rmap-fail-try_to_migrate-early-when-setting-a-pmd-migration-entry-fails.patch
mm-gup-disallow-follow_pagefoll_pin.patch
mm-support-gup-triggered-unsharing-of-anonymous-pages.patch
mm-gup-trigger-fault_flag_unshare-when-r-o-pinning-a-possibly-shared-anonymous-page.patch
mm-gup-sanity-check-with-config_debug_vm-that-anonymous-pages-are-exclusive-when-unpinning.patch
mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit.patch
mm-debug_vm_pgtable-add-tests-for-__have_arch_pte_swp_exclusive.patch
x86-pgtable-support-__have_arch_pte_swp_exclusive.patch
arm64-pgtable-support-__have_arch_pte_swp_exclusive.patch
s390-pgtable-cleanup-description-of-swp-pte-layout.patch
s390-pgtable-support-__have_arch_pte_swp_exclusive.patch
powerpc-pgtable-remove-_page_bit_swap_type-for-book3s.patch
powerpc-pgtable-support-__have_arch_pte_swp_exclusive-for-book3s.patch

